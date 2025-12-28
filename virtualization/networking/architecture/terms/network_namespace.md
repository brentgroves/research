# Network Namespace

## references

<https://lwn.net/Articles/580893/>

## Namespaces in operation, part 1: namespaces overview

The Linux 3.8 merge window saw the acceptance of Eric Biederman's sizeable series of user namespace and related patches. Although there remain some details to finish—for example, a number of Linux filesystems are not yet user-namespace aware—the implementation of user namespaces is now functionally complete.

The completion of the user namespaces work is something of a milestone, for a number of reasons. First, this work represents the completion of one of the most complex namespace implementations to date, as evidenced by the fact that it has been around five years since the first steps in the implementation of user namespaces (in Linux 2.6.23). Second, the namespace work is currently at something of a "stable point", with the implementation of most of the existing namespaces being more or less complete. This does not mean that work on namespaces has finished: other namespaces may be added in the future, and there will probably be further extensions to existing namespaces, such as the addition of namespace isolation for the kernel log. Finally, the recent changes in the implementation of user namespaces are something of a game changer in terms of how namespaces can be used: starting with Linux 3.8, unprivileged processes can create user namespaces in which they have full privileges, which in turn allows any other type of namespace to be created inside a user namespace.

Thus, the present moment seems a good point to take an overview of namespaces and a practical look at the namespace API. This is the first of a series of articles that does so: in this article, we provide an overview of the currently available namespaces; in the follow-on articles, we'll show how the namespace APIs can be used in programs.

## The namespaces

Currently, Linux implements six different types of namespaces. The purpose of each namespace is to wrap a particular global system resource in an abstraction that makes it appear to the processes within the namespace that they have their own isolated instance of the global resource. One of the overall goals of namespaces is to support the implementation of containers, a tool for lightweight virtualization (as well as other purposes) that provides a group of processes with the illusion that they are the only processes on the system.

In the discussion below, we present the namespaces in the order that they were implemented (or at least, the order in which the implementations were completed). The CLONE_NEW* identifiers listed in parentheses are the names of the constants used to identify namespace types when employing the namespace-related APIs (clone(), unshare(), and setns()) that we will describe in our follow-on articles.

