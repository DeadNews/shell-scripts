#!/usr/bin/env zsh

# while [ -n "$1" ]
# do
# case "$1" in
#   --format) format="$2"; shift ;;
#   --) shift; break ;;
#   *) echo "$1 is not an option";;
# esac
# shift
# done
zparseopts -D -format:=format

for F in "$@"; do
    if [[ ${format[-1]} == "xml" ]]; then
        mkvextract ${F} chapters "${F:h}/chapters/${F:t:r}.xml"

    elif [[ ${format[-1]} == "txt" ]]; then
        mkvextract ${F} chapters -s "${F:h}/chapters/${F:t:r}.txt"
    fi
done
kdialog --title "mkvextract" --passivepopup "${1:h:t} done" 7

# Exec=/home/deadnews/my/scripts/zsh/mkvextract-chapters.sh --format txt $F
