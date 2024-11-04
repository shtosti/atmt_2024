#!/bin/bash

# ### small baseline ###
# python translate.py \
# --data data/en-fr/prepared \
# --dicts data/en-fr/prepared \
# --checkpoint-path assignments/03/small_baseline/checkpoints/checkpoint_last.pt \
# --output assignments/03/small_baseline/translations.txt

# ### small batch 16 ###
# python translate.py \
# --data data/en-fr/prepared \
# --dicts data/en-fr/prepared \
# --checkpoint-path assignments/03/small_batch16/checkpoints/checkpoint_last.pt \
# --output assignments/03/small_batch16/translations.txt \
# --batch-size 16

# ### small lr 0.003 ###
# python translate.py \
# --data data/en-fr/prepared \
# --dicts data/en-fr/prepared \
# --checkpoint-path assignments/03/small_lr0p003/checkpoints/checkpoint_last.pt \
# --output assignments/03/small_lr0p003/translations.txt 

# ### small --clip-norm 2.0 ###
# python translate.py \
# --data data/en-fr/prepared \
# --dicts data/en-fr/prepared \
# --checkpoint-path assignments/03/small_clip-norm2/checkpoints/checkpoint_last.pt \
# --output assignments/03/small_clip-norm2/translations.txt 

# ### small hyperparam-tuning ###
# python translate.py \
# --data data/en-fr/prepared \
# --dicts data/en-fr/prepared \
# --checkpoint-path assignments/03/small_hyperparam-tuning/checkpoints/checkpoint_last.pt \
# --output assignments/03/small_hyperparam-tuning/translations.txt \
# --batch-size 8

# ### large hyperparam-tuning ###
# python translate.py \
# --data data/en-fr/prepared \
# --dicts data/en-fr/prepared \
# --checkpoint-path assignments/03/large_hyperparam-tuning/checkpoints/checkpoint_last.pt \
# --output assignments/03/large_hyperparam-tuning/translations.txt \
# --batch-size 8

# ### large hyperparam-tuning-2 ###
# python translate.py \
# --data data/en-fr/prepared \
# --dicts data/en-fr/prepared \
# --checkpoint-path assignments/03/large_hyperparam-tuning-2/checkpoints/checkpoint_last.pt \
# --output assignments/03/large_hyperparam-tuning-2/translations.txt \
# --batch-size 8

# ### small BPE ###
# python translate.py \
# --data data/en-fr/prepared_bpe \
# --dicts data/en-fr/prepared_bpe \
# --checkpoint-path assignments/03/small_bpe/checkpoints/checkpoint_last.pt \
# --output assignments/03/small_bpe/translations.txt \
# --batch-size 8

### large BPE ###
python translate.py \
--data data/en-fr/prepared_bpe \
--dicts data/en-fr/prepared_bpe \
--checkpoint-path assignments/03/large_bpe/checkpoints/checkpoint_last.pt \
--output assignments/03/large_bpe/translations.txt \
--batch-size 8