#!/bin/bash

### small in-domain ###
# python translate.py \
# --data data/en-sv/infopankki/prepared \
# --dicts data/en-sv/infopankki/prepared \
# --checkpoint-path assignments/01/baseline_small/checkpoints/checkpoint_last.pt \
# --output assignments/01/baseline_small/infopankki_translations.txt

# ### small + bible ###
# python translate.py \
# --data data/en-sv/bible_uedin/prepared \
# --dicts data/en-sv/infopankki/prepared/ \
# --checkpoint-path assignments/01/baseline_small/checkpoints/checkpoint_last.pt \
# --output assignments/01/baseline_small/bible_translations.txt

# ### small + TED ###
# python translate.py \
# --data data/en-sv/TED2020/prepared \
# --dicts data/en-sv/infopankki/prepared/ \
# --checkpoint-path assignments/01/baseline_small/checkpoints/checkpoint_last.pt \
# --output assignments/01/baseline_small/TED_translations.txt

# ### large + in-domain ###
# python translate.py \
# --data data/en-sv/infopankki/prepared \
# --dicts data/en-sv/infopankki/prepared \
# --checkpoint-path assignments/01/baseline_large/checkpoints/checkpoint_last.pt \
# --output assignments/01/baseline_large/infopankki_translations.txt

# ### large + bible ###
# python translate.py \
# --data data/en-sv/bible_uedin/prepared \
# --dicts data/en-sv/infopankki/prepared/ \
# --checkpoint-path assignments/01/baseline_large/checkpoints/checkpoint_last.pt \
# --output assignments/01/baseline_large/bible_translations.txt

### large + TED ###
python translate.py \
--data data/en-sv/TED2020/prepared \
--dicts data/en-sv/infopankki/prepared/ \
--checkpoint-path assignments/01/baseline_large/checkpoints/checkpoint_last.pt \
--output assignments/01/baseline_large/TED_translations.txt