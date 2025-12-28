# **[How to Set DNS Nameserver on Ubuntu](https://phoenixnap.com/kb/ubuntu-dns-nameservers)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Tasks](../../../../../a_status/current_tasks.md)**\
**[Back to Detailed Status](../../../../../a_status/detailed_status.md)**\

**[Back to Main](../../../../../README.md)**

The Domain Name System (DNS) translates text-based domain names to IP addresses. By default, most networks are configured to work with DNS servers supplied by the Internet Service Provider (ISP). However, users are free to change the DNS nameservers manually.

This tutorial will show you how to change DNS nameservers on your Ubuntu machine using the terminal or Graphical User Interface (GUI).

| Provider   | Purpose                                       | IPv4 Addresses                | IPv6 Addresses                            |
|------------|-----------------------------------------------|-------------------------------|-------------------------------------------|
| Google     | Speed improvements.                           | 8.8.8.8 8.8.4.4               | 2001:4860:4860::8888 2001:4860:4860::8844 |
| Cloudflare | Speed improvements.                           | 1.1.1.1 1.0.0.1               | 2606:4700:4700::1111 2606:4700:4700::1001 |
| Quad9      | Filters malware, phishing, and exploits.      | 9.9.9.9 149.112.112.112       | 2620:fe::fe 2620:fe::9                    |
| OpenDNS    | Security filtering and user-defined policies. | 208.67.222.222 208.67.220.220 | 2620:119:35::35 2620:119:53::53           |

## Prerequisites

- Ubuntu system (this tutorial uses Ubuntu 22.04 and 24.04).
- Access to the terminal.
- sudo or root privileges.

## Why Change DNS Nameserver on Ubuntu

In most cases, your default DNS settings offer optimal performance. However, there are scenarios in which you should consider changing the DNS server:

- Improved speed. Some DNS providers offer faster response times than the default DNS servers.
- Enhanced security. Some DNS providers offer additional security features, such as protection against phishing and malware.
- Increased reliability. Alternative DNS providers sometimes offer more reliable service with less downtime than the default ISP DNS servers.
- Privacy. Some DNS providers focus on user privacy and do not log your browsing data.
- Access to blocked content. In some cases, ISPs block access to certain websites by manipulating DNS responses. Changing to an alternative DNS server helps bypass such restrictions.

## How to Change DNS Nameserver on Ubuntu

There are several ways to change the DNS nameserver on Ubuntu. The following text elaborates on these methods.

### Change DNS Nameserver via resolve.conf

On earlier Linux distributions, configuring DNS nameservers involved editing the /etc/resolve.conf file directly. The process consisted of adding the desired DNS server entries and saving the file. The system would use those DNS servers for name resolution.

Modern Linux distros use systemd-resolved. Therefore, the /etc/resolv.conf file is a symbolic link managed by systemd-resolved. This means the file is dynamically generated and should not be edited manually. You can still edit them manually, but the changes are not permanent. For example:

1. Access /etc/resolv/conf using a text editor. For example, we use Nano:

`sudo nano /etc/resolv/conf`
2. Add or modify the nameserver entries with the desired DNS servers. For example:

nameserver 1.1.1.1
nameserver 1.0.0.1
3. Save and exit the file.

Note that resolv.conf is overwritten by systemd-resolved, and the changes may not be permanent.

The systemd-resolved service provides DNS resolution services, DNS caching, and other advanced features. It manages the /etc/resolv.conf file to ensure consistency.

Instead of manually editing /etc/resolv.conf, configure your DNS settings through systemd-resolved. Take the following steps:

1. Access the /etc/systemd/resolved.conf file in Nano or another text editor:

`sudo nano /etc/systemd/resolved.conf`

Use 'systemd-analyze cat-config systemd/resolved.conf' to display the full config.
2. Locate the [Resolve] section. This section contains the DNS-related settings for systemd-resolved.

