# **[Learn Network Namespaces and Virtual Ethernet (Veth) Devices with graphs](https://medium.com/@amazingandyyy/introduction-to-network-namespaces-and-virtual-ethernet-veth-devices-304e0c02d084)**

Network namespaces and virtual Ethernet (Veth) devices are powerful concepts in Linux that allow you to create isolated network environments and establish communication between them. It’s a fundamental knowledge that prepare us to learn how docker container can talk to each other, before I talk more details on that topic, let’s learn the basic first.

## What are Network Namespaces?

![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*DKTM_s9Ar5zYhfzIzEsPww.png)

Network namespaces provide a way to create isolated network environments within a Linux system. They allow processes to have their own network stack, complete with interfaces, routing tables, and firewall rules. This isolation ensures that processes in one network namespace are isolated from processes in other namespaces.

Network namespaces provide isolated instances of network stack, interfaces, and routing tables in Linux.

## What are Veth Devices?

![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*jEzLHDLrik00lYF6yZZO0Q.png)

Veth devices, short for virtual Ethernet devices, are pairs of virtual network interfaces that are used to connect network namespaces together. Each pair consists of two ends: one end resides in one namespace, while the other end resides in another. These virtual interfaces behave like Ethernet cables, facilitating communication between the connected namespaces. Traffic can tunnel through this veth pair in two way.

Veth devices are virtual network interfaces that come in pairs and are used to connect network namespaces.

## Setting up the Environment

Before we dive into creating and configuring network namespaces and Veth devices, we need to set up our environment. Which you will use vagrant virtual technology to spin up a new ubuntu machine inside your machine.

```bash
curl -s https://gist.githubusercontent.com/amazingandyyy/352e20f6f757b4519412d03261609f30/raw/befa5184df2d728de2a7642bac24e9cd8907925d/Ubuntu-lab.Vagrantfile > Vagrantfile
vagrant up
```

## Create 2 Network Namespaces

![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*3-eGZ0ALS-EQSJUaYafmwg.png)

Once your vagrant runs successfully and SSH into the ubuntu machine, let’s create 2 network namespaces by using the ip netns command.

```bash
$ vagrant ssh
2023-05-26 03:59:52 ⌚  network-lab in ~
...
$ sudo ip netns add ns1
$ sudo ip netns add ns2
$ ip netns list
ns1
ns2
```

## Create Veth Pair and install them into network namespaces

Create the Veth Pair:
To create a Veth pair, we’ll use the ip link command

```bash
sudo ip link add veth1 type veth peer name veth2
```

This command creates a Veth pair named veth1 and veth2. The veth1 end will be associated with ns1, and the veth2 end will be associated with ns2.

Verify that the veth pair is created by running the following command:

```bash
$ ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 11:22:33:44:55:66 brd ff:ff:ff:ff:ff:ff
3: veth1@veth2: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 11:22:33:44:55:77 brd ff:ff:ff:ff:ff:ff
4: veth2@veth1: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 11:22:33:44:55:88 brd ff:ff:ff:ff:ff:ff
...
```

In the output, you can see veth1 and veth2 listed as part of the veth pair.

![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*dn22hl24Mju4W9I6FIvd3A.png)

That’s it! You have successfully created a veth pair with the peer name “veth2.” If you have any further questions, feel free to ask.

## 2. Install the Veth Ends to Respective Namespaces and turn them on

```bash
$ sudo ip link set veth1 netns ns1
$ sudo ip netns exec ns1 ip link set dev veth1 up

$ sudo ip link set veth2 netns ns2
$ sudo ip netns exec ns2 ip link set dev veth2 up
These commands install and activate the veth1 end to the ns1 namespace and the veth2 end to the ns2 namespace respectively.
```

One thing to notice, the line of

sudo ip netns exec ns1 ip link set dev veth1 up
is actually the shorthand of

```bash
sudo ip netns exec ns1 bash
ip link set dev veth1 up
```

The first command opens a shell within the ns1 namespace. The second command activates the veth1 interface inside the ns1 namespace. After activating the veth1 interface inside the ns1 namespace, youc an type

