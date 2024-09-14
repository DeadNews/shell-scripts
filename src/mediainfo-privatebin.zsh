#!/usr/bin/env zsh
set -euo pipefail

for F in "$@"; do
    mediainfo=$(mediainfo ${F})
    privatebin=$(pbincli send -E never -t "${mediainfo}")

    url=$(echo ${privatebin} | grep -i '^Link:')
    echo "https:${url/*https:/}" | xclip
done

kdialog --title "privatebin" --passivepopup "${1:t:r} done" 3
