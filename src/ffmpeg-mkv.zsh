#!/usr/bin/env zsh

for F in "$@"; do
    ffmpeg -hide_banner -i ${F} -codec copy "${F:r}.mkv"
done

kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 7
