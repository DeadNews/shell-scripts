#!/usr/bin/env zsh
set -euo pipefail

downloads="$HOME/downloads"

fd . "$downloads" -t f --max-depth 1 | while read -r F; do
    mime=$(file -b --mime-type "$F")

    # Move videos by duration
    if [[ ${mime} == video/* ]]; then
        duration=$(mediainfo "--Inform=Video;%Duration%" "$F")
        duration=$((duration / 1000)) # Convert to seconds

        if ((duration > 180)); then # Longer than 3 minutes
            mv "$F" "$downloads/movies/"
            echo "Moved to Movies: '$F'"
        else
            mv "$F" "$downloads/videos/"
            echo "Moved to Videos: '$F'"
        fi
    fi

    # Move pics by type
    if [[ ${mime} == image/gif ]]; then
        mv "$F" "$downloads/videos/"
        echo "Moved to Videos: '$F'"
    elif [[ ${mime} == image/* ]]; then
        mv "$F" "$downloads/pics/"
        echo "Moved to Pics: '$F'"
    fi
done
