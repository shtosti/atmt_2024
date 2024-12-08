import os
import logging
import argparse
import numpy as np
from tqdm import tqdm

import torch
from torch.serialization import default_restore_location

from seq2seq import models, utils
from seq2seq.data.dictionary import Dictionary
from seq2seq.data.dataset import Seq2SeqDataset, BatchSampler
from seq2seq.beam import BeamSearch, BeamSearchNode

# measure decoding time
import time


def get_args():
    """ Defines generation-specific hyper-parameters. """
    parser = argparse.ArgumentParser('Sequence to Sequence Model')
    parser.add_argument('--cuda', default=False, help='Use a GPU')
    parser.add_argument('--seed', default=42, type=int, help='pseudo random number generator seed')

    # Add data arguments
    parser.add_argument('--data', default='assignments/03/prepared', help='path to data directory')
    parser.add_argument('--dicts', required=True, help='path to directory containing source and target dictionaries')
    parser.add_argument('--checkpoint-path', default='checkpoints_asg4/checkpoint_best.pt', help='path to the model file')
    parser.add_argument('--batch-size', default=None, type=int, help='maximum number of sentences in a batch')
    parser.add_argument('--output', default='model_translations.txt', type=str,
                        help='path to the output file destination')
    parser.add_argument('--max-len', default=100, type=int, help='maximum length of generated sequence')

    # Add beam search arguments
    parser.add_argument('--beam-size', default=5, type=int, help='number of hypotheses expanded in beam search')
    # alpha hyperparameter for length normalization (described as lp in https://arxiv.org/pdf/1609.08144.pdf equation 14)
    parser.add_argument('--alpha', default=0.0, type=float, help='alpha for softer length normalization')

    return parser.parse_args()


