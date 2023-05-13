#!/usr/bin/env zsh
zparseopts -D -no_convert=no_convert -rcloneUpload=rcUp -staticName=static -repox265=repox265 \
    -aq-strength:=aqstr -crf:=crf -qcomp:=qcomp -psy-rd:=psyrd -rdoq-level:=rdoqlvl -psy-rdoq:=psyrdoq \
    -keyint:=keyintCLI -aq-mode:=aqmode -ref:=ref -cutree=cutree -limit-refs:=limitrefs -zones:=zones \
    -fast_mode=fMode -unlinkMode=UM -L=L -EVL=EVL -T=T -E=E -hme=hme -tskip=tskip


function encode() {
    if [[ ${1:e} = mkv ]]; then
        tmpvpy="${1:h:h}/${1:t:r}.vpy"
        echo "from vapoursynth import core; core.lsmas.LWLibavSource(source='${1}').set_output()" >${tmpvpy}
        1=${tmpvpy}
    fi
    if [[ ${1:e} = mp4 ]]; then
        tmpvpy="${1:h:h}/${1:t:r}.vpy"
        echo "from vapoursynth import core; core.lsmas.LibavSMASHSource(source='${1}').set_output()" >${tmpvpy}
        1=${tmpvpy}
    fi

    vsinfo=$(vspipe --info ${1} -)
    frames=$(echo ${vsinfo} | grep -i '^Frames:')

    fps=$(echo ${vsinfo} | grep -i '^FPS:')
    fps=${fps#* }
    fps=${fps/ */}
    keyint=$((10.44 * ${fps}))
    keyint=${keyint/.*/}
    keyint_end=${keyintCLI[-1]-${keyint}}
    goplook=$((${keyint_end} / 10 * 2))

    if [[ -f "${1:h}/in/${1:t:r}.qp" ]]; then
        qpfile="${1:h}/in/${1:t:r}.qp"
    else
        echo "0 I -1" >"/tmp/0.qp"
        qpfile="/tmp/0.qp"
    fi

    unset zones_set
    unset zonesOpts
    if [[ ${zones} ]]; then
        zones_set=${zones[-1]}

    elif [[ -f "${1:h}/zones.txt" ]]; then
        zones_set=$(grep -i "^${1:t:r}:" "${1:h}/zones.txt")
        zones_set=${zones_set#*: }
    fi
    if [[ ${zones_set} ]]; then
        zonesOpts=(
            --zones ${zones_set}
        )
    fi

    mkdir -p "${1:h}/out"
    logfile="${1:h}/out/${1:t:r}.log"
    echo "${bold}${underline}${1:t:r}${reset}"
    echo "${vsinfo}\n" >&1 >>${logfile}

    date=$(date "+%Y-%m-%d %T")
    output="${1:h}/out/${1:t:r} (${date}).hevc"
    logtmp="/tmp/${output:t:r}.log"

    if [[ ${repox265} ]]; then
        x265='/usr/bin/x265'
    else
        x265="${HOME}/bin/vpy-x265/x265"
        chmod u+x ${x265}
        export LD_LIBRARY_PATH=${x265:h}
    fi
    inputOpts=(--y4m - --output ${output} --qpfile ${qpfile} --frames ${frames#* })
    customOpts=(
        --ref ${ref[-1]:=5}
        --aq-mode ${aqmode[-1]:=3}
        --aq-strength ${aqstr[-1]:=0.85}
        --crf ${crf[-1]:=15}
        --qcomp ${qcomp[-1]:=0.72}
        --psy-rd ${psyrd[-1]:=2}
        --rdoq-level ${rdoqlvl[-1]:=2}
        --psy-rdoq ${psyrdoq[-1]:=2}
        --keyint ${keyint_end}
        --gop-lookahead ${goplook}
    )
    if [[ ${hme} ]]; then
      hmeOpts=(--hme-search 3,3,3 --scenecut-bias 5.75)
    fi
    if [[ ${tskip} ]]; then
        tskipOpts=(--tskip)
    else
        tskipOpts=(--no-tskip)
    fi
    if [[ ${cutree} ]]; then
        cutreeOpts=(--cutree)
    else
        cutreeOpts=(--no-cutree)
    fi
    if [[ ${fMode} ]]; then
        speedOpts=(--subme 4 --max-merge 2 --early-skip --no-rect --no-amp --limit-refs 3)
    else
        speedOpts=(--subme 7 --max-merge 5 --no-early-skip --rect --amp --limit-refs ${limitrefs[-1]:=2})
    fi

    vspipe ${1} - -c y4m | ${x265} ${inputOpts[@]} ${customOpts[@]} ${zonesOpts[@]} ${speedOpts[@]} \
        --output-depth 10 --rc-lookahead 250 --lookahead-slices 1 --open-gop --no-fades \
        --bframes 16 --b-intra --bframe-bias 0 --b-pyramid --b-adapt 2 --rskip 0  ${tskipOpts[@]} \
        --frame-threads 1 --wpp --me 3 --merange 48 --weightp --weightb  ${hmeOpts[@]} ${cutreeOpts[@]} \
        --refine-mv 3 --no-aq-motion --no-sao --no-sao-non-deblock --deblock 1:-1 --cbqpoffs -2 --crqpoffs -2 \
        --rd 4 --tu-intra-depth 2 --tu-inter-depth 2 --sar 1:1 --info --colorprim bt709 --transfer bt709 --colormatrix bt709 \
        2>&1 2>>${logtmp}

    encode_exitcode=$?

    if [[ ! ${no_convert} ]]; then
        converted="${output:r}.mp4"
        ffmpeg -hide_banner -i ${output} -codec copy ${converted} 2>/dev/null && unlink ${output}
        output=${converted}
    fi

    log-maker 'x265'
    echo "" & echo "\n\n\n" >>${logfile}
}

function convert-secs() {
    ((h = ${1} / 3600))
    ((m = (${1} % 3600) / 60))
    ((s = ${1} % 60))
    printf "%02d:%02d:%02d\n" $h $m $s
}

function log-maker() {
    unset logvar
    logvar=$(cat ${logtmp} | sed 's/\r/\n/g' | grep -v '^\[')
    unlink ${logtmp}
    echo ${logvar} >>${logfile}

    if [[ ${1} == 'x265' ]]; then
        enc_time=$(echo ${logvar} | grep -oE '[[:digit:]]+\.[[:digit:]]+?s ')
        enc_time=${enc_time%s }
    elif [[ ${1} == 'x264' ]]; then
        enc_fps=$(echo ${logvar} | grep -oE '[[:digit:]]+\.[[:digit:]]+? fps,')
        enc_fps=${enc_fps% *}
        enc_time=$((${frames} / ${enc_fps}))
    fi
    enc_time=$(convert-secs ${enc_time})
    vid_size=$(mediainfo --Inform="Video;%StreamSize/String4%" ${output})
    vid_dura=$(mediainfo --Inform="Video;%Duration/String%" ${output})
    echo "encoded ${vid_dura} in ${enc_time}, ${vid_size}" >&1 >>${logfile}
}

function rclone-up() {
    if [[ ${rcUp} ]]; then
        rclone copy --retries 32 ${logfile} ${claud}
        rclone copy --retries 32 ${output} ${claud} && unlink ${output}
    fi
}

function lossless-encode() {
    vsinfo=$(vspipe --info ${1} -)
    echo "${bold}${underline}${1:t:r}${reset}"
    echo "${vsinfo}\n"

    frames=$(echo ${vsinfo} | grep -i '^Frames:')
    frames=${frames#* }
    depth=$(echo ${vsinfo} | grep -i '^Bits:')
    depth=${depth#* }

    if [[ ${depth} == 10 ]] && [[ ! ${static} ]]; then
        date=$(date "+%Y-%m-%d %T")
        output="${1:h}/temp/inprogress/${1:t:r} (${date})_lossless.mp4"
    else
        output="${1:h}/temp/inprogress/${1:t:r}_lossless.mp4"
    fi

    if [[ -f "${1:h}/temp/${output:t}" ]]; then
        echo "Skip lossless-encode: ${yellow}./temp/${output:t}${reset} already exist.\n"
    else
        echo "lossless-encode: ${yellow}./temp/${output:t}${reset}"
        mkdir -p "${1:h}/temp/inprogress"

        logtmp="/tmp/${output:t:r}.log"
        if [[ ${static} ]]; then
            mkdir -p "${1:h}/out"
            logfile="${1:h}/out/${1:t:r}.log"
        else
            logfile=/dev/null
        fi

        vspipe ${1} - -c y4m | x264 --crf 0 --qp 0 --output-depth ${depth} \
            --preset ultrafast --threads auto --output ${output} --demuxer "y4m" - --frames ${frames} \
            2>&1 2>>${logtmp}

        log-maker 'x264'
        echo "" >&1 >>${logfile}

        output_mv="${1:h}/temp/${output:t}"
        mv ${output} ${output_mv} && output=${output_mv}
        rmdir "${1:h}/temp/inprogress"

        if [[ ${rcUp} ]] && [[ ${static} ]]; then
            rclone copy --retries 32 ${logfile} ${claud}
        fi
    fi
}

function lossless-unlink-mode() {
    del="${1:h}/temp/${1:t:r}_lossless.mp4"
    unlink "${del}" && \
        echo "unlink ${yellow}./temp/${del:t}${reset} done"
    echo ""
}

function encod-via-lossless() {
    static=1

    lossless-encode ${1}
    sleep 5

    encode ${1}
    if [[ ${encode_exitcode} == 0 ]]; then
        lossless-unlink-mode ${1}
    else
        echo "encode_exitcode: ${encode_exitcode}" >>${logfile}
        echo "lossless was not unlinked" >>${logfile}
    fi
    find "${1:h}" -type d -empty -delete
}

function test-encod-via-lossless() {
    unset static
    lossless-encode ${1}
    encode ${output}
}

bold=$(tput bold)
underline=$(tput smul)
yellow=$(tput setaf 3)
cyan=$(tput setaf 6)
reset=$(tput sgr0)
claud="antreides:DeadNews/${PWD:t}/out"

if [[ ! ${L} ]] && [[ ! ${EVL} ]] && [[ ! ${T} ]] && [[ ! ${UM} ]]; then
    E=1
fi

if [[ ${UM} ]]; then
    for F in "$@"; do
        lossless-unlink-mode ${F}
    done

elif [[ ${L} ]]; then
    echo "${bold}${cyan}::${reset} ${bold}queue-lossless-encode: ${cyan}${@:t:r}\n${reset}"
    for F in "$@"; do
        lossless-encode ${F}
    done

elif [[ ${T} ]]; then
    echo "${bold}${cyan}::${reset} ${bold}queue-test-encod-via-lossless: ${cyan}${@:t:r}\n${reset}"
    for F in "$@"; do
        test-encod-via-lossless ${F}
    done

elif [[ ${EVL} ]]; then
    echo "${bold}${cyan}::${reset} ${bold}queue-encod-via-lossless: ${cyan}${@:t:r}\n${reset}"
    for F in "${@[1,-2]}"; do
        encod-via-lossless ${F}
        rclone-up &
    done
    for F in "${@[-1]}"; do
        encod-via-lossless ${F}
        rclone-up
    done

elif [[ ${E} ]]; then
    echo "${bold}${cyan}::${reset} ${bold}queue-encode: ${cyan}${@:t:r}\n${reset}"
    for F in "${@[1,-2]}"; do
        encode ${F}
        rclone-up &
    done
    for F in "${@[-1]}"; do
        encode ${F}
        rclone-up
    done

else
    echo "L=${L}, E=${E}, EVL=${EVL}, T=${T}, UM=${UM}"

fi
