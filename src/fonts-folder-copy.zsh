#!/usr/bin/env zsh

function fonts-ln {
    fonts_d="~/.local/share/fonts/${2}"
    mkdir -p ${fonts_d}
    ln -sv --target-directory=${fonts_d} ${1}
}

for H in "$@"; do
    cd ${H}
    find . -type f -iname '*.*tf' | while read F; do fonts-ln "${F:a}" "${H:t}"; done
done
