# **[how to do vlan sub interfaces with netplan](https://ostechnix.com/configure-vlan-tagging-in-linux/)**

**[Back to Research List](../../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../../README.md)**

AI Overview
Learn more
To configure VLAN subinterfaces using Netplan, you define a "vlans" section within your Netplan YAML file, specifying the VLAN ID and linking it to the physical network interface, essentially creating a virtual interface for each VLAN on the same physical connection; you can then assign IP addresses and other network settings to each VLAN subinterface within the configuration.

Key points about using VLANs in Netplan:
"vlans" section: This is where you define your VLAN subinterfaces, specifying the VLAN ID and linking it to the physical interface using the "link" parameter.
"id": The unique identifier for each VLAN.
"link": The physical network interface that the VLAN is attached to.

Example Netplan configuration with VLANs:
Code

```yam
network:

  version: 2

  renderer: networkd

  ethernets:

    ens3:

      dhcp4: false

      addresses:

        - 192.168.1.1/24

  vlans:

    vlan10:

      id: 10

      link: ens3

      addresses:

        - 10.0.0.1/24

    vlan20:

      id: 20

      link: ens3

      addresses:

        - 10.0.1.1/24

```

Explanation:
This configuration creates two VLANs (VLAN 10 and VLAN 20) on the physical interface "ens3".
Each VLAN is assigned a unique ID (10 and 20).
You can further configure each VLAN with specific IP addresses, gateway, and other network settings within the "addresses" section.

Important considerations:
Switch configuration:
Ensure your network switch is properly configured to support VLANs and is tagging traffic on the appropriate ports.
Applying changes:
After modifying your Netplan configuration, use the command sudo netplan apply to apply the changes.
