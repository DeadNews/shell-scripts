#!/usr/bin/env zsh
zparseopts -D -E -F -A opts -- q:
source $(which env_parallel.zsh)

quality=${opts[-q]:=100}
echo "quality=${quality}"

function webp-convert() {
    mkdir -p "${1:h:h}/${1:h:t}–q${quality}"
    cwebp -m 6 -q ${quality} -pass 5 ${1} -o "${1:h:h}/${1:h:t}–q${quality}/${1:t:r}.webp"
}

for H in "$@"; do
    # setopt +o nomatch
    # env_parallel --eta webp-convert ::: ${H}/**/*

    find "${H}" -type f | env_parallel --eta webp-convert {}
done

kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 7
