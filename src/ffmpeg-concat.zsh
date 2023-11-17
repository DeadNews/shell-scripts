#!/usr/bin/env zsh

for F in "$@"; do
    silence_time=1
    # silence_time=0.042
    # silence_time=0.001
    # silence_time=0.480
    # silence_time=2.100

    rate=$(mediainfo --Inform="Audio;%SamplingRate%" ${F})
    silence='/tmp/silence.aac'
    if [[ ! -f ${silence} ]]; then
        ffmpeg -hide_banner -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=${rate} -t ${silence_time} ${silence}
    fi

    mkdir -p "${F:h}/combined"
    ffmpeg -hide_banner -i concat:"${silence}|${F}" -codec copy "${F:h}/combined/${F:t:r} [${silence_time}+].aac"

done

unlink ${silence}

# https://ubuntugeeks.com/questions/381072/add-1-second-of-silence-to-audio-through-ffmpeg
# ffmpeg -hide_banner -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=48000 -t 1 silence.aac
# ffmpeg -hide_banner -i concat:"silence.aac|audio6.aac" -codec copy combined.aac
