# Network Configuration

## references

<https://ubuntu.com/server/docs/network-configuration>

## Ethernet interfaces

Ethernet interfaces are identified by the system using predictable network interface names. These names can appear as eno1 or enp0s25. However, in some cases an interface may still use the kernel eth# style of naming.

Identify Ethernet interfaces
To quickly identify all available Ethernet interfaces, you can use the ip command as shown below.

```bash
ssh brent@reports13
ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 98:90:96:c3:f4:83 brd ff:ff:ff:ff:ff:ff
    altname enp0s25
    inet 10.1.0.112/22 brd 10.1.3.255 scope global eno1
       valid_lft forever preferred_lft forever
    inet6 fe80::9a90:96ff:fec3:f483/64 scope link 
       valid_lft forever preferred_lft forever
4: cali87d0e87cee8@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default 
    link/ether ee:ee:ee:ee:ee:ee brd ff:ff:ff:ff:ff:ff link-netns cni-be042aea-d3c4-50d5-2817-9b5dc0d0f583
    inet6 fe80::ecee:eeff:feee:eeee/64 scope link 
       valid_lft forever preferred_lft forever
7: vxlan.calico: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UNKNOWN group default 
    link/ether 66:eb:2f:b2:c5:e7 brd ff:ff:ff:ff:ff:ff
    inet 10.1.75.128/32 scope global vxlan.calico
       valid_lft forever preferred_lft forever
    inet6 fe80::64eb:2fff:feb2:c5e7/64 scope link 
       valid_lft forever preferred_lft forever
8: calib6e99f7c0f0@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default 
    link/ether ee:ee:ee:ee:ee:ee brd ff:ff:ff:ff:ff:ff link-netns cni-b563bde9-ff57-0b44-6fb1-cc00b9740d6b
    inet6 fe80::ecee:eeff:feee:eeee/64 scope link 
       valid_lft forever preferred_lft forever
28: cali273c23168a9@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default 
    link/ether ee:ee:ee:ee:ee:ee brd ff:ff:ff:ff:ff:ff link-netns cni-2257b9ef-d87d-6fff-80b5-fab218898133
    inet6 fe80::ecee:eeff:feee:eeee/64 scope link 
       valid_lft forever preferred_lft forever
29: calie61a2eec846@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default 
    link/ether ee:ee:ee:ee:ee:ee brd ff:ff:ff:ff:ff:ff link-netns cni-2f61d90e-9981-904c-ff68-224c416d2f33
    inet6 fe80::ecee:eeff:feee:eeee/64 scope link 
       valid_lft forever preferred_lft forever
31: cali171f4d0822a@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default 
    link/ether ee:ee:ee:ee:ee:ee brd ff:ff:ff:ff:ff:ff link-netns cni-874aa017-970a-9651-1f39-2e47c044584e
    inet6 fe80::ecee:eeff:feee:eeee/64 scope link 
       valid_lft forever preferred_lft forever
33: cali049a4ac6276@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default 
    link/ether ee:ee:ee:ee:ee:ee brd ff:ff:ff:ff:ff:ff link-netns cni-b67b509f-2b0b-8890-52df-ab3e968ede48
    inet6 fe80::ecee:eeff:feee:eeee/64 scope link 
       valid_lft forever preferred_lft forever
34: cali9673087a9d3@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default 
    link/ether ee:ee:ee:ee:ee:ee brd ff:ff:ff:ff:ff:ff link-netns cni-691960fb-20ef-51e9-6b04-c0783fc21902
    inet6 fe80::ecee:eeff:feee:eeee/64 scope link 
       valid_lft forever preferred_lft forever

```

Another application that can help identify all network interfaces available to your system is the lshw command. This command provides greater details around the hardware capabilities of specific adapters. In the example below, lshw shows a single Ethernet interface with the logical name of eth4 along with bus information, driver details and all supported capabilities.

