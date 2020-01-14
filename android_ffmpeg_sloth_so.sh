#!/bin/bash

ARCH=$1

source config.sh $ARCH
NOW_DIR=$(cd `dirname $0`; pwd)
LIBS_DIR=$NOW_DIR/libs
echo "LIBS_DIR="$LIBS_DIR

cd ffmpeg-3.3.3

PLATFORM=$ANDROID_NDK_ROOT/platforms/$AOSP_API/$AOSP_ARCH
TOOLCHAIN=$ANDROID_NDK_ROOT/toolchains/$TOOLCHAIN_BASE-$AOSP_TOOLCHAIN_SUFFIX/prebuilt/linux-x86_64

PREFIX=$LIBS_DIR/ffmpeg333-x264-fdkaac/$AOSP_ABI

FDK_INCLUDE=$LIBS_DIR/libfdk-aac/$AOSP_ABI/include
FDK_LIB=$LIBS_DIR/libfdk-aac/$AOSP_ABI/lib
X264_INCLUDE=$LIBS_DIR/libx264/$AOSP_ABI/include
X264_LIB=$LIBS_DIR/libx264/$AOSP_ABI/lib

# 这段解释见后文  #libavresample/libavresample.a \  #libavdevice/libavdevice.a \ libpostproc/libpostproc.a \
$TOOLCHAIN/bin/$TOOLNAME_BASE-ld -rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -L$PREFIX/lib -soname librecorder.so -shared -nostdlib -Bsymbolic --whole-archive --no-undefined -o $PREFIX/librecorder.so \
    $FDK_LIB/libfdk-aac.a \
    $X264_LIB/libx264.a \
    libavcodec/libavcodec.a \
    libavfilter/libavfilter.a \
    libswresample/libswresample.a \
    libavformat/libavformat.a \
    libavutil/libavutil.a \
    libswscale/libswscale.a \
    -lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker $TOOLCHAIN/lib/gcc/$TOOLNAME_BASE/4.9.x/libgcc.a


cd ..
