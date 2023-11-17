#!/usr/bin/env zsh

for F in "$@"; do
    name=${F:t:r}
    name=${name% \(*}
    mkdir -p "${F:h}/mkv"

    mkvmerge --output "${F:h}/mkv/${name:t:r}.mkv" ${F}
    # mkvmerge --output "${F:h}/mkv/${F:t:r}.mkv" ${F}
done

# kdialog --title "${0:t:r}" --passivepopup "${1:t:r} done" 7
