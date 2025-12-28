# **[TUN/TAP Demystified](https://floating.io/2016/05/tuntap-demystified/)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

![tt](https://floating.io/2016/05/tuntap-demystified/concept-medium.png)

## reference

- **[tun_tap device in golang](https://snippet.build4.fun/posts/005_tun_in_go/)**
- Linux Kernel - Documentation/networking/tuntap.txt
- Linux Kernel - drivers/net/tun.c
- Linux Kernel - include/uapi/linux/if_tun.h
- Let’s code a TCP/IP stack, 1: Ethernet & Arp

Have you ever wondered what the Linux TUN/TAP driver is for? Wonder no more! After spending most of last weekend tweaking the NuttX Simulator network support, I now have a pretty good idea of what TUN/TAP is, what it’s useful for, and how it works.

Might as well pass it on, right?

## What Is TUN/TAP?

The Linux TUN/TAP driver is primarily designed to support network tunnels. In the Linux source, Documentation/networking/tuntap.txt has this to say:

TUN/TAP provides packet reception and transmission for user space programs. It can be seen as a simple Point-to-Point or Ethernet device, which, instead of receiving packets from physical media, receives them from user space program and instead of sending packets via physical media writes them to the user space program.

To put the matter more simply, the TUN/TAP driver creates a virtual network interface on your Linux box. This interface works just like any other; you can assign IP addresses, route to it, and so on. But when you send traffic to that interface, the traffic is routed to your program instead of to a real network. If your program sends traffic back, it’s handled by the interface just as though it came from a real network.

Each TUN/TAP device has two ends, which we’ll call the “far end” (which terminates on the Linux host), and the “near end” (which terminates at the file descriptor you use to talk to the device). Essentially, you’ve created a network interface on the Linux host, a network interface in your application, and a transmission medium that runs between the two.

But why on Earth would anyone other than developers of VPN software care about something like this?

## Use Cases

The TUN/TAP driver is far more useful than one would expect. Use cases may include:

- **VPN Tunnels** - As previously discussed, you can use it in order to funnel network traffic through to another location.
- **Protocol Development** - If you’re developing a new network protocol, this can allow you to perfect it without writing a kernel-mode driver.
- **Virtualization** - Virtualization platforms like qemu can use it to provide “real” network interfaces for the virtual machines they host.

It’s the latter case that I’m most interested in, because this is also how RTOS platforms like Contiki or NuttX allow you to simulate networked devices under Linux.

But how do you use it?

## Usage Overview

In general, using TUN/TAP devices is surprisingly simple. There are a lot of advanced features, but you’ll need to read the actual documentation for more on that. We’re only going to cover the basics here.

The general workflow looks like this:

- Open /dev/net/tun.
- Call the TUNSETIFF ioctl to select the device mode and options.
- Read packets from, and write packets to, the file descriptor.
- Close the device.

It’s really that simple – but, as always, the devil is in the details.

## TUN Mode

The first of the two modes for the TUN/TAP driver is TUN mode, of course.

When you place the TUN/TAP device in TUN mode, the data you’ll receive from the file descriptor will be in the form of network protocol packets. For example, if your network is based on IP, you’ll receive IPv4 or IPv6 packets. When you write data back to the device, it must also be in the form of valid protocol packets.

This is the primary mode in which VPN tunnels operate, for obvious reasons. It’s a fairly simple matter to take in a packet, ship it over some other network connection, and spit it out on a similar TUN device on a remote machine. The hard part of VPNs isn’t moving the packets around; it’s how to do so securely, which is left up to the developer.

I can also see some other odd use cases for this; for example, if you needed something that could simulate real network traffic for debugging or load testing purposes. If you had a good algorithm for it (not unlike an NPC AI in a video game, I’d guess), then you could create fake traffic and send it over a TUN connection. It would look like real IP traffic as far as the host system is concerned.

The nice thing about TUN interfaces is that you don’t have to worry about lower-level issues like ARP.

## TAP Mode

TAP mode, on the other hand, is much more interesting to developers of virtualization solutions. It operates in much the same way as TUN mode, but with one major exception: you get raw ethernet frames instead of protocol packets. As far as the kernel is concerned, your application is just another ethernet device.

If you’re actually processing these packets instead of just shipping them somewhere else, that means that you have to handle everything, including things like ARP requests and replies. The applications that consume TAP devices most often implement their own protocol stacks, and they don’t want the host interfering with their interpretation of things. The TAP device provides the virtualized ethernet connection.

## Device Options

When calling TUNSETIFF, there are several options that can be specified (and more besides, but they’re too advanced to cover in this article):

- IFF_TUN - Allocate the device in TUN mode.
- IFF_TAP - Allocate the device in TAP mode.
- IFF_NO_PI - Do not prepend a protocol information header.

The first two are obvious; set **IFF_TUN** if you want a TUN device, or **IFF_TAP** if you want a TAP. **IFF_NO_PI**, on the other hand, is a bit less obvious, and important to understand.

Without IFF_NO_PI, the driver will send you two bytes of flags, two bytes of protocol type, and then the actual network packet that the header corresponds with. Since the first two values are largely redundant, most applications will probably want to set this flag. I could be wrong about this, however; documentation on the TUN/TAP driver is poor, to say the least.

There are a number of other advanced features supported (such as IFF_MULTI_QUEUE), but the documentation is extremely slim, and they’re not needed for a basic use case, which is all I’m intending to cover here.

## Opening the Device

Before you can do anything, you need to open the device. As I mentioned in the overview, this is as as simple as opening the /dev/net/tun device file:

```c
int tapfd = open("/dev/net/tun", O_RDWR);
if (tapfd < 0) {
  perror("open");
  return; // Or otherwise handle the error.
}
```

This is nothing you’re not familiar with; no special flags are needed, or anything of that sort. Once you have the tap file descriptor (tapfd in the example), you can move on to setting the mode and options.

## Setting the Mode

The mode and options are set with a simple ioctl() call:

```c
#include <linux/if.h>
#include <linux/if_tun.h>

// ...
  struct ifreq ifr;

  // Set up the ioctl request
  memset(&ifr, 0, sizeof(ifr));
  ifr.ifr_flags = IFF_TAP | IFF_NO_PI;

  // Call the ioctl
  int err = ioctl(tapfd, TUNSETIFF, (void *)&ifr);
  if (err < 0) {
    perror("ioctl");
    return; // Or otherwise handle the error.
  }
// ...
```

And that’s it. Once this is done, you’re ready to use your shiny new tun/tap device.

## Sending and Receiving

After the ioctl() call, your file descriptor can be used just like any other. Send and receive are analogous to write and read, respectively:

```c
// Write a packet to the network.
//
// Returns 0 on success, or a negative error number on error.
int send_data(int tapfd, char *packet, int len) {
  int wlen;

  wlen = write(tapfd, packet, len);
  if (wlen < 0) {
    perror("write");
  }

  return wlen;
}

// Read a packet from the network.
//
// Returns the packet size on successful read, or a negative error number on error.
int receive_data(int tapfd, char *packet, int bufsize) {
  int len;

  len = read(tapfd, packet, bufsize);
  if (len < 0) {
    perror("read");
  }

  return len;
}

```

It’s so simple that the functions are only adding error handling. They just wrap read and write. Simple, yes? Any operation that works on a non-seekable stream (poll() and select(), for example) should work just fine on the TUN/TAP file descriptor.

## Routing Traffic

Okay, so you have an application that opens a tap device, and you’re not seeing any traffic. The far end of your tunnel is the same as any other network interface under Linux, so all the standard network principles apply.

For example, let’s say that you’ve got an application that implements an IPv4 stack. It has the IP address 10.0.0.42, and the TUN/TAP device it allocated is called tap0. Your host system is 10.0.0.3. The simplest way for your host system to talk to your tap device is with a host route:

```bash
# route add -host 10.0.0.42 tap0
```

If you now ping (or send other traffic to) 10.0.0.42, it will hit the routing table, see that route, and get routed over the tap interface. Piece of cake for simple applications. Unfortunately, this doesn’t do anything for you if you want your application to talk to the rest of the network (unless you go overboard and set up your Linux box as a router, of course).

So what if you want that?

## There are two main solutions to this problem

1. NAT - If you’re dealing with IP networking, you’re almost certainly familiar with NAT. The iptables facility can enable you to map traffic from an IP (or alias) on your host machine directly to the IP used by the application that owns the tap interface. This can also get complicated, however.

2. Bridging - You can use the Linux bridge facility to put your application directly on the network the host is attached to.

My preference is for the latter solution. The nice thing about it is, once you have it set up you can run as many tap devices as you want on the same bridge. That means you only have to do it once.

To accomplish this, you might get on your system console and do something like this (note that you’ll need the bridge-utils package for brctl, at least under RedHat and friends):

```bash
# brctl addbr bridge0
# ifconfig bridge0
# brctl addif bridge0 eth0
```

Once done, your system will work like it normally does – but now you’ll be able to add other interfaces (including TUN/TAP devices) to the bridge. They will see any and all network traffic that appears there (say, from eth0). Makes running multiple instances easy, right?

How to set this up at startup is beyond the scope of this article. See your platform’s documentation for more information.

## Common Misconceptions

- An IP Address Is Required On The TAP Interface - This is absolutely false in TAP mode. If you add an IP address to the the interface on the host side, it is (literally) the same as adding another IP address to your system. Instead of being available to the general network, though, it’s accessible to the application on the other end of the tunnel. There are use cases – especially where routing and tunneling are concerned – but if you just want your application to be able to talk to the local host system, you’re better off with a host route. It’s less to manage.

- Hardware Address Ownership - I’ve seen some applications that use an ioctl call to get the hardware address of the TAP interface, and then attempt to use that address as the source of packets sent back over the tunnel. This is invalid! That hardware address belongs to the far end (the Linux host), not the near end. If you do this, you’ll have all manner of hard-to-debug problems. The correct method is to set or generate a unique MAC address for your application.
That’s all I can think of for now.

## Conclusion

As you can see, using the TUN/TAP device is quite straightforward. There’s no mucking about with all the vagaries of writing kernel code. You simply open it, set it up, and exchange data with it.

As I mentioned, I spent most of last weekend (and a couple of evenings this week) sorting out the networking code in the NuttX simulator arch, and the tap device was the easy part. Most of the difficulty was in understanding the NuttX device model and making my features work with it. The actual network communication is a piece of cake.
