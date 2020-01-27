#!/bin/bash
usage(){
echo -e "\033[31;1mUsage:\033[32;1m $0\033[33;1m [name]\033[34;1m [C/C++/Android/Java/Python2/Python3/Vala/Kmod]\033[35;1m (package name)\033[;0m"
}
if [ "$1" != "" ]
then
  export name="$1" 
else
  echo "ARG-1:name not defined!"
  usage
  exit 1
fi

if [ "$2" != "" ]
then
  export type="$2"
else
  echo "ARG-2:type not defined!"
  usage
  exit 1
fi
echo $0 $*
if [ "$type" == "C" ]
then
  mkdir -p $name/{src,res}
  #building makefile
  echo -e "CC=gcc" > $name/Makefile
  echo -e "CFLAG=-Isrc -O3 -o" >> $name/Makefile
  echo -e "OUT=build/$name" >> $name/Makefile
  echo -e "NAME=\"$name\"" >> $name/Makefile
  echo >> $name/Makefile
  echo -e "all: clean build" >> $name/Makefile
  echo -e "build:" >> $name/Makefile
  echo -e "\tmkdir -p build" >> $name/Makefile
  echo -e "\t\$(CC) \$(CFLAG) \$(OUT) src/main.c" >> $name/Makefile
  echo -e "clean:" >> $name/Makefile
  echo -e "\trm -rf build/" >> $name/Makefile
  echo -e "install:" >> $name/Makefile
  echo -e "\tcp -prfv res/* \$(TARGET)/" >> $name/Makefile
  echo -e "\tinstall \$(OUT) \$(TARGET)/usr/bin/\$(NAME)" >> $name/Makefile
  #building main.c
  echo -e "#include <stdio.h>" > $name/src/main.c
  echo -e "" >> $name/src/main.c
  echo -e "int main(int argc,char* argv[]){" >> $name/src/main.c
  echo -e "\tprintf(\"Hello World!\\n\");" >> $name/src/main.c
  echo -e "\treturn 0;" >> $name/src/main.c
  echo -e "}" >> $name/src/main.c
