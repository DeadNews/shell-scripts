#!/usr/bin/env zsh

zparseopts -D -good_dir:=good_dir

for F in "$@"; do

    out_dir="${F:h}/+shift"
    mkdir -p ${out_dir}
    name=${F:t:r}
    name_short=${name%%.*}
    echo ${name_short}

    bad="${F}"
    good="${good_dir[-1]}/${name_short}.mka"
    out="${out_dir}/${name}.flac"

    ~/.local/bin/sync-audio-tracks.sh ${bad} ${good} ${out}

done

kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 4
