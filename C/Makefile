CC=gcc
CFLAG=-Isrc -O3 -o
OUT=build/C

all: clean build
build:
	mkdir -p build
	$(CC) $(CFLAG) $(OUT) src/main.c
clean:
	rm -rf build/
