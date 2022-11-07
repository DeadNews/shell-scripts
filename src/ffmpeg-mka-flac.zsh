#!/usr/bin/env zsh

N=$(nproc)
for F in "$@"; do
    ((i = i % N))
    ((i++ == 0)) && wait
    (
        mkdir -p "${F:h}/flac12"

        ffmpeg -hide_banner -i ${F} -acodec flac -compression_level 12 "/tmp/${F:t:r}.flac"
        mkvmerge --output "${F:h}/flac12/${F:t:r}.mka" --language 0:jpn --track-name '0:LPCM->FLAC' "/tmp/${F:t:r}.flac"
        unlink "/tmp/${F:t:r}.flac"
    ) &
done
wait

kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 7

# DTS-HDMA->FLAC
