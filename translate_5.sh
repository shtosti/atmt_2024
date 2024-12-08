#!/bin/bash

### small baseline ###
mkdir -p assignments/05/small_baseline
python translate.py \
--data data/en-fr/prepared \
--dicts data/en-fr/prepared \
--checkpoint-path assignments/03/small_baseline/checkpoints/checkpoint_last.pt \
--output assignments/05/small_baseline/translations.txt


### large baseline ###
mkdir -p assignments/05/large_baseline
python translate.py \
--data data/en-fr/prepared \
--dicts data/en-fr/prepared \
--checkpoint-path assignments/03/large_baseline/checkpoints/checkpoint_last.pt \
--output assignments/05/large_baseline/translations.txt