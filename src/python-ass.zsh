#!/usr/bin/env zsh
set -euo pipefail

for F in "$@"; do
    time_shift='+1s'
    # time_shift='-10.05'
    # time_shift='-3s'

    mkdir -p "${F:h}/+retimed"
    prass shift --by ${time_shift} ${F} -o "${F:h}/+retimed/${F:t:r}.ass"
done

# Deps:
# pipx install git+https://github.com/tp7/prass
