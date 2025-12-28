# **[Networkd](https://launchpad.net/netplan)**

**[Back to Research List](../../research_list.md)**\
**[Back to Networking Menu](./networking_menu.md)**\
**[Back to Current Status](../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../README.md)**

systemd-networkd.service, systemd-networkd — Network manager

## Synopsis

systemd-networkd.service

/usr/lib/systemd/systemd-networkd

## Description

systemd-networkd is a system service that manages networks. It detects and configures network devices as they appear, as well as creating virtual network devices.

To configure low-level link settings independently of networks, see systemd.link(5).

systemd-networkd will create network devices based on the configuration in systemd.netdev(5) files, respecting the [Match] sections in those files.

systemd-networkd will manage network addresses and routes for any link for which it finds a .network file with an appropriate [Match] section, see systemd.network(5). For those links, it will flush existing network addresses and routes when bringing up the device. Any links not matched by one of the .network files will be ignored. It is also possible to explicitly tell systemd-networkd to ignore a link by using Unmanaged=yes option, see systemd.network(5).

When systemd-networkd exits, it generally leaves existing network devices and configuration intact. This makes it possible to transition from the initrd and to restart the service without breaking connectivity. This also means that when configuration is updated and systemd-networkd is restarted, netdev interfaces for which configuration was removed will not be dropped, and may need to be cleaned up manually.

systemd-networkd may be introspected and controlled at runtime using networkctl(1).

## Configuration Files

The configuration files are read from the files located in the system network directory /usr/lib/systemd/network, the volatile runtime network directory /run/systemd/network and the local administration network directory /etc/systemd/network.

Networks are configured in .network files, see systemd.network(5), and virtual network devices are configured in .netdev files, see systemd.netdev(5).

## **[How to tell if networkd is running](https://unix.stackexchange.com/questions/640658/determine-current-networking-manager-being-used-on-linux#:~:text=Ubuntu%20(%20and%20Debian%20)%20uses%20NetworkManager,running%20and%20managing%20any%20interfaces.)**

Ubuntu ( and Debian ) uses NetworkManager by default but also has ifupdown installed by default if you want to configure /etc/network/interfaces. Running networkctl will tell you whether systemd-networkd is running and managing any interfaces

```bash
# Networkd is running on ubuntu 22.04 server but not on Ubuntu 22.04 desktop
ssh brent@reports11
networkctl
IDX LINK            TYPE     OPERATIONAL SETUP     
  1 lo              loopback carrier     unmanaged
  2 enp0s31f6       ether    routable    configured
  9 vxlan.calico    vxlan    routable    unmanaged
 43 calid91e40e752c ether    degraded    unmanaged
 46 cali56b95e837c6 ether    degraded    unmanaged
 47 cali92441034b36 ether    degraded    unmanaged
 48 cali7b9b66e0016 ether    degraded    unmanaged
 49 cali715c7bde611 ether    degraded    unmanaged

cat /etc/netplan/00-installer-config.yaml 
# This is the network config written by 'subiquity'
network:
  ethernets:
    enp0s31f6:
      addresses:
      - 10.1.0.110/22
      nameservers:
        addresses:
        - 10.1.2.69
        - 172.20.88.20
        search: []
      routes:
      - to: default
        via: 10.1.1.205
  version: 2


ssh brent@reports-alb
networkctl
WARNING: systemd-networkd is not running, output will be incomplete.

IDX LINK            TYPE     OPERATIONAL SETUP    
  1 lo              loopback n/a         unmanaged
  2 enp0s25         ether    n/a         unmanaged
  3 mpqemubr0       bridge   n/a         unmanaged
  4 tap-d951e26a898 ether    n/a         unmanaged
  5 br-860dc0d9b54b bridge   n/a         unmanaged
  6 docker0         bridge   n/a         unmanaged
  7 br-924b3db7b366 bridge   n/a         unmanaged
  8 br-b543cc541f49 bridge   n/a         unmanaged
  9 br-ef440bd353e1 bridge   n/a         unmanaged

9 links listed.

ssh brent@repsys11
networkctl
WARNING: systemd-networkd is not running, output will be incomplete.

IDX LINK        TYPE     OPERATIONAL SETUP    
  1 lo          loopback n/a         unmanaged
  2 enp66s0f0   ether    n/a         unmanaged
  3 enp66s0f1   ether    n/a         unmanaged
  4 eno1        ether    n/a         unmanaged
  5 enp66s0f2   ether    n/a         unmanaged
  6 enp66s0f3   ether    n/a         unmanaged
  7 eno2        ether    n/a         unmanaged
  8 eno3        ether    n/a         unmanaged
  9 eno4        ether    n/a         unmanaged
 10 docker0     bridge   n/a         unmanaged
 11 mpbr0       bridge   n/a         unmanaged
 12 br-eno1     bridge   n/a         unmanaged
 26 localbr     bridge   n/a         unmanaged
 27 tapd7333b8f ether    n/a         unmanaged
 28 tap50c73101 ether    n/a         unmanaged
 29 tapd789600c ether    n/a         unmanaged

16 links listed.

```
