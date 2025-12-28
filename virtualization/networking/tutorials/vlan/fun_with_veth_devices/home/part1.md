# **[Fun with veth-devices, Linux bridges and VLANs in unnamed Linux network namespaces – I](https://linux-blog.anracom.com/2017/10/30/fun-with-veth-devices-linux-bridges-and-vlans-in-unnamed-linux-network-namespaces-i/)**
 

**[Back to Research List](../../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../../README.md)**

## references

- **[redhat vlan tutorial](https://developers.redhat.com/blog/2018/10/22/introduction-to-linux-interfaces-for-virtual-networking#vlan)**
- **[extreme swtiches](https://emc.extremenetworks.com/content/oneview/docs/network/devices/docs/l_ov_cf_vlan.html#:~:text=Port%20VLAN%20ID's.-,VLAN%20ID%20(VID),(VIDs)%20and%20VLAN%20names.&text=A%20unique%20number%20between%201,reserved%20for%20the%20Default%20VLAN.)**

In the previous posts of this series

- **[Fun with veth-devices, Linux bridges and VLANs in unnamed Linux network namespaces – II](https://linux-blog.anracom.com/2017/11/12/fun-with-veth-devices-linux-bridges-and-vlans-in-unnamed-linux-network-namespaces-ii/)**
- **[Fun with veth-devices, Linux bridges and VLANs in unnamed Linux network namespaces – III](https://linux-blog.anracom.com/2017/11/14/fun-with-veth-devices-linux-bridges-and-vlans-in-unnamed-linux-network-namespaces-iii/)**
- **[Fun with veth-devices, Linux bridges and VLANs in unnamed Linux network namespaces – IV](https://linux-blog.anracom.com/2017/11/20/fun-with-veth-devices-linux-bridges-and-vlans-in-unnamed-linux-network-namespaces-iv/#:~:text=Both%20variants%20can%20also%20be,trunk%20interface%20a%20trunk%20port.)**

## home network

```bash
 nmap -sP 192.168.1.0/24
Starting Nmap 7.95 ( https://nmap.org ) at 2025-02-22 09:43 EST
Nmap scan report for router.home (192.168.1.1)
Host is up (0.00065s latency).
Nmap scan report for moto (192.168.1.60)
Host is up (0.0015s latency).
Nmap scan report for k8sgw1 (192.168.1.65)
Host is up (0.0011s latency).
Nmap scan report for 43onnRokuTV.home (192.168.1.173)
Host is up (0.0031s latency).
Nmap scan report for users-airport-extreme.home (192.168.1.205)
Host is up (0.0050s latency).
Nmap scan report for 32HisenseRokuTV.home (192.168.1.223)
Host is up (0.0053s latency).
Nmap done: 256 IP addresses (6 hosts up) scanned in 2.57 seconds
```
Fun with veth-devices, Linux bridges and VLANs in unnamed Linux network namespaces – I
Posted on 30. October 2017 by eremo

Recently, I started writing some blog posts about my first experiences with LXC-containers and libvirt/virt-manager. Whilst gathering knowledge about LXC basics I stumbled across four hurdles for dummies as me, who would like to experiment with network namespaces, veth devices and bridges on the command line and/or in the context of LXC-containers built with virt-manager:

When you use virt-manager/libvirt to set up LXC-containers you are no longer able to use the native LXC commands to deal with these containers. virt-manager/virsh/libvirt directly use the kernel API for cgroups/namespaces and provide their own and specific user interfaces (graphical, virsh, XML configuration files) for the setup of LXC containers and their networks. Not very helpful for quick basic experiments on virtual networking in network namespaces ….
LXC-containers created via virt-manager/virsh/libvirt use unnamed namespaces which are identified by unique inode numbers, but not by explicit names. However, almost all articles on the Internet which try to provide a basic understanding of network namespaces and veth devices explicitly use “ip” command options for named namespaces. This raises the question: How to deal with unnamed network namespaces?
As a beginner you normally do not know how to get a shell for exploring an existing unnamed namespace. Books offer certain options of the “ip”-command – but these again refer to named network namespaces. You may need such a shell – not only for basic experiments, but also as the administrator of the container’s host: there are many situations in which you would like to enter the (network) namespace of a LXC container directly.
When you experiment with complex network structures you may quickly loose the overview over which of the many veth interfaces on your machine is assigned to which (network) namespace.
Objectives and requirements
Unfortunately, even books as “Containerization with LXC” of K. Ivanov did not provide me with the few hints and commands that would have been helpful. I want to close this gap with some blog posts. The simple commands and experiments shown below and in a subsequent article may help others to quickly setup basic network structures for different namespaces – without being dependent on named namespaces, which will not be provided by virt-manager/libvirt. I concentrate on network namespaces here, but some of the things may work for other types of namespace, too.

After a look at some basics, we will create a shell associated with a new unnamed network namespace which will be different from the network namespace of other system processes. Afterwards we will learn how to enter an existing unnamed namespaces by a new shell. A third objective is the attachment of virtual network devices to a network namespace.

In further articles we will use our gathered knowledge to attach veth interfaces of 2 different namespaces to virtual bridges/switches in yet a third namespace, then link the host to the bridge/switch and test communications as well as routing. We shall the extend our virtual networking scenario to isolated groups of namespaces (or containers, if you like) via VLANs. As a side aspect we shall learn how to use a Linux bridge for defining VLANs.

All our experiments will lead to temporary namespaces which can quickly be cretated by scripts and destroyed by killing the basic shell processes associated with them.

Requirements: The kernel should have been compiled with option “CONFIG_NET_NS=y”. We make use of userspace tools that are provided as parts of a RPM or DEB packet named “util-linux” on most Linux distributions.

## Namespaces

Some basics first. There are 6 different types of “namespaces” for the isolation of processes or process groups on a Linux system. The different namespace types separate

- PID-trees,
- the networks,
- User-UIDs,
- mounts,
- inter process communication,
- host/domain-names (uts) of process groups

against each each other. Every process on a host is attached to certain namespace (of each type), which it may or may not have in common with another process. Note that the uts-namespace type provides an option to give a certain process an uts-namespace which may get a different hostname than the original host of the process!

“Separation” means: Limitation of the view on the process’ own environment and on the environment of other processes on the system. “Separation” also means a limitation of the control a process can get on processes/environments associated with other namespaces.

Therefore, to isolate LXC containers from other containers and from the host, the container’s processes will typically be assigned to distinct namespaces of most of the 6 types. In addition: The root filesystem of a LXC containers typically resides in a chroot jail.

Three side remarks:

1. cgroups limit the resource utilization of process groups on a host. We do not look at cgroups in this article.
2. Without certain measures the UID namespace of a LXC container will be the same as the namespace of the host. This is e.g. the case for a standard container created with virt-manager. Then root in the container is root on the host. When a container’s basic processes are run with root-privileges of the host we talk of a “privileged container”. Privileged containers pose a potential danger to the host if the container’s environment could be left. There are means to escape chroot jails – and under certain circumstances there are means to cross the borders of a container … and then root is root on the host.
3. You should be very clear about the fact that a secure isolation of processes and containers on a host depend on other more sophisticated isolation mechanisms beyond namespaces and chroot jails. Typically, SE Linux or Apparmor rules may be required to prevent crossing the line from a namespace attached process to the host environment.

In our network namespace experiments below we normally will not separate the UID namespaces. If you need to do it, you must map a non-privileged UID (> 1000) on UID 0 inside the namespace to be able to perform certain network operations. See the options in the man pages of the commands used below for this mapping.

