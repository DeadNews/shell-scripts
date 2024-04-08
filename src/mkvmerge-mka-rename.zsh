#!/usr/bin/env zsh
zparseopts -D -fix=fix

# lang='rus'
# lang='eng'
# lang='chi'
lang='jpn'

# name=''
# name='[BD]'
# name='[WEB]'
# name='TrueHD->FLAC'
name='TrueHD->FLAC16'

if [[ ! ${fix} ]]; then
    for F in "$@"; do
        codec=$(mediainfo --Inform="Audio;%CodecID%" ${F})
        codec=${codec:2:l}
        if [[ ${codec} == 'aac-2' ]] {  codec='aac'  }
        if [[ ${codec} == '-2' ]] {  codec='aac'  }

        mkvmerge --output "${F:h}/${name}/${F:t:r}.${lang}.${name#*] }.${codec}.mka" --no-video --no-subtitles --no-chapters --no-attachments --language 0:${lang} --track-name "0:${name}" ${F} --title "" #если только 1 аудио без видео

        # mkvmerge --output "${F:h}/${name}/${F:t:r}.${lang}.${name#*] }.${codec}.mka" --no-video --no-subtitles --no-chapters --no-attachments --language 1:${lang} --track-name "1:${name}" ${F} --title "" #если видео и 1 аудио

        # mkvmerge --output "${F:h}/${name}/${F:t:r}.${lang}.${name#*] }.${codec}.mka" --audio-tracks 1 --no-video --no-subtitles --no-chapters --no-attachments --language 1:${lang} --track-name "1:${name}" ${F} --title "" #когда больше 1 трека
    done

else
    for F in "$@"; do
        lang=$(mediainfo --Inform="Audio;%Language%" ${F})
        name='LPCM->FLAC'

        mkvmerge --output "${F:h}/+fix/${F:t:r}.mka" --no-video --no-subtitles --no-chapters --no-attachments --language 0:${lang} --track-name "0:${name}" ${F}
    done
fi

kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 5


# https://coder-booster.ru/learning/linux-beginners/modification-of-variables-in-bash
