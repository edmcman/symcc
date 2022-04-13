#all: jpeg-symcc jpeg-afl
all: img-afl sample2.afl

.PHONY: jpeg-symcc jpeg-afl jpeg-fuzz img-afl img-symcc

jpeg-symcc:
	mkdir jpeg-symcc
	cd jpeg-symcc
	CC=symcc SYMCC_NO_SYMBOLIC_INPUT=1 cmake ~/libjpeg-turbo-2.0.3
	make -j8
jpeg-afl:
	mkdir jpeg-afl
	cd jpeg-afl
	CC=/afl/afl-clang-lto cmake -DCMAKE_AR=/usr/bin/llvm-ar-11 -DCMAKE_RANLIB=/usr/bin/llvm-ranlib-11 ~/libjpeg-turbo-2.0.3
	make -j8

jpeg-fuzz:
	/afl/afl-fuzz -i input/ -o output ./jpeg-afl/djpeg-static
jpeg-sym:
	SYMCC_TARGET=./jpeg-symcc/djpeg-static AFL_CUSTOM_MUTATOR_LIBRARY=/afl/custom_mutators/symcc/symcc-mutator.so /afl/afl-fuzz -D -i input/ -o output ./jpeg-afl/djpeg-static

img-afl:
	mkdir img-afl
	tar -xvzf ImageMagick-5.3.0.tar.gz -C img-afl
	cd img-afl/ImageMagick-5.3.0 && CC=/afl/afl-clang-lto ./configure --without-magick-plus-plus && make -j4

sample2.afl sample2.symcc: sample2.cpp
	/afl/afl-clang-lto++ sample2.cpp -o sample2.afl
	sym++ sample2.cpp -o sample2.symcc
	echo SYMCC_TARGET=./sample2.symcc AFL_CUSTOM_MUTATOR_LIBRARY=/afl/custom_mutators/symcc/symcc-mutator.so /afl/afl-fuzz -i input -o output ./sample2.afl
