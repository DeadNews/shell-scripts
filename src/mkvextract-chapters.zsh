#!/usr/bin/env zsh
zparseopts -D -format:=format

for F in "$@"; do
    if [[ ${format[-1]} == "xml" ]]; then
        mkvextract ${F} chapters "${F:h}/chapters/${F:t:r}.xml"

    elif [[ ${format[-1]} == "txt" ]]; then
        mkvextract ${F} chapters -s "${F:h}/chapters/${F:t:r}.txt"
    fi
done

kdialog --title "mkvextract" --passivepopup "${1:h:t} done" 7
