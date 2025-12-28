# **[](https://www.juniper.net/documentation/us/en/software/junos/high-availability/topics/topic-map/vrrp-understanding.html)**

Understanding VRRP
For Ethernet, Fast Ethernet, Gigabit Ethernet, 10-Gigabit Ethernet, and logical interfaces, you can configure the Virtual Router Redundancy Protocol (VRRP) or VRRP for IPv6. VRRP enables hosts on a LAN to make use of redundant routing platforms on that LAN without requiring more than the static configuration of a single default route on the hosts. The VRRP routing platforms share the IP address corresponding to the default route configured on the hosts. At any time, one of the VRRP routing platforms is the primary (active) and the others are backups. If the primary routing platform fails, one of the backup routing platforms becomes the new primary routing platform, providing a virtual default routing platform and enabling traffic on the LAN to be routed without relying on a single routing platform. Using VRRP, a backup device can take over a failed default device within a few seconds. This is done with minimum VRRP traffic and without any interaction with the hosts. Virtual Router Redundancy Protocol is not supported on management interfaces.

Devices running VRRP dynamically elect primary and backup devices. You can also force assignment of primary and backup devices using priorities from 1 through 255, with 255 being the highest priority. In VRRP operation, the default primary device sends advertisements to backup devices at regular intervals. The default interval is 1 second. If a backup device does not receive an advertisement for a set period, the backup device with the next highest priority takes over as primary and begins forwarding packets.

Note: Priority 255 cannot be set for routed VLAN interfaces (RVIs).
Note: To minimize network traffic, VRRP is designed in such a way that only the device that is acting as the primary sends out VRRP advertisements at any given point in time. The backup devices do not send any advertisement until and unless they take over primary role.

VRRP for IPv6 provides a much faster switchover to an alternate default router than IPv6 neighbor discovery procedures. Typical deployments use only one backup router.

Note: Do not confuse the VRRP primary and backup routing platforms with the primary and backup member switches of a Virtual Chassis configuration. The primary and backup members of a Virtual Chassis configuration compose a single host. In a VRRP topology, one host operates as the primary routing platform and another operates as the backup routing platform, as shown in Figure 3.

VRRP is defined in RFC 3768, Virtual Router Redundancy Protocol. VRRP for IPv6 is defined in draft-ietf-vrrp-ipv6-spec-08.txt, Virtual Router Redundancy Protocol for IPv6. See also draft-ietf-vrrp-unified-mib-06.txt, Definitions of Managed Objects for the VRRP over IPv4 and IPv6.

Note: Even though VRRP, as defined in RFC 3768, does not support authentication, the Junos OS implementation of VRRP supports authentication as defined in RFC 2338. This support is achieved through the backward compatibility options in RFC 3768.

Note: On EX2300 and EX3400 switches, the VRRP protocol must be configured with a Hello interval of 2 seconds or more with dead interval not less than 6 seconds to prevent flaps during CPU intensive operations events such as routing engine switchover, interface flaps, and exhaustive data collection from the packet forwarding engine.

Figure 1 illustrates a basic VRRP topology. In this example, Routers A, B, and C are running VRRP and together make up a virtual router. The IP address of this virtual router is 10.10.0.1 (the same address as the physical interface of Router A).

Figure 1: Basic VRRP

![i2](https://www.juniper.net/documentation/us/en/software/junos/high-availability/images/g016843.png)

Because the virtual router uses the IP address of the physical interface of Router A, Router A is the primary VRRP router, while routers B and C function as backup VRRP routers. Clients 1 through 3 are configured with the default gateway IP address of 10.10.0.1. As the primary router, Router A forwards packets sent to its IP address. If the primary virtual router fails, the router configured with the higher priority becomes the primary virtual router and provides uninterrupted service for the LAN hosts. When Router A recovers, it becomes the primary virtual router again.

Note: In some cases, during an inherit session, there is a small time frame during which two routers are in Primary-Primary state. In such cases, the VRRP groups that inherit the state do send out VRRP advertisements every 120 seconds. So, it takes the routers up to 120 seconds to recover after moving to Primary-Backup state from Primary-Primary state.
