#!/bin/bash

# ### small baseline ###
# cat \
# assignments/03/small_baseline/translations.p.txt \
# | sacrebleu data/en-fr/raw/test.en


### small batch 16 ###
cat \
assignments/03/small_batch16/translations.p.txt \
| sacrebleu data/en-fr/raw/test.en