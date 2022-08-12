#!/usr/bin/env zsh

tmp_dir=$(mktemp -d)

for F in "$@"; do

    tmp="${tmp_dir}/${1:t:r}.wav"
    ffmpeg -hide_banner -i ${F} -acodec pcm_s16le ${tmp}
    fdkaac -m 5 ${tmp} -o "${F:r}.m4a"
    # fdkaac -m 0 -b 320 ${tmp} -o "${F:r}.m4a"
    unlink ${tmp}

done

# kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 7

# m 5 = 192 kb/s