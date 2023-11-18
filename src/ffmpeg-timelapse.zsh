#!/usr/bin/env zsh

for F in "$@"; do
    ffmpeg -hide_banner -i ${F} -vf "fps=60, setpts=PTS/30" -c:v libx265 -crf 14 -an "${F:r}-${RANDOM}-timelapse.mp4"
done
