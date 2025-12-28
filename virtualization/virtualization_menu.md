# Virtualization Menu

**[Current Status](../../../development/status/weekly/current_status.md)**\
**[Research List](../../research_list.md)**\
**[Back Main](../../../README.md)**

- **[bridged networking](./bridged_networking.md)**
- **[d-bus](./d-bus.md)**
- KVM
  - **[Install KVM](./kvm/kvm_install.md)**
  - **[Manage KVM virtual machines with virsh](./kvm/manage_virtual_machines_with_virsh.md)**
- multipass
  - **[Configure Static IPs](./multipass/create_bridges_with_netplan.md)** \
- nmcli
  - **[nmcli](./nmcli/nmcli.md)**
  - **[nmcli examples](./nmcli/nmcli_examples.md)**
  - **[add network bridge](./nmcli/how_to_add_network_bridge_nmcli.md)**
- **[Ubuntu network management](./network_management.md)**
- **[netplan](./netplan.md)**
- **[NetworkManager](./network_manager.md)**
- nmcli
  - **[nmcli](./nmcli/nmcli.md)**
  - **[Create a bridge using nmcli](./nmcli/how_to_add_network_bridge_nmcli.md)**
- **[polkit](./polkit.md)**
- **[Spanning Tree Protocal (STP)](./stp.md)**
- **[udev](./udev.md)**
- **[virsh](./virsh.md)**
- Virtual Networking
  - **[Virtio-Net part 1](./virtual_networking/virtio-part1.md)**
  - **[Virtio-Net part 2](./virtual_networking/virtio-part2.md)**
  - **[Virtual Network Interface Cards](./virtual_networking/virtual_network_interface_cards.md)**

- **[Configure Static IPs](../m/multipass/config_static_ips.md)** \
This document explains how to create instances with static IPs in a new network, internal to the host. With this approach,Netfilter e, local network we avoid any IP conflicts. Instances retain the usual default interface with a DHCP-allocated IP, which gives them connectivity to the outside.
