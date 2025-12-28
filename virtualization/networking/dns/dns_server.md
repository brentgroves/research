# **[Linux DNS Server Configuration: Detailed Guide](https://mailserverguru.com/linux-dns-server/)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Tasks](../../../../../a_status/current_tasks.md)**\
**[Back to Detailed Status](../../../../../a_status/detailed_status.md)**\

**[Back to Main](../../../../../README.md)**

## reference

- **[config](https://bind9.readthedocs.io/en/v9.20.7/reference.html#configuration-file-named-conf)**
- **[bind9 docs](https://bind9.readthedocs.io/en/v9.20.7/)**
- **[ubuntu doc](https://documentation.ubuntu.com/server/how-to/networking/install-dns/index.html)

This is a SUPER detailed Linux DNS Server Configuration tutorial for 2025.

In this tutorial you’ll learn, step-by-step, how to:

- Install and Configure Linux DNS Server
- Understand How DNS Server works
- Advanced Configuration Guideline
- Troubleshoot and Test DNS Servers

DNS servers play a crucial role in the internet ecosystem, and Linux is the primary choice for heavy-duty DNS deployments. Different types of DNS Servers serve different purposes.

In this article, we will learn How to Install and Configure Linux DNS Server. We will focus on four main types: Primary, Secondary, Caching-only and Forwarder DNS. Each of these will be explained in detail with scenarios, diagrams and practical use cases.

Ready? Let’s dive into this comprehensive Linux DNS server setup guide!

Types of DNS Servers in Linux
In Linux, DNS administration typically involves four main types of DNS servers:

Primary/Master DNS Server: A DNS server is referred to as “Primary” when it holds the authoritative records for a domain. It is responsible to provide definitive answers for that domain. It is the main server which provides DNS records to other DNS servers or clients.

Secondary/Slave DNS Server: A Secondary DNS server is defined by the zone declaration. This type of DNS server isn’t necessarily dedicated, but it can be. You can assign master and slave zones to different servers. The server hosting the slave zone is considered the Secondary DNS server, which syncs DNS records from the Primary.

![t](https://mailserverguru.com/wp-content/uploads/2024/10/dns-server-types-in-linux-1015x1024.webp)

Caching-Only DNS Server: A Caching-Only DNS server doesn’t host any zones. It’s primary function is to communicate with other DNS servers on the internet, to retrieve DNS records and stores them in it’s cache, it always serves responses to clients from it’s cache. This reduces the need to query external servers for repeated queries, thus improves the response time.

Forwarder DNS Server: This type of server forwards all DNS queries (when it doesn’t know the answer) to another designated DNS server, often a parent server. It then caches the responses like a Caching-Only server, speeding up future queries. The key difference is that its primary function is forwarding queries.

How DNS Server Works
Let’s explore how DNS server works from a practical standpoint:

Generally, DNS server works in a distributed manner, each server performs it’s own role.

The illustration below shows, how the four types of DNS servers communicate with one another for name resolution.

This scenario will clarify the unique roles and objectives of each server, whether they operate independently or coexist with other DNS servers on the same network.

Here, the 1st Server (Caching-only) sits at the corporate level, handling all DNS requests from client devices. It answers queries from its cache. If the answer isn’t in its cache, the server will query external DNS servers on the internet to fetch the response.

If the caching server is configured as a Forwarding DNS, it will forward unresolved queries to a designated parent DNS server to obtain the answer.

![f](https://mailserverguru.com/wp-content/uploads/2024/10/how-dns-server-works.gif)

The 2nd Server is an ISP level Forwarder DNS, At the ISP level, Forwarder DNS servers are typically configured to reduce bandwidth usage on port 53 (TCP/UDP) by caching as much DNS data as possible. This allows them to answer client queries directly from their cache, minimizing the need to forward requests upstream.

The 3rd Servers, are the Primary and Secondary DNS servers that contain the DNS zones. The ISP Forwarders must communicate with these authoritative servers to retrieve definitive (authoritative) answers for domains.

In this article, we will Install and configure all four types of Linux DNS Server Step by Step.

Lets get started…

What is a Primary or Master DNS Server?
A Primary DNS Server (also called a Master DNS Server) is the authoritative server for a specific domain. It holds the original DNS records and serves as the primary source of DNS information for that domain.

When other DNS servers or clients request these records, the Primary DNS Server provides them, and its responses are considered authoritative and final.

![p](https://mailserverguru.com/wp-content/uploads/2024/10/master-dns-zone.webp)

## What is DNS Zone and Zone Files?

A DNS zone is a distinct part of a domain namespace, like “example.com”, within this zone, you can create sub-zones, like “marketing.example.com” or “sales.example.com“

Each zone contains various DNS records, such as:

- A records (map domain names to IP addresses)
- MX records (specify mail servers)
- CNAME records (provide domain aliases)

These DNS records are stored in special files called zone files. When a DNS client requests a record, the server retrieves the necessary information from these zone files and returns it.

![z](https://mailserverguru.com/wp-content/uploads/2024/10/dns-zone-files-1024x647.webp)

Master DNS Server contains Forward and Reverse Zone Files

## What is DNS Query?

When we browse a website and type the domain name like http://domain_name in a browser, the browser needs to find the web server’s IP address to connect to that domain. To do this, it queries a DNS server to translate the domain name into an IP address. This process of resolving a name is called a DNS Query.

There are two types of DNS queries:

1. Forward Query – Translates a domain name into an IP address.
2. Reverse Query – Translates an IP address into a domain name.

For each zone, the Primary DNS server maintains two zone files: one for forward queries and another for reverse queries.

![q](https://mailserverguru.com/wp-content/uploads/2024/10/dns-name-resolution-1024x690.webp)

## DNS Name Resolution and Data Retrieval

When a DNS server replies to a query, the response can be classified into two types:

1. Authoritative answer
2. Non-Authoritative answer

Authoritative Answer: DNS authoritative answer comes from the DNS server that has full control over the domain’s DNS records. It holds the official data (e.g., A, MX, or NS records), so its response is considered final.

Non-Authoritative Answer: This response is from a DNS server that doesn’t host the zone but has cached the result from a previous lookup. It doesn’t hold the official records but temporarily stores the information obtained from an authoritative DNS server.

We will see all these queries and answers during the practical sessions.

Now, lets Install the Primary DNS server and during the installation we will explain each of the concept we discussed earlier.

## Our DNS Server Lab Scenario

We will try to understand the Primary DNS Server configuration with an easy and small scenario, here, we have some devices on the network.

We will configure DNS records for them, so that, each device can communicate with other devices with their hostname instead of IP.

![l](https://mailserverguru.com/wp-content/uploads/2024/10/master-dns-server.webp)

- DNS Server: ns1.lab.com (192.168.1.10)
- Local Subnet: 192.168.1.0/24
- Domain Name: lab.com

## Install and Configure the Primary DNS Server

Now, lets begin the Installation, we will install the Primary DNS server with the following steps:

- Step #1: Update the System
- Step #2: Install DNS Server Packages
- Step #3: Explain named.conf File
- Step #4: Configure DNS Server Options
- Step #5: Create DNS Zone and Zone Files
- Step #6: Configure Forward Zone
- Step #7: Configure Reverse Zone
- Step #8: Test Master DNS Server

We will Install Linux DNS Server on Ubuntu. the steps are almost similar for other Linux distributions.

## Step #1: Update the System

Before Install any DNS Server, always update the system to the latest packages.

`sudo apt update -y && sudo apt upgrade -y`

## Step #2: Install DNS Server Package

We will install the Primary DNS Server with Bind9, install bind9 and bind9 utilities.

`sudo apt install bind9 bind9utils dnsutils -y`

The Bind9 DNS server configuration files are located in the /etc/bind directory.

![b](https://mailserverguru.com/wp-content/uploads/2024/10/dns-server-configuration-files-1024x452.webp)

Bind9: DNS Server Configuration Files

## Step #3: Explain named.conf file

Next, we need to work with the Primary DNS Server Configuration files. Bind DNS Server’s main configuration file is /etc/bind/named.conf. but we will not directly edit this file, it includes other configuration files we needs to work with.

named.conf file appears as follows:

![n](https://mailserverguru.com/wp-content/uploads/2024/10/named-conf-file-1024x390.webp)

named.conf: Bind DNS Server Main Configuration File
There are three files has been referenced from the named.conf.

1. /etc/bind/named.conf.options: In this file, we provide Linux DNS server configuration parameters, how DNS server will behave, ACL, Forwarders, directories etc.
2. /etc/bind/named.conf.local: in this file, we define zones, forward zone, reverse zone, if this DNS server maintains multiple zone, all zones should be defined here.
3. /etc/bind/named.conf.default-zones: This file contains some default zone declarations, we normally leave the file as is.

To configure the Primary DNS server properly, lets work with each of these files.

```bash
ls /etc/bind
bind.keys  db.127  db.empty  named.conf                named.conf.local    rndc.key
db.0       db.255  db.local  named.conf.default-zones  named.conf.options  zones.rfc1918
```

## Step #4: Configure DNS Server Options

Now, we need to configure the primary DNS with essential parameters. we need to edit the /etc/bind/named.conf.options file and provide the necessary configurations.

The default configuration of the named.conf.options file appears as follows:

![o](https://mailserverguru.com/wp-content/uploads/2024/10/dns-server-configuration-options-1024x699.webp)

We provided the parameters to run the Primary DNS server with minimum configuration.

```bash
vi /etc/bind/named.conf.options

acl local-network {
        192.168.2.0/24;
};

options {
        directory "/var/cache/bind";
        dnssec-validation auto;
        allow-query { localhost; local-network; };
        recursion yes;
        listen-on-v6 { none; };
        listen-on { 192.168.2.1; };

};

:x //save the file.
```

Here are the Key Details of the above configurations:

- ACL: Defines a range of IP addresses that can interact with the Primary DNS server. Here, the local-network ACL includes the 192.168.1.0/24 subnet.
- directory: Specifies the working directory where BIND stores zone files, caches, and related data.
- dnssec-validation: Enables automatic DNSSEC validation for security.
- allow-query: Controls which clients can send DNS queries to the server.
- recursion: Determines whether the Primary DNS server should perform recursive queries on behalf of clients.
- forwarders: Defines upstream DNS servers to which our server forwards queries it cannot resolve locally (in this case, Google’s DNS servers).
- listen-on-v6: Configures whether the Primary DNS server should listen on IPv6 address.
- listen-on: Specifies the IPv4 address on which the DNS server listens for queries.

## 2. Restart BIND after applying the changes to ensure the configuration takes effect

`systemctl restart bind9`
3. Check the Primary DNS Server status and Listening Ports.

`systemctl status bind9`

![s](https://mailserverguru.com/wp-content/uploads/2024/10/dns-server-is-running-1024x415.webp)

## 4. Check the Listening Ports and Sockets

`netstat -antp`

![l](https://mailserverguru.com/wp-content/uploads/2024/10/dns-port-is-listening-1024x189.webp)

DNS Ports are Listening
Everything seems ok, lets move to next step.

## Step #5: Create DNS Zone and Zone Files

Now, we will create zones. we need to create two zones, a forward and a reverse zone.

![z](https://mailserverguru.com/wp-content/uploads/2024/10/dns-forward-and-reverse-zones.webp)

## DNS Zones: Forward and Reverse Zone

We will create zone files under /etc/bind/zones directory, this is optional, but a good practice.

Create the /etc/bind/zones directory and assign permissions

```bash
sudo mkdir /etc/bind/zones
sudo chown root:bind /etc/bind/zones
```

We configured two DNS zones “zone lab.com” is the forward zone for the domain “lab.com” and “zone 1.168.192.in-addr.arpa” is the reverse zone declaration for the 192.168.1.0/24 network

We also specified the respective file locations for each zone where their records will be stored.

```bash
vi /etc/bind/named.conf.local


zone "lab.com" {
    type master;
    file "/etc/bind/zones/forward.lab.com.db";
    allow-update { none; };
};

zone "1.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/reverse.192.168.1.db";
    allow-update { none; };
};


:x //save the file
```

Summary of Important Parameters:

- zone: Defines the zone name, either for a  domain (forward) or network (reverse).
- type: Specifies the type of zone (e.g., master, slave, or forward).
- file: Indicates the file where zone data (DNS records) is stored.
- allow-update: Controls whether dynamic DNS updates are allowed. Setting it to none blocks automatic changes, improving security.
