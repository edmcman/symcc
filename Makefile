all: jpeg-symcc jpeg-afl

.PHONY: jpeg-symcc jpeg-afl

jpeg-symcc:
	mkdir jpeg-symcc; cd jpeg-symcc; CC=symcc SYMCC_NO_SYMBOLIC_INPUT=1 cmake ~/libjpeg-turbo-2.0.3; make -j8
jpeg-afl:
	mkdir jpeg-afl; cd jpeg-afl; CC=/afl/afl-clang cmake ~/libjpeg-turbo-2.0.3; make -j8
