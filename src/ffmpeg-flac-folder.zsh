#!/usr/bin/env zsh
source $(which env_parallel.zsh)

flac_convert() {
    ffmpeg -hide_banner -i "${1}" -map 0:a:0 -acodec flac -compression_level 12 "/tmp/${1:t:r}.flac" &&
        mv "/tmp/${1:t:r}.flac" "${1:h}"
}

jpgoptim() {
    jpegoptim --strip-all --all-progressive ${1}
}

avair() {
    ~/my/bin/avir --fit --dither -q 98 ${1} ${2} 500x500
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
    setopt +o nomatch
    for F (**/*.jpg) jpg_reaname ${F}
    env_parallel jpg_convert ::: **/*.jpg
    env_parallel png_convert ::: **/*.png
    env_parallel flac_convert ::: **/*.flac
done

kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 5

# https://unix.stackexchange.com/questions/50313/how-do-i-perform-an-action-on-all-files-with-a-specific-extension-in-subfolders#50314
# for i (${H}/**/*.flac(D)) /path/to/ffmpeg-flac.zsh $i
# find ${H} -iname '*.flac' -exec /path/to/ffmpeg-flac.zsh '{}' \;
# find ${H} -iname '*.flac' -exec /path/to/ffmpeg-flac.zsh '{}' +
# find ${H} -iname '*.flac' -print0 | xargs -r0 /path/to/ffmpeg-flac.zsh

# http://zsh.sourceforge.net/Doc/Release/Shell-Grammar.html#Alternate-Forms-For-Complex-Commands
