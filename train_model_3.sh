#!/bin/bash

# ### small baseline ###
# python train.py \
# --train-on-tiny \
# --data data/en-fr/prepared \
# --source-lang fr \
# --target-lang en \
# --save-dir assignments/03/small_baseline/checkpoints \
# --log-file assignments/03/small_baseline/logs/train_log.txt


# ### small batch 16 ###
# python train.py \
# --train-on-tiny \
# --data data/en-fr/prepared \
# --source-lang fr \
# --target-lang en \
# --save-dir assignments/03/small_batch16/checkpoints \
# --log-file assignments/03/small_batch16/logs/train_log.txt \
# --batch-size 16


# ### small lr 0.003 ###
# python train.py \
# --train-on-tiny \
# --data data/en-fr/prepared \
# --source-lang fr \
# --target-lang en \
# --save-dir assignments/03/small_lr0p003/checkpoints \
# --log-file assignments/03/small_lr0p003/logs/train_log.txt \
# --lr 0.003

# ### small --clip-norm 2.0 ###
# python train.py \
# --train-on-tiny \
# --data data/en-fr/prepared \
# --source-lang fr \
# --target-lang en \
# --save-dir assignments/03/small_clip-norm2/checkpoints \
# --log-file assignments/03/small_clip-norm2/logs/train_log.txt \
# --clip-norm 2.0

### small hyperparam-tuning ###
python train.py \
--train-on-tiny \
--data data/en-fr/prepared \
--source-lang fr \
--target-lang en \
--save-dir assignments/03/small_hyperparam-tuning/checkpoints \
--log-file assignments/03/small_hyperparam-tuning/logs/train_log.txt \
--clip-norm 2.0 \
--batch-size 8 \
--lr 0.003