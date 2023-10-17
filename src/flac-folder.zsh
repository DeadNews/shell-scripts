#!/usr/bin/env zsh

for H in "$@"; do
    cd ${H}

    # Extract cover.
    find . -mindepth 1 -type d | while read d; do
        find ${d} -type f -iname '*.flac' -execdir metaflac {} --export-picture-to=temp_cover.jpg \; -quit 2> /dev/null
    done

    find . -type f -iname '*.png' -exec mogrify -format jpg -quality 99% {} +
    find . -type f -iname '*.png' -exec rm {} +
    find . -type f -iname '*.jpg' -exec jpegoptim {} +
    find . -type f -iname '*.jpg' -execdir mv -vn {} cover.jpg \;

    find . -type f -iname '*.flac' -exec metaflac --remove --block-type=PICTURE,PADDING --dont-use-padding {} +
    # find . -type f -iname '*.flac' -exec parallel --jobs 50% flac --best --force ::: {} +
    find . -type f -iname '*.flac' -exec flac --best --force {} +
done

kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 5
