#!/usr/bin/env zsh
zparseopts -D -scale:=scale_cli -noise:=noise_cli

scale=${scale_cli[-1]:='4'}
noise=${noise_cli[-1]:='3'}

for F in "$@"
do
  mkdir -p "/home/deadnews/my/images/waifu2x/"
  waifu2x-converter-cpp --scale-ratio ${scale} --noise-level ${noise} --mode noise-scale \
    --processor 1 --silent --input ${F} --output "/home/deadnews/my/images/waifu2x/${F:t:r}--scale${scale}-noise${noise}.png"
done
kdialog --title "${0:t:r}" --passivepopup "${1:h:h:t} done" 7

# Exec=/home/deadnews/my/scripts/zsh/waifu2x.zsh --scale 8 --noise 3  %F
