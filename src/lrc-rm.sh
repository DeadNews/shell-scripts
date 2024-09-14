#!/usr/bin/env bash

search_dir="$HOME/music/"

# fd . "${search_dir}" -e lrc --exec bash -c 'if [[ $(cat "{}") == "[au: instrumental]" ]]; then rm "{}"; echo "Removed {}"; fi'

# Iterate over all files in the directory
find "${search_dir}" -type f -iname '*.lrc' | while read -r F; do
    # Check if the file content is exactly "[au: instrumental]"
    if [[ $(cat "${F}") == '[au: instrumental]' ]]; then
        # Remove the file
        rm "${F}"
        echo "Removed ${F}"
    fi
done
