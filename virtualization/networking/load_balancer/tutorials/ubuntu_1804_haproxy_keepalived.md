# **[How to setup a highly available load balancer with keepalived and HAProxy on Ubuntu 18.04](https://medium.com/@xmikex83/how-to-setup-an-highly-available-load-balancer-with-keepalived-and-haproxy-on-ubuntu-18-04-8bab7b77f715)**

At Wonderflow we’re handling more and more data during our customer feedback analysis processes.

We wanted to add data redundancy and high availability to our infrastructure, so battle-tested and very flexible load balancers like HAProxy are a must to use.

However, having only a single instance of HAProxy in front of all infrastructure means also that it’s a single point of failure.

Fortunately, we’ve been able to get rid of this SPOF using keepalived, HAProxy and our infrastructure provider APIs (OVH).

## About our infrastructure

We are using OVH Dedicated Servers which seems to be a good compromise in terms of performance and reliability, especially when you need to make MongoDB run very fast on bare metal.

There’s no need to dive in into our infrastructure configuration, the only thing you need to know is that we’ve provisioned two servers with HAProxy instances configured. I’ll call them lb1 and lb2.

Network-wise, both lb1 and lb2 are using OVH vRack feature, so they are able to communicate between each other on a private network via a vLAN.

## About the floating IP

On OVH (but also on other providers) you can easily buy ad additional IP address which will be your floating IP address.

A floating IP address is a virtual IP address which could be routed to one of your services (i.e. dedicated servers) both manually (using OVH Control Panel) or automatically (using OVH APIs).

Remember to ensure that the virtual IP address is assigned as an alias to both lb1 and lb2 servers. You easily assign that IP as an alias to the public network interface using netplan on Ubuntu 18.04:

```bash
$ sudo vi /etc/systemd/network/50-default.network
# Add this line under [Network] section
Address={FLOATING_IP}/32
$ sudo systemctl restart systemd-networkd
# Test 
ping {FLOATING_IP}
```

## Build and Install keepalived

We chose to download and compile a recent version of keepalived (2.0.15). The one present on Ubuntu repositories is a bit too old (1.3.9), and new versions have a lot of improvements.

If you want to deep dive into keepalived, I suggest to read its official documentation. It’s very well done.

## First, you need to install some requirements

```bash
apt install libssl-dev build-essential
```

## **[downloads](https://www.keepalived.org/download.html)**

Keepalived for Linux - Version 2.3.4 - Release Notes - June 10, 2025 - MD5SUM:={622b09f4502ada4c6d20ef1c29205f77}
