CC=valac
CFLAG= -o
OUT=build/Vala
NAME="Vala"

all: clean build
build:
	mkdir -p build
	$(CC) $(CFLAG) $(OUT) src/main.vala
clean:
	rm -rf build/
install:
	cp -prfv res/* $(TARGET)/
	install $(OUT) $(TARGET)/usr/bin/$(NAME)
