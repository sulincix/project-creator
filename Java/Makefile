JC=$(JAVA_HOME)/bin/javac
JFLAG= -encoding UTF-8
SRC=src/
NAME="Java"

all: clean build
build:
	mkdir -p build
	$(JC) $(JFLAG) $(shell find $(SRC) -name "*.java")
	mv src/*.class build/
	echo "#!/bin/sh" > build/run.sh
	echo "java Main" >> build/run.sh
	chmod 755 build/run.sh
clean:
	rm -rf build/
