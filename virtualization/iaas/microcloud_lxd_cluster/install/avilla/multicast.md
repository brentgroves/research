# avilla

## **[Trust establishment session](https://documentation.ubuntu.com/microcloud/latest/microcloud/explanation/initialization/#trust-establishment-session)**

To allow several instances of MicroCloud joining the final cluster, in both the interactive and non-interactive method each instance is running one half of the trust establishment session to trust the other side.

Each trust establishment session has one initiator and one to many joiners. In case of the interactive mode the side which runs the microcloud init command becomes the initiator. The other side becomes the joiner by running microcloud join. In the non-interactive mode the initiator is being defined either using the initiator or initiator_address configuration key.

## **[Automatic server detection](https://documentation.ubuntu.com/microcloud/latest/microcloud/explanation/initialization/#automatic-server-detection)**

If required MicroCloud uses multicast discovery to automatically detect a so called initiator on the network. This method works in physical networks, but it is usually not supported in a cloud environment. Instead you can specify the address of the initiator instead to not require using multicast.

The scan is limited to the local subnet of the network interface you select when choosing an address for MicroCloud’s internal traffic (see Network interface for intra-cluster traffic).

Repeat these steps on all micro1,micro2,micro3.

```bash
sudo snap install lxd --channel=5.21/stable --cohort="+"
snap install microceph --channel=squid/stable --cohort="+"
snap install microovn --channel=24.03/stable --cohort="+"
snap install microcloud --channel=2/stable --cohort="+"
```

Note

The --cohort="+" flag in the command ensures that the same version of the snap is installed on all machines. See Keep cluster members in sync for more information.

## Initialize MicroCloud

We use the micro1 VM to initialize MicroCloud in the instructions below, but you can use any of the four VMs.

Complete the following steps:

Access the shell in micro1 and start the initialization process:

```bash
ssh brent@micro11
microcloud init
```

Answer the questions:

Select yes to select more than one cluster member.

As the address for MicroCloud’s internal traffic, select the listed IPv4 address.

```bash
Select an address for MicroCloud's internal traffic:
Space to select; enter to confirm; type to filter results.
Up/down to move; right to select all; left to select none.
       +----------------+-------+
       |    ADDRESS     | IFACE |
       +----------------+-------+
> [ ]  | 10.188.50.201  | br0   |
  [ ]  | 10.188.220.201 | br1   |
  [ ]  | 10.187.220.201 | br2   |
       +----------------+-------+
```

Copy the session passphrase.
`wanderer dentist popcorn equipment`

Head to the other machines (micro2, micro3, and micro4) and start the join process on each:

```bash
ssh brent@micro1x
microcloud join
sudo microcloud join
Waiting for services to start ...
Select an address for MicroCloud's internal traffic:
Space to select; enter to confirm; type to filter results.
Up/down to move; right to select all; left to select none.
       +----------------+-------+
       |    ADDRESS     | IFACE |
       +----------------+-------+
> [x]  | 10.188.50.202  | br0   |
  [ ]  | 10.188.220.202 | br1   |
  [ ]  | 10.187.220.202 | br2   |
       +----------------+-------+
Error: Failed to find an eligible system: Failed to lookup eligible system: Failed to read from multicast network endpoint: Lookup timeout exceeded

```

Size in GiB of the new loop device (1GiB minimum)

Enter 100GB

What IPv4 address should be used? (CIDR subnet notation, “auto” or “none”)

Enter 10.188.50.0/24.

What IPv6 address should be used? (CIDR subnet notation, “auto” or “none”)

Enter fd42:1:1234:1234::1/64.

Create a ZFS storage pool called disks:

`lxc storage create disks zfs size=200GiB`
