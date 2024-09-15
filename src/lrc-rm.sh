#!/usr/bin/env bash
set -euo pipefail

fd . "$HOME/music/" -e lrc | while read -r F; do
    # Check if the file content is exactly "[au: instrumental]"
    if [[ $(cat "$F") == '[au: instrumental]' ]]; then
        rm "$F"
        echo "Removed $F"
    fi
done
