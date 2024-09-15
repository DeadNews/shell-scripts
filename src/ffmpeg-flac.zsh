#!/usr/bin/env zsh
set -euo pipefail

N=$(nproc)
for F in "$@"; do
    ((i = i % N))
    ((i++ == 0)) && wait
    (
        bit_depth=$(mediainfo --Inform="Audio;%BitDepth%" ${F})
        if [[ ${bit_depth} == '16' ]]; then
            sample_fmt='s16'
        elif [[ ${bit_depth} == '24' ]]; then
            sample_fmt='s32'
        else
            sample_fmt='s16'
        fi
        ffmpeg -hide_banner -i ${F} -map 0:a:0 -sample_fmt ${sample_fmt} -acodec flac -compression_level 8 "/tmp/${F:t:r}.flac"
        mv "/tmp/${F:t:r}.flac" "${F:h}"
    ) &
done
wait

# kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 7
