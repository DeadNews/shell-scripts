#!/usr/bin/env zsh
set -euo pipefail

for F in "$@"; do
    out_dir="${1:h}/+opus"
    mkdir -p ${out_dir}

    ffmpeg -hide_banner -i ${F} -acodec libopus -b:a 180k "${out_dir}/${F:t:r}.opus"
done
