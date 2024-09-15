#!/usr/bin/env zsh
set -euo pipefail

for CUE in "$@"; do
    AUDIO="${CUE:r}.flac"
    DIR="${CUE:h}/flac"

    mkdir -p ${DIR}

    shnsplit -f ${CUE} -t "%n %t" -d ${DIR} -o "flac flac -s -8 -o %f -" ${AUDIO}
    cuetag.sh ${CUE} ${DIR}/*.flac

    setopt +o nomatch
    cp "${CUE:h}"/*.{jpg,jpeg,png} ${DIR}
done

# https://wiki.archlinux.org/index.php/CUE_Splitting
