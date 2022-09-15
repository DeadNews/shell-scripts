#!/usr/bin/env zsh

echo "yt-dlp \"$(cat ${1} | tail -n 1)\"" >>~/my/downloads/dl.log

mpv --playlist="${1}"
