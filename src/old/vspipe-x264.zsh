#!/usr/bin/env zsh
for F in "$@"; do

  vsinfo=$(vspipe --info ${F} -)
  frames=$(echo ${vsinfo} | grep -i '^Frames:')

  if [ -f "${F:h}/in/${F:t:r}.qp" ]; then
    qpfile="${F:h}/in/${F:t:r}.qp"
  else
    echo "0 I -1" >"/tmp/0.qp"
    qpfile="/tmp/0.qp"
  fi

  mkdir -p "${F:h}/out"
  logfile="${F:h}/out/${F:t:r}.log"
  echo "${vsinfo}\n" >&1 >>${logfile}
  tmplog="/tmp/${F:t:r}.log"

  vspipe ${F} - --y4m | x264 --output-depth 10 --level 5.0 --psy-rd 1.00:0.00 --open-gop --crf 14.0 --keyint 250 --deblock 1:-1 --bframes 9 --b-adapt 2 --ref 4 --deadzone-inter 21 --deadzone-intra 11 --qcomp 0.72 --aq-mode 3 --aq-strength 0.85 --merange 32 --me umh --subme 10 --trellis 2 --direct spatial --no-mbtree --sar 1:1 --threads auto --colormatrix "bt709" --colorprim "bt709" --transfer "bt709" --output "${F:h}/out/${F:t:r}.264" --demuxer "y4m" - --qpfile "${qpfile}" --frames ${frames#* } 2>&1 2>${tmplog}

  <${tmplog} | tail -n 20 >>${logfile}
done
kdialog --title "x264" --passivepopup "${1:t:r} done" 7

# qpfile="--qpfile \"${F:h}/dep/${F:t:r}.qp\""
# frames=$(vspipe --info ${F} - | grep -i '^Frames:')

# --subme 9

# первая строчка лога не выводится
# 2>>(grep -ve '^\[' >>${logfile})
# grep -ve ':[0-9][0-9]  $' ${tmplog} >> ${logfile}

# grep -vwe 'eta' ~/test >&1 >~/test2
# grep -ve ':[0-9][0-9]  $' ~/test >&1 >~/test2
