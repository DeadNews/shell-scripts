#!/usr/bin/env zsh


for H in "$@"; do
    cd ${H}
    setopt +o nomatch
    for F (**/*.vpy) black --line-length "90" ${F}
    for F (**/*.vpy) isort --line-length "90" --ds ${F}

    for F (**/*.vpy) sed -e "s|# |#|g" -i ${F}
done
