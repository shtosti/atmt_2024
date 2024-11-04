#!/bin/bash

### small baseline ###
python translate.py \
--data data/en-fr/prepared \
--dicts data/en-fr/prepared \
--checkpoint-path assignments/03/baseline_small/checkpoints/checkpoint_last.pt \
--output assignments/03/baseline_small/translations.txt

