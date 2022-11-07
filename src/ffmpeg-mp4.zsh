#!/usr/bin/env zsh

zparseopts -D -del=del -no_del_vid=no_del_vid -dir:=dir

for F in "$@"; do

    if [[ ${dir} ]]; then
        out_dir="${dir[-1]}"
    else
        out_dir="${F:h}"
    fi

    if [[ ${no_del_vid} ]]; then
        ffmpeg -hide_banner -i ${F} -codec copy "${out_dir}/${F:t:r}.mp4"
    else
        ffmpeg -hide_banner -i ${F} -map 0:v:0 -codec copy "${out_dir}/${F:t:r}.mp4"
    fi

    if [[ ${del} ]]; then
        unlink ${F}
    fi

done

kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 7
