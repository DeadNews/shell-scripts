#!/usr/bin/env zsh
set -euo pipefail

# Usage:
# ~/git/shell-scripts/src/ffmpeg-cut.zsh video.mp4 --ss hh:mm:ss[.xxx] --t hh:mm:ss[.xxx]

zparseopts -D -E -F -A opts -- -ss: -t:

for F in "$@"; do
    ffmpeg -hide_banner -i ${F} -c:v copy -c:a copy -ss ${opts[--ss]:='00:00:00'} -t ${opts[--t]:='00:00:00'} "${F:r}-${RANDOM}-cut.mp4"
done
