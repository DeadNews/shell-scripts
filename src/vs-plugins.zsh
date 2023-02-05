#!/usr/bin/env zsh

# flags
CPPFLAGS="-D_FORTIFY_SOURCE=2"
CFLAGS="-march=x86-64 -mtune=intel -O2 -pipe -fno-plt -fstack-protector-stron -ftree-vectorize"
CXXFLAGS="${CFLAGS}"
MAKEFLAGS="-j4"

# folders
BIN="${HOME}/bin/"
cd ${BIN}
root_dir="${PWD}/vapoursynth-plugins"
plugins_dir="${root_dir}/plugins"
packages_dir="${root_dir}/packages"
sysPlugins="${PWD}/vpy-plugins"
sysPackages="${PWD}/vpy-packages"

mkdir -p "${plugins_dir}"
mkdir -p "${packages_dir}"
cd "${root_dir}"

# make dep: meson ninja boost
function meson-build() {
    cd "${root_dir}"
    git clone ${1} --depth 1
    name=${1#https://github.com/*/}
    name=${name%}
    cd ${name}
    meson build
    ninja -C build
    mv ./build/*.so "${plugins_dir}"
    echo ''
}

function meson-cd2vpy-build() {
    cd "${root_dir}"
    git clone ${1} --depth 1 -b ${2}
    name=${1#https://github.com/*/}
    name=${name%}
    if [[ -d ${name}/VapourSynth ]]; then
        cd ${name}/VapourSynth
    elif [[ -d ${name}/vapoursynth ]]; then
        cd ${name}/vapoursynth
    fi
    meson build
    ninja -C build
    mv ./build/*.so "${plugins_dir}"
    echo ''
}

function py-copy() {
    cd "${root_dir}"
    git clone ${1} --depth 1
    name=${1#https://*github.com/*/}
    name=${name%}
    mv ./${name}/*.py "${packages_dir}"
    echo ''
}

function py-copy-name() {
    cd "${root_dir}"
    if [[ ! ${3} ]]; then
        git clone ${1} --depth 1
    else
        git clone ${1} --depth 1 -b ${3}
    fi
    name=${1#https://*github.com/*/}
    name=${name%}
    mv ./${name}/${2} "${packages_dir}"
    echo ''
}

# function py-copy-folder() {
#     cd "${root_dir}"
#     git clone ${1} --depth 1
#     name=${1#https://*github.com/*/}
#     name=${name%}
#     mv ./${name}/${2} "${packages_dir}"
#     echo ''
# }

# make dep: yasm essential nasm
function x265-build() {
    cd ${BIN}
    git clone https://bitbucket.org/multicoreware/x265_git --depth 1 -b ${1}
    cd x265_git

    # git apply ~/downloads/x265-x265-1-of-2-Histogram-based-scenecut-detection.patch

    cd build/linux
    cmake ../../source -D HIGH_BIT_DEPTH=ON
    make
    rm ${BIN}/vpy-x265/libx265.so.[0-9]*
    cp ./x265 ./libx265.so.[0-9]* ${BIN}/vpy-x265/
    rm -rf ${BIN}/x265_git
}

function x265-build-mod() {
    cd ${BIN}
    git clone https://github.com/msg7086/x265-Yuuki-Asuna --depth 1 -b ${1}
    cd x265-Yuuki-Asuna

    cd build/linux
    cmake ../../source -D HIGH_BIT_DEPTH=ON
    make
    rm ${BIN}/vpy-x265/libx265.so.[0-9]*
    cp ./x265 ./libx265.so.[0-9]* ${BIN}/vpy-x265/
    rm -rf ${BIN}/x265_git
}

