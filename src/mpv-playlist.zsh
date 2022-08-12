#!/usr/bin/env zsh

echo "yt-dlp \"$(cat ${1} | tail -n 1)\"" >>/home/deadnews/my/downloads/dl.log

mpv --playlist="${1}"
