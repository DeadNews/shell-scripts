#!/usr/bin/env zsh

underline=$(tput smul)
reset=$(tput sgr0)

for F in "$@"; do

    echo "${underline}${F:t:r}${reset}"
    echo "$(vspipe  --info ${F} -) \n"
    # echo "$(vspipe --filter-time --info ${F} -) \n"

done
