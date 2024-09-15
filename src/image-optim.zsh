#!/usr/bin/env zsh
# Usage:
# ~/git/shell-scripts/src/image-optim.zsh --png-mod --level 7 $F

set -euo pipefail
zparseopts -D -E -F -A opts -- -png-mod -level:
source $(which env_parallel.zsh)

main() {
    mime=$(file -b --mime-type "${1}")

    if [[ ${mime} == "image/png" ]]; then
        if [[ "${(k)opts[--png-mod]}" ]]; then
            optipng -strip all -o${opts[--level]:='5'} "${1}"
        else
            cwebp -m 6 -z 9 -lossless "${1}" -o "${1:r}.webp" && unlink "${1}"
        fi
    elif [[ ${mime} == "image/jpeg" ]]; then
        jpegoptim --strip-all --all-progressive "${1}"
        mv "${1}" "${1:r}.jpg"
    fi
}

env_parallel --jobs 40% --eta main ::: "$@"

kdialog --title "image-optim" --passivepopup "${1:h:t} done" 7
