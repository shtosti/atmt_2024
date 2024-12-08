#!/bin/bash

# ### small baseline ###
# OUTPUT_DIR="assignments/05/small_baseline"
# mkdir -p "$OUTPUT_DIR"
# python translate.py \
# --data data/en-fr/prepared \
# --dicts data/en-fr/prepared \
# --checkpoint-path assignments/03/small_baseline/checkpoints/checkpoint_last.pt \
# --output $OUTPUT_DIR/translations.txt


### small beam k=default ###
OUTPUT_DIR="assignments/05/small--beam-size-5"
mkdir -p "$OUTPUT_DIR"
python translate_beam.py \
--data data/en-fr/prepared \
--dicts data/en-fr/prepared \
--checkpoint-path assignments/03/small_baseline/checkpoints/checkpoint_last.pt \
--output $OUTPUT_DIR/translations.txt

