#!/usr/bin/env zsh

for F in "$@"; do
    echo ${F:t}
    ffmpeg -i ${F} -vn -f md5 - 2>/dev/null
done

# https://superuser.com/questions/1044413/audio-md5-checksum-with-ffmpeg
