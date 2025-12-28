# Kernel Module

## references

<https://linuxconfig.org/basic-linux-module-administration-commands>

## Basic Linux Kernel commands for module administration

23 April 2022 by Luke Reynolds
The kernel of a Linux system is the core that everything else in the operating system relies on. The functionality of the kernel can be extended by adding modules to it by use of a specific Linux kernel commands. As such, a user can fine tune their kernel settings by enabling or disabling modules. This level of granular control is one of the many reasons why users love Linux in the first place.

In this guide, we’ll go over some of the most essential kernel module administration commands on Linux. Knowing these commands will help you understand the components that have been loaded into your system’s kernel, and will also allow you to load, reload, or unload modules in the system kernel.

## In this tutorial you will learn

How to administer kernel modules on Linux with commands

![](https://linuxconfig.org/wp-content/uploads/2021/07/02-basic-linux-module-administration-commands.png)

## Linux kernel module administration commands

Check out some of the commands below to administer the kernel of your Linux system. Some, but not all, of these commands will require root privileges.

To see a list of all the modules currently available on your system, use the following command to list the contents of the /lib/modules directory. Linux distros are made up of a staggering number of components, so you should expect a lot of output.

```bash
# ls -R /lib/modules/$(uname -r)

```

Use the following command syntax to display information for a particular module. Of course, replace the name below with the real name of an actual module on your system.

```bash
# modinfo /path/to/module.ko
```

![](https://linuxconfig.org/wp-content/uploads/2021/07/02-basic-linux-module-administration-commands.png)

Install a module into the running kernel by using the following command. Note that this command will not resolve module dependencies automatically.

```bash
# insmod kernel-module-name
```

Install module into the running kernel while also resolving module dependencies.

```bash
# modprobe kernel-module-name

```

Rebuild the module dependency database using /lib/modules/$(uname -r)/modules.dep.

```bash
# depmod -a
```

Some modules are only designed to be loaded into a particular version of a kernel. When trying to load these modules into a kernel of a different version, you’ll get an error. However, you can bypass this red tape and force insmod to load a module even if it’s built for a different kernel version by using the --force option in your command.

```bash
# insmod --force kernel-module-name
```

Display insmod commands to load module and its dependencies. This command is useful when modprobe gives up due to a dependency problem.

```bash
# modprobe -n -v kernel-module-name
```

Display all modules currently loaded into the kernel.

```bash
# lsmod
```

![](https://linuxconfig.org/wp-content/uploads/2021/07/03-basic-linux-module-administration-commands.png)

Remove a module from a running kernel with the rmmod command.

```bash
# rmmod kernel-module-name
```

## Closing Thoughts

In this guide, we saw various commands that can be used to manage the kernel modules on a Linux system. Knowing these commands will come in handy when troubleshooting hardware components or software that relies on certain modules to function. Now you know how to load or remove modules from the kernel, as well as retrieve information about the modules on your system.
