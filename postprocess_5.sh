#!/bin/bash


# ### small baseline ###
# OUTPUT_DIR="assignments/05/small_baseline"
# scripts/postprocess.sh \
# $OUTPUT_DIR/translations.txt \
# $OUTPUT_DIR/translations.p.txt en


# Starting beam size
START_BEAM=2
# Ending beam size
END_BEAM=25
# Beam increment
INCREMENT=3

# Loop over the beam sizes
for BEAM_SIZE in $(seq $START_BEAM $INCREMENT $END_BEAM)
do
    OUTPUT_DIR="assignments/05/large--beam-size-$BEAM_SIZE"
    scripts/postprocess.sh \
    $OUTPUT_DIR/translations.txt \
    $OUTPUT_DIR/translations.p.txt en
done