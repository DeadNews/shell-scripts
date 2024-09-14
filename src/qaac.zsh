#!/usr/bin/env zsh
set -euo pipefail

V='127'
tmp_dir=$(mktemp -d)

for F in "$@"; do
    tmp="${tmp_dir}/${1:t:r}.wav"
    ffmpeg -hide_banner -i ${F} -acodec pcm_s16le ${tmp}
    qaac --no-delay -V ${V} ${tmp} -o "${F:r}.m4a"
    # qaac -V ${V} ${tmp} -o "${F:r}.m4a"
    unlink ${tmp}
done

# kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 7
