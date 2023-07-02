#!/usr/bin/env zsh

function ffprobe-info() {
    ffprobe -show_entries stream=index,codec_type:stream_tags=language -of compact ${1} 2>&1 | {
        while read line; do if $(echo "$line" | grep -q -i "stream #"); then echo "$line"; fi; done
        while read -d $'\x0D' line; do if $(echo "$line" | grep -q "time="); then echo "$line" | awk '{ printf "%s\r", $8 }'; fi; done
    }
}

for F in "$@"; do
    tmp_dir=$(mktemp -d)
    tmpfile="${tmp_dir}/${F:t:r}.${F:t:e}.log"

    if [ "${F:e}" = "m2ts" ]; then
        ffprobe-info ${F} > ${tmpfile}
        echo "" >> ${tmpfile}
        mediainfo ${F} >> ${tmpfile}

    else
        mediainfo ${F} > ${tmpfile}
    fi

    kwrite ${tmpfile}
    unlink ${tmpfile}
done
