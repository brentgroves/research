# Multiple IPs

## references

<https://askubuntu.com/questions/1432883/how-to-create-sub-interface>

## IPRoute2

Netplan does not have aliases ("sub-interface" per your wording) but does allow labeling of interfaces.

## The long answer

I, too, was looking for something like this. There are a few things to parse out here.

First, a "sub-interface" is, strictly speaking, an interface alias and they are now "obsolete". Per: <https://www.kernel.org/doc/html/latest/networking/alias.html>

IP-aliases are an obsolete way to manage multiple IP-addresses/masks per interface. Newer tools such as iproute2 support multiple address/prefixes per interface, but aliases are still supported for backwards compatibility.

At this fundamental level, aliases are supported by the Linux kernel. However, I believe the ability to create aliases for interfaces comes from older network configuration tools like ifconfig and route

Second, the iproute2 package and its utilities are the modern approach to network configuration. It allows assigning multiple addresses to an interface without the need for aliases.

Third, netplan, it is yet another new approach to configuring networks and interfaces, via yaml files.

Specific to your question, you will wind up defining different routes per IP address on your interface. Netplan DOES provide labeling of interfaces but I don't believe this is necessary for you to achieve your goals. (From the documentation)

```yaml
ethernets:
enp3s0:
  addresses:
    - 10.100.1.37/24
    - 10.100.1.38/24:
        label: "enp3s0:0"
    - 10.100.1.39/24:
        label: "enp3s0:some-label"
```

<https://netplan.readthedocs.io/en/stable/examples/#how-to-use-multiple-addresses-on-a-single-interface>

