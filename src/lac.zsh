#!/usr/bin/env zsh
echo "Lossless Audio Checker 2.0.5\n" > "${1:h}/lac.log"

for F in "$@"; do
    flac --decode --silent ${F} -o "/tmp/${F:t:r}.wav"
    LAC "/tmp/${F:t:r}.wav" | grep -i '^[FR]' >> "${F:h}/lac.log"
    sed -i -e 's%/tmp/%%g' "${F:h}/lac.log"
    unlink "/tmp/${F:t:r}.wav"
done
kdialog --title "LAC" --passivepopup "${1:h:t} done" 7

# https://aur.archlinux.org/packages/losslessaudiochecker