![i1](https://phoenixnap.com/kb/wp-content/uploads/2024/07/resolve-section.png)

If [Resolve] does not exist, create it.
3. Add or modify the DNS settings in this file. For example, add the DNS and FallbackDNS settings.

The DNS parameter specifies the primary DNS servers systemd-resolved uses for DNS resolution. In the example, 1.1.1.1 and 1.0.0.1 are used, which are the IP addresses for Cloudflare's (DNS provider) DNS servers.

The FallbackDNS parameter specifies fallback DNS servers systemd-resolved uses if the primary DNS servers specified in the DNS parameter are unavailable. In the example, 8.8.8.8 and 8.8.4.4 are used, which are the IP addresses for Google's Public DNS servers.
4. Save the file.
5. Restart the systemd-resolved service:

`sudo systemctl restart systemd-resolved`

The command has no output.

## Change DNS Nameserver via Netplan

Another way to change DNS settings is via Netplan. Netplan is a utility in Ubuntu that simplifies the configuration of networking settings, including IP addresses, DNS servers, and routing. It uses YAML files to define network configurations. Take the following steps:

1. Go to the Netplan directory via the cd command:

`cd /etc/netplan`
2. List the directory contents with ls to see the name of the YAML file containing network configuration.

`ls`
3. Open the file in a text editor. Your file may have a different name.

`sudo nano 01-network-manager.yaml`

![i2](https://phoenixnap.com/kb/wp-content/uploads/2024/07/sudo-nano-01-network-manager-yaml-terminal-output.png)

Ethernet connections are listed in the ethernets section of the file. If there are any wireless connections, they are in the wifis section. Netplan stores the current **[DNS configuration](https://phoenixnap.com/kb/dns-configuration)** parameters in the nameservers subsections of each section.

![i3](https://phoenixnap.com/kb/wp-content/uploads/2023/03/resolvectl-status-google-dns-servers-terminal-output.png)

```bash
 resolvectl status
Global
         Protocols: -LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
  resolv.conf mode: stub

Link 2 (eno1)
    Current Scopes: DNS
         Protocols: +DefaultRoute -LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
Current DNS Server: 192.168.1.1
```

The addresses show as the current DNS server for the Global settings. Alternatively, run the dig command:

![i4](https://phoenixnap.com/kb/wp-content/uploads/2023/03/dig-phoenixnap.com-terminal-output-google-dns-server-configuration.png)

```bash
dig phoenixnap.com


; <<>> DiG 9.18.30-0ubuntu0.24.04.2-Ubuntu <<>> phoenixnap.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 31192
;; flags: qr rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 2, ADDITIONAL: 13

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;phoenixnap.com.                        IN      A

;; ANSWER SECTION:
phoenixnap.com.         30      IN      A       104.22.54.121
phoenixnap.com.         30      IN      A       104.22.55.121
phoenixnap.com.         30      IN      A       172.67.14.186

;; AUTHORITY SECTION:
phoenixnap.com.         170648  IN      NS      micah.ns.cloudflare.com.
phoenixnap.com.         170648  IN      NS      aleena.ns.cloudflare.com.

;; ADDITIONAL SECTION:
micah.ns.cloudflare.com. 78279  IN      A       108.162.193.206
micah.ns.cloudflare.com. 78279  IN      A       172.64.33.206
micah.ns.cloudflare.com. 78279  IN      A       173.245.59.206
aleena.ns.cloudflare.com. 85776 IN      A       108.162.194.81
aleena.ns.cloudflare.com. 85776 IN      A       162.159.38.81
aleena.ns.cloudflare.com. 85776 IN      A       172.64.34.81
micah.ns.cloudflare.com. 78279  IN      AAAA    2606:4700:58::adf5:3bce
micah.ns.cloudflare.com. 78279  IN      AAAA    2803:f800:50::6ca2:c1ce
micah.ns.cloudflare.com. 78279  IN      AAAA    2a06:98c1:50::ac40:21ce
aleena.ns.cloudflare.com. 85776 IN      AAAA    2606:4700:50::a29f:2651
aleena.ns.cloudflare.com. 85776 IN      AAAA    2803:f800:50::6ca2:c251
aleena.ns.cloudflare.com. 85776 IN      AAAA    2a06:98c1:50::ac40:2251

;; Query time: 15 msec
;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)
;; WHEN: Fri Apr 04 19:49:18 UTC 2025
;; MSG SIZE  rcvd: 410
```

## AI Overview

why does my dns server say 127.0.0.53?

The IP 127.0. 0.53 refers to a local resolver that runs on your machine. This is commonly seen in systems using systemd-resolved, which provides a DNS resolver service that caches DNS queries, improving performance and reducing the load on external DNS servers.Aug 18, 2024
