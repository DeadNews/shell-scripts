#!/usr/bin/env zsh

N=$(nproc)
for F in "$@"; do
    ((i = i % N))
    ((i++ == 0)) && wait
    (
        cwebp -m 6 -z 9 -lossless ${F} -o "${F:h}/${F:t:r}.webp"
    ) &
done
wait

# kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 7
