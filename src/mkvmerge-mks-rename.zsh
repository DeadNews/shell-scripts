#!/usr/bin/env zsh

lang='eng'
# lang='rus'

name='[BD]'
# name='[crunchyroll]'

for F in "$@"; do
    # make mks
    echo ${F:t}
    outfile="${F:h}/${name}/${F:t:r}.mks"
    mkvmerge --output ${outfile} --no-audio --no-video --no-chapters --no-attachments --no-global-tags --language 0:${lang} --track-name 0:"${name}" --compression 0:zlib ${F} --title ""

    # add attachment to mks
    stem="${F:t:r}"
    attach_dir="${F:h}/${stem%%_*}_Attachments/"
    fonts_dir="${F:h}/fonts/"
    if [[ -d ${attach_dir} ]] || [[ -d ${fonts_dir} ]]; then
        if [[ -d ${attach_dir} ]]; then
            cd ${attach_dir}
        elif [[ -d ${fonts_dir} ]]; then
            cd ${fonts_dir}
        fi
        args=()

        for F in *; do
            args+=(--add-attachment ${F})
        done

        mkvpropedit ${outfile} ${args[*]}
        cd "${F:h}/"
    fi
done

# kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 7