NB! In netplan configs, gateway4 is deprecated, so use routes as displayed in the documentation. (It doesn't error, yet, but it does give warnings.)

<https://netplan.readthedocs.io/en/stable/examples/#how-to-use-multiple-addresses-with-multiple-gateways>

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp3s0:
      addresses:
        - 10.0.0.10/24
        - 11.0.0.11/24
      routes:
        - to: default
          via: 10.0.0.1
          metric: 200
        - to: default
          via: 11.0.0.1
          metric: 300
```

Further reading, links specific to adding multiple addresses on a loopback, just in case someone comes looking.

<https://bugs.launchpad.net/ubuntu/+source/netplan.io/+bug/1968287>

<https://github.com/canonical/netplan.io/pull/225>

```yaml
renderer: networkd
ethernets:
  lo:
    match:
        name: lo
    addresses: [ "127.0.0.1/8", "::1/128", "7.7.7.7/32" ]
```

cat /etc/netplan/00-installer-config.yaml

```yaml
# This is the network config written by 'subiquity'
network:
  ethernets:
    eno1:
      addresses:
      - 10.1.0.112/22
      nameservers:
        addresses:
        - 10.1.2.69
        - 172.20.88.20
        search: []
      routes:
      - to: default
        via: 10.1.1.205
  version: 2
```

3.Configure the Network Interface:

In the configuration file, specify the network interface (ens18 in this case) and add the additional IP addresses using the "addresses" key.

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens18:
      dhcp4: no
      addresses:
        - 192.168.1.22/24
        - 192.168.1.23/24
        - 192.168.1.24/24
      routes:
        - to: default
          via: 192.168.1.101
      nameservers:
          addresses: [8.8.8.8, 8.8.4.4]
```

In this example, we've added three IP addresses (192.168.1.22, 192.168.1.23, and 192.168.1.24) to the "ens18" interface. Replace the IP addresses, subnet masks, gateway, and DNS servers with your specific network configuration.

Press CTRL+O followed by CTRL+X to save the file and close it.

4.Validate Configuration File:

Please be mindful that Netplan uses YAML (Yet Another Markup Language) for its configuration syntax, and YAML is highly sensitive to whitespace and indentation.

Incorrect indentation can lead to errors or misconfigurations. A common practice is to use spaces (typically 2 or 4) for indentation rather than tabs to maintain consistency.

When editing a Netplan configuration file:

Be consistent with the number of spaces you use for indentation at each level.
Avoid using tabs. If you're using an editor like nano, you can configure it to replace tabs with spaces for consistency.

Before applying any changes, always validate the configuration using the command:

$ sudo netplan try

WARNING:root:Cannot call Open vSwitch: ovsdb-server.service is not running.

This command allows you to test the configuration, and if there's an error, it will revert to the previous working configuration after a timeout.

5.Apply the Configuration:

After saving your changes to the Netplan configuration file, apply the configuration by running:

$ sudo netplan apply

6. Verify the Configuration:

To confirm that the additional IP addresses have been assigned to the network interface, you can use the ip addr command:

$ ip addr show ens18

ip addr show enp0s25
2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 98:90:96:c3:f4:83 brd ff:ff:ff:ff:ff:ff
    altname enp0s25
    inet 10.1.0.112/22 brd 10.1.3.255 scope global eno1
       valid_lft forever preferred_lft forever
    inet6 fe80::9a90:96ff:fec3:f483/64 scope link
       valid_lft forever preferred_lft forever

That's it! You have successfully assigned multiple IP addresses to a network interface using Netplan in Linux. Make sure to adjust the configuration to match your specific network requirements and naming conventions.

You can verify if all IPs are working by pinging them.

$ ping -c 3 192.168.1.22
$ ping -c 3 192.168.1.23
$ ping -c 3 192.168.1.24

2. Configure Multiple IP Addresses using nmcli Command
nmcli is a command-line tool for managing NetworkManager, which is commonly used for network configuration on Linux systems.

To assign multiple IP addresses to a network interface using the nmcli command in Linux, you can follow these steps.

1. List Network Connections:

Use the following command to list the available network connections managed by NetworkManager:

```bash
nmcli connection show
NAME                UUID                                  TYPE      DEVICE          
Wired connection 1  c031620b-0f27-3dea-9352-8b45b7a8b2ea  ethernet  enp0s25         
br-860dc0d9b54b     3e8d6b8a-0a46-4504-8bae-4e223f79d348  bridge    br-860dc0d9b54b 
br-924b3db7b366     08c847a4-7626-4886-b0de-b8bf9fa61506  bridge    br-924b3db7b366 
br-b543cc541f49     9732b497-852a-469b-b79f-e205b93cd40a  bridge    br-b543cc541f49 
br-ef440bd353e1     9fafab6f-2991-4201-9a56-751526d17f67  bridge    br-ef440bd353e1 
docker0             2ffc3d02-34e6-4ce9-bee6-20c82ab5ff60  bridge    docker0 
```

Identify the network connection you want to configure with multiple IP addresses. Note the name of the connection; it is often named something like 'Wired connection 1", "eth0" or "ens18."

2.Add Additional IP Addresses:

You can add multiple IP addresses to the chosen network connection using the nmcli command. Replace connection-name with the name of your network connection.

$ sudo nmcli connection modify 'Wired connection 1' +ipv4.addresses "192.168.1.22/24,192.168.1.23/24,192.168.1.24/24"

In the command above, we are adding three IP addresses (192.168.1.22, 192.168.1.23, and 192.168.1.24) with a subnet mask of /24 to the specified network connection.

3. Apply the Changes:

Apply the changes to the network configuration by restarting the network connection:

$ sudo nmcli connection down 'Wired connection 1'
$ sudo nmcli connection up 'Wired connection 1'

Replace connection-name with the name of your network connection.

4. Verify the Configuration:

To confirm that the additional IP addresses have been assigned to the network interface, you can use the ip addr or nmcli connection show command:

$ nmcli con show 'Wired connection 1'

This command should display the network interface with the added IP addresses.

Your network connection should now have multiple IP addresses assigned to it using nmcli. Make sure to adjust the configuration to match your specific network requirements and the name of your network connection.

3. Set Multiple IP Addresses using nmtui Utility
The nmtui is a terminal-based user interface tool that allows you to manage network configurations on systems using NetworkManager.

1. Install nmtui (if not already installed):

Depending on your Linux installation, nmtui might not be installed by default. You can install it using the following commands:

$ sudo apt update
$ sudo apt install network-manager

2. Launch nmtui:

Simply type the command: $ sudo nmtui

3. Navigate the nmtui menu:

Use the arrow keys to navigate and the Enter key to make selections. Highlight the "Edit a connection" option and press Enter.

![](https://ostechnix.com/wp-content/uploads/2023/10/Choose-Edit-Option-and-Press-Enter.png)
<https://ostechnix.com/how-to-assign-multiple-ip-addresses-to-single-network-card-in-linux/>

...

## Conclusion

To sum it up, you can give a single network card multiple IP addresses in Linux. This is handy when you want different parts of your network to talk to each other, or when you have various services that need separate addresses.

Assigning multiple IP addresses to a single network interface in Linux can be useful for a variety of purposes, such as load balancing, high availability, security, and network segmentation.

Just remember to keep the addresses in the same group (like Class C) so they can communicate, and set up the right routes and gateways for smooth communication.
