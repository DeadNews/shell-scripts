#!/usr/bin/env zsh

for F in "$@"; do

    lang=$(mediainfo --Inform="Audio;%Language%" ${F})
    title=$(mediainfo --Inform="Audio;%Title%" ${F})

    ffmpeg -hide_banner -i ${F} -acodec libvorbis -q 6 "/tmp/${F:t:r}.ogg"

    if [ -f "/tmp/${F:t:r}.ogg" ]; then
        mkvmerge --output "${F:h}/ogg/${F:t:r}.vorbis.mka" --language 0:${lang} --track-name 0:"${title}" "/tmp/${F:t:r}.ogg"
        # mkvmerge --output "${F:h}/ogg/${F:t:r}.vorbis.mka" --language 0:${lang} --track-name 0:"[BD]" "/tmp/${F:t:r}.ogg"
        # mkvmerge --output "${F:h}/ogg/${F:t:r}.vorbis.mka"  "/tmp/${F:t:r}.ogg"
        unlink "/tmp/${F:t:r}.ogg"
    fi

    tmp_dir=$(mktemp -d)
    N=2
    for F in "${@}"; do
        ((i = i % N))
        ((i++ == 0)) && wait
        (
            _resampler
        ) &
    done
    wait
    rm -R ${tmp_dir}

    script_name=${0:t:r}
    kdialog --title "${script_name}" --passivepopup "${1:h:t} done" 5

done

