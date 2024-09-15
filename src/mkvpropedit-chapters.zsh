#!/usr/bin/env zsh
set -euo pipefail

for F in "$@"; do
    ch_1="${F:h}/chapters/${F:t:r}.txt"
    ch_2="${F:h:h}/out/chapters/${F:t:r}.txt"

    if [ -f ${ch_1} ]; then
        mkvpropedit --chapters ${ch_1} ${F}
    elif [ -f ${ch_2} ]; then
        mkvpropedit --chapters ${ch_2} ${F}
    fi

    name=${F:t:r}
    name=${name% \(*}
    fileWithTitles="${F:h:h}/titles.txt"
    if [ -f ${fileWithTitles} ]; then
        title=$(grep -i "^${name}:" ${fileWithTitles})
        title=${title#*: }
        tagTitle=${title/#EP/E}
        mkvpropedit --set "title=${tagTitle}" ${F}
    fi
done

kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 7
