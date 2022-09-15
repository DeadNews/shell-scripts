#!/usr/bin/env zsh
zparseopts -D -E -F -A opts -- -png_mod -level:
source $(which env_parallel.zsh)

main() {
    mime="$(file -b --mime-type ${1})"

    if [[ ${mime} == "image/png" ]]; then
        if [[ "${(k)opts[--png_mod]}" ]]; then
            optipng -strip all -o${opts[--level]:='7'} ${1}
        else
            cwebp -m 6 -z 9 -lossless ${1} -o "${1:r}.webp" && unlink ${1}
        fi
    elif [[ ${mime} == "image/jpeg" ]]; then
        jpegoptim --strip-all --all-progressive ${1}
        mv ${1} "${1:r}.jpg"
    fi
}

env_parallel --eta main ::: "$@"

kdialog --title "image-optim" --passivepopup "${1:h:t} done" 7

# ~/my/scripts/zsh/image-optim.zsh --png_mod --level 7  $F
# find . -type f -print0 | xargs -0 ~/my/scripts/zsh/image-optim.zsh
