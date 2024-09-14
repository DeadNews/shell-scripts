#!/usr/bin/env zsh
set -euo pipefail

help='''
Archiving

positional:
    input_args

optional:
    -h, --help              show this help message and exit
    --out-dir               by default this is the parent directory
    --nopv                  dont use pv

usage:
    arc --out-dir /tmp /data/archive_test/file.ext
    arc /data/archive_test/
'''

parse_args() {
    zparseopts -D -E -F -A opts -- h -help -out-dir: -nopv

    if [[ $? != 0 || "${(k)opts[-h]}" || "${(k)opts[--help]}" || -z "$@" ]]; then
        echo "${help:1:-1}"
        exit 1
    fi
    positional=("${@}")
}

main() {
    out_dir="${opts[--out-dir]:=${1:h}}"
    mkdir -p ${out_dir}
    cd "${1:h}"

    if [[ $(zstd --version 2>/dev/null) ]]; then
        out_file="${out_dir}/${1:t}.tar.zst"
        util='zstdmt'
        utl_args=(-3)
    else
        out_file="${out_dir}/${1:t}.tar.xz"
        util='xz'
        utl_args=(-T0 -0)
    fi

    size=$(du -sb ${1} | cut -f 1)
    size_human=$(numfmt --to=iec ${size})
    echo "-> src: ${yellow}${1}${reset} ${magenta}${size_human}${reset}"

    if [[ "${(k)opts[--nopv]}" ]]; then
        time tar -c -I"${util} ${utl_args[@]}" -f ${out_file} -C ${1:h} ${1:t}
    else
        tar -c -f - -C ${1:h} ${1:t} | pv -pteba -s ${size} | ${util} ${utl_args[@]} >${out_file}
    fi

    out_size=$(du -sbh ${out_file} | cut -f 1)
    echo "-> out: ${yellow}${out_dir}/${out_file}${reset} ${magenta}${out_size}${reset}"
}


reset=$(tput sgr0)
yellow=$(tput setaf 3)
magenta=$(tput setaf 5)

parse_args "${@}"

for F in ${positional}; do
    main ${F}
done
