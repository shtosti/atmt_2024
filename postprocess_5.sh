#!/bin/bash


# ### small baseline ###
# OUTPUT_DIR="assignments/05/small_baseline"
# scripts/postprocess.sh \
# $OUTPUT_DIR/translations.txt \
# $OUTPUT_DIR/translations.p.txt en


### small beam=5 ###
OUTPUT_DIR="assignments/05/small--beam-size-5"
scripts/postprocess.sh \
$OUTPUT_DIR/translations.txt \
$OUTPUT_DIR/translations.p.txt en