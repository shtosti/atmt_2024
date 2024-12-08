#!/bin/bash

# ### small baseline ###
# OUTPUT_DIR="assignments/05/small_baseline"
# mkdir -p "$OUTPUT_DIR"
# python translate.py \
# --data data/en-fr/prepared \
# --dicts data/en-fr/prepared \
# --checkpoint-path assignments/03/small_baseline/checkpoints/checkpoint_last.pt \
# --output $OUTPUT_DIR/translations.txt


# # Starting beam size
# START_BEAM=2
# # Ending beam size
# END_BEAM=25
# # Beam increment
# INCREMENT=3

# # Loop over the beam sizes
# for BEAM_SIZE in $(seq $START_BEAM $INCREMENT $END_BEAM)
# do
#     OUTPUT_DIR="assignments/05/large--beam-size-$BEAM_SIZE"
#     mkdir -p "$OUTPUT_DIR"

#     python translate_beam.py \
#     --beam-size $BEAM_SIZE \
#     --data data/en-fr/prepared \
#     --dicts data/en-fr/prepared \
#     --checkpoint-path assignments/03/baseline/checkpoints/checkpoint_last.pt \
#     --output "$OUTPUT_DIR/translations.txt"
# done


BEAM_SIZE=3
OUTPUT_DIR="assignments/05/large--beam-size-$BEAM_SIZE"
mkdir -p "$OUTPUT_DIR"

python translate_beam.py \
--beam-size $BEAM_SIZE \
--data data/en-fr/prepared \
--dicts data/en-fr/prepared \
--checkpoint-path assignments/03/baseline/checkpoints/checkpoint_last.pt \
--output "$OUTPUT_DIR/translations.txt"