```bash
exist
```

to exist the ns1 and jump back to the host where your vagrant is running.

Splitting the command in this way allows for better readability and individual execution of each part of the command related to setting up the interface within the specific namespace. But, it can be slower, hence, I will mostly use the shorthand in the following step, but it’s good practice to split the command so you are super clear about which namespace you are executing. I will leave that part for you.

## 3. Configure IP Addresses for the Veth Interfaces

If you inspect the veth1 inside the ns1

```bash
sudo ip netns exec ns1 ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
8: veth1@if7: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 42:e9:53:6b:7d:7f brd ff:ff:ff:ff:ff:ff link-netnsid 0
       valid_lft forever preferred_lft forever
```

In the output, you see veth1 has no IP information available.

Let’s configure IP addresses (IP CIDR) for the Veth interfaces within their respective namespaces. Execute the following commands:

```bash
sudo ip netns exec ns1 ip addr add 192.168.1.1/24 dev veth1 && sudo ip netns exec ns1 ip link set dev veth1 up
sudo ip netns exec ns2 ip addr add 192.168.1.2/24 dev veth2 && sudo ip netns exec ns2 ip link set dev veth2 up
```

![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*UEoFaEvwIH8IiOaoypMG-Q.png)

These commands assign the IP address 192.168.1.1/24 to the veth1 interface within ns1 and 192.168.1.2/24 to the veth2 interface within ns2.

You can verify that veth now has IP of 192.168.1.1/24

```bash
sudo ip netns exec ns1 ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
8: veth1@if7: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 42:e9:53:6b:7d:7f brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.168.1.1/24 brd 192.168.1.255 scope global veth1
       valid_lft forever preferred_lft forever
```

Now that we have set up the Veth devices and configured IP addresses, the network namespaces ns1 and ns2 are ready to communicate (ping each other).

Testing Connectivity between Network Namespaces
To test the connectivity, let’s open two terminals, one for each namespace:

Terminal 1 (for ns1):

```bash
sudo ip netns exec ns1 bash
```

Terminal 2 (for ns2):

```bash
sudo ip netns exec ns2 bash
```

In Terminal 1 (ns1), you can now ping the IP address of veth2 in ns2:

```bash
ping 192.168.1.2
```

If everything is set up correctly, you should see successful ICMP echo replies.

To capture the ICMP traffic in ns2 using tcpdump, execute the following command in Terminal 2 (ns2):

```bash
sudo ip netns exec ns2 tcpdump -i veth2 icmp
```

You should now see the captured ICMP traffic on the veth2 interface within ns2.

The output will display the ICMP packets that are being sent and received on the `eth2` interface.

```bash
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth2, link-type EN10MB (Ethernet), capture size 262144 bytes
08:30:15.732396 IP 192.168.1.1 > 192.168.1.2: ICMP echo request, id 1234, seq 1, length 64
08:30:15.732409 IP 192.168.1.2 > 192.168.1.1: ICMP echo reply, id 1234, seq 1, length 64
08:30:16.732601 IP 192.168.1.1 > 192.168.1.2: ICMP echo request, id 1234, seq 2, length 64
08:30:16.732613 IP 192.168.1.2 > 192.168.1.1: ICMP echo reply, id 1234, seq 2, length 64
…
```

In the output, each line represents a captured ICMP packet. It includes information such as the source IP address, destination IP address, ICMP type (echo request or echo reply), ICMP identifier, sequence number, and packet length.

You will see a continuous stream of ICMP packets as they are being captured in real-time.

you have created two namespaces, and successfully established communication between these originally isolated network namespaces via the Veth devices/pair created by you.

![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*pH7-RpFLr97aoT34mPUyhA.png)

In this tutorial, we explore the concepts of network namespaces and virtual Ethernet (Veth) devices in Linux. We created isolated network environments and establishing communication between them and observe the traffic. These concepts are fundamental in network virtualization and isolation, providing a powerful toolset for various networking scenarios.
