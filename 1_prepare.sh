#!/usr/bin/env bash
# Copyright (c) 2015, Facebook, Inc. All rights reserved.
# Copyright (c) 2020, kzkymn All rights reserved.
# Adapted from https://github.com/facebookresearch/MIXER/blob/master/prepareData.sh
 
if [ ! -f mosesdecoder ]; then
    echo 'Cloning Moses github repository (for tokenization scripts)...'
    git clone https://github.com/moses-smt/mosesdecoder.git
fi
 
if [ ! -f subword-nmt ]; then
    echo 'Cloning Subword NMT repository (for BPE pre-processing)...'
    git clone https://github.com/rsennrich/subword-nmt.git
fi
 
SCRIPTS=mosesdecoder/scripts
LC=$SCRIPTS/tokenizer/lowercase.perl
CLEAN=$SCRIPTS/training/clean-corpus-n.perl
BPEROOT=subword-nmt
BPE_TOKENS=10000

language=en
src=source
tgt=target
prep=tmp/bpe/$language
tmp=tmp
orig=orig/$language

TOKENIZER=mecab.pl
if [ $language == en ]; then
    TOKENIZER=$SCRIPTS/tokenizer/tokenizer.perl

fi

rm -rf $prep
rm -rf $tmp
mkdir -p $prep $tmp $tmp/splitted
 
# 原文と要約が対になっているtextをjpn.txtとする。すでに分けているのでここは略。
# mv jpn.txt orig
# mkdir $orig
# cat orig/jpn.txt | cut -f 2 > $orig/train.tags.$src
# cat orig/jpn.txt | cut -f 1 > $orig/train.tags.$tgt
 
echo "pre-processing train data..."
for l in $src $tgt; do
    f=train.$l
    tok=train.tokenized.$l
 
    cat $orig/$f | perl $TOKENIZER -threads 8 > $tmp/$tok
    echo ""
done

# mosesdecoderで行うデータクレンジングは今は行わないものとする。
# perl $CLEAN -ratio 1.5 $tmp/train.tags.tok $src $tgt $tmp/train.tags.clean 1 175
# for l in $src $tgt; do
#     perl $LC < $tmp/train.tags.clean.$l > $tmp/train.tags.$l
# done
 
echo "creating train, valid, test..."
~/.venv/transformers/bin/python split_data.py

# trainのデータのみでBPE圧縮用のパターンを学習する
TRAIN=$tmp/splitted/train.vocab
BPE_CODE=$tmp/splitted/bpe
rm -f $TRAIN
for l in $src $tgt; do
    cat $tmp/splitted/train.$l >> $TRAIN
done
 
echo "learn_bpe.py on ${TRAIN}..."
~/.venv/transformers/bin/python $BPEROOT/learn_bpe.py -s $BPE_TOKENS < $TRAIN > $BPE_CODE
 
# BPE圧縮を実行
for L in $src $tgt; do
    for f in train.$L valid.$L test.$L; do
        echo "apply_bpe.py to ${f}..."
        ~/.venv/transformers/bin/python $BPEROOT/apply_bpe.py -c $BPE_CODE < $tmp/splitted/$f > $prep/$f
    done
done
