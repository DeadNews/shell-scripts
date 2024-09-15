#!/usr/bin/env zsh
set -euo pipefail

for F in "$@"; do
    mkdir "${F:h}/subs"
    cd "${F:h}/subs"
    ffmpeg -hide_banner -i ${F} -map 0:s:0 -c copy "${F:h}/subs/${F:t:r}.ass"
    # ffmpeg -hide_banner -i ${F} -codec:s "" -n
    # ffmpeg -hide_banner -dump_attachment:s "" -i ${F} -n
done

# kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 7

# ffprobe -v error -show_entries stream=index,codec_name,codec_type
