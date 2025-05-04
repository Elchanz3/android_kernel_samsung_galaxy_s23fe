#!/bin/bash

#main variables
export ARCH=arm64
export RDIR="$(pwd)"
export KBUILD_BUILD_USER="@chanz22"
export TARGET_SOC=s5e9925
export LLVM=1 LLVM_IAS=1
export PLATFORM_VERSION=12
export ANDROID_MAJOR_VERSION=s

export PATH=${RDIR}/toolchains/clang-r416183d/bin:$PATH
export BUILD_CROSS_COMPILE="${RDIR}/toolchains/aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-"

if [ ! -d "${RDIR}/build" ]; then
    mkdir -p "${RDIR}/build"
else
    rm -rf "${RDIR}/build" && mkdir -p "${RDIR}/build"
fi

export ARGS="
-j$(nproc) \
ARCH=arm64 \
CROSS_COMPILE=${BUILD_CROSS_COMPILE} \
CC=clang
PLATFORM_VERSION=12 \
ANDROID_MAJOR_VERSION=s \
LLVM=1 \
LLVM_IAS=1 \
TARGET_SOC=s5e9925 \
"

build_kernel(){
    cd "${RDIR}"
    make ${ARGS} s5e9925-r11sxxx_defconfig
    make ${ARGS} menuconfig
    make ${ARGS}|| exit 1
    cp ${RDIR}/arch/arm64/boot/Image* ${RDIR}/build
}

build_boot() {    
    rm -f ${RDIR}/AIK-Linux/split_img/boot.img-kernel ${RDIR}/AIK-Linux/boot.img
    cp "${RDIR}/build/Image" ${RDIR}/AIK-Linux/split_img/boot.img-kernel
    mkdir -p ${RDIR}/AIK-Linux/ramdisk/{debug_ramdisk,dev,metadata,mnt,proc,second_stage_resources,sys}
    cd ${RDIR}/AIK-Linux && ./repackimg.sh --nosudo && mv image-new.img ${RDIR}/build/boot.img
}

build_tar(){
    cd ${RDIR}/build
    tar -cvf "KernelSU-Next-SM-S711B-${BUILD_KERNEL_VERSION}.tar" boot.img && rm boot.img
    echo -e "\n[i] Build Finished..!\n" && cd ${RDIR}
}

build_kernel
build_boot
build_tar