elif [ "$type" == "C++" ]
then
  mkdir -p $name/{src,res}
  #building makefile
  echo -e "CC=g++" > $name/Makefile
  echo -e "CFLAG=-Isrc -O3 -o" >> $name/Makefile
  echo -e "OUT=build/$name" >> $name/Makefile
  echo -e "NAME=\"$name\"" >> $name/Makefile
  echo >> $name/Makefile
  echo -e "all: clean build" >> $name/Makefile
  echo -e "build:" >> $name/Makefile
  echo -e "\tmkdir -p build" >> $name/Makefile
  echo -e "\t\$(CC) \$(CFLAG) \$(OUT) src/main.cpp" >> $name/Makefile
  echo -e "clean:" >> $name/Makefile
  echo -e "\trm -rf build/" >> $name/Makefile
  echo -e "install:" >> $name/Makefile
  echo -e "\tcp -prfv res/* \$(TARGET)/" >> $name/Makefile
  echo -e "\tinstall \$(OUT) \$(TARGET)/usr/bin/\$(NAME)" >> $name/Makefile
  #building main.cpp
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
    usage
    exit 1
  fi
  mkdir -p $name/{res,src,assets}
  #building manifest
  echo -e "<?xml version=\"1.0\" encoding=\"utf-8\"?>" > $name/AndroidManifest.xml
  echo -e "<manifest xmlns:android=\"http://schemas.android.com/apk/res/android\"" >> $name/AndroidManifest.xml
  echo -e "\tpackage=\"$package\"" >> $name/AndroidManifest.xml
  echo -e "\tandroid:versionCode=\"1\"" >> $name/AndroidManifest.xml
  echo -e "\tandroid:versionName=\"1.0\" >" >> $name/AndroidManifest.xml
  echo -e "" >> $name/AndroidManifest.xml
  echo -e "\t<uses-sdk android:minSdkVersion=\"8\" " >> $name/AndroidManifest.xml
  echo -e "\t\tandroid:targetSdkVersion=\"29\" />" >> $name/AndroidManifest.xml
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
  echo -e "SDK=\$(HOME)/Android/Sdk">> $name/Makefile
  echo -e "TARGET=29">> $name/Makefile
  echo -e "TOOL=29.0.2">> $name/Makefile
  echo -e "JAVADIR= ">> $name/Makefile
  echo -e "BUILDTOOLS=\$(SDK)/build-tools/\$(TOOL)">> $name/Makefile
  echo -e "AJAR=\$(SDK)/platforms/android-\$(TARGET)/android.jar">> $name/Makefile
  echo -e "ADX=\$(BUILDTOOLS)/dx">> $name/Makefile
  echo -e "AAPT=\$(BUILDTOOLS)/aapt">> $name/Makefile
  echo -e "JAVAC=\$(JAVADIR)javac">> $name/Makefile
  echo -e "KOTLINC=\$(SDK)/plugins/Kotlin/kotlinc/bin/kotlinc">> $name/Makefile
  echo -e "JARSIGNER=\$(JAVADIR)jarsigner">> $name/Makefile
  echo -e "APKSIGNER=\$(BUILDTOOLS)/apksigner">> $name/Makefile
  echo -e "ZIPALIGN=\$(BUILDTOOLS)/zipalign">> $name/Makefile
  echo -e "KEYTOOL=\$(JAVADIR)keytool">> $name/Makefile
  echo -e "ADB=\$(SDK)/platform-tools/adb">> $name/Makefile
  echo -e "FAIDL=\$(SDK)/platforms/android-\$(TARGET)/framework.aidl">> $name/Makefile
  echo -e "AIDL=\$(BUILDTOOLS)/aidl">> $name/Makefile
  echo -e "space := \$(aa) \$(aa)">> $name/Makefile
  echo -e "CLASSPATH=\$(AJAR):\$(subst \$(space),:,\$(shell find include/ -name \"*.jar\"))">> $name/Makefile
  echo -e "PKGNAME=$package">> $name/Makefile
  echo -e "">> $name/Makefile
  echo -e "SRC=src/">> $name/Makefile
  echo -e "NAME=\$(shell basename \$(CURDIR))">> $name/Makefile
  echo -e "">> $name/Makefile
  echo -e "KEYFILE=key.jks">> $name/Makefile
  echo -e "KEYALIAS=Alias">> $name/Makefile
  echo -e "STOREPASS=123456">> $name/Makefile
  echo -e "KEYPASS=123456">> $name/Makefile
  echo -e "# JAVAC_DEBUG_FLAGS = \"-Xlint:unchecked -Xlint:deprecation\"">> $name/Makefile
  echo -e "JAVAC_DEBUG_FLAGS = ">> $name/Makefile
  echo -e "">> $name/Makefile
  echo -e "all: clear mkdirs build rmdirs zipalign jarsign install">> $name/Makefile
  echo -e "build:">> $name/Makefile
  echo -e "	\$(AAPT) package -v -f -I \$(AJAR) -M \"AndroidManifest.xml\" -A \"assets\" -S \"res\" -m -J \"gen\" -F \"bin/resources.ap_\"">> $name/Makefile
  echo -e "	\$(JAVAC) -classpath \$(CLASSPATH) -source 8 -g:none -nowarn -sourcepath \$(SRC) -sourcepath bin/aidl/ -sourcepath gen -d bin \$(JAVAC_DEBUG_FLAGS) \`find gen -name \"*.java\"\` \`find bin/aidl/ -name \"*.java\"\` \`find \$(SRC) -name \"*.java\"\`">> $name/Makefile
  echo -e "	\$(ADX) --dex --output=bin/classes.dex bin">> $name/Makefile
  echo -e "	mv bin/resources.ap_ bin/\$(NAME).ap_">> $name/Makefile
  echo -e "	cd bin ; \$(AAPT) add \$(NAME).ap_ classes.dex">> $name/Makefile
  echo -e "abuild:">> $name/Makefile
  echo -e "	\$(AIDL) -Iaidl -I\$(SRC) -p\$(FAIDL) -obin/aidl/ \`find aidl -name \"*.aidl\"\` \`find \$(SRC) -name \"*.aidl\"\`">> $name/Makefile
  echo -e "zipalign:">> $name/Makefile
  echo -e "	\$(ZIPALIGN) -v -p 4 bin/\$(NAME).ap_ bin/\$(NAME)-aligned.ap_">> $name/Makefile
  echo -e "	mv bin/\$(NAME)-aligned.ap_ bin/\$(NAME).ap_">> $name/Makefile
  echo -e "optimize:">> $name/Makefile
  echo -e "	optipng -o7 \`find res -name \"*.png\"\`">> $name/Makefile
  echo -e "sign:">> $name/Makefile
  echo -e "	\$(APKSIGNER) sign --ks \$(KEYFILE) --ks-key-alias \$(KEYALIAS) --ks-pass pass:\$(STOREPASS) --key-pass pass:\$(KEYPASS) --out bin/\$(NAME).apk bin/\$(NAME).ap_">> $name/Makefile
  echo -e "	#rm -f bin/\$(NAME).ap_">> $name/Makefile
  echo -e "jarsign:">> $name/Makefile
  echo -e "	\$(JARSIGNER) -keystore \$(KEYFILE) -storepass \$(STOREPASS) -keypass \$(KEYPASS) -signedjar bin/\$(NAME).apk bin/\$(NAME).ap_ \$(KEYALIAS)">> $name/Makefile
  echo -e "	#rm -f bin/\$(NAME).ap_">> $name/Makefile
  echo -e "generate:">> $name/Makefile
  echo -e "	rm -f \$(KEYFILE)">> $name/Makefile
  echo -e "	\$(KEYTOOL) -genkey -noprompt -keyalg RSA -alias \$(KEYALIAS) -dname \"CN=Hostname, OU=OrganizationalUnit, O=Organization, L=City, S=State, C=Country\" -keystore \$(KEYFILE) -storepass \$(STOREPASS) -keypass \$(KEYPASS) -validity 3650">> $name/Makefile
  echo -e "clear:">> $name/Makefile
  echo -e "	rm -rf bin gen">> $name/Makefile
  echo -e "install:">> $name/Makefile
  echo -e "	\$(ADB) install -r bin/\$(NAME).apk">> $name/Makefile
  echo -e "	\$(ADB) shell monkey -p \$(PKGNAME) 1">> $name/Makefile
  echo -e "mkdirs:">> $name/Makefile
  echo -e "	mkdir aidl 2> /dev/null || true">> $name/Makefile
  echo -e "	mkdir bin 2> /dev/null || true">> $name/Makefile
  echo -e "	mkdir gen 2> /dev/null || true">> $name/Makefile
  echo -e "	mkdir assets 2> /dev/null || true">> $name/Makefile
  echo -e "	mkdir res 2> /dev/null || true">> $name/Makefile
  echo -e "	mkdir bin/aidl 2> /dev/null || true">> $name/Makefile
  echo -e "	mkdir include 2> /dev/null || true">> $name/Makefile
  echo -e "rmdirs:">> $name/Makefile
  echo -e "	rmdir \`find\` 2> /dev/null || true">> $name/Makefile
  echo -e "push:">> $name/Makefile
  echo -e "	\$(ADB) push bin/\$(NAME).apk /sdcard">> $name/Makefile
  echo -e "">> $name/Makefile
