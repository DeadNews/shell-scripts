#!/usr/bin/env zsh
zparseopts -D -noA=noA -noV=noV

function ffmpeg_extractor() {
    lang=${3}
    out_format=${4}
    echo "\n$(tput bold)  ${1:t:r}:${2} $(tput sgr0)"

    codec=$(ffprobe -v error -i ${F} -select_streams ${2} -of default=nokey=1:noprint_wrappers=1 -show_entries stream=codec_name | tr -d '\n')
    if [[ ${codec} == 'pcm_bluray' ]] || [[ ${codec} == 'pcm_bluraypcm_bluray' ]] || [[ ${codec} == 'pcm_s16le' ]] | [[ ${codec} == 'pcm_s24le' ]]; then
        codec='LPCM'
    elif [[ ${codec} == 'dts' ]] || [[ ${codec} == 'dtsdts' ]]; then
        codec='DTS-HDMA'
    elif [[ ${codec} == 'truehd' ]] || [[ ${codec} == 'truehdtruehd' ]]; then
        codec='TrueHD'
    elif [[ ${codec} == 'ac3' ]]; then
        codec='AC3'
    fi

    if [[ ${out_format} == 'flac' ]]; then
        tmp="${tmp_dir}/${1:t:r}.flac"
        # channels=$(mediainfo --Inform="Audio;%channels%" ${F})
        if [[ ${lang} == 'jpn' ]]; then
            out="${out_dir}/in/${1:t:r}.mka"
            lvl=12
        else
            out="${out_dir}/out/mux/${lang:u} Sound/${1:t:r}.${lang}.[BD].flac.mka"
            lvl=12
        fi
        ffmpeg -hide_banner -i ${1} -map 0:${2} -acodec flac -compression_level ${lvl} ${tmp}
        # ffmpeg -hide_banner -i ${1} -map 0:${2} -acodec flac -compression_level ${lvl} -sample_fmt s16 ${tmp}

        mkvmerge --output ${out} --language 0:${lang} --track-name 0:"${codec}->FLAC" ${tmp}
        unlink ${tmp}

    elif [[ ${out_format%%.*} == 'opus' ]]; then
        tmp="${tmp_dir}/${1:t:r}.opus"
        ffmpeg -hide_banner -i ${1} -map 0:${2} -acodec libopus -b:a 80k ${tmp}
        out="${out_dir}/out/mux/Bonus/Commentary/${1:t:r}.${lang}.${out_format#*.}.mka"
        mkvmerge --output ${out} --language 0:${lang} --track-name 0:"${codec}->OPUS" ${tmp}
        unlink ${tmp}

    elif [[ ${out_format} == 'ac3' ]]; then
        tmp="${tmp_dir}/${1:t:r}.ac3"
        ffmpeg -hide_banner -i ${1} -map 0:${2} -c copy ${tmp}
        if [[ ${lang} == 'jpn' ]]; then
            out="${out_dir}/in/${1:t:r}.mka"
        else
            out="${out_dir}/out/mux/${lang:u} Sound/${1:t:r}.${lang}.[BD].ac3.mka"
        fi
        mkvmerge --output ${out} --language 0:${lang} --track-name 0:"${codec}" ${tmp}
        unlink ${tmp}

    elif [[ ${out_format%%.*} == 'sup' ]]; then
        tmp="${tmp_dir}/${1:t:r}.${lang}.sup"
        ffmpeg -hide_banner -i ${1} -map 0:${2} -c copy ${tmp}
        out="${out_dir}/out/mux/${lang:u} Subs/${1:t:r}.${lang}.[BD].${out_format#*.}.mks"
        mkvmerge --output ${out} --language 0:${lang} --track-name 0:"[BD]" --compression 0:zlib ${tmp}
        unlink ${tmp}
    fi
}

out_dir=${1:h}
# out_dir="/run/media/deadnews/data7/2004-ElfenLied/"

if [[ ! ${noA} ]]; then
    tmp_dir=$(mktemp -d)
    N=1
    for F in "$@"; do
        ((i = i % N))
        ((i++ == 0)) && wait
        (
            ffmpeg_extractor ${F} 'a:0' 'jpn' 'flac'
            # ffmpeg_extractor ${F} 'a:0' 'eng' 'flac'
            # ffmpeg_extractor ${F} 'a:0' 'chi' 'flac'
            # ffmpeg_extractor ${F} 'a:1' 'eng' 'flac'
            # ffmpeg_extractor ${F} 'a:2' 'jpn' 'flac'
            # ffmpeg_extractor ${F} 'a:1' 'jpn' 'opus'
            # ffmpeg_extractor ${F} 's:0' 'jpn' 'sup'
            # ffmpeg_extractor ${F} 's:1' 'eng' 'sup'
            # ffmpeg_extractor ${F} 'a:1' 'jpn' 'opus.1'
            # ffmpeg_extractor ${F} 'a:2' 'jpn' 'opus.2'
            # ffmpeg_extractor ${F} 'a:4' 'jpn' 'opus.3'
            # ffmpeg_extractor ${F} 'a:0' 'jpn' 'ac3'
        ) &
    done
    wait
    rm -R ${tmp_dir}
fi

if [[ ! ${noV} ]]; then
    for F in "$@"; do
        mkvmerge --output "${out_dir}/in/${F:t:r}.mkv" --no-audio --no-subtitles --language 0:jpn --track-name '0:BDRemux by DeadNews' ${F}
    done
fi

kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 7
