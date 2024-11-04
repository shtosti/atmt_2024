#!/bin/bash

# ### small baseline ###
# cat \
# assignments/03/small_baseline/translations.p.txt \
# | sacrebleu data/en-fr/raw/test.en


# ### small batch 16 ###
# cat \
# assignments/03/small_batch16/translations.p.txt \
# | sacrebleu data/en-fr/raw/test.en

# ### small lr 0.003 ###
# cat \
# assignments/03/small_lr0p003/translations.p.txt \
# | sacrebleu data/en-fr/raw/test.en

# ### small clip norm 2.0 ###
# cat \
# assignments/03/small_clip-norm2/translations.p.txt \
# | sacrebleu data/en-fr/raw/test.en

### small hyperparam tuning ###
cat \
assignments/03/small_hyperparam-tuning/translations.p.txt \
| sacrebleu data/en-fr/raw/test.en
