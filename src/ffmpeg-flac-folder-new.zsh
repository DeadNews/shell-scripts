#!/usr/bin/env zsh
source $(which env_parallel.zsh)

flac_convert() {
        metaflac --remove --block-number=3 ${1}
        flac --best --force "${1}"
}

jpgoptim() {
    jpegoptim --strip-all --all-progressive ${1}
}

avair() {
    ~/my/bin/avir --fit --dither -q 98 ${1} ${2} 500x500
    # convert cover.jpg -filter Lanczos -distort Resize 500x500 cover_500_Lanczos_distort.jpg
    # convert cover.jpg -filter Lanczos -resize 500x500 cover_500_Lanczos.jpg
    # convert cover.jpg -resize 500x500 cover_500.jpg
}

jpg_convert() {
    if [[ -f "${1}" ]]; then
        geometry=$(magick identify -format "%w %h" ${1})
        widt=${geometry/ */}
        height=${geometry#* }

        if [[ ${widt} -gt 500 || ${height} -gt 500 ]]; then
            cwebp -m 6 -q 98 -pass 5 ${1} -o "${1:r}.webp"
            avair ${1} ${1}
        fi
        jpgoptim ${1}
    fi
}

png_convert() {
    if [[ -f "${1}" ]]; then
        cwebp -m 6 -z 9 -lossless ${1} -o "${1:r}.webp"
        avair ${1} "${1:r}.jpg"
        jpgoptim "${1:r}.jpg"
        unlink ${1}
    fi
}

jpg_reaname() {
    if [[ -f "${1}" ]]; then
        cover="${1:h}/cover.jpg"
        if [[ ! -f ${cover} ]] && [[ ! -f "${cover:r}.png" ]]; then
            mv ${1} ${cover}
        fi
    fi
}

for H in "$@"; do
    cd ${H}
    # for F (**/*.jpg) jpg_reaname ${F}
    # env_parallel jpg_convert ::: **/*.jpg
    # env_parallel png_convert ::: **/*.png
    # env_parallel flac_convert ::: **/*.flac
    # find . -type f -iname '*.flac' -print0 | parallel -0 --jobs 50% flac --best --force {}
    find . -type f -iname '*.flac' -exec metaflac --remove --block-number=3 {} +
    find . -type f -iname '*.flac' -exec parallel --jobs 50% flac --best --force ::: {} +

    # find . -type f -iname '*.flac' -exec env_parallel -j 50% flac_convert ::: {} +
    # find . -type f -iname '*.flac' -print0 | env_parallel -0 -j 50% flac_convert ::: {}
done

kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 5
