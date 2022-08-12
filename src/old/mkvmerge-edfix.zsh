#!/usr/bin/env zsh
for F in "$@"; do

    name=${F:t:r}
    name=${name% \(*}

    edstart=$(<"${F:h}/dep/${F:t:r}.vpy" | grep -i '^ED')
    let "edstart_1=${edstart#* = }+1"
    echo ${edstart_1}

    mkvmerge --output "${F:h}/cut/${name:t:r}.mkv" --no-audio --no-subtitles --no-chapters --no-attachments --default-track 0:yes ${F} --split parts-frames:0-${edstart_1}

    mkvmerge --output "${F:h}/fixed/${name:t:r}.mkv" --language 0:jpn --track-name '0:BDRip by DeadNews' --default-track 0:yes "${F:h}/cut/${name:t:r}.mkv" + "${F:h}/end/${name:t:r}.mkv" --append-to 1:0:0:0

    # name=${F:t:r}
    # mkvmerge --output "${F:h}/end/${name% \(*}.mkv"  --language 0:und ${F}

done
# kdialog --title "x264" --passivepopup "${1:t:r} done" 7
