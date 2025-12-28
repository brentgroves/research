# **[Private Network with Gateway](https://dev.to/webduvet/setting-up-private-network-with-a-gateway-1dln)**


**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

## Building a Kubernetes cluster at home, part One.
This chapter will focus on the preparation work. I will wire all computers together and I configure one of my laptops to serve as an access point to the cluster and also it will serve as a gateway from the cluster to the outside world. I already gathered about 5 old computers and a simple non-managed Ethernet switch with 5 ports. I will start with the simplest possible solutions and will add complexity as goes.

Step 1
Plugin the first laptop. This one will serve as a gateway as it has two network interfaces. Wifi will interface with my router network and the Ethernet will interface private network. When you connect your laptop to your home WIFI, it usually will obtain the dynamic IP address from a router, something like 192.168.0.15. The router is set as the default gateway for all internet traffic. When you plug in the computer with an Ethernet cable, it does the same (minus the WIFI security bit). The operating system usually activates only one network interface (Ethernet takes precedes if both are present). In our case, we need to enable both so the machine can communicate with the cluster and with me.
mnode@mnode:~$ ip address show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
        valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
        valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state DOWN group default qlen 1000
    link/ether 49:ba:4e:4a:eb:c5 brd ff:ff:ff:ff:ff:ff
    altname enp1s0
    inet 192.168.3.34/24 brd 192.168.3.255 scope global eth0
        valid_lft forever preferred_lft forever
    inet6 fc80::4aba:4eff:fe39:ebc5/64 scope link
        valid_lft forever preferred_lft forever
3: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether da:64:6a:9f:cd:1f brd ff:ff:ff:ff:ff:ff
    altname wlp2s0
    inet 192.168.1.5/24 metric 600 brd 192.168.1.255 scope global dynamic wlan0
        valid_lft 86379sec preferred_lft 86379sec
    inet6 fe80::d66a:6aff:fe9c:cd1f/64 scope link
        valid_lft forever preferred_lft forever
The above is the list of all available network interfaces. Those interesting for us are eth0 which is the Ethernet interface and wlan0 which is WIFI. from the above list we can see that Ethernet is in the state DOWN. For comparison the wireless LAN is wlan0 and the state is UP.

Running the following command will turn on the networking interface: sudo ip link set eth0 up Running ip address show again will show that the eth0 interface is now with the flag UP, so the operation worked. However, doing this on the Ubuntu desktop might result in the operating system (Ubuntu) reporting an error message activation of network connection failed Ubuntu

