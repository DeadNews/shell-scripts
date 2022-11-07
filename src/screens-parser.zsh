#!/usr/bin/env zsh

for conigFile in "$@"; do
    pattern=$(grep -i "^pattern:" ${conigFile})
    pattern=${pattern#*: }
    title=$(grep -i "^title:" ${conigFile})
    title=${title#*: }

    for num in $(seq 1 1 24); do
        episFrames=$(grep -i "^e${num}:" ${conigFile})
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
