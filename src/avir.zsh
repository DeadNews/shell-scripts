#!/usr/bin/env zsh

for F in "$@"; do
    mkdir -p "${F:h}/avir"
    resized="${F:h}/avir/${F:t:r}-fit-496x696.png"

    ~/my/bin/avir --fit --dither --algparams=ulr ${F} ${resized} 496x696

    # /usr/bin/convert -border 2 -bordercolor '#534BA1' -quality 100% -strip -interlace Plane \
    #   -sampling-factor 4:2:0 "${resized}" "${resized:r}.jpg"

    color1='#534BA1'
    color2='#8d2f2f'
    color3='#224488'
    color4='#1d8434'
    color5='#3b389b'
    color6='#000000'

    python -c "from PIL import Image, ImageOps; \
    img = Image.open(\"${resized}\"); \
    bimg = ImageOps.expand(img, border=2, fill='${color1}'); \
    bimg = bimg.convert('RGB'); \
    bimg.save(\"${resized:r}.jpg\", \"JPEG\", quality=100, optimize=True, progressive=True)"

    unlink ${resized}
done
# kdialog --title "avair" --passivepopup "${1:h:h:t} done" 7
