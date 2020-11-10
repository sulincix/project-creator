#!/bin/bash
usage(){
echo -e "\033[31;1mUsage:\033[32;1m $0\033[33;1m [name]\033[34;1m [C/C++/Android/Java/Python2/Python3/Vala/Kmod/Debian\Inary]\033[35;1m (package name)\033[;0m"
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
mkdir $name
cd $name
if [ "$type" == "C" ]
then
  mkdir -p {src,res}
  #building makefile
  echo -e "CC=gcc" > Makefile
  echo -e "CFLAG=-Isrc -O3 -o" >> Makefile
  echo -e "OUT=build/$name" >> Makefile
  echo -e "NAME=\"$name\"" >> Makefile
  echo >> Makefile
  echo -e "all: clean build" >> Makefile
  echo -e "build:" >> Makefile
  echo -e "\tmkdir -p build" >> Makefile
  echo -e "\t\$(CC) \$(CFLAG) \$(OUT) src/main.c" >> Makefile
  echo -e "clean:" >> Makefile
  echo -e "\trm -rf build/" >> Makefile
  echo -e "install:" >> Makefile
  echo -e "\tcp -prfv res/* \$(TARGET)/" >> Makefile
  echo -e "\tinstall \$(OUT) \$(TARGET)/usr/bin/\$(NAME)" >> Makefile
  #building main.c
  echo -e "#include <stdio.h>" > src/main.c
  echo -e "" >> src/main.c
  echo -e "int main(int argc,char* argv[]){" >> src/main.c
  echo -e "\tprintf(\"Hello World!\\n\");" >> src/main.c
  echo -e "\treturn 0;" >> src/main.c
  echo -e "}" >> src/main.c
elif [ "$type" == "C++" ]
then
  mkdir -p {src,res}
  #building makefile
  echo -e "CC=g++" > Makefile
  echo -e "CFLAG=-Isrc -O3 -o" >> Makefile
  echo -e "OUT=build/$name" >> Makefile
  echo -e "NAME=\"$name\"" >> Makefile
  echo >> Makefile
  echo -e "all: clean build" >> Makefile
  echo -e "build:" >> Makefile
  echo -e "\tmkdir -p build" >> Makefile
  echo -e "\t\$(CC) \$(CFLAG) \$(OUT) src/main.cpp" >> Makefile
  echo -e "clean:" >> Makefile
  echo -e "\trm -rf build/" >> Makefile
  echo -e "install:" >> Makefile
  echo -e "\tcp -prfv res/* \$(TARGET)/" >> Makefile
  echo -e "\tinstall \$(OUT) \$(TARGET)/usr/bin/\$(NAME)" >> Makefile
  #building main.cpp
  echo -e "#include <iostream>" > src/main.cpp
  echo -e "" >> src/main.cpp
  echo -e "int main(int argc,char* argv[]){" >> src/main.cpp
  echo -e "\tstd::cout<<\"Hello World!\"<<std::endl;" >> src/main.cpp
  echo -e "\treturn 0;" >> src/main.cpp
  echo -e "}" >> src/main.cpp
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
  mkdir -p {res,src,assets}
  #building manifest
  echo -e "<?xml version=\"1.0\" encoding=\"utf-8\"?>" > AndroidManifest.xml
  echo -e "<manifest xmlns:android=\"http://schemas.android.com/apk/res/android\"" >> AndroidManifest.xml
  echo -e "\tpackage=\"$package\"" >> AndroidManifest.xml
  echo -e "\tandroid:versionCode=\"1\"" >> AndroidManifest.xml
  echo -e "\tandroid:versionName=\"1.0\" >" >> AndroidManifest.xml
  echo -e "" >> AndroidManifest.xml
  echo -e "\t<uses-sdk android:minSdkVersion=\"8\" " >> AndroidManifest.xml
  echo -e "\t\tandroid:targetSdkVersion=\"29\" />" >> AndroidManifest.xml
  echo -e "" >> AndroidManifest.xml
  echo -e "\t<application " >> AndroidManifest.xml
  echo -e "\t\tandroid:label=\"$name\" >" >> AndroidManifest.xml
  echo -e "" >> AndroidManifest.xml
  echo -e "\t\t<activity android:name=\".MainActivity\"" >> AndroidManifest.xml
  echo -e "\t\t\tandroid:label=\"$name\" >" >> AndroidManifest.xml
  echo -e "\t\t\t<intent-filter>" >> AndroidManifest.xml
  echo -e "\t\t\t\t<action android:name=\"android.intent.action.MAIN\" />" >> AndroidManifest.xml
  echo -e "\t\t\t\t<category android:name=\"android.intent.category.LAUNCHER\" />" >> AndroidManifest.xml
  echo -e "\t\t\t</intent-filter>" >> AndroidManifest.xml
  echo -e "\t\t</activity>" >> AndroidManifest.xml
  echo -e "" >> AndroidManifest.xml
  echo -e "\t</application>" >> AndroidManifest.xml
  echo -e "</manifest>" >> AndroidManifest.xml
  #create java dir
  export jdir=src/$(echo "$package" | sed "s|\.|/|g")
  echo $jdir
  mkdir -p $jdir
  #building activity
  echo -e "package $package;" > $jdir/MainActivity.java
  echo -e "" >> $jdir/MainActivity.java
  echo -e "import android.app.Activity;" >> $jdir/MainActivity.java
  echo -e "import android.os.Bundle;" >> $jdir/MainActivity.java
  echo -e "" >> $jdir/MainActivity.java
  echo -e "public class MainActivity extends Activity {" >> $jdir/MainActivity.java
  echo -e "" >> $jdir/MainActivity.java
  echo -e "\tpublic void onCreate(Bundle instance){" >> $jdir/MainActivity.java
  echo -e "\t\tsuper.onCreate(instance);" >> $jdir/MainActivity.java
  echo -e "\t}" >> $jdir/MainActivity.java
  echo -e "" >> $jdir/MainActivity.java
  echo -e "}" >> $jdir/MainActivity.java
  #building makefile
  echo -e "SDK=\$(HOME)/Android/Sdk">> Makefile
  echo -e "TARGET=29">> Makefile
  echo -e "TOOL=29.0.2">> Makefile
  echo -e "JAVADIR= ">> Makefile
  echo -e "BUILDTOOLS=\$(SDK)/build-tools/\$(TOOL)">> Makefile
  echo -e "AJAR=\$(SDK)/platforms/android-\$(TARGET)/android.jar">> Makefile
  echo -e "ADX=\$(BUILDTOOLS)/dx">> Makefile
  echo -e "AAPT=\$(BUILDTOOLS)/aapt">> Makefile
  echo -e "JAVAC=\$(JAVADIR)javac">> Makefile
  echo -e "KOTLINC=\$(SDK)/plugins/Kotlin/kotlinc/bin/kotlinc">> Makefile
  echo -e "JARSIGNER=\$(JAVADIR)jarsigner">> Makefile
  echo -e "APKSIGNER=\$(BUILDTOOLS)/apksigner">> Makefile
  echo -e "ZIPALIGN=\$(BUILDTOOLS)/zipalign">> Makefile
  echo -e "KEYTOOL=\$(JAVADIR)keytool">> Makefile
  echo -e "ADB=\$(SDK)/platform-tools/adb">> Makefile
  echo -e "FAIDL=\$(SDK)/platforms/android-\$(TARGET)/framework.aidl">> Makefile
  echo -e "AIDL=\$(BUILDTOOLS)/aidl">> Makefile
  echo -e "space := \$(aa) \$(aa)">> Makefile
  echo -e "CLASSPATH=\$(AJAR):\$(subst \$(space),:,\$(shell find include/ -name \"*.jar\"))">> Makefile
  echo -e "PKGNAME=$package">> Makefile
  echo -e "">> Makefile
  echo -e "SRC=src/">> Makefile
  echo -e "NAME=\$(shell basename \$(CURDIR))">> Makefile
  echo -e "">> Makefile
  echo -e "KEYFILE=key.jks">> Makefile
  echo -e "KEYALIAS=Alias">> Makefile
  echo -e "STOREPASS=123456">> Makefile
  echo -e "KEYPASS=123456">> Makefile
  echo -e "# JAVAC_DEBUG_FLAGS = \"-Xlint:unchecked -Xlint:deprecation\"">> Makefile
  echo -e "JAVAC_DEBUG_FLAGS = ">> Makefile
  echo -e "">> Makefile
  echo -e "all: clear mkdirs build rmdirs zipalign jarsign install">> Makefile
  echo -e "build:">> Makefile
  echo -e "	\$(AAPT) package -v -f -I \$(AJAR) -M \"AndroidManifest.xml\" -A \"assets\" -S \"res\" -m -J \"gen\" -F \"bin/resources.ap_\"">> Makefile
  echo -e "	\$(JAVAC) -classpath \$(CLASSPATH) -source 8 -g:none -nowarn -sourcepath \$(SRC) -sourcepath bin/aidl/ -sourcepath gen -d bin \$(JAVAC_DEBUG_FLAGS) \`find gen -name \"*.java\"\` \`find bin/aidl/ -name \"*.java\"\` \`find \$(SRC) -name \"*.java\"\`">> Makefile
  echo -e "	\$(ADX) --dex --output=bin/classes.dex bin">> Makefile
  echo -e "	mv bin/resources.ap_ bin/\$(NAME).ap_">> Makefile
  echo -e "	cd bin ; \$(AAPT) add \$(NAME).ap_ classes.dex">> Makefile
  echo -e "abuild:">> Makefile
  echo -e "	\$(AIDL) -Iaidl -I\$(SRC) -p\$(FAIDL) -obin/aidl/ \`find aidl -name \"*.aidl\"\` \`find \$(SRC) -name \"*.aidl\"\`">> Makefile
  echo -e "zipalign:">> Makefile
  echo -e "	\$(ZIPALIGN) -v -p 4 bin/\$(NAME).ap_ bin/\$(NAME)-aligned.ap_">> Makefile
  echo -e "	mv bin/\$(NAME)-aligned.ap_ bin/\$(NAME).ap_">> Makefile
  echo -e "optimize:">> Makefile
  echo -e "	optipng -o7 \`find res -name \"*.png\"\`">> Makefile
  echo -e "sign:">> Makefile
  echo -e "	\$(APKSIGNER) sign --ks \$(KEYFILE) --ks-key-alias \$(KEYALIAS) --ks-pass pass:\$(STOREPASS) --key-pass pass:\$(KEYPASS) --out bin/\$(NAME).apk bin/\$(NAME).ap_">> Makefile
  echo -e "	#rm -f bin/\$(NAME).ap_">> Makefile
  echo -e "jarsign:">> Makefile
  echo -e "	\$(JARSIGNER) -keystore \$(KEYFILE) -storepass \$(STOREPASS) -keypass \$(KEYPASS) -signedjar bin/\$(NAME).apk bin/\$(NAME).ap_ \$(KEYALIAS)">> Makefile
  echo -e "	#rm -f bin/\$(NAME).ap_">> Makefile
  echo -e "generate:">> Makefile
  echo -e "	rm -f \$(KEYFILE)">> Makefile
  echo -e "	\$(KEYTOOL) -genkey -noprompt -keyalg RSA -alias \$(KEYALIAS) -dname \"CN=Hostname, OU=OrganizationalUnit, O=Organization, L=City, S=State, C=Country\" -keystore \$(KEYFILE) -storepass \$(STOREPASS) -keypass \$(KEYPASS) -validity 3650">> Makefile
  echo -e "clear:">> Makefile
  echo -e "	rm -rf bin gen">> Makefile
  echo -e "install:">> Makefile
  echo -e "	\$(ADB) install -r bin/\$(NAME).apk">> Makefile
  echo -e "	\$(ADB) shell monkey -p \$(PKGNAME) 1">> Makefile
  echo -e "mkdirs:">> Makefile
  echo -e "	mkdir aidl 2> /dev/null || true">> Makefile
  echo -e "	mkdir bin 2> /dev/null || true">> Makefile
  echo -e "	mkdir gen 2> /dev/null || true">> Makefile
  echo -e "	mkdir assets 2> /dev/null || true">> Makefile
  echo -e "	mkdir res 2> /dev/null || true">> Makefile
  echo -e "	mkdir bin/aidl 2> /dev/null || true">> Makefile
  echo -e "	mkdir include 2> /dev/null || true">> Makefile
  echo -e "rmdirs:">> Makefile
  echo -e "	rmdir \`find\` 2> /dev/null || true">> Makefile
  echo -e "push:">> Makefile
  echo -e "	\$(ADB) push bin/\$(NAME).apk /sdcard">> Makefile
  echo -e "">> Makefile
elif [ "$type" == "Java" ]
then
  mkdir -p src
  mkdir -p res
  #building makefile
  echo -e "JC=\$(JAVA_HOME)/bin/javac" > Makefile
  echo -e "JAR=\$(JAVA_HOME)/bin/jar" >> Makefile
  echo -e "JFLAG= -encoding UTF-8" >> Makefile
  echo -e "SRC=src/" >> Makefile
  echo -e "NAME=$name" >> Makefile
  echo -e "" >> Makefile
  echo -e "all: clean build" >> Makefile
  echo -e "build:" >> Makefile
  echo -e "	mkdir -p build" >> Makefile
  echo -e "	\$(JC) \$(JFLAG) \$(shell find \$(SRC) -name \"*.java\")" >> Makefile
  echo -e "	mv src/*.class build/" >> Makefile
  echo -e "	cp -prfv res/* build/ 2>/dev/null || true" >> Makefile
  echo -e "	cd build ; jar cfe ../\$(NAME).jar Main \`find \`" >> Makefile
  echo -e "clean:" >> Makefile
  echo -e "	rm -rf build/" >> Makefile
  #building main.java
  echo -e "public class Main{" > src/Main.java
  echo -e "\tpublic static void main(String[] args){" >> src/Main.java
  echo -e "\t\tSystem.out.println(\"Hello World\");" >> src/Main.java
  echo -e "\t}" >> src/Main.java
  echo -e "}" >> src/Main.java
elif [ "$type" == "Python2" ]
then
  mkdir -p src
  #building makefile
  echo -e "PC=python2" > Makefile
  echo -e "PFLAG=-m py_compile" >> Makefile
  echo -e "SRC=src/" >> Makefile
  echo -e "NAME=\"$name\"" >> Makefile
  echo >> Makefile
  echo -e "all: clean build" >> Makefile
  echo -e "build:" >> Makefile
  echo -e "\tmkdir -p build" >> Makefile
  echo -e "\t\$(PC) \$(PFLAG) \$(shell find \$(SRC) -name \"*.py\")" >> Makefile
  echo -e "\tmv src/*.pyc build/" >> Makefile
  echo -e "\tcp -prfv res/* build/ 2>/dev/null || true" >> Makefile
  echo -e "\tchmod 755 build/*" >> Makefile
  echo -e "clean:" >> Makefile
  echo -e "\trm -rf build/" >> Makefile
  #buinding main.py
  echo -e "class Main:" > src/Main.py
  echo -e "\tdef write(self):" >> src/Main.py
  echo -e "\t\tprint \"Hello World\"" >> src/Main.py
  echo -e "Main().write()" >> src/Main.py
elif [ "$type" == "Python3" ]
then
  mkdir -p src
  #building makefile
  echo -e "PC=python3" >> Makefile
  echo -e "PFLAG=-m compileall" >> Makefile
  echo -e "SRC=src/" >> Makefile
  echo -e "NAME=$name" >> Makefile
  echo -e "" >> Makefile
  echo -e "all: clean build" >> Makefile
  echo -e "build:" >> Makefile
  echo -e "	mkdir -p build" >> Makefile
  echo -e "	\$(PC) \$(PFLAG) \$(SRC)" >> Makefile
  echo -e "	mv \$(SRC)/__pycache__/*.pyc build/" >> Makefile
  echo -e "	rmdir \$(SRC)/__pycache__/" >> Makefile
  echo -e "	cp -prfv res/* build/ 2>/dev/null || true" >> Makefile
  echo -e "	chmod 755 build/*" >> Makefile
  echo -e "clean:" >> Makefile
  echo -e "	rm -rf build/" >> Makefile
  #buinding main.py
  echo -e "class Main:" > src/Main.py
  echo -e "\tdef write(self):" >> src/Main.py
  echo -e "\t\tprint(\"Hello World\")" >> src/Main.py
  echo -e "Main().write()" >> src/Main.py
elif [ "$type" == "Vala" ]
then
  mkdir -p {src,res}
  #building makefile
  echo -e "CC=valac" > Makefile
  echo -e "CFLAG= -o" >> Makefile
  echo -e "OUT=build/$name" >> Makefile
  echo -e "NAME=\"$name\"" >> Makefile
  echo >> Makefile
  echo -e "all: clean build" >> Makefile
  echo -e "build:" >> Makefile
  echo -e "\tmkdir -p build" >> Makefile
  echo -e "\t\$(CC) \$(CFLAG) \$(OUT) src/main.vala" >> Makefile
  echo -e "clean:" >> Makefile
  echo -e "\trm -rf build/" >> Makefile
  echo -e "install:" >> Makefile
  echo -e "\tcp -prfv res/* \$(TARGET)/" >> Makefile
  echo -e "\tinstall \$(OUT) \$(TARGET)/usr/bin/\$(NAME)" >> Makefile
  #building main.c
  echo -e "static void main (string[] args){" > src/main.vala
  echo -e "\tstdout.printf (\"Hello World!\\n\");" >> src/main.vala
  echo -e "}" >> src/main.vala
elif [ "$type" == "Kmod" ]
then
	#building makefile
	echo -e "obj-m += $name.o" > Makefile
	echo -e "" >> Makefile
	echo -e "all:" >> Makefile
	echo -e "\tmake -C /lib/modules/\$(shell uname -r)/build M=\$(PWD) modules" >> Makefile
	echo -e "" >> Makefile
	echo -e "clean:" >> Makefile
	echo -e	"\techo -e make -C /lib/modules/\$(shell uname -r)/build M=\$(PWD) clean" >> Makefile
	#building module.c"
	echo -e "#include <linux/module.h>" >$name.c
	echo -e "#include <linux/kernel.h>" >>$name.c
	echo -e "#include <linux/init.h>" >>$name.c
	echo -e "" >>$name.c
	echo -e "MODULE_LICENSE(\"GPL\");" >>$name.c
	echo -e "MODULE_AUTHOR(\"Your Name\");" >>$name.c
	echo -e "MODULE_DESCRIPTION(\"A Simple Kernel module\");" >>$name.c
	echo -e "" >>$name.c
	echo -e "static int __init "$name"_init(void){" >>$name.c
    echo -e "\tprintk(KERN_INFO \"Hello world!\\\n\");" >>$name.c
    echo -e "\treturn 0;" >>$name.c
	echo -e "}" >>$name.c
	echo -e "" >>$name.c
	echo -e "static void __exit "$name"_cleanup(void){" >>$name.c
    echo -e "\tprintk(KERN_INFO \"Cleaning up module.\\\n\");" >>$name.c
	echo -e "}" >>$name.c
	echo -e "" >>$name.c
	echo -e "module_init("$name"_init);" >>$name.c
	echo -e "module_exit("$name"_cleanup);" >>$name.c
elif [ "$type" == "Debian" ]
then
	echo -e "build:" > Makefile
	echo -e "\techo \"edit me\"" >> Makefile
	echo -e "install:" >> Makefile
	echo -e "\techo \"edit me\"" >> Makefile
	mkdir -p debian
	cd debian
	echo -e "${name,,} (0.1.0) unstable; urgency=medium" > changelog
	echo -e "" >> changelog
	echo -e "  * Initial commit" >> changelog
	echo -e "" >> changelog
	echo -e " -- Your Name <your.email@example.org>  $(LANG=C date -R)" >> changelog
	
	echo 9 > compat

	echo -e "Source: ${name,,}" > control
	echo -e "Section: utils" >> control
	echo -e "Priority: optional" >> control
	echo -e "Maintainer: Your Name <your.email@example.org>" >> control
	echo -e "Build-Depends: make" >> control
	echo -e "Standards-Version: 4.3.0" >> control
	echo -e "Homepage: https://example.org" >> control
	echo -e "" >> control
	echo -e "Package: ${name,,}" >> control
	echo -e "Architecture: all" >> control
	echo -e "Depends: \${misc:Depends}, libc6" >> control
	echo -e "Description: Edit me" >> control
	echo -e " Edit me. I am description" >> control

	touch copyright

	echo -e "#!/usr/bin/make -f" > rules
	echo -e "" >> rules
	echo -e "%:" >> rules
	echo -e "\tdh \$@ " >> rules
	cd ..
elif [ "$type" == "Inary" ]
then
    echo -e "<?xml version=\"1.0\" ?>" > pspec.xml
    echo -e "<!DOCTYPE INARY SYSTEM \"https://gitlab.com/sulinos/sulinproject/inary/raw/master/inary-spec.dtd\">" >> pspec.xml
    echo -e "<INARY>" >> pspec.xml
    echo -e "  <Source>" >> pspec.xml
    echo -e "    <Name>$name</Name>" >> pspec.xml
    echo -e "    <Rfp>Example rfp packager name</Rfp>" >> pspec.xml
    echo -e "    <Homepage>http://example.org/</Homepage>" >> pspec.xml
    echo -e "    <Packager>" >> pspec.xml
    echo -e "      <Name>Your Name</Name>" >> pspec.xml
    echo -e "      <Email>your.mail@example.org</Email>" >> pspec.xml
    echo -e "    </Packager>" >> pspec.xml
    echo -e "    <License>exampleV2</License>" >> pspec.xml
    echo -e "    <IsA>app:example</IsA>" >> pspec.xml
    echo -e "    <Summary>This is example Summary</Summary>" >> pspec.xml
    echo -e "    <Description>This is example description</Description>" >> pspec.xml
    echo -e "    <Archive sha1sum=\"example_sha1sum\" type=\"tarxz\">https://example.org/example.tar.xz</Archive>" >> pspec.xml
    echo -e "    <BuildDependencies>" >> pspec.xml
    echo -e "      <Dependency>make</Dependency>" >> pspec.xml
    echo -e "      <Dependency>gcc</Dependency>" >> pspec.xml
    echo -e "    </BuildDependencies>" >> pspec.xml
    echo -e "  </Source>" >> pspec.xml
    echo -e "" >> pspec.xml
    echo -e "  <Package>" >> pspec.xml
    echo -e "    <Name>$name</Name>" >> pspec.xml
    echo -e "    <RuntimeDependencies>" >> pspec.xml
    echo -e "      <Dependency>glibc</Dependency>" >> pspec.xml
    echo -e "      <Dependency>readline</Dependency>" >> pspec.xml
    echo -e "    </RuntimeDependencies>" >> pspec.xml
    echo -e "    <Files>" >> pspec.xml
    echo -e "      <Path fileType=\"config\">/etc</Path>" >> pspec.xml
    echo -e "      <Path fileType=\"localedata\">/usr/share/locale</Path>" >> pspec.xml
    echo -e "      <Path fileType=\"doc\">/usr/share/doc/nano</Path>" >> pspec.xml
    echo -e "      <Path fileType=\"man\">/usr/share/man</Path>" >> pspec.xml
    echo -e "      <Path fileType=\"info\">/usr/share/info</Path>" >> pspec.xml
    echo -e "      <Path fileType=\"data\">/usr/share/nano</Path>" >> pspec.xml
    echo -e "      <Path fileType=\"executable\">/usr/bin</Path>" >> pspec.xml
    echo -e "      <Path fileType=\"executable\">/bin</Path>" >> pspec.xml
    echo -e "    </Files>" >> pspec.xml
    echo -e "  </Package>" >> pspec.xml
    echo -e "" >> pspec.xml
    echo -e "  <History>" >> pspec.xml
    echo -e "    <Update release=\"1\">" >> pspec.xml
    echo -e "      <Date>1970-01-01</Date>" >> pspec.xml
    echo -e "      <Version>0.0.1</Version>" >> pspec.xml
    echo -e "      <Comment>example comment</Comment>" >> pspec.xml
    echo -e "      <Name>Name Surname</Name>" >> pspec.xml
    echo -e "      <Email>mail@example.org</Email>" >> pspec.xml
    echo -e "    </Update>" >> pspec.xml
    echo -e "  </History>" >> pspec.xml
    echo -e "</INARY>" >> pspec.xml

    echo -e "#!/usr/bin/env python3 " > actions.py
    echo -e "# -*- coding: utf-8 -*-" >> actions.py
    echo -e "from inary.actionsapi import autotools" >> actions.py
    echo -e "from inary.actionsapi import inarytools" >> actions.py
    echo -e "from inary.actionsapi import get" >> actions.py
    echo -e "def setup():" >> actions.py
    echo -e "  autotools.configure()" >> actions.py
    echo -e "" >> actions.py
    echo -e "def build():" >> actions.py
    echo -e "  autotools.make()" >> actions.py
    echo -e "" >> actions.py
    echo -e "def install():" >> actions.py
    echo -e "  autotools.rawInstall(\"DESTDIR={}\".format(get.installDIR()))" >> actions.py
    cd ..
else
echo "Type not supported yet."
fi
cd ..
