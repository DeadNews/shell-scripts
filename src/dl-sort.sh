#!/usr/bin/env bash
downloads="$HOME/downloads"

# Iterate over each file in the download folder
fd . "$downloads" -t f --max-depth 1 | while read -r F; do
    # Move videos by duration
    if [[ $(file --mime-type -b "$F") == video/* ]]; then
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
    # Move GIFs
    if [[ $(file --mime-type -b "$F") == image/gif ]]; then
        mv "$F" "$downloads/videos/"
        echo "Moved to Videos: '$F'"
    fi
    # Move pics
    if [[ $(file --mime-type -b "$F") == image/* ]]; then
        mv "$F" "$downloads/pics/"
        echo "Moved to Pics: '$F'"
    fi
done
