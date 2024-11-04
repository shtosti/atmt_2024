#!/bin/bash

# ### small baseline ###
# python translate.py \
# --data data/en-fr/prepared \
# --dicts data/en-fr/prepared \
# --checkpoint-path assignments/03/small_baseline/checkpoints/checkpoint_last.pt \
# --output assignments/03/small_baseline/translations.txt


### small batch 16 ###
python translate.py \
--data data/en-fr/prepared \
--dicts data/en-fr/prepared \
--checkpoint-path assignments/03/small_batch16/checkpoints/checkpoint_last.pt \
--output assignments/03/small_batch16/translations.txt \
--batch-size 16