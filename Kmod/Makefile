obj-m += Kmod.o

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
	echo -e make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
