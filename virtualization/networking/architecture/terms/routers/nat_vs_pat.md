# **[NAT vs PAT](https://orhanergun.net/nat-vs-pat)**

## Pros and Cons of NAT

NAT, or Network Address Translation, is a technology commonly used in networks to allow for the use of public and private IP addresses. Without NAT, every network device would need its unique public IP address, which can be scarce and expensive to obtain.

![](https://orhanergun.net/uploads/blog/thumbnail/network-address-translation-definition.jpg)

NAT allows for a single public IP address to be shared among multiple devices with private IP addresses. This conserves public IP addresses and adds an extra layer of security as private IP addresses are not routed on the public internet.

## Advantages of NAT

NAT essentially serves as a protective measure for registered public addresses and helps to prevent IP address space exhaustion.
Addresses will no longer be renumbered when you switch networks.
Address overlap happens much less frequently.
Increased connection establishment flexibility.

## Disadvantages of NAT

No end-to-end traceability
Incompatible with some applications
Path delays occur when switching

## Pros and Cons of PAT

PAT, also known as port address translation, is an extension of network address translation (NAT). It allows a single public IP address to be used by multiple devices within a private network. This is accomplished by assigning each device a unique port number and routing incoming traffic accordingly. The main advantage of using PAT is that it helps to conserve scarce public IP addresses. In that sense, both NAT and PAT are similar.

![](https://orhanergun.net/uploads/blog/thumbnail/what-is-pat.jpg)

It also provides an added security layer since the traffic from a specific device can be easily identified by its port number. Additionally, PAT can also improve performance for certain applications, such as online gaming and video streaming. Overall, PAT is a useful tool for managing internet connections within a private network.

## Advantages of PAT

IP addresses are conserved by using a single public IP for a group of hosts with different port numbers.
By having a private address, you are lessening the chance of security flaws or attacks as opposed to if you had a public address.

## Disadvantages of PAT

The internal table is limited to a specific number of entries to manage connections.
In PAT, you cannot run more than one instance of the same public service from the same IP address.

## Different Types of NAT and PAT

You might expect to see different types of NAT and PAT while researching the differences between NAT vs. PAT. Let's try to explain some of the different types of NAT and PAT...

Static NAT is a type of Network Address Translation (NAT) that gives a fixed mapping between one internal IP address and one external IP address. This is in contrast to Dynamic NAT, which gives a different mapping each time it's used. Static NAT is useful for devices that need to have the same external IP address all the time, such as a web server.

In static PAT, IP addresses and port numbers are changed, and the mapping between pre-translation and post-translation attributes is explicitly known. On the other hand, in dynamic PAT, the router decides this mapping every time.
