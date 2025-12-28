# **[Linux Network Interface Renaming](https://www.youtube.com/watch?v=CXsNAaIYWco&list=PLmZU6NElARbZtvrVbfz9rVpWRt5HyCeO7&index=4)**


**[Back to Research List](../../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../../README.md)**

## references


- **[Linux Networking](https://www.youtube.com/@routerologyblog1111/playlists)**
## netfilter subsystem hooks
![pf](https://people.netfilter.org/pablo/nf-hooks.png)

The following hooks represent these well-defined points in the networking stack:

- **NF_IP_PRE_ROUTING:** This hook will be triggered by any incoming traffic very soon after entering the network stack. This hook is processed before any routing decisions have been made regarding where to send the packet.
- **NF_IP_LOCAL_IN:** This hook is triggered after an incoming packet has been routed if the packet is destined for the local system.
- **NF_IP_FORWARD:** This hook is triggered after an incoming packet has been routed if the packet is to be forwarded to another host.
- **NF_IP_LOCAL_OUT:** This hook is triggered by any locally created outbound traffic as soon as it hits the network stack.
- **NF_IP_POST_ROUTING:** This hook is triggered by any outgoing or forwarded traffic after routing has taken place and just before being sent out on the wire.

| Tables↓/Chains→               | PREROUTING | INPUT | FORWARD | OUTPUT | POSTROUTING |
|-------------------------------|------------|-------|---------|--------|-------------|
| (routing decision)            |            |       |         | ✓      |             |
| raw                           | ✓          |       |         | ✓      |             |
| (connection tracking enabled) | ✓          |       |         | ✓      |             |
| mangle                        | ✓          | ✓     | ✓       | ✓      | ✓           |
| nat (DNAT)                    | ✓          |       |         | ✓      |             |
| (routing decision)            | ✓          |       |         | ✓      |             |
| filter                        |            | ✓     | ✓       | ✓      |             |
| security                      |            | ✓     | ✓       | ✓      |             |
| nat (SNAT)                    |            | ✓     |         |        | ✓           |


```bash
# don't do this
# use udev rules
cd /etc/udev/rules.d/
ls -l
total 96
-rw-r--r-- 1 root root 14476 Jan 24 14:40 70-snap.firefox.rules
-rw-r--r-- 1 root root  5569 Jan 24 14:40 70-snap.firmware-updater.rules
-rw-r--r-- 1 root root  2226 Jan 24 14:40 70-snap.snapd-desktop-integration.rules
-rw-r--r-- 1 root root 63357 Jan 24 14:40 70-snap.snapd.rules
-rw-r--r-- 1 root root  3194 Jan 24 14:40 70-snap.snap-store.rules

# find interface name 
ip a

# method 1
vi 40-etx.rules
SUBSYSTEM=="net", KERNELS=="", NAME="enxf8e43bed63bd"
information i'm matching on
udevadm info -a -p /sys/class/net/enxf8e43bed63bd
Udevadm info starts with the device specified by the devpath and then
walks up the chain of parent devices. It prints for every device
found, all possible attributes in the udev rules key format.
A rule to match, can be composed by the attributes of the device
and the attributes from one single parent device.

# These are things you can match in a udev rule
some people are using the mac address
but a better way is to match the parent device KERNEL=="enxf8e43bed63bd"
  looking at device '/devices/pci0000:00/0000:00:0d.0/usb2/2-3/2-3:2.0/net/enxf8e43bed63bd':
    KERNEL=="enxf8e43bed63bd"
    SUBSYSTEM=="net"
    DRIVER==""
    ATTR{addr_assign_type}=="0"
    ATTR{addr_len}=="6"
    ATTR{address}=="f8:e4:3b:ed:63:bd"
    ATTR{broadcast}=="ff:ff:ff:ff:ff:ff"
    ATTR{carrier}=="1"
    ATTR{carrier_changes}=="2"
    ATTR{carrier_down_count}=="1"
    ATTR{carrier_up_count}=="1"
```

## method 2

```bash
cd /etc/systemd/network
ls -l

ls -l /lib/systemd/network
-rw-r--r-- 1 root root   44 Oct 16 16:37 73-usb-net-by-mac.link
-rw-r--r-- 1 root root  819 Feb 27  2024 80-6rd-tunnel.network
-rw-r--r-- 1 root root  719 Feb 27  2024 80-auto-link-local.network.example
-rw-r--r-- 1 root root  947 Feb 27  2024 80-container-host0.network
-rw-r--r-- 1 root root  940 Feb 27  2024 80-container-vb.network
-rw-r--r-- 1 root root 1037 Feb 27  2024 80-container-ve.network
-rw-r--r-- 1 root root 1023 Feb 27  2024 80-container-vz.network
-rw-r--r-- 1 root root  984 Feb 27  2024 80-vm-vt.network
-rw-r--r-- 1 root root  730 Feb 27  2024 80-wifi-adhoc.network
-rw-r--r-- 1 root root  664 Feb 27  2024 80-wifi-ap.network.example
-rw-r--r-- 1 root root  595 Feb 27  2024 80-wifi-station.network.example
-rw-r--r-- 1 root root  636 Feb 27  2024 89-ethernet.network.example
# if you want to make your own file make it before 99-default.link
-rw-r--r-- 1 root root  769 Feb 27  2024 99-default.link
# find a sample on the internet
vi /etc/systemd/network/10-ety0.link
vi /etc/default/grub
update-grub

```