**[Mount namespaces](http://lwn.net/2001/0301/a/namespaces.php3)** (CLONE_NEWNS, Linux 2.4.19) isolate the set of filesystem mount points seen by a group of processes. Thus, processes in different mount namespaces can have different views of the filesystem hierarchy. With the addition of mount namespaces, the mount() and umount() system calls ceased operating on a global set of mount points visible to all processes on the system and instead performed operations that affected just the mount namespace associated with the calling process.

## **[Namespaces in operation, part 7: Network namespaces](https://lwn.net/Articles/580893/)**

As the name would imply, network namespaces partition the use of the network—devices, addresses, ports, routes, firewall rules, etc.—into separate boxes, essentially virtualizing the network within a single running kernel instance. Network namespaces entered the kernel in 2.6.24, almost exactly five years ago; it took something approaching a year before they were ready for prime time. Since then, they seem to have been largely ignored by many developers.

## Basic network namespace management

As with the others, network namespaces are created by passing a flag to the clone() system call: CLONE_NEWNET. From the command line, though, it is convenient to use the ip networking configuration tool to set up and work with network namespaces. For example:

```bash
ip netns add netns1
```

This command creates a new network namespace called netns1. When the ip tool creates a network namespace, it will create a bind mount for it under /var/run/netns; that allows the namespace to persist even when no processes are running within it and facilitates the manipulation of the namespace itself. Since network namespaces typically require a fair amount of configuration before they are ready for use, this feature will be appreciated by system administrators.

The bind option of the mount command allows you to remount part of a file hierarchy at a different location while it is still available at the original location.

5.13. /var/run : Run-time variable data
5.13.1. Purpose
This directory was once intended for system information data describing the system since it was booted. These functions have been moved to /run; this directory exists to ensure compatibility with systems and software using an older version of this specification.

<https://lwn.net/Articles/436012/>

/run is now a tmpfs, and /var/run is bind mounted to it. /var/lock is
bind mounted to /run/lock. Applications can use /run the same way as
/var/run. Since the latter is FHS/LSB most apps should just use the
latter, only early boot stuff should use /run, for now. The folks who
have packages where this applies already have been informed. If you
haven't heard from any of us, then this doesn't apply to you.

So, what's the benefit of this again?

- There's only one tmpfs used, backing /run, /var/lock and /var/run,
  reducing a bit the ever increasing amount of tmpfs' used on a default
  system.

- All runtime data at the same place. systemd's, udev's, dracut's data
  are all beneath /run and /var/run now. Easily discoverable to the
  admin. For the first time you can see the data all these important
  tools used on your system store just like any other by doing "ls
  /var/run".

```bash
sudo ls /var/run        
acpid.pid     console-setup  cups         fsck       irqbalance  netns           plymouth         snapd-snap.socket  sshd.pid    udev                      uuidd
acpid.socket  containerd     dbus         gdm3       lock        NetworkManager  screen           snapd.socket       sudo        udisks2                   vsftpd
alsa          credentials    docker       gdm3.pid   log         openvpn         sendsigs.omit.d  speech-dispatcher  systemd     unattended-upgrades.lock  xrdp
avahi-daemon  crond.pid      docker.pid   initctl    motd.d      openvpn-client  shm              spice-vdagentd     thermald    user                      xtables.lock
blkid         crond.reboot   docker.sock  initramfs  mount       openvpn-server  snapd            sshd               tmpfiles.d  utmp
```

The "ip netns exec" command can be used to run network management commands within the namespace:

```bash
ip netns exec netns1 ip link list
    1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN mode DEFAULT 
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
This command lists the interfaces visible inside the namespace. A network namespace can be removed with:

ip netns delete netns1
This command removes the bind mount referring to the given network namespace. The namespace itself, however, will persist for as long as any processes are running within it.

```

Network namespace configuration
New network namespaces will have a loopback device but no other network devices. Aside from the loopback device, each network device (physical or virtual interfaces, bridges, etc.) can only be present in a single network namespace. In addition, physical devices (those connected to real hardware) cannot be assigned to namespaces other than the root. Instead, virtual network devices (e.g. virtual ethernet or veth) can be created and assigned to a namespace. These virtual devices allow processes inside the namespace to communicate over the network; it is the configuration, routing, and so on that determine who they can communicate with.

When first created, the lo loopback device in the new namespace is down, so even a loopback ping will fail:

```bash
ip netns exec netns1 ping 127.0.0.1
    connect: Network is unreachable
Bringing that interface up will allow pinging the loopback address:
    # ip netns exec netns1 ip link set dev lo up
    # ip netns exec netns1 ping 127.0.0.1
    PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.
    64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.051 ms
    ...
```

Bringing that interface up will allow pinging the loopback address:
    # ip netns exec netns1 ip link set dev lo up
    # ip netns exec netns1 ping 127.0.0.1
    PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.
    64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.051 ms
    ...
But that still doesn't allow communication between netns1 and the root namespace. To do that, virtual ethernet devices need to be created and configured:
    # ip link add veth0 type veth peer name veth1
    # ip link set veth1 netns netns1

The first command sets up a pair of virtual ethernet devices that are connected. Packets sent to veth0 will be received by veth1 and vice versa. The second command assigns veth1 to the netns1 namespace.
    # ip netns exec netns1 ifconfig veth1 10.1.1.1/24 up
    # ifconfig veth0 10.1.1.2/24 up
Then, these two commands set IP addresses for the two devices.
    # ping 10.1.1.1
    PING 10.1.1.1 (10.1.1.1) 56(84) bytes of data.
    64 bytes from 10.1.1.1: icmp_seq=1 ttl=64 time=0.087 ms
    ...

    # ip netns exec netns1 ping 10.1.1.2
    PING 10.1.1.2 (10.1.1.2) 56(84) bytes of data.
    64 bytes from 10.1.1.2: icmp_seq=1 ttl=64 time=0.054 ms
    ...
Communication in both directions is now possible as the ping commands above show.

As mentioned, though, namespaces do not share routing tables or firewall rules, as running route and iptables -L in netns1 will attest.

    # ip netns exec netns1 route
    # ip netns exec netns1 iptables -L
The first will simply show a route for packets to the 10.1.1 subnet (using veth1), while the second shows no iptables configured. All of that means that packets sent from netns1 to the internet at large will get the dreaded "Network is unreachable" message. There are several ways to connect the namespace to the internet if that is desired. A bridge can be created in the root namespace and the veth device from netns1. Alternatively, IP forwarding coupled with network address translation (NAT) could be configured in the root namespace. Either of those (and there are other configuration possibilities) will allow packets from netns1 to reach the internet and for replies to be received in netns1.
Non-root processes that are assigned to a namespace (via clone(), unshare(), or setns()) only have access to the networking devices and configuration that have been set up in that namespace—root can add new devices and configure them, of course. Using the ip netns sub-command, there are two ways to address a network namespace: by its name, like netns1, or by the process ID of a process in that namespace. Since init generally lives in the root namespace, one could use a command like:

    # ip link set vethX netns 1
That would put a (presumably newly created) veth device into the root namespace and it would work for a root user from any other namespace. In situations where it is not desirable to allow root to perform such operations from within a network namespace, the PID and mount namespace features can be used to make the other network namespaces unreachable.

```bash
# From reports1 k8s cluster
ip netns list
cni-3415112c-7188-57b8-a2b5-33e00e73e5c0 (id: 6)
cni-5c22117f-dfc1-3cd4-cf74-46cd4d473a10 (id: 5)
cni-00b4ddf8-b38a-7c21-ad79-2220af009c1d (id: 4)
cni-43c4f73a-eabf-7a07-7bef-4b47c49732c4 (id: 3)
cni-d7fa7a8c-f3dd-60a2-0761-b19736e9af04 (id: 2)
ip netns exec cni-d7fa7a8c-f3dd-60a2-0761-b19736e9af04 ping 127.0.0.1
```
