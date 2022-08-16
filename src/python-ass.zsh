#!/usr/bin/env zsh

for F in "$@"; do
    time_shift='+1s'
    # time_shift='-10.05'
    # time_shift='-3s'

    mkdir -p "${F:h}/+retimed"
    prass shift --by ${time_shift} ${F} -o "${F:h}/+retimed/${F:t:r}.ass"
done

## install
# yay -S python-click
# pip install git+https://github.com/tp7/prass
## help
# prass shift -h
# https://pysubs2.readthedocs.io/en/latest/cli.html
