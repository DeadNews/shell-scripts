#!/usr/bin/env zsh

chmod u+x "${1:h}/lib/linux-x86_64/${1:t:r}" && chmod u+x ${1} && exec ${1}
