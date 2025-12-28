# **[](https://github.com/openvswitch/ovs/blob/main/Documentation/tutorials/ovs-advanced.rst)**

Open vSwitch Advanced Features
Many tutorials cover the basics of OpenFlow. This is not such a tutorial. Rather, a knowledge of the basics of OpenFlow is a prerequisite. If you do not already understand how an OpenFlow flow table works, please go read a basic tutorial and then continue reading here afterward.

It is also important to understand the basics of Open vSwitch before you begin. If you have never used ovs-vsctl or ovs-ofctl before, you should learn a little about them before proceeding.

Most of the features covered in this tutorial are Open vSwitch extensions to OpenFlow. Also, most of the features in this tutorial are specific to the software Open vSwitch implementation. If you are using an Open vSwitch port to an ASIC-based hardware switch, this tutorial will not help you.

This tutorial does not cover every aspect of the features that it mentions. You can find the details elsewhere in the Open vSwitch documentation, especially ovs-ofctl(8) and the comments in the include/openflow/nicira-ext.h and include/openvswitch/meta-flow.h header files.

Getting Started
This is a hands-on tutorial. To get the most out of it, you will need Open vSwitch binaries. You do not, on the other hand, need any physical networking hardware or even supervisor privilege on your system. Instead, we will use a script called ovs-sandbox, which accompanies the tutorial, that constructs a software simulated network environment based on Open vSwitch.

You can use ovs-sandbox three ways:

If you have already installed Open vSwitch on your system, then you should be able to just run ovs-sandbox from this directory without any options.
If you have not installed Open vSwitch (and you do not want to install it), then you can build Open vSwitch according to the instructions in :doc:`/intro/install/general`, without installing it. Then run ./ovs-sandbox -b DIRECTORY from this directory, substituting the Open vSwitch build directory for DIRECTORY.
As a slight variant on the latter, you can run make sandbox from an Open vSwitch build directory.
When you run ovs-sandbox, it does the following:

CAUTION: Deletes any subdirectory of the current directory named "sandbox" and any files in that directory.
Creates a new directory "sandbox" in the current directory.
Sets up special environment variables that ensure that Open vSwitch programs will look inside the "sandbox" directory instead of in the Open vSwitch installation directory.
If you are using a built but not installed Open vSwitch, installs the Open vSwitch manpages in a subdirectory of "sandbox" and adjusts the MANPATH environment variable to point to this directory. This means that you can use, for example, man ovs-vsctl to see a manpage for the ovs-vsctl program that you built.
Creates an empty Open vSwitch configuration database under "sandbox".
Starts ovsdb-server running under "sandbox".
Starts ovs-vswitchd running under "sandbox", passing special options that enable a special "dummy" mode for testing.
Starts a nested interactive shell inside "sandbox".
At this point, you can run all the usual Open vSwitch utilities from the nested shell environment. You can, for example, use ovs-vsctl to create a bridge:

$ ovs-vsctl add-br br0
From Open vSwitch's perspective, the bridge that you create this way is as real as any other. You can, for example, connect it to an OpenFlow controller or use ovs-ofctl to examine and modify it and its OpenFlow flow table. On the other hand, the bridge is not visible to the operating system's network stack, so ip cannot see it or affect it, which means that utilities like ping and tcpdump will not work either. (That has its good side, too: you can't screw up your computer's network stack by manipulating a sandboxed OVS.)

When you're done using OVS from the sandbox, exit the nested shell (by entering the "exit" shell command or pressing Control+D). This will kill the daemons that ovs-sandbox started, but it leaves the "sandbox" directory and its contents in place.

The sandbox directory contains log files for the Open vSwitch dameons. You can examine them while you're running in the sandboxed environment or after you exit.

Using GDB
GDB support is not required to go through the tutorial. It is added in case user wants to explore the internals of OVS programs.

GDB can already be used to debug any running process, with the usual gdb <program> <process-id> command.

ovs-sandbox also has a -g option for launching ovs-vswitchd under GDB. This option can be handy for setting break points before ovs-vswitchd runs, or for catching early segfaults. Similarly, a -d option can be used to run ovsdb-server under GDB. Both options can be specified at the same time.

In addition, a -e option also launches ovs-vswitchd under GDB. However, instead of displaying a gdb> prompt and waiting for user input, ovs-vswitchd will start to execute immediately. -r option is the corresponding option for running ovsdb-server under gdb with immediate execution.

To avoid GDB mangling with the sandbox sub shell terminal, ovs-sandbox starts a new xterm to run each GDB session. For systems that do not support X windows, GDB support is effectively disabled.

When launching sandbox through the build tree's make file, the -g option can be passed via the SANDBOXFLAGS environment variable. make sandbox
SANDBOXFLAGS=-g will start the sandbox with ovs-vswitchd running under GDB in its own xterm if X is available.

In addition, a set of GDB macros are available in utilities/gdb/ovs_gdb.py. Which are able to dump various internal data structures. See the header of the file itself for some more details and an example.

Motivation
The goal of this tutorial is to demonstrate the power of Open vSwitch flow tables. The tutorial works through the implementation of a MAC-learning switch with VLAN trunk and access ports. Outside of the Open vSwitch features that we will discuss, OpenFlow provides at least two ways to implement such a switch:

An OpenFlow controller to implement MAC learning in a "reactive" fashion. Whenever a new MAC appears on the switch, or a MAC moves from one switch port to another, the controller adjusts the OpenFlow flow table to match.
The "normal" action. OpenFlow defines this action to submit a packet to "the traditional non-OpenFlow pipeline of the switch". That is, if a flow uses this action, then the packets in the flow go through the switch in the same way that they would if OpenFlow was not configured on the switch.
Each of these approaches has unfortunate pitfalls. In the first approach, using an OpenFlow controller to implement MAC learning, has a significant cost in terms of network bandwidth and latency. It also makes the controller more difficult to scale to large numbers of switches, which is especially important in environments with thousands of hypervisors (each of which contains a virtual OpenFlow switch). MAC learning at an OpenFlow controller also behaves poorly if the OpenFlow controller fails, slows down, or becomes unavailable due to network problems.

The second approach, using the "normal" action, has different problems. First, little about the "normal" action is standardized, so it behaves differently on switches from different vendors, and the available features and how those features are configured (usually not through OpenFlow) varies widely. Second, "normal" does not work well with other OpenFlow actions. It is "all-or-nothing", with little potential to adjust its behavior slightly or to compose it with other features.
