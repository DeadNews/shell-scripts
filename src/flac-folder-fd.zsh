#!/usr/bin/env zsh

for H in "$@"; do
    cd ${H}

    # Extract cover.
    fd -t d -x bash -c 'fd -t f -e flac . {} -x metaflac --export-picture-to=temp_cover.jpg -q \; -x true'

    fd -t f -e png -x mogrify -format jpg -quality 99% {}
    fd -t f -e png -x rm {}
    fd -t f -e jpg -x jpegoptim {}
    fd -t f -e jpg -x mv -vn {} cover.jpg \;

    fd -t f -e flac -x metaflac --remove --block-type=PICTURE,PADDING --dont-use-padding {}
    fd -t f -e flac -x flac --best --force {}
done

kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 5
