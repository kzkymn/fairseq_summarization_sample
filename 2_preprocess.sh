#!/bin/sh
# Copyright (c) 2020, kzkymn All rights reserved.

TOTAL_NUM_UPDATES=20000  
WARMUP_UPDATES=500      
MAX_TOKENS=2048
UPDATE_FREQ=4
BART_PATH=./mbart/model.pt
LANGUAGE=en
DATA=tmp/bpe

rm -rf ./data-bin/

CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7 ~/.venv/transformers/bin/fairseq-preprocess \
    --seed 1 \
    --bpe sentencepiece \
    --task translation \
    -s source \
    -t target \
    --trainpref ${DATA}/${LANGUAGE}/train \
    --validpref ${DATA}/${LANGUAGE}/valid \
    --testpref ${DATA}/${LANGUAGE}/test \
    --align-suffix binarized \
    --joined-dictionary \
    --workers 8
