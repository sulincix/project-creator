JC=javac
JFLAG=
SRCS=src/Main.java

all: clean build
build:
	mkdir -p build
	$(JC) $(JFLAG) $(SRCS)
	mv src/*.class build/
	echo "#!/bin/sh" > build/run.sh
	echo "java Main" >> build/run.sh
	chmod 755 build/run.sh
clean:
	rm -rf build/
