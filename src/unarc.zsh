#!/usr/bin/env zsh
help='''
Unarchiving

positional:
    input_args

optional:
    -h, --help              show this help message and exit
    --out-dir               by default this is the parent directory

usage:
    unarc --out-dir /data/archive_test/ /tmp/file.ext.tar.zst
'''

parse_args() {
    zparseopts -D -E -F -A opts -- h -help -out-dir:

    if [[ $? != 0 || "${(k)opts[-h]}" || "${(k)opts[--help]}" || -z "$@" ]]; then
        echo "${help:1:-1}"
        exit 1
    fi
    positional=("${@}")
}

main() {
    out_dir="${opts[--out-dir]:=${1:h}}"
    mkdir -p ${out_dir}
    type="$(file -b --mime-type ${1})"

    size=$(du -sbh ${1} | cut -f 1)
    echo "-> src: ${yellow}${1}${reset} ${magenta}${size}${reset}"
    echo "-> dst: ${yellow}${out_dir}${reset}"

    if [[ ${type} == 'application/zstd' ]]; then
        pv ${1} | tar -I"zstdmt" -x -C ${out_dir}
    elif [[ ${type} == 'application/x-xz' ]]; then
        pv ${1} | tar -I"xz -T0" -x -C ${out_dir}
    elif [[ ${type} == 'application/x-rar' ]]; then
        rar e ${1} ${out_dir}
    else
        time tar -xf ${1} -C ${out_dir}
    fi
}


reset=$(tput sgr0)
yellow=$(tput setaf 3)
magenta=$(tput setaf 5)

parse_args "${@}"

for F in ${positional[@]}; do
    main ${F}
done
