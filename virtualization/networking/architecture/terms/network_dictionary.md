# Network dictionary

## references

## **[TAP devices](https://www.netscout.com/what-is/Network-Tap#:~:text=A%20network%20tap%20is%20a,network%20taps%3A%20hardware%20and%20software.)

A network tap is a device that allows you to monitor and access data that is transmitted over a network. It is typically used in network security applications to monitor traffic and identify malicious activity or security threats. There are two main types of network taps: hardware and software.

## Bridge

A Linux bridge behaves like a network switch. It forwards packets between interfaces that are connected to it. It's usually used for forwarding packets on routers, on gateways, or between VMs and network namespaces on a host. It also supports STP, VLAN filter, and multicast snooping.

![](https://developers.redhat.com/blog/wp-content/uploads/2018/10/bridge.png)

Use a bridge when you want to establish communication channels between VMs, containers, and your hosts.

### Here's how to create a bridge

```bash
# ip link add br0 type bridge
# ip link set eth0 master br0
# ip link set tap1 master br0
# ip link set tap2 master br0
# ip link set veth1 master br0
```

## Bonded interface

The Linux bonding driver provides a method for aggregating multiple network interfaces into a single logical "bonded" interface. The behavior of the bonded interface depends on the mode; generally speaking, modes provide either hot standby or load balancing services.

![](https://developers.redhat.com/blog/wp-content/uploads/2018/10/bond.png)

## Network **[Tap device](https://blog.cloudflare.com/virtual-networking-101-understanding-tap)**

A tap device is a virtual network interface that looks like an ethernet network card. Instead of having real wires plugged into it, it exposes a nice handy file descriptor to an application willing to send/receive packets. Historically tap devices were mostly used to implement VPN clients. The machine would route traffic towards a tap interface, and a VPN client application would pick them up and process accordingly. For example this is what our Cloudflare WARP Linux client does. Here's how it looks on my laptop:

## Network **[Tap](https://www.instructables.com/Make-a-Passive-Network-Tap/)**

Make a Passive Network Tap
Step 1: Parts. You will need: ...
Step 2: Tools. You will need a wire stripper and a screw driver.
Step 3: Strip Wire. Cut 5 inches of cat 5 cable, and pull out the 8 strands of wire.
Step 4: Wire the First Jack. ...
Step 5: Wire the Second Jack. ...
Step 6: Third Jack. ...
Step 7: Close It Up.
