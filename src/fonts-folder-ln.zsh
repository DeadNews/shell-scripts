#!/usr/bin/env zsh

for H in "$@"; do
    fonts_dir="${HOME}/.local/share/fonts/${H:t}"
    mkdir -p ${fonts_dir}

    find "${H}" -type f -iname '*.*tf' -exec ln -sv --target-directory="${fonts_dir}" {} +
done