This is because Ubuntu Desktop uses NetworkManager to manage all the network interfaces by default. It is the application responsible for network management via UI. This is not the case in Ubuntu Server which I will be using. The documentation can be found here NetworkManager It can be completely turned off by choosing a different renderer or a specific networking interface can be excluded from under the management of NetworkManager. The configuration is in the file /etc/NetworkManager/NetworkManager.conf. On UI-less versions like Ubuntu Server, there is no NetworkManager installed. The default network renderer is systemd-networkd. In both flavors of Ubuntu, the networking configuration is done via Netplan and the configuration for Netplan is stored in yaml file in the location /etc/netplan/*.yaml. There could be more than one configuration file. More information on this are to be found in the provided link.

The default configuration on the Ubuntu desktop might look like this and it basically tells the system that NetworkManager manages all networking devices:

network:
  version: 2
  renderer: NetworkManager
If there is no renderer specified, Ubuntu by default uses systemd-networkd as the network renderer. We want to customize values for the gateway and the static IP address as we need to manage two separate network interfaces and we need to have them UP at the same time.

network:
    wifis:
        wlan0:
            dhcp4: true
            dhcp6: true
            access-points:
                "WIFI-Name":
                    password: "wifi_password"
    ethernets:
        eth0:
            dhcp4: false
            addresses: [192.168.3.34/24]
            routes:
                - to: default
                - via: 192.168.1.1
The above configuration tells the system that both interfaces are managed (by default) by systemd-networkd specifies the access point for WIFI and password. It specifies that WIFI takes the IP address from the router for both ipv4 and ipv6 protocols. It specifies that the Ethernet interface does not try to obtain IP addresses from DHCP server and takes the hard-coded one. The format 192.168.3.34/24 specifies that the IP address in the domain 192.168.3.xx and the address 192.168.3.34 within the domain. There is a lot that can be done configuring the netplan.

NOTE: for the desktop version turning off the NetworkManager results in an inability to select the network from the dropdown menu in the taskbar.

An important part is that the Wifi subnet is not clashing with the ethernet subnet. In my case wifi runs on 192.168.1.0/24 and I set up the ethernet IP to 192.168.3.0/24

After this netplan's new configuration needs to be applied bash sudo netplan apply In case this is done on the Ubuntu desktop, there might be a message systemd-networkd not running, output will be incomplete. this indicates the network manager is not managing the network anymore, but the default networkd is not running yet. it needs to be started bash systemctl start systemd-networkd I have to note also that to setup the Ubuntu server is much simpler as there is no NetworkManager and the systemd-networkd is a default network renderer.

Step 2, adding another compouter to cluster
This should be fairly simple. For me the second guinea pig is raspberry pi3, running Ubuntu for raspberry, not too dissimilar to the Ubuntu server. The only configuration which I need to do here is to assign a static IP address and point to the default gateway: yaml network: version: 2 ethernets: eth0: dhcp4: false addresses: [192.168.3.40/24] after bash sudo netplan apply I can reach the Raspberry node from the gateway laptop and vice versa. I also can reach the gateway laptop on the Wifi domain. I should be good to go to plug in the rest of the computers and do the same to them After that I could start installing k3s and build the Kubernetes cluster.

It is also worth noting - when you are building the cluster out of old laptops - it is handy to prevent them to go sleep or hibernate when the lid is closed. That way is is possible to stack them on each other to save the space.
On Ubuntu server as per documentation this needs to be added to /etc/systemd/sleep.conf or preferably new file in the location /etc/systemd/sleep.conf.d/00-sleep.conf to be created as it takes precedence over default configuration in the former file.

[Sleep]
AllowSuspend=no
AllowHibernation=no
AllowSuspendThenHibernate=no
AllowHybridSleep=no
Step 3, optional - internet access
However, there is one more thing I wanted to do. It is not essential and perhaps even not recommended, but for my convenience want to have a connection to the internet from the individual machines in the cluster. This will help me with the installation of the required software on individual nodes. This is not a production environment so I can easily get away with it. The same scenario would apply if you had a desktop machine without WIFI. You could use a laptop to connect to WIFI and use the laptop's Ethernet interface to connect with your desktop and to serve as a router.

To do this we need to add a few rules in IP tables. We need to forward all internet traffic from ethernet to wifi interface and back. We also want to set up network address translation(NAT). For Linux operating system to enable IP forwarding. This can typically be done by editing the /etc/sysctl.conf file and adding the following line:

net.ipv4.ip_forward = 1
or run sysctl -w net.ipv4.ip_forward=1 We also need to add the following rules in the ip tables:

iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i wlan0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
The first rule forwards all the traffic coming from the individual machines on our subnet to out via wireless LAN.

the second adds a record to NAT table to masquerade packets coming from the individual machines from the private subnet via the gateway laptop as packets coming from the gateway laptop itself (the home router does the same thing again when you are reaching out to the internet)

The third rule forwards all the traffic originating from the individual machines back to them

Save your IP tables rules and make sure they are automatically loaded at startup. This can typically be done by using the iptables-save and iptables-restore commands. For example:

iptables-save > /etc/iptables.rules
Edit the /etc/rc.local file and add the following line before the exit 0 line:

iptables-restore < /etc/iptables.rules
Once this is done it should be possible to access the internet from a machine connected to an Ethernet switch provided the configuration in step 2 is followed.

Summary
After the above steps, I do have a cluster of computers wired together via an Ethernet switch. The computers share a private network and can communicate with each other. The private network is connected to the router via a wireless connection and the internet is also reachable from inside the private network.