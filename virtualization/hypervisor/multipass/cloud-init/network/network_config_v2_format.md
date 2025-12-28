# **[Networking config Version 2](https://cloudinit.readthedocs.io/en/latest/reference/network-config-format-v2.html#network-config-v2)**

**[Back to Research List](../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../README.md)**

Cloud-init’s support for Version 2 network config is a subset of the Version 2 format defined for the Netplan tool. Cloud-init supports both reading and writing of Version 2. Writing support requires a distro with Netplan present.

Netplan passthrough
On a system with Netplan present, cloud-init will pass Version 2 configuration through to Netplan without modification. On such systems, you do not need to limit yourself to the below subset of Netplan’s configuration format.

Warning

If you are writing or generating network configuration that may be used on non-netplan systems, you must limit yourself to the subset described in this document, or you will see network configuration failures on non-netplan systems.

