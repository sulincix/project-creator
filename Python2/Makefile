PC=python
PFLAG=-m py_compile
SRC=src/
NAME="Python2"

all: clean build
build:
	mkdir -p build
	$(PC) $(PFLAG) $(shell find $(SRC) -name "*.py")
	mv src/*.pyc build/
	echo "#!/bin/sh" > build/run.sh
	echo "./Main.pyc" >> build/run.sh
	chmod 755 build/*
clean:
	rm -rf build/
