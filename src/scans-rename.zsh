#!/usr/bin/env zsh
set -euo pipefail

function scans-rename {
    F="${1:2}" # remove first 2 characters
    mv -vn ${F} "${F//\// - }"
}

for H in "$@"; do
    cd ${H}
    find . -type f | while read F; do scans-rename "${F}"; done
done
