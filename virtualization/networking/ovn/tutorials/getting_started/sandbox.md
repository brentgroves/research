# **[OVN Sandbox](https://docs.ovn.org/en/stable/tutorials/ovn-sandbox.html)**

This tutorial shows you how to explore features using ovn-sandbox as a simulated test environment. It’s assumed that you have an understanding of OVS before going through this tutorial. Detail about OVN is covered in ovn-architecture, but this tutorial lets you quickly see it in action.

## Getting Started

ovn-sandbox is derived from the Open vSwitch ovs-sandbox utility. For some general information about it, see the “Getting Started” section of ovs-advanced in the Open vSwitch documentation.

ovn-sandbox in the OVN repo includes OVN support by default. To start it, you would simply need to run:

$ make sandbox

Running the sandbox does the following steps to the environment:

Creates the OVN_Northbound and OVN_Southbound databases as described in ovn-nb(5) and ovn-sb(5).

Creates a backup server for OVN_Southbond database. Sandbox launch screen provides the instructions on accessing the backup database. However access to the backup server is not required to go through the tutorial.

Creates the hardware_vtep database as described in vtep(5).

Runs the ovn-northd(8), ovn-controller(8), and ovn-controller-vtep(8) daemons.

Makes OVN and VTEP utilities available for use in the environment, including vtep-ctl(8), ovn-nbctl(8), and ovn-sbctl(8).

Using GDB
GDB support is not required to go through the tutorial. See the “Using GDB” section of ovs-advanced in the Open vSwitch documentation for more info. Additional flags exist for launching the debugger for the OVN programs:

--gdb-ovn-northd
--gdb-ovn-controller
--gdb-ovn-controller-vtep
