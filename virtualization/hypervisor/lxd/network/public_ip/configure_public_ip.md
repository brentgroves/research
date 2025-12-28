# AI: give lxd container public ip

<https://discuss.linuxcontainers.org/t/assign-external-ip-address-to-container/13875>

<https://www.experts-exchange.com/questions/29196085/assign-public-IPs-for-every-lxd-container-how-to-config-in-host-system-and-routing-steps.html>

<https://www.experts-exchange.com/questions/29196085/assign-public-IPs-for-every-lxd-container-how-to-config-in-host-system-and-routing-steps.html#:~:text=sir%2C%20edited%20eth0%20to%20eth1,it%20is%20working%20as%20expected>.

<https://discuss.linuxcontainers.org/t/configure-lxd-container-with-public-ip-and-make-it-available-online/12215#:~:text=To%20configure%20an%20LXD%20container%20with%20a,Ubuntu%2020.04%20with%20its%20own%20public%20IP>

How to make your LXD containers get IP addresses from your ...

To assign a public IP to an LXD container, you can use the routed network type, which is often the most direct method for this scenario. After attaching a routed NIC to the container, you configure the container's network with the desired public IP and gateway details within the container's network configuration file, often a netplan file.
Here's a step-by-step approach using the routed NIC type:

How to make your LXD containers get IP addresses from your ...

To assign a public IP to an LXD container, you can use the routed network type, which is often the most direct method for this scenario. After attaching a routed NIC to the container, you configure the container's network with the desired public IP and gateway details within the container's network configuration file, often a netplan file.

Here's a step-by-step approach using the routed NIC type:

Add a routed network interface to the container:
This command attaches a virtual network interface to your container and sets the parent interface to your host's external network interface (e.g., enp2s0f0).

```bash
lxc config device add <container_name> eth0 nic nictype=routed parent=<host_network_interface> ipv4.address=<public_ip>/32
```

Replace <container_name> with the actual name of your container.
Replace <host_network_interface> with the name of your host's external network interface.
Replace <public_ip> with the specific public IP address you want to assign to the container.
Configure the container's network using Netplan (or equivalent):
Inside the container, you need to ensure its eth0 interface is set up to use this public IP and has the appropriate gateway. You can do this by editing the network configuration file (often /etc/netplan/) within the container:
yaml
network:
  version: 2
  ethernets:
    eth0:
      addresses:
        - <public_ip>/32
      gateway4: <your_router_or_gateway_ip>
      nameservers:
        addresses: [<your_dns_ip_1>, <your_dns_ip_2>]
Replace <public_ip> with the IP you used in the previous step.
Replace <your_router_or_gateway_ip> with your network's gateway IP address.
Replace <your_dns_ip_1> and <your_dns_ip_2> with actual DNS server IP addresses.
Apply the configuration and restart the container:
After modifying the Netplan configuration file, apply the changes and restart the container for them to take effect.
bash
sudo netplan apply
sudo lxc restart <container_name>
