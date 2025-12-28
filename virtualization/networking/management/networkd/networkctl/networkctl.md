# **[networkctl](https://www.tecmint.com/networkctl-check-linux-network-interface-status/)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Networking Menu](../networking_menu.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

## check systemd-networkd

Note: Before running networkctl, ensure that systemd-networkd is running, otherwise you will get incomplete output indicated by the following error.

You can check the status of systemd-networkd by running the following systemctl command.

```bash
sudo systemctl status systemd-networkd
```

If systemd-networkd is not running, you can start, enable it to start at boot time, and verify the status using the following commands.

```bash
sudo systemctl start systemd-networkd
sudo systemctl enable systemd-networkd
sudo systemctl status systemd-networkd
```

## Listing Network Connections in Linux

To get the status information about your all network connections, run the following networkctl command without any argument.

```bash
networkctl
```

The above command will list all the network interfaces along with their statuses.

![](https://www.tecmint.com/wp-content/uploads/2018/07/Check-Network-Connection-Status.png)

In the above output, you can see three network interfaces: lo (loopback), enp7s0 (Ethernet), and virbr0 (virtual network). Each interface has information about its index (IDX), name (LINK), type, operational status, and setup status.

## Listing Active Network Connections in Linux

To display information about the specified links, such as type, state, kernel module driver, hardware and IP address, configured DNS, server, and more, use the status command. If you don’t specify any links, routable links are shown by default.

```bash
networkctl status
```

![](https://www.tecmint.com/wp-content/uploads/2018/07/Check-All-Network-Connection-Status.png)

To list various details of specific network interface called enp7s0, you can run the following command, which will list network configuration files, type, state, IP addresses (both IPv4 and IPv6), broadcast addresses, gateway, DNS servers, domain, routing information, maximum transmission unit (MTU), and queuing discipline (QDisc).

```bash
networkctl status enp6s0

● 3: enp6s0
                   Link File: /usr/lib/systemd/network/99-default.link
                Network File: /run/systemd/network/10-netplan-extra0.network
                       State: routable (configured)
                Online state: online                                         
                        Type: ether
                        Path: pci-0000:06:00.0
                      Driver: virtio_net
                      Vendor: Red Hat, Inc.
                       Model: Virtio 1.0 network device
            Hardware Address: 5c:13:55:48:43:58
                         MTU: 1500 (min: 68, max: 65535)
                       QDisc: mq
IPv6 Address Generation Mode: eui64
    Number of Queues (Tx/Rx): 2/2
            Auto negotiation: no
                     Address: 10.13.31.13
                              fe80::5e13:55ff:fe48:4358
           Activation Policy: up
         Required For Online: yes
           DHCP6 Client DUID: DUID-EN/Vendor:0000ab11fa956945a47e6700

May 29 18:37:58 test1 systemd-networkd[715]: enp6s0: Link UP
May 29 18:37:58 test1 systemd-networkd[715]: enp6s0: Gained carrier
May 29 18:37:58 test1 systemd-networkd[715]: enp6s0: Configuring with /run/systemd/network/10-netplan-extra0.network.
May 29 18:37:58 test1 systemd-networkd[715]: enp6s0: DHCPv6 lease lost
May 29 18:38:00 test1 systemd-networkd[715]: enp6s0: Gained IPv6LL
May 30 06:36:09 test1 systemd-networkd[715]: enp6s0: DHCPv6 lease lost
May 30 06:36:09 test1 systemd-networkd[5396]: enp6s0: Link UP
May 30 06:36:09 test1 systemd-networkd[5396]: enp6s0: Gained carrier
May 30 06:36:09 test1 systemd-networkd[5396]: enp6s0: Gained IPv6LL
May 30 06:36:09 test1 systemd-networkd[5396]: enp6s0: Configuring with /run/systemd/network/10-netplan-extra0.network.
```

## Step 2 Edit the Netplan Configuration File

Netplan configuration files are stored in /etc/netplan/. You will find this file in the /etc/netplan directory. It might be named 01-netcfg.yaml, 50-cloud-init.yaml, or something similar, depending on your setup. Open or create a file for editing.

```bash
ls /etc/netplan
50-cloud-init.yaml

```

## before edits

```yaml
# This file is generated from information provided by the datasource.  Changes
# to it will not persist across an instance reboot.  To disable cloud-init's
# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    ethernets:
        eno1:
            addresses:
            - 10.1.0.125/22
            nameservers:
                addresses:
                - 10.1.2.69
                - 10.1.2.70
                - 172.20.0.39
                search: []
            routes:
            -   to: default
                via: 10.1.1.205
        eno2:
            dhcp4: true
        eno3:
            dhcp4: true
        eno4:
            dhcp4: true
        enp66s0f0:
            dhcp4: true
        enp66s0f1:
            dhcp4: true
        enp66s0f2:
            dhcp4: true
        enp66s0f3:
            dhcp4: true
    version: 2
```

## **[after edits](https://serverfault.com/questions/1150152/configuring-2nd-and-3rd-nic-on-ubuntu-22)**

multiple default routes can lead to conflicts

```yaml
# This file is generated from information provided by the datasource.  Changes
# to it will not persist across an instance reboot.  To disable cloud-init's
# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    ethernets:
        eno1:
            addresses:
            - 10.1.0.125/22
            nameservers:
                addresses:
                - 10.1.2.69
                - 10.1.2.70
                - 172.20.0.39
                search: []
            routes:
            -   to: default
                via: 10.1.1.205
        eno2:
            addresses:
            - 10.1.0.126/22
            nameservers:
                addresses:
                - 10.1.2.69
                - 10.1.2.70
                - 172.20.0.39
                search: []
        eno3:
            dhcp4: true
        eno4:
            dhcp4: true
        enp66s0f0:
            dhcp4: true
        enp66s0f1:
            dhcp4: true
        enp66s0f2:
            dhcp4: true
        enp66s0f3:
            dhcp4: true
    version: 2
```

## step 3 Secure Configuration File Permissions

It’s crucial to ensure that the Netplan configuration file permissions are secure to prevent unauthorized access.

```$ sudo chmod 600 /etc/netplan/01-netcfg.yaml```

## step 4

netplan  try takes a netplan(5) configuration, applies it, and automatically rolls it back
if the user does not confirm the configuration within a time limit.

A configuration can be confirmed or rejected interactively or by sending  the  SIGUSR1  or SIGINT signals.

This  may  be  especially  useful  on  remote  systems,  to prevent an administrator being permanently locked out of systems in the case of a network configuration error.

```bash
sudo netplan try
Problem encountered while validating default route consistency.Please set up multiple routing tables and use `routing-policy` instead.
Error: Conflicting default route declarations for IPv4 (table: main, metric: default), first declared in eno2 but also in eno1

```

Apply the Configuration Changes: Once you’ve edited the configuration file, apply the changes to update your network settings.
$ sudo netplan apply
