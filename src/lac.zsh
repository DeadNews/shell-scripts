#!/usr/bin/env zsh
lac='/home/deadnews/my/bin/LAC'
echo "Lossless Audio Checker 2.0.5\n" >"${1:h}/lac.log"

for F in "$@"; do
    flac --decode --silent ${F} -o "/tmp/${F:t:r}.wav"
    ${lac} "/tmp/${F:t:r}.wav" | grep -i '^[FR]' >>"${F:h}/lac.log"
    sed -i -e 's%/tmp/%%g' "${F:h}/lac.log"
    unlink "/tmp/${F:t:r}.wav"
done
kdialog --title "LAC" --passivepopup "${1:h:t} done" 7

# LosslessAudioChecker
# grep -i '^[FR]' "${F:h}/lac.log"
# sed -i -e 's/tmp/lol/g' "${F:h}/lac.log"     ${foo//mi/ma}

# N=$(nproc)
# (
# for thing in a b c d e f g; do
#    ((i=i%N)); ((i++==0)) && wait
#    task "$thing" &
# done
# )
# https://unix.stackexchange.com/questions/103920/parallelize-a-bash-for-loop