def main(args):
    """ Main translation function' """
    # Load arguments from checkpoint
    torch.manual_seed(args.seed)
    state_dict = torch.load(args.checkpoint_path, map_location=lambda s, l: default_restore_location(s, 'cpu'))
    args_loaded = argparse.Namespace(**{**vars(state_dict['args']), **vars(args)})
    args = args_loaded
    utils.init_logging(args)

    # Load dictionaries
    src_dict = Dictionary.load(os.path.join(args.dicts, 'dict.{:s}'.format(args.source_lang)))
    logging.info('Loaded a source dictionary ({:s}) with {:d} words'.format(args.source_lang, len(src_dict)))
    tgt_dict = Dictionary.load(os.path.join(args.dicts, 'dict.{:s}'.format(args.target_lang)))
    logging.info('Loaded a target dictionary ({:s}) with {:d} words'.format(args.target_lang, len(tgt_dict)))

    # Load dataset
    test_dataset = Seq2SeqDataset(
        src_file=os.path.join(args.data, 'test.{:s}'.format(args.source_lang)),
        tgt_file=os.path.join(args.data, 'test.{:s}'.format(args.target_lang)),
        src_dict=src_dict, tgt_dict=tgt_dict)

    test_loader = torch.utils.data.DataLoader(test_dataset, num_workers=1, collate_fn=test_dataset.collater,
                                              batch_sampler=BatchSampler(test_dataset, 9999999,
                                                                         args.batch_size, 1, 0, shuffle=False,
                                                                         seed=args.seed))
    # Build model and criterion
    model = models.build_model(args, src_dict, tgt_dict)
    if args.cuda:
        model = model.cuda()
    model.eval()
    model.load_state_dict(state_dict['model'])
    logging.info('Loaded a model from checkpoint {:s}'.format(args.checkpoint_path))
    progress_bar = tqdm(test_loader, desc='| Generation', leave=False)

    # Iterate over the test set
    all_hyps = {}
    total_time = 0
    for i, sample in enumerate(progress_bar):
        start_time = time.time() 

        # Create a beam search object or every input sentence in batch
        batch_size = sample['src_tokens'].shape[0]
        searches = [BeamSearch(args.beam_size, args.max_len - 1, tgt_dict.unk_idx) for i in range(batch_size)]

        with torch.no_grad():
            # Compute the encoder output
            encoder_out = model.encoder(sample['src_tokens'], sample['src_lengths'])
            # __QUESTION 1: What is "go_slice" used for and what do its dimensions represent?
            """
            "go_slice" is a tensor we create to start as the starting token for each batch seq. 
            Its role is to mark the beginning of the sequence for consistent decoding.

            2D tensor with shape (batch, 1) -> initialize with each value = 1.0
            batch: n seqs in the batch -> n rows
            1: single start token for each seq -> n columns in each row
            """
            go_slice = \
                torch.ones(sample['src_tokens'].shape[0], 1).fill_(tgt_dict.eos_idx).type_as(sample['src_tokens'])
            if args.cuda:
                go_slice = utils.move_to_cuda(go_slice)

            #import pdb;pdb.set_trace()
            
            # Compute the decoder output at the first time step
            decoder_out, _ = model.decoder(go_slice, encoder_out)

            # __QUESTION 2: Why do we keep one top candidate more than the beam size?
            """
            Not sure - I have found some information that this is a back-up candidate for 
            more robustness, e.g. in case there are duplicates, tie-breaking, or if some candidate
            violates the constraints (e.g. prohibited tokens) and must be pruned.
            """
            log_probs, next_candidates = torch.topk(torch.log(torch.softmax(decoder_out, dim=2)),
                                                    args.beam_size+1, dim=-1)

        # Create number of beam_size beam search nodes for every input sentence
        for i in range(batch_size):
            for j in range(args.beam_size):
                best_candidate = next_candidates[i, :, j]
                backoff_candidate = next_candidates[i, :, j+1]
                best_log_p = log_probs[i, :, j]
                backoff_log_p = log_probs[i, :, j+1]
                next_word = torch.where(best_candidate == tgt_dict.unk_idx, backoff_candidate, best_candidate)
                log_p = torch.where(best_candidate == tgt_dict.unk_idx, backoff_log_p, best_log_p)
                log_p = log_p[-1]

                # Store the encoder_out information for the current input sentence and beam
                emb = encoder_out['src_embeddings'][:,i,:]
                lstm_out = encoder_out['src_out'][0][:,i,:]
                final_hidden = encoder_out['src_out'][1][:,i,:]
                final_cell = encoder_out['src_out'][2][:,i,:]
                try:
                    mask = encoder_out['src_mask'][i,:]
                except TypeError:
                    mask = None

                node = BeamSearchNode(searches[i], emb, lstm_out, final_hidden, final_cell,
                                      mask, torch.cat((go_slice[i], next_word)), log_p, 1)
                # __QUESTION 3: Why do we add the node with a negative score?
                """
                To "flip" the logic of min-heaps, as they are built in python, and avoid constructing max-heaps. 
                If we use the node values as they are originally, we would access (=remove) nodes with smallest probabilities.
                Since we are interested in the nodes with the largest probabilities, we need to flip their values
                and make them negative -> the largest prob becomes the smallest value -> removed first.
                """
                searches[i].add(-node.eval(args.alpha), node)

        #import pdb;pdb.set_trace()
        # Start generating further tokens until max sentence length reached
        for _ in range(args.max_len-1):

            # Get the current nodes to expand
            nodes = [n[1] for s in searches for n in s.get_current_beams() if not n[1].completed]

            if not nodes:
                break

            # Reconstruct prev_words, encoder_out from current beam search nodes
            prev_words = torch.stack([node.sequence for node in nodes])
            encoder_out["src_embeddings"] = torch.stack([node.emb for node in nodes], dim=1)
            lstm_out = torch.stack([node.lstm_out for node in nodes], dim=1)
            final_hidden = torch.stack([node.final_hidden for node in nodes], dim=1)
            final_cell = torch.stack([node.final_cell for node in nodes], dim=1)
            encoder_out["src_out"] = (lstm_out, final_hidden, final_cell)
            try:
                encoder_out["src_mask"] = torch.stack([node.mask for node in nodes], dim=0)
            except TypeError:
                encoder_out["src_mask"] = None

            with torch.no_grad():
                # Compute the decoder output by feeding it the decoded sentence prefix
                decoder_out, _ = model.decoder(prev_words, encoder_out)

            # see __QUESTION 2
            log_probs, next_candidates = torch.topk(torch.log(torch.softmax(decoder_out, dim=2)), args.beam_size+1, dim=-1)

            # Create number of beam_size next nodes for every current node
            for i in range(log_probs.shape[0]):
                for j in range(args.beam_size):

                    best_candidate = next_candidates[i, :, j]
                    backoff_candidate = next_candidates[i, :, j+1]
                    best_log_p = log_probs[i, :, j]
                    backoff_log_p = log_probs[i, :, j+1]
                    next_word = torch.where(best_candidate == tgt_dict.unk_idx, backoff_candidate, best_candidate)
                    log_p = torch.where(best_candidate == tgt_dict.unk_idx, backoff_log_p, best_log_p)
                    log_p = log_p[-1]
                    next_word = torch.cat((prev_words[i][1:], next_word[-1:]))

                    # Get parent node and beam search object for corresponding sentence
                    node = nodes[i]
                    search = node.search


                    # __QUESTION 4: How are "add" and "add_final" different? 
                    # What would happen if we did not make this distinction?
                    """
                    "add" increments intermediate sequences, i.e. those that have not yet reached the EOS token -->
                    generation continues. "add_final" stores those nodes which correspond to the completed seqs, 
                    i.e. those that have reached the final EOS token. 
                    The final result is only computed using the values added with "add_final", 
                    since only completed seqs should be considered as candidates.
                    Else -> Termination issues - when would the search stop if candidates have various lengths?
                    """

                    completed = next_word[-1] == tgt_dict.eos_idx # create a variable for better readability

                    # Store the node as final if EOS is generated
                    if completed:
                        new_node = BeamSearchNode(
                            search, node.emb, node.lstm_out, node.final_hidden,
                            node.final_cell, node.mask, torch.cat((prev_words[i][0].view([1]),
                            next_word)), node.logp, node.length, completed=True
                            )
                        search.add_final(-new_node.eval(args.alpha), new_node)

                    # Add the node to current nodes for next iteration
                    else:
                        new_node = BeamSearchNode(
                            search, node.emb, node.lstm_out, node.final_hidden,
                            node.final_cell, node.mask, torch.cat((prev_words[i][0].view([1]),
                            next_word)), node.logp + log_p, node.length + 1
                            )
                        search.add(-new_node.eval(args.alpha), new_node)

            # #import pdb;pdb.set_trace()
            # __QUESTION 5: What happens internally when we prune our beams?
            # How do we know we always maintain the best sequences?
            """
            The answer can be found in beam.py:

            def prune(self):
                # Removes all nodes but the beam_size best ones (lowest neg log prob)
                nodes = PriorityQueue()
                # Keep track of how many search paths are already finished (EOS)
                finished = self.final.qsize()
                for _ in range(self.beam_size-finished):
                    node = self.nodes.get()
                    nodes.put(node) 
                self.nodes = nodes

            By pruning, we ensure only the highest-prob candidate seqs are retained;
            it reduces the number of nodes / candidate seqs tracked.
            As seen in the prune() method, pruning only applies to intermediate steps (self.nodes), 
            whereas final seqs (self.final, those that have reached EOS), are not pruned.
            We know that we maintain the best seqs, because take those with lowest neg log prob.
            The use of a priority queue ensures that nodes are automatically ordered by their scores.
            Importantly, completed seqs are tracked separately in self.final and remain safe from deletion/pruning.
            """
            for search in searches:
                search.prune()

        # Segment into sentences
        best_sents = torch.stack([search.get_best()[1].sequence[1:].cpu() for search in searches])
        decoded_batch = best_sents.numpy()
        #import pdb;pdb.set_trace()

        output_sentences = [decoded_batch[row, :] for row in range(decoded_batch.shape[0])]

        # __QUESTION 6: What is the purpose of this for loop?
        """
        This loop perform truncation of seqs up to the first occurance of the EOS token.

        The first condition truncated up to the index of the first EOS, and appends the truncated seq to temp:
        if len(first_eos) > 0:
            temp.append(sent[:first_eos[0]])

        The second condition simply appends the whole seq to temp, since EOS has not been generated yet.
        else:
            temp.append(sent)
        """
        temp = list()
        for sent in output_sentences:
            first_eos = np.where(sent == tgt_dict.eos_idx)[0]
            if len(first_eos) > 0:
                temp.append(sent[:first_eos[0]])
            else:
                temp.append(sent)
        output_sentences = temp

        # Convert arrays of indices into strings of words
        output_sentences = [tgt_dict.string(sent) for sent in output_sentences]

        for ii, sent in enumerate(output_sentences):
            all_hyps[int(sample['id'].data[ii])] = sent


        end_time = time.time()  # End timing the decoding
        total_time += (end_time - start_time)
    
    avg_time_per_sentence = total_time / len(test_loader.dataset)
    print(f"Total decoding time:\t{total_time:.2f} seconds")
    print(f"Average decoding time per sentence:\t{avg_time_per_sentence:.4f} seconds")


    # Write to file
    if args.output is not None:
        with open(args.output, 'w') as out_file:
            for sent_id in range(len(all_hyps.keys())):
                out_file.write(all_hyps[sent_id] + '\n')


if __name__ == '__main__':
    args = get_args()
    main(args)
