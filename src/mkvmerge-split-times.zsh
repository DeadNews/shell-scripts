#!/usr/bin/env zsh


# fr="00:00.021-"
# fr="00:00.042-"
# fr="00:00.100-"
# fr="00:00.163-"
# fr="00:00.084-"
# fr="00:00.121-"
fr="00:17.000-"

for F in "$@"; do
    mkvmerge --output "${F:h}/+split/${F:t:r} [${fr}].mka" --no-subtitles --no-chapters --no-attachments ${F} \
        --split parts:${fr}
done

