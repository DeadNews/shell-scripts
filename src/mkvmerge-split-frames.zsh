#!/usr/bin/env zsh
set -euo pipefail

fr="0-3000"
# fr="13952-14317"
# fr="19580-19806"

for F in "$@"; do
    mkvmerge --output "/run/media/deadnews/data1/temp/split/${F:t:r} [${fr}].mkv" --no-audio --no-subtitles --no-chapters --no-attachments ${F} \
        --split parts-frames:${fr}
done
