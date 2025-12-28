# VPN tunnel

## references

<https://cybernews.com/what-is-vpn/what-is-a-vpn-tunnel/>
<https://www.paloaltonetworks.com/cyberpedia/what-is-a-business-vpn-understand-its-uses-and-limitations#:~:text=A%20business%20VPN%20is%20exactly,need%20to%20do%20their%20jobs>.

<https://www.paloaltonetworks.com/resources/videos/enabling-a-secure-remote-workforce-to-support-business-continuity>

## **[Site-to-Site VPN](https://www.paloaltonetworks.com/cyberpedia/what-is-a-site-to-site-vpn)**

A site-to-site virtual private network (VPN) is a connection between two or more networks, such as a corporate network and a branch office network. Many organizations use site-to-site VPNs to leverage an internet connection for private traffic as an alternative to using private MPLS circuits.

Site-to-site VPNs are frequently used by companies with multiple offices in different geographic locations that need to access and use the corporate network on an ongoing basis. With a site-to-site VPN, a company can securely connect its corporate network with its remote offices to communicate and share resources with them as a single network.

![](https://www.paloaltonetworks.com/content/dam/pan/en_US/images/cyberpedia/site-to-site-vpn.png?imwidth=1920)

Site-to-site VPNs and remote access VPNs may sound similar, but they serve entirely different purposes.

- A site-to-site VPN is a permanent connection designed to function as an encrypted link between offices (i.e., “sites”). This is typically set up as an IPsec network connection between networking equipment.

Unlike a remote access VPN, which connects individual devices or users to an organization’s corporate network, a site-to-site VPN is a connection between two or more networks, such as a corporate network and a branch office network. Many organizations choose site-to-site VPNs so they can use an internet connection for private traffic rather than private multiprotocol label switching (MPLS) circuits.

## What Is a Business VPN?

A business VPN is exactly what it sounds like: a VPN connection used by businesses and other professional organizations to securely connect their remote workforces and branch offices to the applications, data, tools and resources they need to do their jobs.

## What is a VPN tunnel and how does it work?

Although most people have vague understanding what is a VPN and how it's used, few can explain how it works. VPNs were something that was invented to more easily share data, so the terminology can get quite technical and quite confusing.

In this article, I’ll try my best to explain the central part of VPN setup – tunneling.

## What is a VPN tunnel?

A VPN tunnel is an encrypted connection between your device and a VPN server. It's uncrackable without a cryptographic key, so neither hackers nor your Internet Service Provider (ISP) could gain access to the data. This protects users from attacks and hides what they're doing online.

Effectively, VPN tunnels are a private route to the internet via intermediary servers. That's why VPNs are popular among privacy-cautious individuals.

## How does VPN tunneling work?

Generally speaking, VPN tunneling means simply using a VPN service. Therefore, the answer to "How does VPN tunneling work?" is virtually the same as to "How does a VPN work?".

![](https://media.cybernews.com/2021/01/What-is-a-VPN-tunnel.jpg)

And now here's what a VPN tunnel does:

- Traffic encryption. Your data becomes protected from the third-parties.
- Hiding your IP address. The VPN tunnel funnels your traffic through to a VPN server, hiding your IP. Without the IP, there's no way to tell your location.
- Securing wifi hotspots. You no longer have to worry about your safety when using public wifi.

To make VPN tunneling work, first, you have to get a VPN service. Once you connect to the desired server, a VPN tunnel will be established. Without it, your ISP sees everything you do online, but this is impossible after you connect to a VPN server. That's because of the encryption and hidden IP address.

Most VPN services claim to have a strict no-logs policy, which means they don’t monitor and store personally identifiable information or online activity data. Having said all that, your best bet is to use a reputable VPN service that either has an independently-audited or no logs policy or one that's been tested in the wild.

## VPN tunnel security - can it be hacked?

If VPN connection is so secure, is it actually possible to hack it? Unfortunately, yes - but that’s much less common than you think. You shouldn’t worry about that if you’re just a regular user, as hackers usually prey only on high-profit targets like million-dollar companies.

So, how can a VPN tunnel be hacked? Well, as breaking the encryption itself is virtually impossible (unless there’s a known vulnerability), the most common way is stealing the encryption key. This can be done in a lot of different ways, however, using a reputable VPN greatly minimizes the risk.

For example, VPNs like NordVPN use a 4096-bit DH (Diffie-Hellman) key cipher, which makes the key exchange in a VPN connection extremely secure.

## Types of VPN tunnel protocols

A tunneling protocol, or a VPN protocol, is software that allows securely sending and receiving data among two networks. Some may excel in speed but have lackluster security and vice versa.

At the moment of writing this article, the most popular tunnel protocols are OpenVPN, IKEv2/IPSec, and L2TP/IPSec. However, the next-gen WireGuard protocol is being implemented in many premium VPN services.

Below you will find a list of VPN tunneling protocols, ranked from best to worst. Don't forget that not all providers offer the same set of protocols, and even if they do, their availability will be different across desktop and mobile devices.

1. WireGuard
Security: Very high
Speed: Very high

WireGuard is hands-down the best tunnel protocol available right now. It offers unprecedented speed and security, using top-notch encryption. What's more, this open-source protocol is easy to implement and audit thanks to its lightweight code, consisting of only 4000 lines. That's a hundred times less than OpenVPN, the most popular protocol.

Built from the ground up, WireGuard is free from any disadvantages that come with an old framework. It's also free from the negative impact of network changes, making it a go-to choice for mobile users.

2.OpenVPN
Security: High
Speed: High

Released almost two decades ago, OpenVPN is still the most popular tunneling protocol. However, because of WireGuard, it's slowly losing its position for good. Despite that, you still get first-class security and fast speeds with this open-source VPN tunneling protocol.

You may encounter two versions of OpenVPN – TCP and UDP. The former is more stable and the latter offers a faster connection.

3.IKEv2/IPSec
Security: High
Speed: High

This combination of protocol rivals OpenVPN in terms of popularity, security, and speed. IKEv2 excels at maintaining your VPN connection whenever you switch from one network to another. Due to the native support, it's especially popular on iPhone and iPad devices.

## VPN split tunneling

Split tunneling allows you to choose which websites or apps should use a VPN tunnel and which ones should stay outside. This feature is useful when you want to watch a show that's available in the US and read a local version of a news portal. Another example would be using your office's printer while torrenting securely with a VPN.

![](https://media.cybernews.com/2020/11/CN-split-tunneling.jpg)