function autotools-build() {
    cd "${root_dir}"
    git clone ${1} --depth 1
    name=${1#https://github.com/*/}
    name=${name%}
    cd ${name}
    ./autogen.sh
    ./configure --extra-cxxflags="${CXXFLAGS}"
    make
    mv ./.libs/*.so "${plugins_dir}"
    echo ''
}

function autotools-bilateral() {
    cd "${root_dir}"
    git clone ${1} --depth 1
    name=${1#https://github.com/*/}
    name=${name%}
    cd ${name}
    ./configure --extra-cxxflags="${CXXFLAGS}"
    make
    mv ./*.so "${plugins_dir}"
    echo ''
}

function descale-build() {
    cd "${root_dir}"
    git clone ${1} --depth 1
    name=${1#https://github.com/*/}
    name=${name%}
    cd ${name}
    meson build
    ninja -C build
    mv ./build/*.so "${plugins_dir}"
    mv ./*.py "${packages_dir}"
    echo ''
}

function znedi3-build() {
    cd "${root_dir}"
    git clone ${1} --depth 1 --recursive
    name=${1#https://github.com/*/}
    name=${name%}
    cd ${name}
    make X86=1
    mv vsznedi3.so "${plugins_dir}"
    mv nnedi3_weights.bin "${plugins_dir}"
    echo ''
}

