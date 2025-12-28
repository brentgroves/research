# **[Introduction to Netfilter](https://blogs.oracle.com/linux/post/introduction-to-netfilter)**

## Introduction

In this page, we are going to understand the various features of netfilter hooks, their functionality, and how to utilize them.

Netfilter is a subsystem that was introduced in the Linux 2.4 kernel that provides a framework for implementing advanced network functionalities such as packet filtering, network address translation (NAT), and connection tracking. It achieves this by leveraging hooks in the kernel’s network code, which are the locations where kernel code can register functions to be invoked for specific network events. For instance, when a packet is received, it triggers a handler for the event and performs module specified actions.

## Background - Netfilter Architecture

The netfilter framework provides a powerful mechanism for intercepting and manipulating network packets in the Linux kernel. This framework has 2 components to it - Netfilter hooks and conntrack. In this blog, we will focus mostly on the netfilter hooks. Whilst there are different Netfilter hooks available for different protocols, in this blog we will concentrate on IPv4 netfilter hooks.

## Netfilter Hooks

Netfilter hooks are functions that are registered with the kernel to be called at specific points in the network stack. These hooks can be viewed as checkpoints in the different layers of the network stack. They allow the kernel modules to implement custom firewall rules, network address translation, packet filtering, logging, and more. Pre-defined functions that are performing tasks such as filtering and logging can be hot-plugged into the kernel, which makes them easier to use.

There are five predefined netfilter hook points:

- **NF_IP_PRE_ROUTING:** The callbacks registered to this hook will be triggered by any incoming traffic very soon after entering the network stack. This hook is processed before any routing decisions have been made regarding where to send the packet i.e. to check if this packet is destined for another interface, or a local process. The routing code may drop packets that are unrouteable.
- **NF_IP_LOCAL_IN:** The callbacks registered to this hook are triggered after an incoming packet has been routed and the packet is destined for the local system.
- **NF_IP_FORWARD:** The callbacks registered to this hook are triggered after an incoming packet has been routed and the packet is to be forwarded to another host.
- **NF_IP_LOCAL_OUT:** The callbacks registered to this hook are triggered by any locally created outbound traffic as soon it hits the network stack.
- **NF_IP_POST_ROUTING:** The callbacks registered to this hook are triggered by any outgoing or forwarded traffic after routing has taken place and just before being put out on the wire.

Each hook point corresponds to a different stage of packet processing, as shown in the diagram below:

![](https://blogs.oracle.com/content/published/api/v1.1/assets/CONTA49E135C72694072948F0F9816404B23/Medium?cb=_cache_31b4&channelToken=3189ef66cf584820b5b19e6b10792d6f&format=jpg)

When a packet arrives at or leaves a network interface, it passes through each of these hook points in order. At each hook point, the kernel calls all the registered netfilter hook functions for that hook point. Each netfilter hook function can inspect the packet and decide what to do with it. The possible actions are:

- **Accept:** The packet is allowed to continue to the next hook point or the destination.
- **Drop:** The packet is silently discarded and no further processing is done.
- **Queue:** The packet is queued for userspace processing by a daemon such as iptables or nftables.
- **Repeat:** The packet is re-injected at the same hook point for another round of processing.
- **Stop:** The packet is accepted and no further processing is done.

## Netfilter APIs

One needs to call nf_register_net_hook() with a pointer to a net structure (usually &init_net) and a pointer to the nf_hook_ops structure. This will register the netfilter hook function with the kernel and make it active.

To unregister a netfilter hook function, one needs to call nf_unregister_net_hook() with the same parameters.

One can attach multiple callback functions to the same hooks and perform different operations based on the requirement. Let’s try to visualize what this looks like.

![](https://blogs.oracle.com/content/published/api/v1.1/assets/CONT0E12FB1217624876A18BD7E71AE68359/Medium?cb=_cache_31b4&channelToken=3189ef66cf584820b5b19e6b10792d6f&format=jpg)

## Kernel Code analysis of NF Hooks

To understand the code flow of these netfilter hooks in the kernel, let’s take a simple example of the NF_INET_PRE_ROUTING hook.

When an IPv4 packet is received, its handler function ip_rcv is triggered as follows:

Source taken from net/ipv4/input.c in linux kernel [1].

```c
/*
* IP receive entry point
*/
int ip_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type *pt, struct net_device *orig_dev)
{
    struct net *net = dev_net(dev);

    skb = ip_rcv_core(skb, net);
    if (skb == NULL) {
        return NET_RX_DROP;
    }

    return NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING, net, NULL, skb, dev, NULL, ip_rcv_finish);
}
```

In this handler function, you can see the hook is passed to the funciton NF_HOOK . Now this triggers hook functions attached to NF_INET_PRE_ROUTING and once they all are returned then ip_rcv_finish would be called, which is again an argument to the NF_HOOK callback.

Source taken from include/linux/netfilter.h in linux kernel [2].

```c
static inline int NF_HOOK(uint8_t pf, unsigned int hook, struct net *net, struct sock *sk, struct sk_buff *skb, struct net_device *in, struct net_device *out, int (*okfn)(struct net *, struct sock *, struct sk_buff *))
{
    int ret = nf_hook(pf, hook, net, sk, skb, in, out, okfn);

    if (ret == 1) {
        ret = okfn(net, sk, skb);
    }
    return ret;
}
```

This returns 1, if the hook has allowed the packet to pass. The function okfn must be invoked by the caller in this case. Any other return value indicates the packet has been consumed by the hook.

## **[Writing a Netfilter module](https://medium.com/dvt-engineering/how-to-write-your-first-linux-kernel-module-cf284408beeb)**

Now that we are clear on the concepts of netfilter hooks. Let’s understand how to use these hooks to perform a simple logging operation of packets in the network stack. To hot-plug the callbacks to these hooks, users need to write a kernel module that defines and registers one or more netfilter hook functions.

Source taken from include/linux/netfilter.h in linux kernel [2].
