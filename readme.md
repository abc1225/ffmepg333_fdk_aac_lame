## ReadMe ##

### 1. ffmpeg x264 aac源码来自于项目： ### 

	https://github.com/CainKernel/FFmpegAndroid

	FFmpegAndroid
	本项目为简单的将FFmpeg + x264 + fdk-aac 编译成单个 libffmpeg.so 的脚本

	ffmpeg.tar.gz: ffmpeg-3.3.3的源码 x264.tar.gz: libx264 源码 fdk-aac.tar.gz: fdk-aac-0.1.5源码

	如果要更新源码，直接将压缩包替换即可

	本项目仅仅是一个简单的编译脚本，如果想要做成可裁剪的自动化编译工具，可参考ijkplayer等开源库的实现方案。

### 2. Build Method ##

	>  ./build_lame.sh  armeabi-v7a
	>  ./build_fdkaac015.sh	 armeabi-v7a
	>  ./build_x264.sh	 armeabi-v7a
	>  ./build_ffmpeg_with_x264_fdkaac_small.sh armeabi-v7a

### 3. SO File ###

	./libs/ffmpeg333-x264-fdkaac/armeabi-v7a
	./libs/ffmpeg333-x264-fdkaac/armeabi-v7a/libffmpeg.so
