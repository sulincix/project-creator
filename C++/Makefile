CC=g++
CFLAG=-Isrc -O3 -o
OUT=build/C++
NAME="C++"

all: clean build
build:
	mkdir -p build
	$(CC) $(CFLAG) $(OUT) src/main.cpp
clean:
	rm -rf build/
install:
	cp -prfv res/* $(TARGET)/
	install $(OUT) $(TARGET)/usr/bin/$(NAME)
