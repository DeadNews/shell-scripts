#!/usr/bin/env zsh

for F in "$@"; do
    bit_depth=$(mediainfo --Inform="Audio;%BitDepth%" ${F})

    if [[ ${bit_depth} == '16' ]]; then
        acodec='pcm_s16le'
    elif [[ ${bit_depth} == '24' ]]; then
        acodec='pcm_s24le'
    fi

    ffmpeg -hide_banner -i ${F} -acodec ${acodec} "${F:r}.wav"
done

# kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 7
