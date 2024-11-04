#!/bin/bash
infile=$1
outfile=$2
lang=$3

# Remove BPE markers and detokenize
cat $infile | sed -r 's/(@@ )|(@@ ?$)//g' | perl moses_scripts/detokenizer.perl -q -l $lang > $outfile
