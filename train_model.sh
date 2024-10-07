#!/bin/bash

# ### small ###
# python train.py \
# --train-on-tiny \
# --data data/en-sv/infopankki/prepared \
# --source-lang sv \
# --target-lang en \
# --save-dir assignments/01/baseline_small/checkpoints \
# --log-file assignments/01/baseline_small/logs/train_log.txt


### large ###
python train.py \
--data data/en-sv/infopankki/prepared \
--source-lang sv \
--target-lang en \
--save-dir assignments/01/baseline_large/checkpoints \
--log-file assignments/01/baseline_large/logs/train_log.txt