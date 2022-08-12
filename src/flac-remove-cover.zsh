#!/usr/bin/env zsh

for F in "$@"; do

  metaflac --remove --block-number=3 ${F}

done

# kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 7
