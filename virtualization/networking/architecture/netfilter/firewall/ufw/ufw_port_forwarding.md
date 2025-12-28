# **[Set up a Port Forward Using UFW](https://www.baeldung.com/linux/ufw-port-forward)**


**[Back to Research List](../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../README.md)**

While we can enable various UFW firewall rules using commands, things are a bit different when setting up port forwarding. Nevertheless, the steps are straightforward.

In this tutorial, we’ll go over the steps to activate packet forwarding and set up a port forward using UFW.

2. Enabling Packet Forwarding
Before we configure UFW to allow port forwarding, we must enable packet forwarding. We can do this through any of:

the UFW network variables file: /etc/ufw/sysctl.conf
the system variables file: /etc/sysctl.conf
In this tutorial, we’ll use the UFW network variables file since UFW prioritizes it over the system variables file.

To enable packet forwarding, let’s open /etc/ufw/sysctl.conf:

```bash
$ sudo nano /etc/ufw/sysctl.conf
```

After that, let’s uncomment net/ipv4/ip_forward=1.

If we have access to the root user, we can enable packet forwarding on /etc/ufw/sysctl.conf by running:

```bash
# echo 'net/ipv4/ip_forward=1' >> /etc/ufw/sysctl.conf
```

3. Configuring Port Forwarding on UFW
We can configure UFW to forward traffic from an external port to an internal port. If we have to, we can also set it up to forward traffic from an external port to a server listening on a specific internal port.

3.1. Port Forwarding From an External Port to an Internal Port
To set up a port forward on UFW, we must edit the /etc/ufw/before.rules file:

```bash
$ sudo nano /etc/ufw/before.rules 
```
In the before.rules file, let’s add a NAT table after the filter table (the table that starts with *filter and ends with COMMIT):

```bash
*nat
:PREROUTING ACCEPT [0:0]
-A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 500
COMMIT
```

This NAT table will redirect incoming traffic from the external port (80) to the internal port (500). Of course, we can adjust the table to forward traffic from any other external port to any other internal port.

Now that we’ve saved the NAT table to the before.rules file, let’s allow traffic through the internal port since we didn’t do that before:

```bash
$ sudo ufw allow 500/tcp
Rule added
Rule added (v6)
Copy
Lastly, let’s restart UFW:

$ sudo systemctl restart ufw
```

3.2. Port Forwarding From an External Port to a Server Listening on a Specific Internal Port
We can forward incoming traffic from an external port to a server listening on a specific internal port using the same steps as above. However, we’ll use a different NAT table for this purpose:

```bash
*nat :PREROUTING ACCEPT [0:0]
-A PREROUTING -p tcp -i eth0 --dport 443 -j DNAT \ --to-destination 192.168.56.9:600
COMMIT
```

```bash
$ sudo ufw allow 5240/tcp

*nat :PREROUTING ACCEPT [0:0]
-A PREROUTING -p tcp -i eth0 --dport 5240 -j DNAT \ --to-destination 10.72.173.107:5240
COMMIT
```

Unlike the other table, this redirects incoming traffic from port 443 (external port) to 192.168.56.9 (the server) listening on port 600 (internal port). As we did before, we’ll ensure that we allow traffic through the internal port.