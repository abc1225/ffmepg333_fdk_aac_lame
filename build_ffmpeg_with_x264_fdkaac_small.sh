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
LAME_INCLUDE=$LIBS_DIR/lame/$AOSP_ABI/include
LAME_LIB=$LIBS_DIR/lame/$AOSP_ABI/lib


./configure \
--prefix=$PREFIX \
--enable-cross-compile \
--disable-runtime-cpudetect \
--arch=$AOSP_ABI \
--target-os=android \
--cc=$TOOLCHAIN/bin/$TOOLNAME_BASE-gcc \
--cross-prefix=$TOOLCHAIN/bin/$TOOLNAME_BASE- \
--nm=$TOOLCHAIN/bin/$TOOLNAME_BASE-nm \
--sysroot=$PLATFORM \
--extra-cflags="-I$X264_INCLUDE  -I$FDK_INCLUDE -I$LAME_INCLUDE " \
--extra-ldflags="-L$FDK_LIB -L$X264_LIB  -L$LAME_LIB" \
--enable-gpl \
--enable-nonfree \
--disable-shared \
--enable-static \
--enable-small \
--enable-version3 \
--enable-pthreads \
--enable-libx264 \
--enable-asm \
--enable-neon \
--enable-yasm \
--enable-runtime-cpudetect \
--disable-network \
--disable-vda \
--disable-iconv \
--disable-encoders \
--enable-libfdk_aac \
--enable-libx264 \
--enable-libmp3lame \
--enable-encoder=h263 \
--enable-encoder=libx264 \
--enable-encoder=libfdk_aac \
--enable-encoder=libmp3lame \
--enable-encoder=aac \
--enable-decoder=aac_latm \
--enable-encoder=mpeg4 \
--enable-encoder=mjpeg \
--enable-encoder=png \
--enable-encoder=gif \
--enable-encoder=bmp \
--disable-muxers \
--enable-muxer=h264 \
--enable-muxer=flv \
--enable-muxer=gif \
--enable-muxer=mp3 \
--enable-muxer=dts \
--enable-muxer=mp4 \
--enable-muxer=mov \
--enable-muxer=mpegts \
--enable-muxer=avi \
--disable-decoders \
--enable-jni \
--enable-mediacodec \
--enable-decoder=h264_mediacodec \
--enable-hwaccel=h264_mediacodec \
--enable-decoder=aac \
--enable-decoder=aac_latm \
--enable-decoder=mp3 \
--enable-decoder=h263 \
--enable-decoder=h264 \
--enable-decoder=mpeg4 \
--enable-decoder=mjpeg \
--enable-decoder=gif \
--enable-decoder=png \
--enable-decoder=bmp \
--enable-decoder=yuv4 \
--disable-demuxers \
--enable-demuxer=image2 \
--enable-demuxer=h263 \
--enable-demuxer=h264 \
--enable-demuxer=flv \
--enable-demuxer=gif \
--enable-demuxer=aac \
--enable-demuxer=ogg \
--enable-demuxer=dts \
--enable-demuxer=mp3 \
--enable-demuxer=mov \
--enable-demuxer=m4v \
--enable-demuxer=avi \
--enable-demuxer=mpc \
--enable-demuxer=concat \
--enable-demuxer=mpegts \
--enable-demuxer=mjpeg \
--enable-demuxer=mpegvideo \
--enable-demuxer=rawvideo \
--enable-demuxer=yuv4mpegpipe \
--disable-parsers \
--enable-parser=aac \
--enable-parser=ac3 \
--enable-parser=h264 \
--enable-parser=mjpeg \
--enable-parser=png \
--enable-parser=bmp\
--enable-parser=mpegvideo \
--enable-parser=mpegaudio \
--disable-protocols \
--enable-protocol=file \
--enable-protocol=hls \
--enable-protocol=concat \
--enable-protocol=rtmp \
--enable-protocol=rtmpe \
--enable-protocol=rtmps \
--enable-protocol=rtmpt \
--enable-protocol=rtmpte \
--enable-protocol=rtmpts \
--disable-filters \
--enable-filter=aresample \
--enable-filter=asetpts \
--enable-filter=setpts \
--enable-filter=ass \
--enable-filter=scale \
--enable-filter=concat \
--enable-filter=atempo \
--enable-filter=movie \
--enable-filter=overlay \
--enable-filter=rotate \
--enable-filter=transpose \
--enable-filter=hflip \
--enable-zlib \
--disable-outdevs \
--disable-doc \
--disable-ffplay \
--disable-ffmpeg \
--disable-ffserver \
--disable-debug \
--disable-ffprobe \
--disable-postproc \
--disable-avdevice \
--disable-symver \
--disable-stripping \
--extra-cflags="$FF_EXTRA_CFLAGS  $FF_CFLAGS" \
--extra-ldflags="  "

make clean
make -j6
make install


# 这段解释见后文  #libavresample/libavresample.a \  #libavdevice/libavdevice.a \      libpostproc/libpostproc.a \
$TOOLCHAIN/bin/$TOOLNAME_BASE-ld -rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -L$PREFIX/lib -soname libffmpeg.so -shared -nostdlib -Bsymbolic --whole-archive --no-undefined -o $PREFIX/libffmpeg.so \
    $FDK_LIB/libfdk-aac.a \
    $X264_LIB/libx264.a \
    $LAME_LIB/libmp3lame.a \
    libavcodec/libavcodec.a \
    libavfilter/libavfilter.a \
    libswresample/libswresample.a \
    libavformat/libavformat.a \
    libavutil/libavutil.a \
    libswscale/libswscale.a \
    -lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker $TOOLCHAIN/lib/gcc/$TOOLNAME_BASE/4.9.x/libgcc.a


cd ..

