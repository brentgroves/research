# **[How exactly are NetworkManager, networkd, netplan, ifupdown2, and iproute2 interacting?](https://unix.stackexchange.com/questions/475146/how-exactly-are-networkmanager-networkd-netplan-ifupdown2-and-iproute2-inter)**

**[Back to Research List](../../research_list.md)**\
**[Back to Multipass Menu](./multipass_menu.md)**\
**[Back to Current Status](../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../README.md)**

## references

- **[networking trio](https://www.reddit.com/r/Ubuntu/comments/16oizuj/netplan_systemdnetworkd_and_networkmanager_trio/)**

- **[How exactly are NetworkManager, networkd, netplan, ifupdown2, and iproute2 interacting?](https://unix.stackexchange.com/questions/475146/how-exactly-are-networkmanager-networkd-netplan-ifupdown2-and-iproute2-inter)**

## networking trio

My understanding was that NetworkManager belongs to the desktop way of managing network connectivity and networkd is predominantly designed for server use.

Now, I installed fresh 20.04 and am getting NetworkManager running my network layer.

Can someone please shed some lite as to how to even think about these components and what is their main purpose and natural habitat? Surely, this is not OK for all those living and randomly managing network devices on a host (I am a server user so this is where my focus is as opposed to Desktop).

### Netplan

Netplan is a network configuration abstraction renderer used in modern Ubuntu releases (since 17.10). It provides a high-level, YAML-based configuration interface for defining network interfaces and settings. Netplan generates network configuration files in the format understood by the underlying networking subsystem, which can be either networkd or NetworkManager. Netplan is the recommended way to configure network settings in Ubuntu, regardless of whether you are using a server or a desktop environment. It's the front-end configuration tool.

### systemd-networkd (networkd)

systemd-networkd is a component of systemd, the init system used in Ubuntu (and many other Linux distributions). It provides a minimalistic, low-level networking configuration service designed for server use cases. Networkd is suitable for headless servers and other environments where a lightweight and predictable network configuration solution is needed. When you configure networking via Netplan, you can choose to use networkd as the backend for network management.

### NetworkManager

NetworkManager is a more feature-rich and user-friendly network management solution. It is commonly associated with desktop environments because it offers a graphical user interface for managing network connections. However, NetworkManager is not limited to desktop use. It can be used on servers as well, especially if you need advanced networking features or if your server has a mix of wired and wireless connections. NetworkManager can also be used in combination with Netplan.

## Choosing Between networkd and NetworkManager on Servers

For server environments, the choice between networkd and NetworkManager depends on your specific requirements. If you prefer a simple, lightweight, and predictable network configuration, networkd is a good choice. It's especially suitable for headless servers. If you need more advanced network management features, especially for handling complex networking scenarios or mixed wired/wireless connections, NetworkManager might be a better fit. You can configure either networkd or NetworkManager as the backend for Netplan by specifying it in your Netplan YAML configuration file **(renderer: networkd or renderer: NetworkManager)**. In your case, if you have a fresh Ubuntu 20.04 installation, it's common to see **NetworkManager handling network configuration by default, even on servers.** You can switch to networkd if you prefer a simpler setup or if NetworkManager doesn't meet your specific requirements.

To summarize, while NetworkManager is often associated with desktop environments, it is a versatile tool that can also be used effectively on servers, especially when more advanced network management features are needed. The choice between networkd and NetworkManager depends on your specific use case and preferences. Netplan serves as a convenient and standardized configuration layer for both of these backends.

## **[How are NetworkManager, networkd, netplan, ifupdown2, and iproute2 interacting?](https://unix.stackexchange.com/questions/475146/how-exactly-are-networkmanager-networkd-netplan-ifupdown2-and-iproute2-inter)**

I am learning about Linux networking on my Kubuntu 18.04 workstation, and I see there that both NetworkManager and networkd-dispatcher are running:

```bash
ssh brent@repsys13
cat /etc/netplan/01-network-manager-all.yaml
# Let NetworkManager manage all devices on this system
network:
  version: 2
  renderer: NetworkManager

sudo systemctl status systemd-networkd
○ systemd-networkd.service - Network Configuration
     Loaded: loaded (/lib/systemd/system/systemd-networkd.service; disabled; vendor preset: enabled)
     Active: inactive (dead)
TriggeredBy: ○ systemd-networkd.socket
       Docs: man:systemd-networkd.service(8)

multipass shell test7

sudo systemctl status systemd-networkd
● systemd-networkd.service - Network Configuration
     Loaded: loaded (/usr/lib/systemd/system/systemd-networkd.service; enabled; preset: enabled)
     Active: active (running) since Tue 2024-06-18 17:23:19 EDT; 22h ago
TriggeredBy: ● systemd-networkd.socket
       Docs: man:systemd-networkd.service(8)
             man:org.freedesktop.network1(5)
   Main PID: 662 (systemd-network)
     Status: "Processing requests..."
      Tasks: 1 (limit: 1093)
   FD Store: 0 (limit: 512)
     Memory: 3.2M (peak: 3.5M)
        CPU: 567ms
     CGroup: /system.slice/systemd-networkd.service
             └─662 /usr/lib/systemd/systemd-networkd

sudo cat /etc/netplan/50-cloud-init.yaml 
# This file is generated from information provided by the datasource.  Changes
# to it will not persist across an instance reboot.  To disable cloud-init's
# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    ethernets:
        default:
            dhcp4: true
            match:
                macaddress: 52:54:00:5a:0a:44
        extra0:
            dhcp4: true
            dhcp4-overrides:
                route-metric: 200
            match:
                macaddress: 52:54:00:41:ee:b9
            optional: true
        extra1:
            dhcp4: true
            dhcp4-overrides:
                route-metric: 200
            match:
                macaddress: 52:54:00:58:18:4f
            optional: true
    version: 2

```

- networkd is running on ubuntu 24.04 server but not on 22.04 desktop.