elif [ "$type" == "Java" ]
then
  mkdir -p $name/src
  mkdir -p $name/res
  #building makefile
  echo -e "JC=\$(JAVA_HOME)/bin/javac" > $name/Makefile
  echo -e "JAR=\$(JAVA_HOME)/bin/jar" >> $name/Makefile
  echo -e "JFLAG= -encoding UTF-8" >> $name/Makefile
  echo -e "SRC=src/" >> $name/Makefile
  echo -e "NAME=$name" >> $name/Makefile
  echo -e "" >> $name/Makefile
  echo -e "all: clean build" >> $name/Makefile
  echo -e "build:" >> $name/Makefile
  echo -e "	mkdir -p build" >> $name/Makefile
  echo -e "	\$(JC) \$(JFLAG) \$(shell find \$(SRC) -name \"*.java\")" >> $name/Makefile
  echo -e "	mv src/*.class build/" >> $name/Makefile
  echo -e "	cp -prfv res/* build/ 2>/dev/null || true" >> $name/Makefile
  echo -e "	cd build ; jar cfe ../\$(NAME).jar Main \`find \`" >> $name/Makefile
  echo -e "clean:" >> $name/Makefile
  echo -e "	rm -rf build/" >> $name/Makefile
  #building main.java
  echo -e "public class Main{" > $name/src/Main.java
  echo -e "\tpublic static void main(String[] args){" >> $name/src/Main.java
  echo -e "\t\tSystem.out.println(\"Hello World\");" >> $name/src/Main.java
  echo -e "\t}" >> $name/src/Main.java
  echo -e "}" >> $name/src/Main.java
elif [ "$type" == "Python2" ]
then
  mkdir -p $name/src
  #building makefile
  echo -e "PC=python2" > $name/Makefile
  echo -e "PFLAG=-m py_compile" >> $name/Makefile
  echo -e "SRC=src/" >> $name/Makefile
  echo -e "NAME=\"$name\"" >> $name/Makefile
  echo >> $name/Makefile
  echo -e "all: clean build" >> $name/Makefile
  echo -e "build:" >> $name/Makefile
  echo -e "\tmkdir -p build" >> $name/Makefile
  echo -e "\t\$(PC) \$(PFLAG) \$(shell find \$(SRC) -name \"*.py\")" >> $name/Makefile
  echo -e "\tmv src/*.pyc build/" >> $name/Makefile
  echo -e "\tcp -prfv res/* build/ 2>/dev/null || true" >> $name/Makefile
  echo -e "\tchmod 755 build/*" >> $name/Makefile
  echo -e "clean:" >> $name/Makefile
  echo -e "\trm -rf build/" >> $name/Makefile
  #buinding main.py
  echo -e "class Main:" > $name/src/Main.py
  echo -e "\tdef write(self):" >> $name/src/Main.py
  echo -e "\t\tprint \"Hello World\"" >> $name/src/Main.py
  echo -e "Main().write()" >> $name/src/Main.py
