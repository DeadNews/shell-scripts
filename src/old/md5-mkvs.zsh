#!/usr/bin/env zsh
zparseopts -D -c=check

for F in "$@"; do
    if [[ ! ${check} ]]; then
        cd "${F}/in"
        # md5sum *.mkv > video.md5
        md5sum *.mka >audio.md5
    else
        cd "${F}/in"
        mv +MKVs.md5 video.md5
        mv +MKAs.md5 audio.md5
        md5sum -c video.md5
        md5sum -c audio.md5
    fi
done
kdialog --title "md5-mkvs" --passivepopup "${1:h:h:t} done" 7

# Exec=/home/deadnews/my/scripts/zsh/md5-mkvs.zsh $folders
