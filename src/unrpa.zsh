#!/usr/bin/env zsh
set -euo pipefail

for F in "$@"; do
    unrpa -mp ~/pictures/unrpa/"${F:h:h:t}" ${F}
done

kdialog --title "${0:t:r}" --passivepopup "${1:h:h:t} done" 3
