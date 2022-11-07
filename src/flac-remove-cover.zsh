#!/usr/bin/env zsh

for F in "$@"; do
    metaflac --remove --block-number=3 ${F}
done
