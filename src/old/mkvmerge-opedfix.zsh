#!/usr/bin/env zsh
for F in "$@"; do

    name=${F:t:r}
    name=${name% \(*}

    OPstart=$(<"${F:h}/dep/${name:t:r}.vpy" | grep -m 1 '^OP')
    OPend=$(<"${F:h}/dep/${name:t:r}.vpy" | grep -m 1 '^Part_A')
    EDstart=$(<"${F:h}/dep/${name:t:r}.vpy" | grep -m 1 '^ED')
    EDend=$(<"${F:h}/dep/${name:t:r}.vpy" | grep -m 1 '^Next')
    let "OPstart=${OPstart#* = }+1"
    let "OPend=${OPend#* = }+1"
    let "EDstart=${EDstart#* = }+1"
    let "EDend=${EDend#* = }+1"
    echo "${OPstart},${OPend},${EDstart},${EDend}"

    One="${F:h}/cut/${name:t:r}-001.mkv"
    OP="${F:h}/OP/${name:t:r}.mkv"
    Three="${F:h}/cut/${name:t:r}-003.mkv"
    ED="${F:h}/ED/${name:t:r}.mkv"
    Five="${F:h}/cut/${name:t:r}-005.mkv"

    # mkvmerge --output "${F:h}/cut/${name:t:r}.mkv" --no-audio --no-subtitles --no-chapters --default-track 0:yes ${F} --split frames:${OPstart},${OPend},${EDstart},${EDend}
    # mkvmerge --output "${F:h}/fixed/${name:t:r}.mkv" --language 0:jpn --track-name '0:BDRip by DeadNews' --default-track 0:yes ${One} + ${OP} + ${Three} + ${ED} + ${Five} --append-to 1:0:0:0,2:0:1:0,3:0:2:0,4:0:3:0

    mkvmerge --output "${F:h}/cut/${name:t:r}.mkv" --no-audio --no-subtitles --no-chapters --default-track 0:yes ${F} --split frames:${OPstart},${OPend},${EDstart}
    mkvmerge --output "${F:h}/fixed/${name:t:r}.mkv" --language 0:jpn --track-name '0:BDRip by DeadNews' --default-track 0:yes ${One} + ${OP} + ${Three} + ${ED} --append-to 1:0:0:0,2:0:1:0,3:0:2:0

done

# kdialog --title "x264" --passivepopup "${1:t:r} done" 7
