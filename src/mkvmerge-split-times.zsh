#!/usr/bin/env zsh
set -euo pipefail

# fr="00:00.021-"
fr="00:00.042-"

for F in "$@"; do
    mkvmerge --output "${F:h}/+split/${F:t:r} [${fr}].mka" --no-subtitles --no-chapters --no-attachments ${F} \
        --split parts:${fr}
done
