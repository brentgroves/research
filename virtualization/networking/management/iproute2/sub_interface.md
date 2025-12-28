# Sub Interfaces

Sub-interfaces are really just a way of assigning 2 or more addresses to the same interface. For example if you assigned an address to eth0:1 then your machine would have 2 address on the physical interface and other machines on your network could reach it on both. Putting them on lo (loopback) means that only your test machine knows about the extra address and the rest of your network isn't impacted.

At a packet level any traffic for lo:100 flows through lo. This is different to dummy interfaces where a whole new interface is created and traffic is isolated.

## references

<https://askubuntu.com/questions/1432883/how-to-create-sub-interface>

<https://unix.stackexchange.com/questions/678162/how-to-create-ethernet-interface-at-a-specific-ip-address-that-i-can-ping-and-fo?noredirect=1&lq=1>

## What are subinterfaces?

Subinterfaces are logical divisions of a physical interface on a router or a layer 3 switch. Each subinterface can be assigned a different IP address, subnet mask, and VLAN ID. Subinterfaces allow a single physical interface to act as multiple virtual interfaces, each connected to a different VLAN. For example, if you have a router with one interface connected to a switch that has four VLANs, you can create four subinterfaces on the router interface, each with a different VLAN ID and IP address, and configure the switch to use 802.1Q trunking to send VLAN-tagged frames to the router. This way, the router can route packets between the VLANs using the subinterfaces.

Netplan does not have aliases ("sub-interface" per your wording) but does allow labeling of interfaces.

<https://askubuntu.com/questions/1432883/how-to-create-sub-interface>

Netplan does not have aliases ("sub-interface" per your wording) but does allow labeling of interfaces.

## How to create Ethernet interface at a specific IP address that I can ping and force to sometimes reply and sometimes not?

3 answers received (my own included), and all 3 answers work!:

by Stephen Harris - use loopback sub-interfaces (probably the best answer so far)
by Hauke Laging - use iptables
my own answer - use virtual interfaces

<https://unix.stackexchange.com/questions/152331/how-can-i-create-a-virtual-ethernet-interface-on-a-machine-without-a-physical-ad/593142#593142>

## Full Example

First, ensure the desired IP address you'd like to use is NOT currently responding to ping:

ping -c 1 -W 1 254.254.254.254

Sample output:

PING 254.254.254.254 (254.254.254.254) 56(84) bytes of data.

--- 254.254.254.254 ping statistics ---
1 packets transmitted, 0 received, 100% packet loss, time 0ms

@Hauke Laging is right in his comment under my question:

There may be a different 10.0.0.1 somewhere. Compare the outputs of ip route get 10.0.0.1 in both cases.

ip route get 10.0.0.1 shows this before deleting the dummy interface:

local 10.0.0.1 dev lo src 10.0.0.1 uid 46153590
...indicating that that route is going through the dummy interface I created, and it shows this after deleting the dummy interface by running sudo ip link delete eth10 type dummy:

10.0.0.1 dev wlp0s20f3 src 10.0.0.36 uid 28301632
...indicating that IP is now being routed through my wlp0s20f3 wireless card. I guess that makes sense because my local WiFi is using and assigning 10.0.0.x IP addresses.

The solution, therefore, is to simply choose a different IP which is not pingable before creating the virtual interface to it! Using 10.0.0.100 instead of 10.0.0.1 in my case worked just fine. But, let's just use 254.254.254.254 for the case of this example.

Full Example:

First, ensure the desired IP address you'd like to use is NOT currently responding to ping:

ping -c 1 -W 1 254.254.254.254
Sample output:

PING 254.254.254.254 (254.254.254.254) 56(84) bytes of data.

--- 254.254.254.254 ping statistics ---
1 packets transmitted, 0 received, 100% packet loss, time 0ms
Now create a dummy eth99 interface (for a full explanation, see my other answer here: How can I create a virtual ethernet interface on a machine without a physical adapter?):

sudo modprobe dummy \
&& sudo ip link add eth99 type dummy \
&& sudo ip address change dev eth10 254.254.254.254 \
&& ip address

Now it IS pingable. Run ping 254.254.254.254. Sample cmd and output:

$ ping 254.254.254.254
PING 254.254.254.254 (254.254.254.254) 56(84) bytes of data.
64 bytes from 254.254.254.254: icmp_seq=1 ttl=64 time=0.086 ms
64 bytes from 254.254.254.254: icmp_seq=2 ttl=64 time=0.093 ms
64 bytes from 254.254.254.254: icmp_seq=3 ttl=64 time=0.086 ms
64 bytes from 254.254.254.254: icmp_seq=4 ttl=64 time=0.051 ms
^C
--- 254.254.254.254 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3050ms
rtt min/avg/max/mdev = 0.051/0.079/0.093/0.016 ms

Now, if you run ping 254.254.254.254 in one terminal, and sudo ip link delete eth99 type dummy in another, the ping response will quit incrementing once you delete the interface. sudo modprobe dummy; sudo ip link add eth99 type dummy; sudo ip address change dev eth99 254.254.254.254; ip address again will re-create the interface and make the ping start responding again.
