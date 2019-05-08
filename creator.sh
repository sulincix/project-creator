#!/bin/bash

if [ "$1" != "" ]
then
  export name="$1" 
else
  echo "ARG-1:name not defined!"
  exit 1
fi

if [ "$2" != "" ]
then
  export type="$2"
else
  echo "ARG-2:type not defined!"
  exit 1
fi
echo $0 $*
if [ "$type" == "C" ]
then
  mkdir -p $name/src
  echo -e "CC=gcc" > $name/Makefile
  echo -e "CFLAG=-Isrc -O3 -o" >> $name/Makefile
  echo -e "OUT=build/$name" >> $name/Makefile
  echo >> $name/Makefile
  echo -e "all: clean build" >> $name/Makefile
  echo -e "build:" >> $name/Makefile
  echo -e "\tmkdir -p build" >> $name/Makefile
  echo -e "\t\$(CC) \$(CFLAG) \$(OUT) src/main.c" >> $name/Makefile
  echo -e "clean:" >> $name/Makefile
  echo -e "\trm -rf build/" >> $name/Makefile
  echo -e "#include <stdio.h>" > $name/src/main.c
  echo -e "" >> $name/src/main.c
  echo -e "int main(int argc,char* argv[]){" >> $name/src/main.c
  echo -e "\tprintf(\"Hello World!\");" >> $name/src/main.c
  echo -e "\treturn 0;" >> $name/src/main.c
  echo -e "}" >> $name/src/main.c
elif [ "$type" == "C++" ]
then
mkdir -p $name/src
  echo -e "CC=g++" > $name/Makefile
  echo -e "CFLAG=-Isrc -O3 -o" >> $name/Makefile
  echo -e "OUT=build/$name" >> $name/Makefile
  echo >> $name/Makefile
  echo -e "all: clean build" >> $name/Makefile
  echo -e "build:" >> $name/Makefile
  echo -e "\tmkdir -p build" >> $name/Makefile
  echo -e "\t\$(CC) \$(CFLAG) \$(OUT) src/main.cpp" >> $name/Makefile
  echo -e "clean:" >> $name/Makefile
  echo -e "\trm -rf build/" >> $name/Makefile
  echo -e "#include <iostream>" > $name/src/main.cpp
  echo -e "" >> $name/src/main.cpp
  echo -e "int main(int argc,char* argv[]){" >> $name/src/main.cpp
  echo -e "\tstd::cout<<\"Hello World!\"<<std::endl;" >> $name/src/main.cpp
  echo -e "\treturn 0;" >> $name/src/main.cpp
  echo -e "}" >> $name/src/main.cpp
fi
