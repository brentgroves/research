# **[Learn Linux Bridge with graphs](https://medium.com/@amazingandyyy/learn-linux-bridge-with-graphs-a425aa92945f)**

In the previous post, we talked about how virtual Ethernet (Veth) devices enable traffic between 2 network namespace. When we want to connect more network namespace, creating veth for such spider-ish traffic become unscalable and complex to maintain. That is, when linux bridge can help.

In this post, we are learning creating a linux bridge and enbling traffic between 4 network namespaces.

We learn Network Namespaces and Veth Devices in the previous post. But for the sake of completion, I will like to introduce them again here.

![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*DKTM_s9Ar5zYhfzIzEsPww.png)

Network namespaces provide a way to create isolated network environments within a Linux system. They allow processes to have their own network stack, complete with interfaces, routing tables, and firewall rules. This isolation ensures that processes in one network namespace are isolated from processes in other namespaces.

Network namespaces provide isolated instances of network stack, interfaces, and routing tables in Linux.

## What are Veth Devices?

![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*jEzLHDLrik00lYF6yZZO0Q.png)

Veth devices, short for virtual Ethernet devices, are pairs of virtual network interfaces that are used to connect network namespaces together. Each pair consists of two ends: one end resides in one namespace, while the other end resides in another. These virtual interfaces behave like Ethernet cables, facilitating communication between the connected namespaces. Traffic can tunnel through this veth pair in two way.

Veth devices are virtual network interfaces that come in pairs and are used to connect network namespaces.

## What is Linux Bridge?

A Linux bridge is a software component in the Linux kernel that allows for the creation of a network bridge. A network bridge is a connection between two or more network interfaces that enables them to operate as a single network segment. It operates at the data link layer (Layer 2) of the OSI model and can forward network traffic between connected interfaces.

![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*nb1aj8zQ4sODcP6EuG44PA.png)

Linux bridges can be managed using various tools and commands. The brctl command-line tool is commonly used to create, configure, and manage Linux bridges. Additionally, newer networking tools like ip and bridge commands are available in recent versions of Linux distributions.

It provides a flexible and efficient way to connect network interfaces and enable network communication between different devices or virtual environments in a Linux system.

A Linux bridge connects network interfaces together, allowing devices to communicate as if they were on the same network.

## Setting up the Environment

Before we dive into creating and configuring network namespaces and Veth devices, we need to set up our environment. Which you will use vagrant virtual technology to spin up a new ubuntu machine inside your machine.

```bash
$ curl -s https://gist.githubusercontent.com/amazingandyyy/352e20f6f757b4519412d03261609f30/raw/b6738afa90dd13869e1a3969b813134050c647bb/ubuntu.Vagrantfile > Vagrantfile
$ vagrant up
...
$ vagrant ssh
```

Create netns, veth and, the bridge

## Step 1: Create the network namespaces

![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*aM13km20kKia5Yv52Kl5YQ.png)

Create 4 network namespaces by using the ip netns add command

```bash
$ sudo ip netns add ns1
$ sudo ip netns add ns2
$ sudo ip netns add ns3
$ sudo ip netns add ns4

# verify the setup
$ ip netns list
ns4
ns3
ns2
ns1
```

After creating, you can use ip netns list to verify there are 4 nerwork namespaces.

## Step 2: Create veth pairs

Create four pairs of virtual Ethernet (veth) interfaces. Each pair consists of two interfaces: a side and b side. By using sudo ip link add <veth-name> type veth peer name <veth-peer-name>.

