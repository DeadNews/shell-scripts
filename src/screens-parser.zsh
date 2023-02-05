#!/usr/bin/env zsh

for conig_file in "$@"; do
    pattern=$(grep -i "^pattern:" ${conig_file})
    pattern=${pattern#*: }
    title=$(grep -i "^title:" ${conig_file})
    title=${title#*: }

    for num in $(seq 1 1 24); do
        episFrames=$(grep -i "^e${num}:" ${conig_file})
        if [ ${episFrames} ]; then
            episFrames=${episFrames#*: }
            pudNum=$(printf "%02d" ${num})
            episPattern=$(echo ${pattern} | sed "s/##/${pudNum}/g" | sed "s/#/${num}/g")

            zsh -c "/path/to/vpy-screens.py ${episPattern} --frames ${episFrames} --title ${title}"
        fi
    done
done

# usage: /path/to/screens-parser.zsh '/path/to/screens.txt'
# --offset 24
