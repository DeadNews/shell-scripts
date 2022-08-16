#!/usr/bin/env zsh
zparseopts -D -make=make

source $(which env_parallel.zsh)

function rate-info() {
    # unset ${rate}
    SR=$(mediainfo --Inform="Audio;%SamplingRate%" ${1})
    if [[ ${SR} == 44100 ]]; then
        rate='44100'
    elif [[ $((SR % 48000)) == 0 ]]; then
        rate='48000'
    fi
}

function resampler_func() {
    duration=$(mediainfo --Inform="Audio;%Duration/String3%" ${1})

    if [ "${1:e}" = "flac" ]; then
        tmp="${tmp_dir}/${1:t:r}.flac"
        out_dir="${1:h}/+resampled"
        mkdir -p ${out_dir}

        rate-info ${1}
        ${resampler} -i ${1} -o ${tmp} -r ${rate} ${resampler_opts[@]}

        duration_out=$(mediainfo --Inform="Audio;%Duration/String3%" ${tmp})
        if [ "${duration_out}" != "${duration}" ]; then
            echo "${1}: ${duration} VS ${duration_out}" >>"${out_dir}/warnings.log"
            ffmpeg -hide_banner -i ${tmp} -t ${duration} -acodec flac -compression_level 12 "${out_dir}/${1:t:r}.flac"
        else
            ffmpeg -hide_banner -i ${tmp} -acodec flac -compression_level 12 "${out_dir}/${1:t:r}.flac"
        fi
        # ffmpeg -hide_banner -i ${tmp} -acodec flac -compression_level 12 "${out_dir}/${1:t:r}.flac"
        unlink ${tmp}

    elif [ "${1:e}" = "mka" ]; then
        bit_depth=$(mediainfo --Inform="Audio;%BitDepth%" ${1})
        lang=$(mediainfo --Inform="Audio;%Language%" ${1})
        title=$(mediainfo --Inform="Audio;%Title%" ${1})
        format=$(mediainfo --Inform="Audio;%Format%" ${1})

        out_dir="${1:h:h}/out/audio"
        mkdir -p ${out_dir}
        echo ${bit_depth}

        if [[ ${bit_depth} == 24 ]]; then
            tmp1="${tmp_dir}/${1:t:r}_1.flac"
            tmp2="${tmp_dir}/${1:t:r}_2.flac"
            tmp3="${tmp_dir}/${1:t:r}_3.flac"

            mkvextract ${1} tracks 0:${tmp1}

            rate-info ${1}
            ${resampler} -i ${tmp1} -o ${tmp2} -r ${rate} ${resampler_opts[@]}
            unlink ${tmp1}

            duration_out=$(mediainfo --Inform="Audio;%Duration/String3%" ${tmp2})
            if [ "${duration_out}" != "${duration}" ]; then
                echo "${1}: ${duration} VS ${duration_out}" >>"${out_dir}/warnings.log"
                ffmpeg -hide_banner -i ${tmp2} -t ${duration} -acodec flac -compression_level 12 ${tmp3}
            else
                ffmpeg -hide_banner -i ${tmp2} -acodec flac -compression_level 12 ${tmp3}
            fi
            unlink ${tmp2}

            mkvmerge --output "${out_dir}/${1:t:r}.mka" --language 0:${lang} --track-name 0:"${title}16" ${tmp3}
            unlink ${tmp3}
        else
            if [[ ${format} == "FLAC" ]]; then
                tmp="${tmp_dir}/${1:t:r}.flac"
                ffmpeg -hide_banner -i ${1} -acodec flac -compression_level 12 ${tmp}

                mkvmerge --output "${out_dir}/${1:t:r}.mka" --language 0:${lang} --track-name 0:${title} ${tmp}
                unlink ${tmp}
            fi
        fi
    fi
}

function make() {
    cd /home/deadnews/my/bin/
    git clone ${1}
    name=${1#https://github.com/*/}
    cd ${name}

    # AVX + FMA (>= Haswell, PileDriver):
    # g++ -pthread -std=c++11 main.cpp ReSampler.cpp conversioninfo.cpp -lfftw3 -lsndfile -o ReSampler -O3 -DUSE_AVX -DUSE_FMA -mavx -mfma
    # Quad Precision (experimental):
    g++ -pthread -std=gnu++11 main.cpp ReSampler.cpp conversioninfo.cpp -lfftw3 -lsndfile -o ReSampler -O3 -lquadmath -DUSE_QUADMATH

    mv ./ReSampler ../ReSamplerLib
    rm -rf /home/deadnews/my/bin/ReSampler/
}

if [[ ${make} ]]; then
    make https://github.com/jniemann66/ReSampler
else
    resampler='/home/deadnews/my/bin/ReSamplerLib'
    resampler_opts=(
        -b 16
        --showStages
        --singleStage
        --relaxedLPF
        --dither
        --ns 2
        # --ns 0
        --autoblank
        --flacCompression 0
        --mt
    )

    # # 24 bits + disable duration_out
    # resampler_opts=(
    #     --showStages
    #     --singleStage
    #     --relaxedLPF
    #     --autoblank
    #     --flacCompression 0
    #     --mt
    # )

    tmp_dir=$(mktemp -d)
    env_parallel -j 2 resampler_func ::: "$@"
    rm -R ${tmp_dir}

    kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 5

fi
