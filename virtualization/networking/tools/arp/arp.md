# **[arp](http://linux-ip.net/html/tools-arp.html)**

B.1. arp
An often overlooked tool, arp is used to view and manipulate the entries in the arp table. See Section 2.1.2, “The ARP cache” for a fuller discussion of the arp table.

The most common uses for arp are to add an address for which to proxy arp, delete an address from the arp table or view the arp table itself.

In the simplest invocation, you simply want to see the current state of the arp table. Invoking arp with no options will provide you exactly the information you need. Typically, you may not trust DNS (or may not wish to wait for the DNS lookups), and you may wish to specify the arp table on a particular interface.

Example B.1. Displaying the arp table with arp

```bash
[root@masq-gw]# arp -n -i eth3
Address                  HWtype  HWaddress           Flags Mask Iface
192.168.100.1           ether   00:C0:7B:7D:00:C8   C                     eth3
[root@masq-gw]# arp -n -i eth0
Address                  HWtype  HWaddress           Flags Mask Iface
192.168.100.17          ether   00:80:C8:E8:4B:8E   C                     eth0
[root@masq-gw]# arp -a -n -i eth0
? (192.168.100.17) at 00:80:C8:E8:4B:8E [ether] on eth0
```

The MAC address in the third column is always a six part hexadecimal number. In practice, the MAC address (also known as the hardware address or the Ethernet address) is not normally needed for the majority of troubleshooting problems, however knowing how to retrieve the MAC address can help when tracking down problems in a network [41].

The arp command can also force a permament entry into the arp table. Let's look at an unusual networking need. Infrequently, a need arises to split a network into two parts, each part with the same network address and netmask. The router which joins the two networks is connected to both sets of media. See Section 9.3, “Breaking a network in two with proxy ARP” for more detail on when and how to do this.

The command to add arp table entries makes a static entry in the arp table. This is not recommended practice, and is probably only necessary in strange, experimental, hybrid, or pseudo-bridging situations.

Example B.2. Adding arp table entries with arp

```bash
[root@masq-gw]# arp -s 192.168.100.17 -i eth3 -D eth3 pub
[root@masq-gw]# arp -n -i eth3
Address                  HWtype  HWaddress           Flags Mask Iface
192.168.100.1           ether   00:C0:7B:7D:00:C8   C                     eth3
192.168.100.17          *       *                   MP                    eth3
```

After inserting an entry into the arp table on eth3, we will now respond for ARP requests on eth3 for the IP 192.168.100.17. If the service-router has a packet bound for 192.168.100.17, it will generate an ARP request to which we will respond with the Ethernet address of our eth3 interface.

Moments after you have added this arp table entry, you realize that you really do not wish service-router and isolde to exchange any IP packets. There is no reason for the isolde to initiate a telnet session with service-router and correspondingly, there are no services on isolde which should be accessible from the router.

Fortunately, it's quite easy to remove the entry.

## Example B.3. Deleting arp table entries with arp

```bash
[root@masq-gw]# arp -i eth3 -d 192.168.100.17
[root@masq-gw]# arp -n -i eth3
Address                  HWtype  HWaddress           Flags Mask Iface
192.168.100.1           ether   00:C0:7B:7D:00:C8   C                     eth3
```

arp is a small utility, but one which can prove extremely handy. One minor annoyance with the arp utility is option handling. Options seem to be handled differently based on order. If in doubt, try specifying the action as the first option.

[41] I know of one instance where some devices which used DHCP to join the network were suddenly and apparently inexplicably receiving addresses in an unexpected netblock. After some head-scratching and judicious use of tcpdump to record the Ethernet address of the DHCP server giving out the bogus IP information, the administrator was able to track down a device through the switch to a port on the LAN. It turned out to be a tiny (4-port) hub with an embedded DHCP server which was intended for home use! The knowledge of the Ethernet address of the rogue DHCP server was the key to physically locating the device.
