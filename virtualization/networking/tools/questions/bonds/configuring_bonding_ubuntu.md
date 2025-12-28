# **[Configuring Bonding on Ubuntu with Netplan](https://netrouting.com/knowledge_base/configuring-bonding-on-ubuntu-with-netplan/)**

Link Aggregation Control Protocol (LACP) allows you to combine multiple network interfaces into a single logical interface, providing redundancy and increased bandwidth. Netplan, the network configuration utility on Ubuntu, makes it straightforward to set up LACP bonding. This tutorial will guide you through the steps to configure LACP bonding on Netrouting Bare Metal Dedicated Servers using Netplan on Ubuntu.

## Prerequisites

- Ubuntu 18.04 or later
- At least two network interfaces available for bonding
- Administrative (root) access to the system

Step 1: Pre-Installation Checkup
Identify the network interfaces you want to bond. You can list all available network interfaces using:

```bash
ip link show
```

For this tutorial, we’ll assume eno1 and eno2 are the interfaces to be bonded.

## Step 2: Remove Existing Netplan Configurations

Before creating a new Netplan configuration, remove any existing configurations to avoid conflicts.

```bash
sudo rm /etc/netplan/*.yaml
```

## Step 2: Create Netplan Configuration File

Netplan configuration files are located in /etc/netplan/. Create a new configuration file or edit an existing one. For this example, we’ll create a file named 17-bonding.yaml.

```bash
sudo nano /etc/netplan/17-bonding.yaml
```

The file numbering is only relevant when you maintain multiple yaml files on the server. Netplan files are executed in alphanumeric order based on their filenames. This means that the configuration files in /etc/netplan/ are applied in the order dictated by their names. Typically, filenames include a numerical prefix to ensure the desired order of execution. For example, a file named 00-netcfg.yaml will be applied before a file named 01-netcfg.yaml. A common use case for wanting to separate your configuration could be with cloud based images where configuration files are dynamically updated via cloud-init. In most cases, you’ll want your custom configuration to be the last file to be applied (highest number).

## Step 3: Define the Bonded Interface

Add the following configuration to bond eno1 and eno2 using LACP:

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eno1:
      dhcp4: no
    eno2:
      dhcp4: no
  bonds:
    bond0:
      interfaces:
        - eno1
        - eno2
      addresses:
        - 192.168.1.100/24
      gateway4: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
      parameters:
        mode: 802.3ad
        lacp-rate: fast
        mii-monitor-interval: 100
```

NOTE: Netplan uses YAML syntax and does not support tabs, indentation is created with use of spaces only and inconsistent indentation will cause errors in your Netplan configuration

## Step 4: Test the Configuration

Before applying the Netplan configuration, it’s important to test it to ensure there are no syntax errors.

```bash
sudo netplan try
```

This command will test the configuration and prompt you to accept or revert the changes. If the configuration is correct, you can proceed to apply it.

## Step 5: Apply the Configuration

If the configuration test is successful, apply the Netplan configuration to activate the bonded interface.

```bash
sudo netplan apply
```

This command will test the configuration and prompt you to accept or revert the changes. If the configuration is correct, you can proceed to apply it.

## Step 6: Verify the Bonding Configuration

After applying the configuration, verify the bonding setup:

```bash
ip a show bond0
```

You should see bond0 with the configured IP address and the bonded interfaces (eno1 and eno2).

Additionally, check the bonding status:

```bash
cat /proc/net/bonding/bond0
```

This command provides detailed information about the bonding interface, including the active interfaces and their statuses.

## Best Practices

Ensure Service Compatibility: Our Bare Metal Dedicated Servers are not LACP enabled by default. Before setting up LACP, verify that your Netrouting Service is LACP supported and configured correctly to work with bonded interfaces.

Consistent Configuration: Ensure that the same LACP configuration is applied exactly as described to ensure compatibility with Netrouting Bare Metal Dedicated Servers. For other use cases, different settings may apply.

Monitor Interface Health: Regularly check the health of the bonded interfaces using tools like ethtool and cat /proc/net/bonding/bond0 to ensure they are functioning as expected.

Update System Regularly: Keep your Ubuntu system and Netplan up to date with the latest patches and updates to ensure stability and security.

Backup Configuration: Always backup your existing Netplan configuration files before making changes. This way, you can quickly revert if something goes wrong.

For users on Netrouting Service the following is implemented by default:

- Use High-Quality Cables: Use of high-quality network cables to reduce the risk of physical layer issues that could affect the bonded interfaces.
- Network Redundancy: Consider using interfaces connected to different switches for better redundancy, which can protect against switch failure.
