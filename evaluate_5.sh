#!/bin/bash


# ### small baseline ###
# OUTPUT_DIR="assignments/05/small_baseline"
# cat \
# $OUTPUT_DIR/translations.p.txt \
# | sacrebleu data/en-fr/raw/test.en


### small beam-5 ###
OUTPUT_DIR="assignments/05/small--beam-size-5"
cat \
$OUTPUT_DIR/translations.p.txt \
| sacrebleu data/en-fr/raw/test.en