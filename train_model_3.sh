#!/bin/bash

### small baseline ###
python train.py \
--train-on-tiny \
--data data/en-fr/prepared \
--source-lang fr \
--target-lang en \
--save-dir assignments/03/baseline_small/checkpoints \
--log-file assignments/03/baseline_small/logs/train_log.txt


# ### large ###
