#!/usr/bin/env zsh

for N in {1..12}; do

    /usr/bin/mkvmerge --ui-language en_US --output "/run/media/deadnews/data1/encode/2008-DetroitMetalCity/out/audio/e${N} (1).mka" --language 0:ja --track-name '0:DTS-HDMA->FLAC16' '(' "/run/media/deadnews/data1/encode/2008-DetroitMetalCity/out/audio/e${N}.mka" ')' --language 0:en --track-name '0:[BD]' --default-track 0:no '(' "/run/media/deadnews/data1/encode/2008-DetroitMetalCity/out/mux/ENG Subs/e${N}.eng.[BD].sup.mks" ')' --track-order 0:0,1:0


done
