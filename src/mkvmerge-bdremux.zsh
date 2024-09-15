#!/usr/bin/env zsh
set -euo pipefail

for F in "$@"; do
    N=3
    ((i = i % N))
    ((i++ == 0)) && wait
    (
        ffmpeg -hide_banner -i ${F} \
            -map 0:a:0 -acodec flac -compression_level 12 "/tmp/${F:t:r}.flac"
        # -map 0:a:1 -acodec libopus -b:a 100k "/tmp/${F:t:r}.opus"

        if [ -f "/tmp/${F:t:r}.opus" ]; then
            mkvmerge --output "${F:h}/bdremux/commentary/${F:t:r}.commentary.opus.mka" --language 0:jpn --track-name '0:LPCM->OPUS' "/tmp/${F:t:r}.opus"
            unlink "/tmp/${F:t:r}.opus"
        fi
    ) &
done

wait
for F in "$@"; do

    mkvmerge --output "${F:h}/bdremux/${F:t:r}.mkv" --no-audio --language 0:jpn --track-name '0:BDRemux by DeadNews' ${F} --language 0:jpn --track-name '0:LPCM->FLAC' "/tmp/${F:t:r}.flac" --track-order 0:0,1:0 --chapters "${F:h}/chapters/${F:t:r}.txt"
    unlink "/tmp/${F:t:r}.flac"

done
kdialog --title "mkvmerge" --passivepopup "${1:h:t} done" 7
