#!/bin/sh
# Copyright (c) 2020, kzkymn All rights reserved.

WARMUP_UPDATES=500      
LR=3e-05
MAX_TOKENS=2048
UPDATE_FREQ=4

CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7 ~/.venv/transformers/bin/fairseq-train data-bin \
    --max-tokens $MAX_TOKENS \
    --arch bart_large \
    --source-lang source --target-lang target \
    --task translation \
    --optimizer adam --adam-betas '(0.9,0.98)' --clip-norm 0.0 \
    --lr $LR --lr-scheduler inverse_sqrt --warmup-updates 2000 \
    --dropout 0.3 --weight-decay 0.0001 \
    --criterion label_smoothed_cross_entropy --label-smoothing 0.1 \
    --max-tokens $MAX_TOKENS \
    --warmup-updates $WARMUP_UPDATES \
    --update-freq $UPDATE_FREQ \
    --save-interval 1 \
    --skip-invalid-size-inputs-valid-test \
    --find-unused-parameters;