elif [ "$type" == "Python3" ]
then
  mkdir -p $name/src
  #building makefile
  echo -e "PC=python3" >> $name/Makefile
  echo -e "PFLAG=-m compileall" >> $name/Makefile
  echo -e "SRC=src/" >> $name/Makefile
  echo -e "NAME=$name" >> $name/Makefile
  echo -e "" >> $name/Makefile
  echo -e "all: clean build" >> $name/Makefile
  echo -e "build:" >> $name/Makefile
  echo -e "	mkdir -p build" >> $name/Makefile
  echo -e "	\$(PC) \$(PFLAG) \$(SRC)" >> $name/Makefile
  echo -e "	mv \$(SRC)/__pycache__/*.pyc build/" >> $name/Makefile
  echo -e "	rmdir \$(SRC)/__pycache__/" >> $name/Makefile
  echo -e "	cp -prfv res/* build/ 2>/dev/null || true" >> $name/Makefile
  echo -e "	chmod 755 build/*" >> $name/Makefile
  echo -e "clean:" >> $name/Makefile
  echo -e "	rm -rf build/" >> $name/Makefile
  #buinding main.py
  echo -e "class Main:" > $name/src/Main.py
  echo -e "\tdef write(self):" >> $name/src/Main.py
  echo -e "\t\tprint(\"Hello World\")" >> $name/src/Main.py
  echo -e "Main().write()" >> $name/src/Main.py
elif [ "$type" == "Vala" ]
then
  mkdir -p $name/{src,res}
  #building makefile
  echo -e "CC=valac" > $name/Makefile
  echo -e "CFLAG= -o" >> $name/Makefile
  echo -e "OUT=build/$name" >> $name/Makefile
  echo -e "NAME=\"$name\"" >> $name/Makefile
  echo >> $name/Makefile
  echo -e "all: clean build" >> $name/Makefile
  echo -e "build:" >> $name/Makefile
  echo -e "\tmkdir -p build" >> $name/Makefile
  echo -e "\t\$(CC) \$(CFLAG) \$(OUT) src/main.vala" >> $name/Makefile
  echo -e "clean:" >> $name/Makefile
  echo -e "\trm -rf build/" >> $name/Makefile
  echo -e "install:" >> $name/Makefile
  echo -e "\tcp -prfv res/* \$(TARGET)/" >> $name/Makefile
  echo -e "\tinstall \$(OUT) \$(TARGET)/usr/bin/\$(NAME)" >> $name/Makefile
  #building main.c
  echo -e "static void main (string[] args){" > $name/src/main.vala
  echo -e "\tstdout.printf (\"Hello World!\\n\");" >> $name/src/main.vala
  echo -e "}" >> $name/src/main.vala
elif [ "$type" == "Kmod" ]
then
	#building makefile
	mkdir -p $name
	echo -e "obj-m += $name.o" > $name/Makefile
	echo -e "" >> $name/Makefile
	echo -e "all:" >> $name/Makefile
	echo -e "\tmake -C /lib/modules/\$(shell uname -r)/build M=\$(PWD) modules" >> $name/Makefile
	echo -e "" >> $name/Makefile
	echo -e "clean:" >> $name/Makefile
	echo -e	"\techo -e make -C /lib/modules/\$(shell uname -r)/build M=\$(PWD) clean" >> $name/Makefile
	#building module.c"
	echo -e "#include <linux/module.h>" >$name/$name.c
	echo -e "#include <linux/kernel.h>" >>$name/$name.c
	echo -e "#include <linux/init.h>" >>$name/$name.c
	echo -e "" >>$name/$name.c
	echo -e "MODULE_LICENSE(\"GPL\");" >>$name/$name.c
	echo -e "MODULE_AUTHOR(\"Your Name\");" >>$name/$name.c
	echo -e "MODULE_DESCRIPTION(\"A Simple Kernel module\");" >>$name/$name.c
	echo -e "" >>$name/$name.c
	echo -e "static int __init "$name"_init(void){" >>$name/$name.c
    echo -e "\tprintk(KERN_INFO \"Hello world!\\\n\");" >>$name/$name.c
    echo -e "\treturn 0;" >>$name/$name.c
	echo -e "}" >>$name/$name.c
	echo -e "" >>$name/$name.c
	echo -e "static void __exit "$name"_cleanup(void){" >>$name/$name.c
    echo -e "\tprintk(KERN_INFO \"Cleaning up module.\\\n\");" >>$name/$name.c
	echo -e "}" >>$name/$name.c
	echo -e "" >>$name/$name.c
	echo -e "module_init("$name"_init);" >>$name/$name.c
	echo -e "module_exit("$name"_cleanup);" >>$name/$name.c
else
echo "Type not supported yet."
fi

