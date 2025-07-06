#!/usr/bin/env zsh
set -euo pipefail

# Rename files in the current directory and subdirectories
# by replacing slashes (/) with spaces and hyphens (-).

function discs-rename {
    F="${1:2}" # remove first 2 characters
    mv -vn ${F} "${F//\// - }"
}

for H in "$@"; do
    cd ${H}
    find . -type f | while read F; do discs-rename "${F}"; done
done
