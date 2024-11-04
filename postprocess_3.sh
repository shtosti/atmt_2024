#!/bin/bash

# ### small baseline ###
# scripts/postprocess.sh \
# assignments/03/small_baseline/translations.txt \
# assignments/03/small_baseline/translations.p.txt en


# ### small batch 16 ###
# scripts/postprocess.sh \
# assignments/03/small_batch16/translations.txt \
# assignments/03/small_batch16/translations.p.txt en

# ### small lr 0.003 ###
# scripts/postprocess.sh \
# assignments/03/small_lr0p003/translations.txt \
# assignments/03/small_lr0p003/translations.p.txt en

# ### small clip norm 2.0 ###
# scripts/postprocess.sh \
# assignments/03/small_clip-norm2/translations.txt \
# assignments/03/small_clip-norm2/translations.p.txt en

# ### small hyperparam tuning ###
# scripts/postprocess.sh \
# assignments/03/small_hyperparam-tuning/translations.txt \
# assignments/03/small_hyperparam-tuning/translations.p.txt en

# ### large hyperparam tuning ###
# scripts/postprocess.sh \
# assignments/03/large_hyperparam-tuning/translations.txt \
# assignments/03/large_hyperparam-tuning/translations.p.txt en

# ### large hyperparam-tuning-2 ###
# scripts/postprocess.sh \
# assignments/03/large_hyperparam-tuning-2/translations.txt \
# assignments/03/large_hyperparam-tuning-2/translations.p.txt en

# ### small BPE ###
# scripts/postprocess_data_BPE.sh \
# assignments/03/small_bpe/translations.txt \
# assignments/03/small_bpe/translations.p.txt en

### large BPE ###
scripts/postprocess_data_BPE.sh \
assignments/03/large_bpe/translations.txt \
assignments/03/large_bpe/translations.p.txt en