```bash
ssh brent@reports13
  *-network                 
       description: Ethernet interface
       product: Ethernet Connection I217-LM
       vendor: Intel Corporation
       physical id: 19
       bus info: pci@0000:00:19.0
       logical name: eno1
       version: 04
       serial: 98:90:96:c3:f4:83
       size: 1Gbit/s
       capacity: 1Gbit/s
       width: 32 bits
       clock: 33MHz
       capabilities: pm msi bus_master cap_list ethernet physical tp 10bt 10bt-fd 100bt 100bt-fd 1000bt-fd autonegotiation
       configuration: autonegotiation=on broadcast=yes driver=e1000e driverversion=5.15.0-88-generic duplex=full firmware=0.13-4 ip=10.1.0.112 latency=0 link=yes multicast=yes port=twisted pair speed=1Gbit/s
       resources: irq:29 memory:f7c00000-f7c1ffff memory:f7c3d000-f7c3dfff ioport:f080(size=32)

# show all hardware
sudo lshw               
reports13                   
    description: Mini Tower Computer
    product: OptiPlex 9020 (OptiPlex 9020)
    vendor: Dell Inc.
    version: 01
    serial: DR6MB42
    width: 64 bits
    capabilities: smbios-2.7 dmi-2.7 smp vsyscall32
    configuration: administrator_password=disabled boot=normal chassis=mini-tower frontpanel_password=disabled keyboard_password=disabled power-on_password=disabled sku=OptiPlex 9020 uuid=4c4c4544-0052-3610-804d-c4c04f423432
  *-core
       description: Motherboard
       product: 0N4YC8
       vendor: Dell Inc.
       physical id: 0
       version: A00
       serial: /DR6MB42/CN7220051C024D/
     *-firmware
          description: BIOS
          vendor: Dell Inc.
          physical id: 0
          version: A09
          date: 11/20/2014
          size: 64KiB
          capacity: 12MiB
          capabilities: pci pnp upgrade shadowing cdboot bootselect edd int13floppy1200 int13floppy720 int13floppy2880 int5printscreen int9keyboard int14serial int17printer acpi usb biosbootspecification netboot uefi
     *-cpu
          description: CPU
          product: Intel(R) Core(TM) i7-4790 CPU @ 3.60GHz
          vendor: Intel Corp.
          physical id: 3a
          bus info: cpu@0
          version: 6.60.3
          slot: SOCKET 0
          size: 2494MHz
          capacity: 4GHz
          width: 64 bits
          clock: 100MHz
          capabilities: lm fpu fpu_exception wp vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp x86-64 constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm cpuid_fault epb invpcid_single pti ssbd ibrs ibpb stibp tpr_shadow vnmi flexpriority ept vpid ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid xsaveopt dtherm ida arat pln pts md_clear flush_l1d cpufreq
          configuration: cores=4 enabledcores=4 microcode=40 threads=8

ssh brent@reports-alb
sudo lshw -class network
  *-network                 
       description: Ethernet interface
       product: 82579LM Gigabit Network Connection (Lewisville)
       vendor: Intel Corporation
       physical id: 19
       bus info: pci@0000:00:19.0
       logical name: enp0s25
       version: 05
       serial: 18:03:73:1f:84:a4
       size: 1Gbit/s
       capacity: 1Gbit/s
       width: 32 bits
       clock: 33MHz
       capabilities: pm msi bus_master cap_list ethernet physical tp 10bt 10bt-fd 100bt 100bt-fd 1000bt-fd autonegotiation
       configuration: autonegotiation=on broadcast=yes driver=e1000e driverversion=6.5.0-17-generic duplex=full firmware=0.13-4 ip=10.1.0.113 latency=0 link=yes multicast=yes port=twisted pair speed=1Gbit/s
       resources: irq:34 memory:fbf00000-fbf1ffff memory:fbf29000-fbf29fff ioport:f040(size=32)
```

## Ethernet Interface logical names

Interface logical names can also be configured via a Netplan configuration. If you would like control which interface receives a particular logical name use the match and set-name keys. The match key is used to find an adapter based on some criteria like MAC address, driver, etc. The set-name key can be used to change the device to the desired logical name.

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth_lan0:
      dhcp4: true
      match:
        macaddress: 00:11:22:33:44:55
      set-name: eth_lan0

```

## Ethernet Interface settings

ethtool is a program that displays and changes Ethernet card settings such as auto-negotiation, port speed, duplex mode, and Wake-on-LAN. The following is an example of how to view the supported features and configured settings of an Ethernet interface.

```bash
ssh brent@reports13
sudo ethtool eno1

Settings for eno1:
 Supported ports: [ TP ]
 Supported link modes:   10baseT/Half 10baseT/Full
                         100baseT/Half 100baseT/Full
                         1000baseT/Full
 Supported pause frame use: No
 Supports auto-negotiation: Yes
 Supported FEC modes: Not reported
 Advertised link modes:  10baseT/Half 10baseT/Full
                         100baseT/Half 100baseT/Full
                         1000baseT/Full
 Advertised pause frame use: No
 Advertised auto-negotiation: Yes
 Advertised FEC modes: Not reported
 Speed: 1000Mb/s
 Duplex: Full
 Auto-negotiation: on
 Port: Twisted Pair
 PHYAD: 1
 Transceiver: internal
 MDI-X: off (auto)
 Supports Wake-on: pumbg
 Wake-on: g
        Current message level: 0x00000007 (7)
                               drv probe link
 Link detected: yes

sudo ethtool eth4
Settings for eth4:
    Supported ports: [ FIBRE ]
    Supported link modes:   10000baseT/Full
    Supported pause frame use: No
    Supports auto-negotiation: No
    Supported FEC modes: Not reported
    Advertised link modes:  10000baseT/Full
    Advertised pause frame use: No
    Advertised auto-negotiation: No
    Advertised FEC modes: Not reported
    Speed: 10000Mb/s
    Duplex: Full
    Port: FIBRE
    PHYAD: 0
    Transceiver: internal
    Auto-negotiation: off
    Supports Wake-on: d
    Wake-on: d
    Current message level: 0x00000014 (20)
                   link ifdown
    Link detected: yes
```

## IP addressing

The following section describes the process of configuring your system’s IP address and default gateway needed for communicating on a local area network and the Internet.

Temporary IP address assignment
For temporary network configurations, you can use the ip command which is also found on most other GNU/Linux operating systems. The ip command allows you to configure settings which take effect immediately – however they are not persistent and will be lost after a reboot.

To temporarily configure an IP address, you can use the ip command in the following manner. Modify the IP address and subnet mask to match your network requirements.

```bash
sudo ip addr add 10.102.66.200/24 dev enp0s25

# The ip can then be used to set the link up or down.
ip link set dev enp0s25 up
ip link set dev enp0s25 down

# To verify the IP address configuration of enp0s25, you can use the ip command in the following manner:

ip address show dev enp0s25
10: enp0s25: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:16:3e:e2:52:42 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.102.66.200/24 brd 10.102.66.255 scope global dynamic eth0
       valid_lft 2857sec preferred_lft 2857sec
    inet6 fe80::216:3eff:fee2:5242/64 scope link
       valid_lft forever preferred_lft forever6
```
