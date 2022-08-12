#!/usr/bin/env zsh

function scans-rename {
  if [[ -f "${1}" ]]; then

    mv ${1} "${2}/${1//\// - }" 
  fi
}


for H in "$@"; do
  cd ${H}

  setopt +o nomatch
  for F (**/*) scans-rename ${F} ${H}
done

