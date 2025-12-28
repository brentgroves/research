# Network **[Tap device](https://blog.cloudflare.com/virtual-networking-101-understanding-tap)**

**[Back to Research List](../../research_list.md)**\
**[Back to Networking Menu](./networking_menu.md)**\
**[Back to Current Status](../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../README.md)**

## Start Here

**[Create an instance with multiple network interfaces](https://multipass.run/docs/create-an-instance#heading--create-an-instance-with-multiple-network-interfaces)**

A tap device is a virtual network interface that looks like an ethernet network card. Instead of having real wires plugged into it, it exposes a nice handy file descriptor to an application willing to send/receive packets. Historically tap devices were mostly used to implement VPN clients. The machine would route traffic towards a tap interface, and a VPN client application would pick them up and process accordingly. For example this is what our Cloudflare WARP Linux client does. Here's how it looks on my laptop:

## references

<https://www.redhat.com/en/blog/introduction-virtio-networking-and-vhost-net>
<https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/virtualization_deployment_and_administration_guide/sect-virtual_networking-directly_attaching_to_physical_interface>

<https://blog.cloudflare.com/virtual-networking-101-understanding-tap>

```bash
ip link list
...
18: CloudflareWARP: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1280 qdisc mq state UNKNOWN mode DEFAULT group default qlen 500
 link/none

$ ip tuntap list
CloudflareWARP: tun multi_queue
```

More recently tap devices started to be used by virtual machines to enable networking. The VMM (like Qemu, Firecracker, or gVisor) would open the application side of a tap and pass all the packets to the guest VM. The tap network interface would be left for the host kernel to deal with. Typically, a host would behave like a router and firewall, forward or NAT all the packets. This design is somewhat surprising - it's almost reversing the original use case for tap. In the VPN days tap was a traffic destination. With a VM behind, tap looks like a traffic source.

A Linux tap device is a mean creature. It looks trivial — a virtual network interface, with a file descriptor behind it. However, it's surprisingly hard to get it to perform well. The Linux networking stack is optimized for packets handled by a physical network card, not a userspace application. However, over the years the Linux tap interface grew in features and nowadays, it's possible to get good performance out of it. Later I'll explain how to use the Linux tap API in a modern way.

## To tun or to tap?

The interface is called "the universal tun/tap" in the kernel. The "tun" variant, accessible via the IFF_TUN flag, looks like a point-to-point link. There are no L2 Ethernet headers. Since most modern networks are Ethernet, this is a bit less intuitive to set up for a novice user. Most importantly, projects like Firecracker and gVisor do expect L2 headers.

**[Frame – data link layer Ethernet Headers](https://en.wikipedia.org/wiki/Ethernet_frame)**

The header features destination and source MAC addresses (each six octets in length), the EtherType field and, optionally, an IEEE 802.1Q tag or IEEE 802.1ad tag.

"Tap", with the IFF_TAP flag, is the one which has Ethernet headers, and has been getting all the attention lately. If you are like me and always forget which one is which, you can use this  AI-generated rhyme (check out WorkersAI/LLama) to help to remember:

```rhyme
Tap is like a switch,
Ethernet headers it'll hitch.
Tun is like a tunnel,
VPN connections it'll funnel.
Ethernet headers it won't hold,
Tap uses, tun does not, we're told.
```

## Listing devices

Tun/tap devices are natively supported by **[iproute2 tooling](https://www.digitalocean.com/community/tutorials/how-to-use-iproute2-tools-to-manage-network-configuration-on-a-linux-vps)**. Typically, one creates a device with ip tuntap add and lists it with ip tuntap list:

```bash
$ sudo ip tuntap add mode tap user marek group marek name tap0
$ ip tuntap list
tap0: tap persist user 1000 group 1000
```

Alternatively, it's possible to look for the /sys/devices/virtual/net/<ifr_name>/tun_flags files.

```bash
ls /sys/devices/virtual/net
br-860dc0d9b54b  br-924b3db7b366  br-b543cc541f49  br-ef440bd353e1  docker0  lo
```

## Tap device setup

To open or create a new device, you first need to open /dev/net/tun which is called a "clone device":

```c
    /* First, whatever you do, the device /dev/net/tun must be
     * opened read/write. That device is also called the clone
     * device, because it's used as a starting point for the
     * creation of any tun/tap virtual interface. */
    char *clone_dev_name = "/dev/net/tun";
    int tap_fd = open(clone_dev_name, O_RDWR | O_CLOEXEC);
    if (tap_fd < 0) {
     error(-1, errno, "open(%s)", clone_dev_name);
    }
```

With the clone device file descriptor we can now instantiate a specific tap device by name:

```c
    struct ifreq ifr = {};
    strncpy(ifr.ifr_name, tap_name, IFNAMSIZ);
    ifr.ifr_flags = IFF_TAP | IFF_NO_PI | IFF_VNET_HDR;
    int r = ioctl(tap_fd, TUNSETIFF, &ifr);
    if (r != 0) {
     error(-1, errno, "ioctl(TUNSETIFF)");
    }
```

What is **[ioctl](https://embetronicx.com/tutorials/linux/device-drivers/ioctl-tutorial-in-linux/)**

IOCTL is referred to as Input and Output Control, which is used to talk to device drivers. This system call is available in most driver ...

If ifr_name is empty or with a name that doesn't exist, a new tap device is created. Otherwise, an existing device is opened. When opening existing devices, flags like IFF_MULTI_QUEUE must match with the way the device was created, or EINVAL is returned. It's a good idea to try to reopen the device with flipped multi queue setting on EINVAL error.

The ifr_flags can have the following bits set:

| IFF_TAP / IFF_TUN         | Already discussed.                                                                                                                                                  |
|---------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| IFF_NO_CARRIER            | Holding an open tap device file descriptor sets the Ethernet interface CARRIER flag up. In some cases it might be desired to delay that until a TUNSETCARRIER call. |
| IFF_NO_PI                 | Historically each packet on tap had a "struct tun_pi" 4 byte prefix. There are now better alternatives and this option disables this prefix.                        |
| IFF_TUN_EXCL              | Ensures a new device is created. Returns EBUSY if the device exists                                                                                                 |
| IFF_VNET_HDR              | Prepend "struct virtio_net_hdr" before the RX and TX packets, should be followed by setsockopt(TUNSETVNETHDRSZ).                                                    |
| IFF_MULTI_QUEUE           | Use multi queue tap, see below.                                                                                                                                     |
| IFF_NAPI / IFF_NAPI_FRAGS | See below.                                                                                                                                                          |

You almost always want IFF_TAP, IFF_NO_PI, IFF_VNET_HDR flags and perhaps sometimes IFF_MULTI_QUEUE.

## The curious IFF_NAPI

Judging by the original patchset introducing IFF_NAPI and IFF_NAPI_FRAGS, these flags were introduced to increase code coverage of syzkaller. However, later work indicates there were performance benefits when doing XDP on tap. IFF_NAPI enables a dedicated NAPI instance for packets written from an application into a tap. Besides allowing XDP, it also allows packets to be batched and GRO-ed. Otherwise, a backlog NAPI is used.

## A note on buffer sizes

Internally, a tap device is just a pair of packet queues. It's exposed as a network interface towards the host, and a file descriptor, a character device, towards the application. The queue in the direction of application (tap TX queue) is of size txqueuelen packets, controlled by an interface parameter:

```bash
 ip link set dev tap0 txqueuelen 1000
$ ip -s link show dev tap0
26: tap0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 ... qlen 1000
 RX:  bytes packets errors dropped  missed   mcast        
          0    0   0    0    0    0
 TX:  bytes packets errors dropped carrier collsns        
        266    3   0   66    0    
```

In "ip link" statistics the column "TX dropped" indicates the tap application was too slow and the queue space exhausted.

In the other direction - interface RX queue -  from application towards the host, the queue size limit is measured in bytes and controlled by the TUNSETSNDBUF ioctl. The qemu comment discusses this setting, however it's not easy to cause this queue to overflow. See this discussion for details.

<https://www.digitalocean.com/community/tutorials/how-to-use-iproute2-tools-to-manage-network-configuration-on-a-linux-vps>

## Network **[Tap](https://www.instructables.com/Make-a-Passive-Network-Tap/)**

Make a Passive Network Tap
Step 1: Parts. You will need: ...
Step 2: Tools. You will need a wire stripper and a screw driver.
Step 3: Strip Wire. Cut 5 inches of cat 5 cable, and pull out the 8 strands of wire.
Step 4: Wire the First Jack. ...
Step 5: Wire the Second Jack. ...
Step 6: Third Jack. ...
Step 7: Close It Up.
