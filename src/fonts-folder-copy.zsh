#!/usr/bin/env zsh

function fonts-ln {
  if [[ -f "${1}" ]]; then
    f_dir=~/.fonts/${2}
    mkdir -p ${f_dir}
    ln -s --target-directory=${f_dir} ${1}
    # cp ${1}  "${f_dir}/${1:t}"
  fi
}


for H in "$@"; do
  cd ${H}
  setopt +o nomatch
  for F (**/*.otf) fonts-ln ${F:a} ${H:t}
  for F (**/*.OTF) fonts-ln ${F:a} ${H:t}
  for F (**/*.ttf) fonts-ln ${F:a} ${H:t}
  for F (**/*.TTF) fonts-ln ${F:a} ${H:t}
done
