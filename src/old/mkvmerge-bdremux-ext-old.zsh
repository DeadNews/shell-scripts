#!/usr/bin/env zsh

function ffmpeg_extractor() {
    mkdir -p "${1:h}/out/audio"
    echo "  ${1:t:r}"

    ffmpeg -hide_banner -i ${1} \
        -map 0:a:0 -acodec flac -compression_level 8 "${tmp_dir}/${1:t:r}.flac"
    # -map 0:a:2 -acodec libopus -b:a 80k "${tmp_dir}/${1:t:r}.opus"
    # -map 0:a:0 -acodec flac -compression_level 8 "${tmp_dir}/${1:t:r}.eng.flac" \
    # -map 0:s:0 -c copy "${1:h}/out/${1:t:r}.eng.sup"
    # -map 0:s:0 -c copy "${1:h}/out/${1:t:r}.jpn.sup"
    # -map 0:a:0 -acodec copy "${tmp_dir}/${1:t:r}.ac3"
    # -map 0:a:0 -acodec copy "${1:h}/out/audio/${1:t:r}-dts.mka" \
    # -map 0:a:1 -acodec libopus -b:a 80k "${tmp_dir}/${1:t:r}.1.opus" \
    # -map 0:a:2 -acodec libopus -b:a 80k "${tmp_dir}/${1:t:r}.2.opus"
}

# to_mkv 1:in 2:out 3:compress 4:name 5:lang
function to_mkv() {
    if [ -f ${1} ]; then
        mkvmerge --output ${2} --language 0:${5} --track-name ${4} --compression 0:${3} ${1}
        unlink ${1}
    fi
}

function mkvmerge_conditions() {

    # depth=$mediainfo --Inform="Audio;%BitDepth%" ${4iiii})

    to_mkv "${tmp_dir}/${1:t:r}.flac" "${1:h}/in/${1:t:r}.mka" 'none' '0:LPCM->FLAC' 'jpn'

    to_mkv "${tmp_dir}/${1:t:r}.eng.flac" "${1:h}/out/mux/ENG Sound/${1:t:r}.eng.[BD].flac.mka" 'none' '0:LPCM->FLAC' 'eng'

    to_mkv "${tmp_dir}/${1:t:r}.opus" "${1:h}/out/mux/Bonus/Commentary/${1:t:r}.jpn.opus.mka" 'none' '0:LPCM->OPUS' 'jpn'
    to_mkv "${tmp_dir}/${1:t:r}.1.opus" "${1:h}/out/mux/Bonus/Commentary/${1:t:r}.1.jpn.opus.mka" 'none' '0:LPCM->OPUS' 'jpn'
    to_mkv "${tmp_dir}/${1:t:r}.2.opus" "${1:h}/out/mux/Bonus/Commentary/${1:t:r}.2.jpn.opus.mka" 'none' '0:LPCM->OPUS' 'jpn'

    to_mkv "${tmp_dir}/${1:t:r}.ac3" "${1:h}/out/audio/${1:t:r}.mka" 'none' '0:AC3' 'jpn'

    to_mkv "${1:h}/out/${1:t:r}.jpn.sup" "${1:h}/out/mux/JPN Subs/${1:t:r}.jpn.[BD].sup.mks" 'zlib' '0:[BD]' 'jpn'
    to_mkv "${1:h}/out/${1:t:r}.eng.sup" "${1:h}/out/mux/ENG Subs/${1:t:r}.eng.[BD].sup.mks" 'zlib' '0:[BD]' 'eng'

}

tmp_dir=$(mktemp -d)
N=1
for F in "$@"; do
    ((i = i % N))
    ((i++ == 0)) && wait
    (
        ffmpeg_extractor "${F}"
        mkvmerge_conditions "${F}"
    ) &
done
wait
rm -R ${tmp_dir}

for F in "$@"; do
    mkvmerge --output "${F:h}/in/${F:t:r}.mkv" --no-audio --no-subtitles --language 0:jpn --track-name '0:BDRemux by DeadNews' ${F}
done

kdialog --title "mkvmerge" --passivepopup "${1:h:t} done" 7

# ffprobe -v error -i ${F} -select_streams a:0 -of default=nokey=1:noprint_wrappers=1 -show_entries stream=codec_name
# ffprobe -v error -i ${F} -select_streams a:0 -of default=nokey=1:noprint_wrappers=1 -show_entries stream=codec_name,bits_per_raw_sample:stream_tags=language
