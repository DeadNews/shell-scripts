#!/usr/bin/env zsh
set -euo pipefail

for F in "$@"; do
    font-rename ${F}
done

for F in "$argv[$#]"; do
    fdupes -dN "${F:h}"

    cd "${F:h}"
    autoload zmv
    chars='[][?=+<>;",-]'
    zmv '(**/)()' '$1${2//$~chars/%}'
done

# https://gist.github.com/niksmac/77de3f19d1de0e7c20a8a0f5736c837d
