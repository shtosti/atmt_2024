#!/bin/bash
# -*- coding: utf-8 -*-

set -e

# pwd=`dirname "$(readlink -f "$0")"`
base=$(pwd)
src=fr
tgt=en
data=$base/data/$tgt-$src
bpe_operations=32000  # Set the desired number of BPE merge operations
bpe_dir=$data/preprocessed_bpe  # Separate directory for BPE-preprocessed data
bpe_code=$bpe_dir/bpe_code  # Path to save the BPE codes

# Change into base directory to ensure paths are valid
cd $base

# Create directories for BPE-processed data
mkdir -p $bpe_dir

# Step 1: Normalize and Tokenize raw data
cat $data/raw/train.$src | perl moses_scripts/normalize-punctuation.perl -l $src | perl moses_scripts/tokenizer.perl -l $src -a -q > $bpe_dir/train.$src.tok
cat $data/raw/train.$tgt | perl moses_scripts/normalize-punctuation.perl -l $tgt | perl moses_scripts/tokenizer.perl -l $tgt -a -q > $bpe_dir/train.$tgt.tok

# Prepare remaining splits (valid, test, tiny_train) by normalizing and tokenizing
for split in valid test tiny_train
do
    cat $data/raw/$split.$src | perl moses_scripts/normalize-punctuation.perl -l $src | perl moses_scripts/tokenizer.perl -l $src -a -q > $bpe_dir/$split.$src.tok
    cat $data/raw/$split.$tgt | perl moses_scripts/normalize-punctuation.perl -l $tgt | perl moses_scripts/tokenizer.perl -l $tgt -a -q > $bpe_dir/$split.$tgt.tok
done

# Step 2: Learn BPE on concatenated tokenized data
cat $bpe_dir/train.$src.tok $bpe_dir/train.$tgt.tok | subword-nmt learn-bpe -s $bpe_operations > $bpe_code

# Step 3: Apply BPE to all splits and save in the BPE directory
for lang in $src $tgt
do
    for split in train valid test tiny_train
    do
        subword-nmt apply-bpe -c $bpe_code < $bpe_dir/$split.$lang.tok > $bpe_dir/$split.$lang
    done
done

# Step 4: Run preprocessing for model training using BPE-preprocessed data
python preprocess.py --target-lang $tgt --source-lang $src --dest-dir $data/prepared_bpe/ \
                     --train-prefix $bpe_dir/train --valid-prefix $bpe_dir/valid \
                     --test-prefix $bpe_dir/test --tiny-train-prefix $bpe_dir/tiny_train \
                     --threshold-src 1 --threshold-tgt 1 --num-words-src 4000 --num-words-tgt 4000

echo "BPE preprocessing complete!"
