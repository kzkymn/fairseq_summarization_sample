#!/bin/bash
# Copyright (c) 2020, kzkymn All rights reserved.

~/.venv/transformers/bin/fairseq-generate data-bin \
    --path checkpoints/checkpoint_best.pt \
    --skip-invalid-size-inputs-valid-test \
    --beam 5 --remove-bpe > result.txt
