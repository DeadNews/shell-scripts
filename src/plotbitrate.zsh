#!/usr/bin/env zsh

for F in "$@"; do

    echo ${F:t}
    out_pic="${F:h}/plotbitrate/${F:t:r}.png"

    if [[ ! -f ${out_pic} ]]; then
        mkdir -p "${F:h}/plotbitrate"
        ~/git/plotbitrate/plotbitrate.py --stream video -o ${out_pic} ${F}
    fi
done

kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 5
