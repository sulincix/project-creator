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
elif [ "$type" == "Android" ]
then
  if [ "$3" != "" ]
  then
    export package="$3"
  else
    echo "ARG-3:package name not defined!"
    exit 1
  fi
  mkdir -p $name/{res,keystore,src,assets}
  #building manifest
  echo -e "<?xml version=\"1.0\" encoding=\"utf-8\"?>" > $name/AndroidManifest.xml
  echo -e "<manifest xmlns:android=\"http://schemas.android.com/apk/res/android\"" >> $name/AndroidManifest.xml
  echo -e "\tpackage=\"$package\"" >> $name/AndroidManifest.xml
  echo -e "\tandroid:versionCode=\"1\"" >> $name/AndroidManifest.xml
  echo -e "\tandroid:versionName=\"1.0\" >" >> $name/AndroidManifest.xml
  echo -e "" >> $name/AndroidManifest.xml
  echo -e "\t<uses-sdk android:minSdkVersion=\"8\" " >> $name/AndroidManifest.xml
  echo -e "\t\tandroid:targetSdkVersion=\"28\" />" >> $name/AndroidManifest.xml
  echo -e "" >> $name/AndroidManifest.xml
  echo -e "\t<application " >> $name/AndroidManifest.xml
  echo -e "\t\tandroid:label=\"$name\" >" >> $name/AndroidManifest.xml
  echo -e "" >> $name/AndroidManifest.xml
  echo -e "\t\t<activity android:name=\".MainActivity\"" >> $name/AndroidManifest.xml
  echo -e "\t\t\tandroid:label=\"$name\" >" >> $name/AndroidManifest.xml
  echo -e "\t\t\t<intent-filter>" >> $name/AndroidManifest.xml
  echo -e "\t\t\t\t<action android:name=\"android.intent.action.MAIN\" />" >> $name/AndroidManifest.xml
  echo -e "\t\t\t\t<category android:name=\"android.intent.category.LAUNCHER\" />" >> $name/AndroidManifest.xml
  echo -e "\t\t\t</intent-filter>" >> $name/AndroidManifest.xml
  echo -e "\t\t</activity>" >> $name/AndroidManifest.xml
  echo -e "" >> $name/AndroidManifest.xml
  echo -e "\t</application>" >> $name/AndroidManifest.xml
  echo -e "</manifest>" >> $name/AndroidManifest.xml
  #create java dir
  export jdir=src/$(echo "$package" | sed "s|\.|/|g")
  echo $jdir
  mkdir -p $name/$jdir
  #building activity
  echo -e "package $package;" > $name/$jdir/MainActivity.java
  echo -e "" >> $name/$jdir/MainActivity.java
  echo -e "import android.app.Activity;" >> $name/$jdir/MainActivity.java
  echo -e "import android.os.Bundle;" >> $name/$jdir/MainActivity.java
  echo -e "" >> $name/$jdir/MainActivity.java
  echo -e "public class MainActivity extends Activity {" >> $name/$jdir/MainActivity.java
  echo -e "" >> $name/$jdir/MainActivity.java
  echo -e "\tpublic void onCreate(Bundle instance){" >> $name/$jdir/MainActivity.java
  echo -e "\t\tsuper.onCreate(instance);" >> $name/$jdir/MainActivity.java
  echo -e "\t}" >> $name/$jdir/MainActivity.java
  echo -e "" >> $name/$jdir/MainActivity.java
  echo -e "}" >> $name/$jdir/MainActivity.java
  #building makefile
  echo -e "SDK=~/Android/Sdk" > $name/Makefile
  echo -e "TARGET=28" >> $name/Makefile
  echo -e "TOOL=28.0.3" >> $name/Makefile
  echo -e "AJAR=\$(SDK)/platforms/android-\$(TARGET)/android.jar" >> $name/Makefile
  echo -e "ADX=\$(SDK)/build-tools/\$(TOOL)/dx" >> $name/Makefile
  echo -e "AAPT=\$(SDK)/build-tools/\$(TOOL)/aapt" >> $name/Makefile
  echo -e "JAVADIR=/usr/bin" >> $name/Makefile
  echo -e "JAVAC=\$(JAVADIR)/javac" >> $name/Makefile
  echo -e "JARSIGNER=\$(JAVADIR)/jarsigner" >> $name/Makefile
  echo -e "" >> $name/Makefile
  echo -e "SRC=$jdir/" >> $name/Makefile
  echo -e "NAME=$name" >> $name/Makefile
  echo -e "" >> $name/Makefile
  echo -e "STOREPASS=123456" >> $name/Makefile
  echo -e "KEYPASS=123456" >> $name/Makefile
  echo -e "" >> $name/Makefile
  echo -e "all: clear build sign install" >> $name/Makefile
  echo -e "build:" >> $name/Makefile
  echo -e "\tmkdir bin" >> $name/Makefile
  echo -e "\t\$(AAPT) package -v -f -I \$(AJAR) -M \"AndroidManifest.xml\" -A \"assets\" -S \"res\" -m -J \"gen\" -F \"bin/resources.ap_\"" >> $name/Makefile
  echo -e "\t\$(JAVAC) -classpath \$(AJAR) -sourcepath src -sourcepath gen -d bin \$(SRC)*.java" >> $name/Makefile
  echo -e "\t\$(ADX) --dex --output=bin/classes.dex bin" >> $name/Makefile
  echo -e "\tmv bin/resources.ap_ bin/\$(NAME).ap_" >> $name/Makefile
  echo -e "\tcd bin ; \$(AAPT) add \$(NAME).ap_ classes.dex" >> $name/Makefile
  echo -e "sign:" >> $name/Makefile
  echo -e "\tjarsigner -keystore keystore/key.keystore -storepass \$(STOREPASS) -keypass \$(KEYPASS) -signedjar bin/\$(NAME).apk bin/\$(NAME).ap_ Alias" >> $name/Makefile
  echo -e "generate:" >> $name/Makefile
  echo -e "\tkeytool -genkey -noprompt -alias Alias -dname \"CN=Hostname, OU=OrganizationalUnit, O=Organization, L=City, S=State, C=Country\" -keystore keystore/key.keystore -storepass \$(STOREPASS) -keypass \$(KEYPASS) -validity 3650" >> $name/Makefile
  echo -e "clear:" >> $name/Makefile
  echo -e "\trm -rf bin" >> $name/Makefile
  echo -e "install:" >> $name/Makefile
  echo -e "\tadb install bin/\$(NAME).apk" >> $name/Makefile
else
echo "Type not supported yet."
fi