function fmtconv-build() {
    cd "${root_dir}"
    git clone ${1} --depth 1
    name=${1#https://github.com/*/}
    name=${name%}
    cd "${name}/build/unix"
    ./autogen.sh
    ./configure --extra-cxxflags="${CXXFLAGS}"
    make
    mv ./.libs/*.so "${plugins_dir}"
    echo ''
}

function f3kdb-build() {
    cd "${root_dir}"
    git clone ${1} --depth 1
    name=${1#https://github.com/*/}
    name=${name%}
    cd ${name}
    ./waf configure
    ./waf build
    mv ./build/*.so "${plugins_dir}"
    echo ''
}

function neo-f3kdb-build() {
    cd "${root_dir}"
    git clone ${1} --depth 1
    name=${1#https://github.com/*/}
    name=${name%}
    cd ${name}
    mkdir -p build && cd build
    cmake ../
    cmake --build .
    mv ../build/*.so "${plugins_dir}"
    echo ''
}

function cmake-build() {
    cd "${root_dir}"
    git clone ${1} --depth 1
    name=${1#https://github.com/*/}
    name=${name%}
    cd ${name}
    mkdir -p build && cd build
    cmake ../
    cmake --build .
    mv ../x64/*.so "${plugins_dir}"
    echo ''
}

# make dep: rust
function cargo-build() {
    cd "${root_dir}"
    git clone ${1} --depth 1
    name=${1#https://*/*/}
    name=${name%}
    cd ${name}
    cargo build --release
    mv ./target/release/*.so "${plugins_dir}"
    echo ''
}

function py-dl() {
    cd "${root_dir}"
    wget ${1}
    mv ./*.py "${packages_dir}"
    echo ''
}

function vpy-build() {
    cargo-build https://git.kageru.moe/kageru/adaptivegrain
    cargo-build https://github.com/End-of-Eternity/vs-average

    meson-build https://github.com/vapoursynth/subtext
    meson-build https://github.com/vapoursynth/vivtc
    meson-build https://github.com/vapoursynth/vs-imwri
    meson-build https://github.com/vapoursynth/vs-miscfilters-obsolete
    meson-build https://github.com/vapoursynth/vs-removegrain

    # meson-build https://github.com/HomeOfVapourSynthEvolution/VapourSynth-Bwdif
    # meson-build https://github.com/HomeOfVapourSynthEvolution/VapourSynth-DCTFilter
    # meson-build https://github.com/HomeOfVapourSynthEvolution/VapourSynth-Deblock
    # meson-build https://github.com/Khanattila/KNLMeansCL
    # meson-build https://github.com/Kiyamou/VapourSynth-JincResize
    # meson-build https://github.com/Lypheo/vs-placebo
    # meson-cd2vpy-build https://github.com/AmusementClub/ReduceFlicker
    meson-build https://github.com/Beatrice-Raws/VapourSynth-TColorMask
    meson-build https://github.com/DeadNews/EdgeFixer
    meson-build https://github.com/dubhater/vapoursynth-awarpsharp2
    meson-build https://github.com/dubhater/vapoursynth-mvtools
    meson-build https://github.com/dubhater/vapoursynth-temporalsoften2
    meson-build https://github.com/HomeOfVapourSynthEvolution/VapourSynth-AddGrain
    meson-build https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D
    meson-build https://github.com/HomeOfVapourSynthEvolution/VapourSynth-CAS
    meson-build https://github.com/HomeOfVapourSynthEvolution/VapourSynth-CTMF
    meson-build https://github.com/HomeOfVapourSynthEvolution/VapourSynth-DFTTest
    meson-build https://github.com/HomeOfVapourSynthEvolution/VapourSynth-EEDI3
    meson-build https://github.com/HomeOfVapourSynthEvolution/VapourSynth-NNEDI3CL
    meson-build https://github.com/HomeOfVapourSynthEvolution/VapourSynth-Retinex
    meson-build https://github.com/HomeOfVapourSynthEvolution/VapourSynth-TCanny
    meson-build https://github.com/HomeOfVapourSynthEvolution/VapourSynth-TTempSmooth
    meson-build https://github.com/HomeOfVapourSynthEvolution/VapourSynth-Yadifmod
    meson-build https://github.com/Irrational-Encoding-Wizardry/Vapoursynth-RemapFrames
    meson-cd2vpy-build https://github.com/AkarinVS/L-SMASH-Works 'ffmpeg-4.5'

    # neo-f3kdb-build https://github.com/HomeOfAviSynthPlusEvolution/neo_f3kdb
    autotools-bilateral https://github.com/HomeOfVapourSynthEvolution/VapourSynth-Bilateral
    autotools-build https://github.com/dubhater/vapoursynth-histogram
    autotools-build https://github.com/dubhater/vapoursynth-nnedi3
    descale-build https://github.com/Irrational-Encoding-Wizardry/vapoursynth-descale
    f3kdb-build https://github.com/SAPikachu/flash3kyuu_deband
    fmtconv-build https://github.com/EleonoreMizo/fmtconv
    znedi3-build https://github.com/sekrit-twc/znedi3

    # py-copy https://gist.github.com/chikuzen/5005590 # easyvfr
    # py-copy https://github.com/AmusementClub/mvsfunc/
    # py-copy https://gitlab.com/Ututu/adptvgrnmod
    py-copy https://gist.github.com/4re/342624c9e1a144a696c6 # nnedi3_rpow2
    py-copy https://gist.github.com/4re/8676fd350d4b5b223ab9 # finesharp
    py-copy https://github.com/DeadNews/vs-insane-aa
    py-copy https://github.com/dubhater/vapoursynth-adjust
    py-copy https://github.com/fdar0536/VapourSynth-Contra-Sharpen-mod
    py-copy https://github.com/HomeOfVapourSynthEvolution/havsfunc
    py-copy https://github.com/HomeOfVapourSynthEvolution/mvsfunc
    py-copy https://github.com/HomeOfVapourSynthEvolution/nnedi3_resample
    py-copy https://github.com/Irrational-Encoding-Wizardry/fvsfunc
    py-copy https://github.com/WolframRhodium/muvsfunc
    py-copy-name https://github.com/Irrational-Encoding-Wizardry/kagefunc 'kagefunc.py'
    py-copy-name https://github.com/Irrational-Encoding-Wizardry/lvsfunc 'lvsfunc'
    py-copy-name https://github.com/Irrational-Encoding-Wizardry/vsutil 'vsutil'

    py-dl https://www.dropbox.com/s/2fw0mm0mswng234/HardAA.py

    cp -R ${plugins_dir}/* ${sysPlugins}
    cp -R ${packages_dir}/* ${sysPackages}
    rm -rf ${root_dir}
}

function test-build() {
    # znedi3-build https://github.com/sekrit-twc/znedi3
    # znedi3-build https://github.com/JeremyMahieu/znedi3
}

function system-build() {
    rm ~/.cache/yay/vapoursynth-git/vapoursynth-git-*.pkg.tar.zst
    yes | yay -S --rebuildtree vapoursynth-git

    rm ~/bin/vpy-plugins/vapoursynth-git-*.pkg.tar.zst
    cp ~/.cache/yay/vapoursynth-git/*.pkg.tar.zst ~/bin/vpy-plugins/
}

# system-build
vpy-build
# test-build
# x265-build stable
# x265-build master
# x265-build-mod Yuuki
