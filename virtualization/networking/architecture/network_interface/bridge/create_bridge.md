# **[Create an ethernet bridge](https://multipass.run/docs/configure-static-ips)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Multipass Menu](./multipass_menu.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

## references

- **[Network connection bridge](../../networking/kvm/)
- **[libvirt](https://ubuntu.com/server/docs/libvirt)**
- **[How Multipass enslaves an ethernet device to a bridge](https://www.cyberciti.biz/faq/how-to-add-network-bridge-with-nmcli-networkmanager-on-linux/)**
- **[Redhat Create Bridge with nmcli](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_networking/configuring-a-network-bridge_configuring-and-managing-networking)**

## **[Virtual networking](https://ubuntu.com/server/docs/libvirt)**

There are a few different ways to allow a virtual machine access to the external network. The default virtual network configuration includes bridging and iptables rules implementing usermode networking, which uses the **[SLiRP](https://en.wikipedia.org/wiki/Slirp)** protocol. Traffic is NATed through the host interface to the outside network.

To enable external hosts to directly access services on virtual machines a different type of bridge than the default needs to be configured. This allows the virtual interfaces to connect to the outside network through the physical interface, making them appear as normal hosts to the rest of the network.

There is a great example of how to **[configure a bridge](https://netplan.readthedocs.io/en/latest/netplan-yaml/#properties-for-device-type-bridges)** and combine it with libvirt so that guests will use it at the **[netplan.io documentation](https://netplan.readthedocs.io/en/latest/)**.

Note: Make sure the first octet in your MAC address is EVEN (eg. 00:) as MAC addresses with ODD first-bytes (eg. 01:) are reserved for multicast communication and can cause confusing problems for you. For instance, the guest will be able to receive ARP packets and reply to them, but the reply will confuse other machines. This is not a KVM issue, but just the way Ethernet works.

You do not need to restart libvirtd to reload the changes; the easiest way is to log into virsh (a command line tool to manage VMs), stop the VM, reread its configuration file, and restart the VM:

```bash
yhamon@paris:/etc/libvirt/qemu$ ls
mirror.xml  networks  vm2.xml
yhamon@paris:/etc/libvirt/qemu$ virsh --connect qemu:///system
Connecting to uri: qemu:///system
Welcome to virsh, the virtualization interactive terminal.

Type:  'help' for help with commands
       'quit' to quit

virsh # list
 Id Name                 State
----------------------------------
 10 vm2                  running
 15 mirror               running

virsh # shutdown mirror
Domain mirror is being shutdown

virsh # define mirror.xml
Domain mirror defined from mirror.xml

virsh # start mirror
Domain mirror started
The VM "mirror" is now using bridged networking.
```

## Step 1: Create a Bridge

A **[network bridge](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_networking/configuring-a-network-bridge_configuring-and-managing-networking)** is a link-layer device which forwards traffic between networks based on a table of MAC addresses. A bridge requires a network device in each network the bridge should connect. When you configure a bridge, the bridge is called controller and the devices it uses ports. To set a static IPv4 address, network mask, default gateway, and DNS server to the bridge0 connection, enter:
