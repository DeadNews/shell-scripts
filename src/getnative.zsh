#!/usr/bin/env zsh

zparseopts -D -detail=detail

for F in "$@"; do
    cd "${F:h}"

    if [[ ! ${detail} ]]; then
        min=680
        # min=380

        # getnative ${F} -min ${min} -max 1080 -pf png -k bilinear
        getnative ${F} -min ${min} -max 1080 -pf png -k bicubic
        # getnative ${F} -min ${min} -max 1080 -pf png -k bicubic -b 0.5 -c 0
        # getnative ${F} -min ${min} -max 1080 -pf png -k bicubic -b 0.2 -c 0.5

        cd "${F:h}/results/"
        for file in *; do
            mv --force -T "${F:h}/results/${file}" "${F:h}/${F:t:r} [${file:r}].${file:e}"
        done

    else
        resolution=720

        min=$((resolution - 2))
        max=$((resolution + 2))
        tmp_dir=$(mktemp -d)

        getnative ${F} -min ${min} -max ${max} -pf png -dir ${tmp_dir} -k bilinear
        getnative ${F} -min ${min} -max ${max} -pf png -dir ${tmp_dir} -k bicubic -b 1/3 -c 1/3
        getnative ${F} -min ${min} -max ${max} -pf png -dir ${tmp_dir} -k bicubic -b 0.5 -c 0
        getnative ${F} -min ${min} -max ${max} -pf png -dir ${tmp_dir} -k bicubic -b 0 -c 0.5
        getnative ${F} -min ${min} -max ${max} -pf png -dir ${tmp_dir} -k bicubic -b 1 -c 0
        getnative ${F} -min ${min} -max ${max} -pf png -dir ${tmp_dir} -k bicubic -b 0 -c 1
        getnative ${F} -min ${min} -max ${max} -pf png -dir ${tmp_dir} -k bicubic -b 0.75 -c 0
        getnative ${F} -min ${min} -max ${max} -pf png -dir ${tmp_dir} -k bicubic -b 0 -c 0.75
        getnative ${F} -min ${min} -max ${max} -pf png -dir ${tmp_dir} -k bicubic -b 0.5 -c 0.5
        getnative ${F} -min ${min} -max ${max} -pf png -dir ${tmp_dir} -k bicubic -b 0.2 -c 0.5
        getnative ${F} -min ${min} -max ${max} -pf png -dir ${tmp_dir} -k bicubic -b 0.2 -c 0.4
        getnative ${F} -min ${min} -max ${max} -pf png -dir ${tmp_dir} -k bicubic -b 1 -c 1
        getnative ${F} -min ${min} -max ${max} -pf png -dir ${tmp_dir} -k bicubic -b 0 -c 0
        getnative ${F} -min ${min} -max ${max} -pf png -dir ${tmp_dir} -k lanczos -t 2
        getnative ${F} -min ${min} -max ${max} -pf png -dir ${tmp_dir} -k lanczos -t 3
        getnative ${F} -min ${min} -max ${max} -pf png -dir ${tmp_dir} -k lanczos -t 4

        tmp1="${tmp_dir}/temp1.txt"
        tmp2="${tmp_dir}/temp2.txt"
        out="${F:h}/getnative_detail_${resolution}.txt"

        cd "${tmp_dir}/results/"
        for file in *.txt; do
            echo "${file:r} | $(grep -i "^ ${resolution}" "${tmp_dir}/results/${file}")" >> ${tmp1}
        done

        < ${tmp1} | tr -d "[:blank:]" > ${tmp2}
        sed -r -e 's/(.*)\|(.*)\|(.*)\|(.*)/\3\t\4\t\1/g' \
            -e 's|f_0_||' \
            -e 's|_ar_.*$||' \
            -i ${tmp2}

        echo "\n-> [${F:t:r}]" >> ${out}
        sort -k 1 -g ${tmp2} | head -n 6 >> ${out}
        echo '' >> ${out}
        sort -k 2 -r -V ${tmp2} | head -n 6 >> ${out}

        rm -R ${tmp_dir}
    fi
done

kdialog --title "${0:t:r}" --passivepopup "${1:h:t} done" 5
