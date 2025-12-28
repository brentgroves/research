# **[How to add a routed NIC device to a virtual machine](https://documentation.ubuntu.com/lxd/en/stable-5.0/howto/instances_routed_nic_vm/)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

When adding a **[routed NIC device](https://documentation.ubuntu.com/lxd/en/stable-5.0/reference/devices_nic/#nic-routed)** to an instance, you must configure the instance to use the link-local gateway IPs as default routes. For containers, this is configured for you automatically. For virtual machines, the gateways must be configured manually or via a mechanism like cloud-init.

To configure the gateways with cloud-init, firstly initialize an instance:

```bash
lxc init ubuntu:22.04 jammy --vm
```