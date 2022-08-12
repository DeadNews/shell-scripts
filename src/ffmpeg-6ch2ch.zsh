#!/usr/bin/env zsh

for F in "$@"; do

    mkdir -p "${F:h}/+stereo"

    bit_depth=$(mediainfo --Inform="Audio;%BitDepth%" ${F})
    channel_layout=$(mediainfo --Inform="Audio;%ChannelLayout%" ${F})

    if [[ "${bit_depth}" == '16' ]]; then
        sample_fmt='s16'
        compression_level='12'
    elif [[ "${bit_depth}" == '24' ]]; then
        sample_fmt='s32'
        compression_level='8'
    fi

    if [[ "${channel_layout}" == 'L R C LFE Ls Rs' ]]; then
        af='pan=stereo|FL = 1.0*FL + 0.707*FC + 0.707*SL|FR = 1.0*FR + 0.707*FC + 0.707*SR'
    elif [[ "${channel_layout}" == 'L R C LFE Lb Rb' ]]; then
        af='pan=stereo|FL < 1.0*FL + 0.707*FC + 0.707*BL|FR < 1.0*FR + 0.707*FC + 0.707*BR'
    fi

    ffmpeg -hide_banner -i ${F} \
        -map 0:a:0 -af ${af} -sample_fmt ${sample_fmt} \
        -acodec flac -compression_level ${compression_level} "${F:h}/+stereo/${F:t:r}.flac"

done

# https://trac.ffmpeg.org/wiki/AudioChannelManipulation#a5.1stereo
