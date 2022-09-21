#!/usr/bin/env zsh
bits_test() {
    bit_depth=$(mediainfo --Inform="Audio;%BitDepth%" ${1})
    sampl_rate=$(mediainfo --Inform="Audio;%SamplingRate%" ${1})

    if [[ "${bit_depth}" == "24" ]]; then
        echo "${bit_depth}/${sampl_rate}: ${1}"
    fi
}

for H in "$@"; do
    cd ${H}
    setopt +o nomatch
    for F (**/*.flac) bits_test ${F}
done
