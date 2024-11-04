#!/bin/bash

# ### small + in-domain ###
# cat \
# assignments/01/baseline_small/infopankki_translations.p.txt \
# | sacrebleu data/en-sv/infopankki/raw/test.en

# ### small + bible ###
# cat \
# assignments/01/baseline_small/bible_translations.p.txt \
# | sacrebleu data/en-sv/bible_uedin/raw/test.en

# ### small + TED ###
# cat \
# assignments/01/baseline_small/TED_translations.p.txt \
# | sacrebleu data/en-sv/TED2020/raw/test.en

# ### large + in-domain ###
# cat \
# assignments/01/baseline_large/infopankki_translations.p.txt \
# | sacrebleu data/en-sv/infopankki/raw/test.en

# ### large + bible ###
# cat \
# assignments/01/baseline_large/bible_translations.p.txt \
# | sacrebleu data/en-sv/bible_uedin/raw/test.en

### large + TED ###
cat \
assignments/01/baseline_large/TED_translations.p.txt \
| sacrebleu data/en-sv/TED2020/raw/test.en