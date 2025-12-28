# **[Introduction to Netfilter](https://blogs.oracle.com/linux/post/introduction-to-netfilter)**

## Introduction

In this page, we are going to understand the various features of netfilter hooks, their functionality, and how to utilize them.

Netfilter is a subsystem that was introduced in the Linux 2.4 kernel that provides a framework for implementing advanced network functionalities such as packet filtering, network address translation (NAT), and connection tracking. It achieves this by leveraging hooks in the kernel’s network code, which are the locations where kernel code can register functions to be invoked for specific network events. For instance, when a packet is received, it triggers a handler for the event and performs module specified actions.

## Writing a Netfilter module

Now that we are clear on the concepts of netfilter hooks. Let’s understand how to use these hooks to perform a simple logging operation of packets in the network stack. To hot-plug the callbacks to these hooks, users need to write a kernel module that defines and registers one or more netfilter hook functions.

Source taken from include/linux/netfilter.h in linux kernel [2].
