#!/usr/bin/env zsh

N=$(nproc)
for F in "$@"; do
    ((i = i % N))
    ((i++ == 0)) && wait
    (
        bit_depth=$(mediainfo --Inform="Audio;%BitDepth%" ${F})
        if [[ "${bit_depth}" == '16' ]]; then
            sample_fmt='s16'
        elif [[ "${bit_depth}" == '24' ]]; then
            sample_fmt='s32'
        else
            sample_fmt='s16'
        fi
        ffmpeg -hide_banner -i ${F} -map 0:a:0 -sample_fmt ${sample_fmt} -acodec flac -compression_level 8 "/tmp/${F:t:r}.flac"
        mv "/tmp/${F:t:r}.flac" "${F:h}"
    ) &
done
wait
# kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 7

# for F in "$@"; do
#   ARTIST=$(mediainfo --Inform="General;%Performer%" ${F})
#   ALBUMARTIST=$(mediainfo --Inform="General;%Album/Performer%" ${F})
#   ALBUMARTIST=${ALBUMARTIST:=${ARTIST}}
#   DATE=$(mediainfo --Inform="General;%Recorded_Date%" ${F})
#   YEAR=${DATE[1, 4]}
#   ALBUM=$(mediainfo --Inform="General;%Album%" ${F})
#   GENRE=$(mediainfo --Inform="General;%Genre%" ${F})
#   TRACKNUMBER=$(mediainfo --Inform="General;%Track/Position%" ${F})
#   TRACKNUMBER=$(printf "%02d" ${TRACKNUMBER})
#   TITLE=$(mediainfo --Inform="General;%Title%" ${F})

#   #   echo "${ARTIST} [${GENRE}]/${YEAR} - ${ALBUM}/${TRACKNUMBER} - ${TITLE}"
#   echo "${ALBUMARTIST}/${DATE} — ${ALBUM}/${TRACKNUMBER} ${TITLE}"
# done

# ffmpeg -hide_banner -i ${F} -codec copy -acodec flac -compression_level 12 "/tmp/${F:t:r}.flac"
# metaflac --remove --block-type=PICTURE --dont-use-padding ${F}
# metaflac --import-picture-from="${F:h}/cover.jpg" ${F}
