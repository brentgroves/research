# **[What is an ARP table?](https://www.auvik.com/franklyit/blog/what-is-an-arp-table/)**

ARP (Address Resolution Protocol) is the protocol that bridges Layer 2 and Layer 3 of the OSI model, which in the typical TCP/IP stack is effectively gluing together the Ethernet and Internet Protocol layers. This critical function allows for the discovery of a devices’ MAC (media access control) address based on its known IP address.

By extension, an ARP table is simply the method for storing the information discovered through ARP. It’s used to record the discovered MAC and IP address pairs of devices connected to a network. Each device that’s connected to a network has its own ARP table, responsible for storing the address pairs that a specific device has communicated with.

ARP is critical network communication, so pairs of MAC and IP addresses don’t need to be discovered (and rediscovered) for every data packet sent. Once a MAC and IP address pair is learned, it’s kept in the ARP table for a specified period of time.  If there’s no record on the ARP table for a specific IP address destination, ARP will need to send out a broadcast message to all devices in that specific subnet to determine what the receiver MAC address should be.

## How ARP works

To fully wrap our heads around how the ARP table works, we need to start with a quick explanation of what MAC and IP addresses are, and how they relate to specific OSI model layers, namely Layer 2, the data link layer, and Layer 3, the network layer.

A MAC address is a unique ID assigned to every network-connected device by the manufacturer. It’s a 48-bit address that doesn’t change as the device moves from network to network. It’s used at the data link layer to handle device-to-device communication within the same network.

An IP address is a 32-bit address that’s assigned (either manually or through another service like DHCP) to a device when it’s connected to a network. It’s used at the network layer to communicate with devices both in and outside of the local network. While IP addresses are unique within a local network, they’re assigned logically, rather than physically, so a device’s IP address can change over time. This is why ARP is needed!

Let’s look at a simple example. Say you have a device (Host 1) that needs to communicate with another device (Host 2) on the same subnet. Host 1 will know Host 2’s IP address (192.168.0.10 in our example), but to communicate with Host 2 directly, Host 1 also needs to know Host 2’s MAC address.

Enter the ARP table. Host 1 can use ARP to discover Host 2’s MAC address.

Since Host 1 doesn’t know exactly where Host 2 is, Host 1 broadcasts an ARP request to all the devices on the local subnet asking, “What’s the MAC address for Host 2’s IP address?”. All the hosts on the network will receive this broadcast message, and most will discard it – they’re not Host 2, so they don’t need to do anything. Host 2, however, will respond directly to Host 1 with, “What’s up? My MAC address is AB:CD:EF:01:23:45”.

![](https://cdn-fainj.nitrocdn.com/HMhNvtGdkXCThiYKondeUNdKlFRQtHkp/assets/images/optimized/rev-65a558f/www.auvik.com/wp-content/uploads/2021/04/ARP-table-diagram.png)

When Host 1 receives the reply, the MAC address for Host 2 is updated on Host 1’s ARP table so it knows how to reach Host 2 for the next message. Host 1 can now send the message.

As you can see, ARP is a necessary protocol to bridge Layer 2 and Layer 3. Without the ARP table recording these address pairs, every time devices sent packets to one another, they’d have to ask, “What’s your MAC address?”. This would really slow down network communication!

## Difference between ARP and MAC table

It’s important to understand the difference between these two tables and the fundamental roles they play.

An ARP table is composed of devices’ IP and MAC addresses. The ARP table is built from the replies to the ARP requests, recorded before a packet is sent on the network.

The MAC address table, sometimes called a MAC Forwarding Table or Forwarding Database (FDB), holds information on the physical switch port a specific device is connected to. When a network switch is making packet switching decisions, the MAC table serves to answer which switch port a packet should be sent down.

While there are a lot of similarities between these two tables, they serve different purposes. Most importantly, MAC and ARP tables work on different OSI model layers. ARP tables map a Layer 3 address to a Layer 2 address configuration, while MAC tables map a Layer 2 address to a Layer 1 (physical layer) interface.

Some devices can have one, but not the other. For example, a device that operates at Layer 2 only, like a Layer 2 switch, will have a MAC address table, but no ARP table – it has no need to translate addresses between Layer 3 and Layer 2.

What’s contained in the ARP table
The most important data in an ARP table is the MAC and IP address pairs of the devices on the network. It also contains other valuable information, such as the specific interface a MAC address is connected to, and how long to keep the ARP entry within the table.

![](https://cdn-fainj.nitrocdn.com/HMhNvtGdkXCThiYKondeUNdKlFRQtHkp/assets/images/optimized/rev-65a558f/www.auvik.com/wp-content/uploads/2021/04/ARP-Table-Image.jpeg)

Let’s break down the table components above:

- **Neighbor:** The IP address of another device connected to the same network.
- **Link layer address:** The MAC address of the device connected to the same network.
- **Expire:** A timer, counting down until the specific entry is no longer considered valid and is flushed (removed) from the ARP table.
- **Netif:** The specific interface that a MAC address was discovered on.

ARP is widely used in IPv4 on Ethernet-compatible networks. For IP data carried over networks built on different data link layer protocols, different address mapping protocols will be defined. In IPv6 networks, for example, the ARP table’s functionality is provided instead by the **[Neighbor Discovery Protocol](https://en.wikipedia.org/wiki/Neighbor_Discovery_Protocol)** (NDP).

## How to create ARP tables

ARP tables are often created automatically through the ARP call and response process discussed earlier. There may however be times when manual changes to the ARP table need to be made. Make sure you understand the impact these changes will have on the network, and make sure you follow the right process to add or remove manual entries, which may vary slightly from device to device.

ARP entries can be modified either through a CLI or through the device’s graphical user interface. The process for each will vary slightly, but generally, the steps and information required to modify the entries are similar.

## Viewing an ARP table

How you view the ARP table on your device will depend on the specific device type and operating system.

On most systems that are *nix (UNIX and Linux flavors), a command prompt is required to access the ARP table. To display the ARP table in this system, enter “arp -a.” This command will also show the ARP table in the Windows command prompt.
