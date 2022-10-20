#!/usr/bin/env zsh

function _opus_mka() {
    tmp="${tmp_dir}/${F:t:r}.opus"
    lang=$(mediainfo --Inform="Audio;%Language%" ${F})
    lang=${lang:='jpn'}
    title=$(mediainfo --Inform="Audio;%Title%" ${F})
    title=${title:='LPCM->OPUS'}
    if [[ ${title} == 'LPCM->FLAC' ]]; then
        title='[BD]'
    fi

    ffmpeg -hide_banner -i ${F} -acodec libopus -b:a 180k ${tmp}

    mkvmerge --output "${F:h}/+opus/${F:t:r}.opus.mka" --language 0:${lang} --track-name 0:"${title}" ${tmp}
    unlink ${tmp}
}

tmp_dir=$(mktemp -d)
N=3
for F in "${@}"; do
    ((i = i % N))
    ((i++ == 0)) && wait
    (
        _opus_mka
    ) &
done
wait
rm -R ${tmp_dir}

kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 5
