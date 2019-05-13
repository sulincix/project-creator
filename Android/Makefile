SDK=~/Android/Sdk
TARGET=28
TOOL=28.0.3
AJAR=$(SDK)/platforms/android-$(TARGET)/android.jar
ADX=$(SDK)/build-tools/$(TOOL)/dx
AAPT=$(SDK)/build-tools/$(TOOL)/aapt
JAVADIR=/usr/bin
JAVAC=$(JAVADIR)/javac
JARSIGNER=$(JAVADIR)/jarsigner

SRC=src/
NAME=Android

STOREPASS=123456
KEYPASS=123456

all: clear build sign install
build:
	mkdir bin
	mkdir gen
	$(AAPT) package -v -f -I $(AJAR) -M "AndroidManifest.xml" -A "assets" -S "res" -m -J "gen" -F "bin/resources.ap_"
	$(JAVAC) -classpath $(AJAR) -sourcepath $(SRC) -sourcepath gen -d bin $(shell find $(SRC) -name "*.java")
	$(ADX) --dex --output=bin/classes.dex bin
	mv bin/resources.ap_ bin/$(NAME).ap_
	cd bin ; $(AAPT) add $(NAME).ap_ classes.dex
sign:
	jarsigner -keystore keystore/key.keystore -storepass $(STOREPASS) -keypass $(KEYPASS) -signedjar bin/$(NAME).apk bin/$(NAME).ap_ Alias
generate:
	keytool -genkey -noprompt -alias Alias -dname "CN=Hostname, OU=OrganizationalUnit, O=Organization, L=City, S=State, C=Country" -keystore keystore/key.keystore -storepass $(STOREPASS) -keypass $(KEYPASS) -validity 3650
clear:
	rm -rf bin gen
install:
	adb install -r bin/$(NAME).apk
