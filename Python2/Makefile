PC=python
PFLAG=-m py_compile
SRC=src/
NAME="Python2"

all: clean build
build:
	mkdir -p build
	$(PC) $(PFLAG) $(shell find $(SRC) -name "*.py")
	mv src/*.pyc build/
	cp -prfv res/* build/ 2>/dev/null || true
	chmod 755 build/*
clean:
	rm -rf build/