```bash
$ sudo ip link add veth1a type veth peer name veth1b
$ sudo ip link add veth2a type veth peer name veth2b
$ sudo ip link add veth3a type veth peer name veth3b
$ sudo ip link add veth4a type veth peer name veth4b

# verify the setup
$ ip a
...
4: veth1b@veth1a: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether c6:9c:e9:44:e9:a4 brd ff:ff:ff:ff:ff:ff
5: veth1a@veth1b: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 96:2a:20:a7:24:33 brd ff:ff:ff:ff:ff:ff
6: veth2b@veth2a: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 8a:f7:c1:cc:92:57 brd ff:ff:ff:ff:ff:ff
7: veth2a@veth2b: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 22:18:45:92:3c:a2 brd ff:ff:ff:ff:ff:ff
8: veth3b@veth3a: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 56:a0:aa:30:e5:85 brd ff:ff:ff:ff:ff:ff
9: veth3a@veth3b: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether a6:12:07:93:fb:7f brd ff:ff:ff:ff:ff:ff
10: veth4b@veth4a: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether f2:a3:71:00:56:dd brd ff:ff:ff:ff:ff:ff
11: veth4a@veth4b: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 0a:5b:4d:65:5d:f7 brd ff:ff:ff:ff:ff:ff
```

Aftering creating, use ip address command or ip a for short to print out all available interfaces on the ubuntu machine, here you can see the 4 veth pairs we created from interfaces 4th to 11th.

## Step 3: Move veth pairs into the respective network namespaces

![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*xW7AwVgAydMLXwN4GIrgRw.png)

Now, move the “b” side of each veth pair into the corresponding network namespace:

```bash
sudo ip link set veth1b netns ns1
sudo ip link set veth2b netns ns2
sudo ip link set veth3b netns ns3
sudo ip link set veth4b netns ns4
```

Also turn all veth devices up in both sides:

```bash
sudo ip netns exec ns1 sudo ip link set dev veth1b up
sudo ip netns exec ns2 sudo ip link set dev veth2b up
sudo ip netns exec ns3 sudo ip link set dev veth3b up
sudo ip netns exec ns4 sudo ip link set dev veth4b up

sudo ip link set dev veth1a up
sudo ip link set dev veth2a up
sudo ip link set dev veth3a up
sudo ip link set dev veth4a up

# verify the setup
$ sudo ip netns exec ns2 ip a
...
6: veth2b@if7: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 8a:f7:c1:cc:92:57 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet6 fe80::88f7:c1ff:fecc:9257/64 scope link
       valid_lft forever preferred_lft forever
```

## link types

```
TYPE := [ bridge | bridge_slave | bond | bond_slave | 
          can | dummy | hsr | ifb | ipoib | macvlan | 
          macvtap | vcan | veth | vlan | vxlan | ip6tnl | 
          ipip | sit | gre | gretap | erspan | ip6gre | 
          ip6gretap | ip6erspan | vti | vrf | nlmon |
          ipvlan | lowpan | geneve | macsec ]
```

```bash
ip -j -p -d link show tap57722358 
...
        "linkinfo": {
            "info_kind": "tun",
            "info_data": {
                "type": "tap",
                "pi": false,
                "vnet_hdr": true,
                "multi_queue": true,
                "numqueues": 1,
                "numdisabled": 1,
                "persist": true
            },
...

ip -details -json link show | jq --join-output '.[] | .ifname," ",.linkinfo.info_kind,"\n"'

lo null
enp66s0f0 null
eno1 null
enp66s0f1 null
enp66s0f2 null
enp66s0f3 null
eno2 null
eno3 null
eno4 null
mybr bridge
localbr bridge
br-eno2 bridge
mpbr0 bridge
tap57722358 tun
tapd17aefc4 tun
tapa648ce65 tun
tap104bbd49 tun
tap0b21331e tun
tap320727e2 tun
tapb9cb2d45 tun
tap96a18e55 tun
virbr0 bridge
mybr-eno3 bridge
tap092b6b51 tun
tap037b8c75 tun

        "linkinfo": {
            "info_kind": "tun",
            "info_data": {
                "type": "tap",
                "pi": false,
                "vnet_hdr": true,
                "multi_queue": true,
                "numqueues": 1,
                "numdisabled": 1,
                "persist": true
            },

```

tapd17aefc4
