JC=$(JAVA_HOME)/bin/javac
JAR=$(JAVA_HOME)/bin/jar
JFLAG= -encoding UTF-8
SRC=src/
NAME=Java

all: clean build
build:
	mkdir -p build
	$(JC) $(JFLAG) $(shell find $(SRC) -name "*.java")
	mv src/*.class build/
	cp -prfv res/* build/ 2>/dev/null || true
	cd build ; jar cfe ../$(NAME).jar Main `find `
clean:
	rm -rf build/
