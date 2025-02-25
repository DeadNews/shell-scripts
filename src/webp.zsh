#!/usr/bin/env zsh
set -euo pipefail

for F in "$@"; do
    mkdir "${F:h}/+test"

    if [[ ${F:e} == "png" ]]; then
        cwebp -q 100 ${F} -o "${F:h}/+test/${F:t:r}.webp"

    elif [[ ${F:e} == "webp" ]]; then
        dwebp ${F} -o "${F:h}/+test/${F:t:r}.png"
    fi
done

# kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 7
