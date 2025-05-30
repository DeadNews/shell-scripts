#!/usr/bin/env zsh
set -euo pipefail

for H in $(fd . ~/git --exact-depth 1 --type d); do
    echo ${H:t}
    git -C ${H} pull
done

# find ~/git -mindepth 1 -maxdepth 1 -type d -exec git -C {} pull \;

# fd . ~/git --exact-depth 1 --type d -x git -C {} pull
