PC=python3
PFLAG=-m compileall
SRC=src/
NAME="Python2"

all: clean build
build:
	mkdir -p build
	$(PC) $(PFLAG) $(SRC)
	mv $(SRC)/__pycache__/*.pyc build/
	rmdir $(SRC)/__pycache__/
	cp -prfv res/* build/ 2>/dev/null || true
	chmod 755 build/*
clean:
	rm -rf build/
