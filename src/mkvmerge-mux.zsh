#!/usr/bin/env zsh

zparseopts -D -rename=rename -year_cli=year_cli

for F in "$@"; do

    name=${F:t:r}
    name=${name% \(*}

    unset audioFlag
    if [ -f "${F:h}/audio/${name}.mka" ]; then
        audioFile="${F:h}/audio/${name}.mka"
        audioFlag=1
    elif [ -f "${F:h:h}/in/${name}.mka" ]; then
        audioFile="${F:h:h}/in/${name}.mka"
        audioFlag=1
    elif [ -f "${F:h}/audio/${name}-1.mka" ]; then
        audioFile="${F:h}/audio/${name}-1.mka"
        audioFile_2="${F:h}/audio/${name}-2.mka"

    elif [ -f "${F:h:h}/in/${name}-1.mka" ]; then
        audioFile="${F:h:h}/in/${name}-1.mka"
        audioFile_2="${F:h:h}/in/${name}-2.mka"
    fi
    lang=$(mediainfo --Inform="Audio;%Language%" ${audioFile})
    lang=${lang:='jpn'}

    if [ ! ${audioFlag} ]; then
        lang2=$(mediainfo --Inform="Audio;%Language%" ${audioFile_2})
        lang2=${lang2:='jpn'}
    fi

    fileWithTitles="${F:h:h}/titles.txt"
    if [ -f ${fileWithTitles} ]; then
        title=$(grep -i "^${name}:" ${fileWithTitles})
        title=${title#*: }
        echo "\n ${title}"

        unset flagEP
        fileTitle=${title%% *}

        fileTitleEP=${fileTitle/#EP/}
        fileTitleOP=${fileTitle/#OP/}
        fileTitleED=${fileTitle/#ED/}
        fileTitleS=${fileTitle/#S/}
        fileTitlePart=${fileTitle/#Part/}
        if [[ ${fileTitle} != "${fileTitleEP}" ]]; then
            flagEP=1
            fileTitleEP=$(printf "%02d" ${fileTitleEP})
            fileTitle=${fileTitleEP}
        elif [[ ${fileTitle} != "${fileTitleOP}" ]] || [[ ${fileTitle} != "${fileTitleED}" ]] || [[ ${fileTitle} != "${fileTitleS}" ]]; then
            fileTitle=${title%% *}
        elif [[ ${fileTitle} != "${fileTitlePart}" ]]; then
            fileTitle=${title%%:*}
        else
            fileTitle=${title}
        fi
        tagTitle=${title/#EP/E}

        globTitle=$(grep -i "title:" ${fileWithTitles})
        globTitle=${globTitle#*: }
        year=$(grep -i "_year:" ${fileWithTitles})
        year=${year#*: }
        shortGTitle=$(grep -i "^short:" ${fileWithTitles})
        shortGTitle=${shortGTitle#*: }
        season=$(grep -i "seasn:" ${fileWithTitles})
        season=${season#*: }
    fi

    if [ -f "${F:h}/chapters/${name}.txt" ]; then
        chapters="${F:h}/chapters/${name}.txt"
    elif [ -f "${F:h:h}/in/chapters/${name}.txt" ]; then
        chapters="${F:h:h}/in/chapters/${name}.txt"
    else
        echo "CHAPTER01=00:00:00.000\nCHAPTER01NAME=Start" >"/tmp/0.txt"
        chapters="/tmp/0.txt"
    fi

    if [ ${rename} ]; then
        TAG='[Kawaiika-Raws]'
        SourceType='BDRip'
        # SourceType='WEBRip'
        Width=$(mediainfo --Inform="Video;%Width%" ${F})
        Height=$(mediainfo --Inform="Video;%Height%" ${F})
        FormatV=$(mediainfo --Inform="Video;%Format%" ${F})
        FormatA=$(mediainfo --Inform="Audio;%Format%" ${audioFile})
        if [ "${FormatA}" = "DTS" ]; then
            FormatA='DTS-HDMA'
        fi
        if [ "${FormatA}" = "FLAC" ]; then
            unset audioName
            audioName=$(mediainfo --Inform="Audio;%Title%" ${audioFile})
            audioName=${audioName:='LPCM->FLAC'}
        fi
        if [ ${season} ]; then
            tagTitle="S${season}${tagTitle}"

            if [ ${flagEP} ]; then
                fileTitle="S${season}E${fileTitle}"
            else
                fileTitle="S${season}${fileTitle}"
            fi
        fi

        format="[${SourceType} ${Width}x${Height} ${FormatV} ${FormatA}]"

        if [ ${year_cli} ]; then
            output="${F:h}/${TAG} (${year}) ${globTitle} ${format}/${TAG} ${shortGTitle:=${globTitle}} ${fileTitle} ${format}.mkv"
        else
            output="${F:h}/${TAG} ${globTitle} (${year}) ${format}/${TAG} ${shortGTitle:=${globTitle}} ${fileTitle} ${format}.mkv"
        fi
    else
        output="${F:h}/mux/${name}.mkv"
    fi

    if [ ${audioFlag} ]; then
        mkvmerge --output ${output} --no-audio --language 0:${lang} --track-name "0:${SourceType} by DeadNews" ${F} \
            --language 0:${lang} --track-name "0:${audioName:=${FormatA}}" ${audioFile} --track-order 0:0,1:0 --chapters ${chapters} --title "${tagTitle}"
    else
        mkvmerge --output ${output} --no-audio --language 0:${lang} --track-name "0:${SourceType} by DeadNews" ${F} \
            --language 0:${lang} --track-name "0:TrueHD->FLAC16" ${audioFile} --language 0:${lang2} --track-name "0:TrueHD->FLAC16" ${audioFile_2} \
            --track-order 0:0,1:0,2:0 --chapters ${chapters} --title "${tagTitle}"
    fi

done
kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 7
