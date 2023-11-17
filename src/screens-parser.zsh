#!/usr/bin/env zsh
# Usage:
# src/screens-parser.zsh /path/to/screens.txt
# --offset 24

for config_file in "$@"; do
    pattern=$(grep -i "^pattern:" ${config_file})
    pattern=${pattern#*: }
    title=$(grep -i "^title:" ${config_file})
    title=${title#*: }

    for num in $(seq 1 1 24); do
        episFrames=$(grep -i "^e${num}:" ${config_file})
        if [ ${episFrames} ]; then
            episFrames=${episFrames#*: }
            pudNum=$(printf "%02d" ${num})
            episPattern=$(echo ${pattern} | sed "s/##/${pudNum}/g" | sed "s/#/${num}/g")

            zsh -c "/path/to/vpy-screens.py ${episPattern} --frames ${episFrames} --title ${title}"
        fi
    done
done
