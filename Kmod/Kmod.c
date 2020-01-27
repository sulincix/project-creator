#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Your Name");
MODULE_DESCRIPTION("A Simple Kernel module");

static int __init Kmod_init(void){
	printk(KERN_INFO "Hello world!\n");
	return 0;
}

static void __exit Kmod_cleanup(void){
	printk(KERN_INFO "Cleaning up module.\n");
}

module_init(Kmod_init);
module_exit(Kmod_cleanup);
