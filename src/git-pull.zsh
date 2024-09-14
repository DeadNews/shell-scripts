#!/usr/bin/env zsh
set -euo pipefail

for H in $(find ~/git -mindepth 1 -maxdepth 1 -type d); do
    echo ${H:t}
    git -C ${H} pull
done

# find ~/git -mindepth 1 -maxdepth 1 -type d -exec git -C {} pull \;
