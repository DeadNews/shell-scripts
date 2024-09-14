#!/usr/bin/env zsh
set -euo pipefail

for F in "$@"; do
    dir="${F:h}/fonts"
    # dir="${F:h}/${F:t:r}"
    mkdir -p ${dir}
    cd ${dir}
    ffmpeg -hide_banner -dump_attachment:t "" -i ${F} -y
done

for F in "$argv[$#]"; do
    cd "${F:h}/fonts"

    # for F in *; do
    #     font-rename ${F}
    # done

    fdupes -dN "${PWD}"

    autoload zmv
    chars='[][?=+<>;",-]'
    zmv '(**/)()' '$1${2//$~chars/%}'
done

# kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 7
