#!/usr/bin/env zsh

for F in "$@"; do
    ffmpeg -hide_banner -i ${F} -c:v copy -c:a copy -ss 00:00:00 -t 00:01:00 "${F:r}-cut.mp4"
done
