#!/usr/bin/env zsh

lang='eng'
# lang='rus'

# name='[BD]'
# name='[crunchyroll]'
# name='[YameteTomete]'
# name='[YameteTomete] [signs]'
# name='[GJM]'
# name='[BlurayDesuYo]'
# name='[SallySubs+DameDesuYo+LostYears]'
# name='[SallySubs+DameDesuYo+LostYears] [signs]'
# name='[DameDesuYo+kBaraka]'
# name='[EveTaku+Coalgirls+Baal+SCY]'
# name='[EveTaku+Coalgirls+Baal+SCY] [signs]'
# name='[BlurayDesuYo+SCY]'
# name='[BlurayDesuYo+SCY] [signs]'
# name='[KH]'
# name='[KH] [signs]'
# name='[CBM]'
# name='[Doki]'
# name='[Nii-sama]'
# name='[LostYears]'
# name='[EMBER]'
# name='[Nyanpasu]'
# name='[DameDesuYo]'
# name='[neoHEVC]'
# name='[Kulot]'
# name='[Funimation]'
# name='[Afro]'
name='[MTBB]'
# name='[YameteTomete]'


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
