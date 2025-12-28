# Linux Virtual Network

## references

<https://superuser.com/questions/1781039/setting-up-simple-isolated-virtual-network-for-testing>

<https://linuxconfig.org/configuring-virtual-network-interfaces-in-linux>

<https://thelinuxchannel.org/2023/10/linux-kernel-dummy-network-interface-drivers-net-dummy-c-network-namespace-research/>

## Linux: Create virtual network interface

23 April 2022 by Luke Reynolds
On Linux, virtual network interface configuration isn’t something most people need to do very often, but it can come in handy sometimes. The system will recognize a virtual interface as a real, physical interface. linux create virtual network interface

In this respect, it works sort of like a virtual machine – that is, it emulates the necessary hardware components to seem like it’s physically connected to the machine.

In this tutorial, you’ll learn how to create a virtual network interface on Linux. Follow along with the step by step instructions below to create one or more of these interfaces on your own system.

## In this tutorial you will learn

How to create virtual network interfaces on Linux

![](https://linuxconfig.org/wp-content/uploads/2014/07/00-configuring-virtual-network-interfaces-in-linux.png)

## Create virtual network interfaces on Linux

The methods for creating a virtual network interface have changed a bit through the years. There is more than one way to do this, but we will be using the “dummy” kernel module to set up our virtual interface in these steps.

1. Start off by enabling the dummy kernel module with the following command.

```bash
sudo modprobe dummy
```
