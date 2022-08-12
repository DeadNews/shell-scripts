#!/usr/bin/env zsh

for F in "$@"; do
  mkdir "${F:h}/${F:h:t} [V0]"

  ffmpeg -hide_banner -i ${F} -codec copy -acodec libmp3lame -q:a 0 "${F:h}/${F:h:t} [V0]/${F:t:r}.mp3"

done

kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 7

# -b:a 320k

# ffmpeg -y -i "${F:h}/mp3/${F:t:r}.mp3" -i "${F:h}/cover.jpg" -map 0:0 -codec copy -map 1:0 -c copy -id3v2_version 3 \
# -metadata:s:v title="Album cover" -metadata:s:v comment="Cover (front)" "${F:h}/mp3/${F:t:r}.mp3"
