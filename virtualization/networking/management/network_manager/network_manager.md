# **[Network Manager](https://networkmanager.dev/)**

**[Back to Research List](../../research_list.md)**\
**[Back to Networking Menu](./networking_menu.md)**\
**[Back to Current Status](../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../README.md)**

![](https://networkmanager.dev/logo.png)

NetworkManager is the standard Linux network configuration tool suite. It supports large range of networking setups, from desktop to servers and mobile and integrates well with popular desktop environments and server configuration management tools.

**[nmcli](https://networkmanager.dev/docs/api/latest/nmcli.html)** is a command-line client for NetworkManager. It allows controlling NetworkManager and reporting its status. For more information please refer to nmcli(1) manual page.

## references

- **[NetworkManager](https://ubuntu.com/core/docs/networkmanager)**

## What NetworkManager Offers

The upstream NetworkManager project offers a wide range of features and most, but not all of them, are available in the snap package at the moment.

Currently we provide support for the following high level features:

- WiFi connectivity
- WAN connectivity (together with ModemManager)
- Ethernet connectivity
- WiFi access point creation
- Shared connections
- VPN connections

## How to tell if NetworkManager is running

```bash
ssh brent@reports-alb
systemctl status NetworkManager.service
● NetworkManager.service - Network Manager
     Loaded: loaded (/lib/systemd/system/NetworkManager.service; enabled; vendor preset: enabled)
     Active: active (running) since Fri 2024-05-24 22:29:20 EDT; 17h ago
       Docs: man:NetworkManager(8)
   Main PID: 642 (NetworkManager)
      Tasks: 3 (limit: 38358)
     Memory: 11.8M
        CPU: 42.012s
     CGroup: /system.slice/NetworkManager.service
             └─642 /usr/sbin/NetworkManager --no-daemon

May 24 22:30:36 reports-alb.busche-cnc.com NetworkManager[642]: <info>  [1716604236.0555] device (br-b543cc541f49): state change: secondaries -> activated (reason 'none', sys-iface-state: 'external')
May 24 22:30:36 reports-alb.busche-cnc.com NetworkManager[642]: <info>  [1716604236.0572] device (br-b543cc541f49): Activation: successful, device activated.
May 24 22:30:36 reports-alb.busche-cnc.com NetworkManager[642]: <info>  [1716604236.0588] device (br-ef440bd353e1): state change: disconnected -> prepare (reason 'none', sys-iface-state: 'external')
May 24 22:30:36 reports-alb.busche-cnc.com NetworkManager[642]: <info>  [1716604236.0596] device (br-ef440bd353e1): state change: prepare -> config (reason 'none', sys-iface-state: 'external')
May 24 22:30:36 reports-alb.busche-cnc.com NetworkManager[642]: <info>  [1716604236.0602] device (br-ef440bd353e1): state change: config -> ip-config (reason 'none', sys-iface-state: 'external')
May 24 22:30:36 reports-alb.busche-cnc.com NetworkManager[642]: <info>  [1716604236.0608] device (br-ef440bd353e1): state change: ip-config -> ip-check (reason 'none', sys-iface-state: 'external')
May 24 22:30:36 reports-alb.busche-cnc.com NetworkManager[642]: <info>  [1716604236.2028] device (br-ef440bd353e1): state change: ip-check -> secondaries (reason 'none', sys-iface-state: 'external')
May 24 22:30:36 reports-alb.busche-cnc.com NetworkManager[642]: <info>  [1716604236.2031] device (br-ef440bd353e1): state change: secondaries -> activated (reason 'none', sys-iface-state: 'external')
May 24 22:30:36 reports-alb.busche-cnc.com NetworkManager[642]: <info>  [1716604236.2060] device (br-ef440bd353e1): Activation: successful, device activated.

# repsys11
ssh brent@repsys11
systemctl status NetworkManager.service
● NetworkManager.service - Network Manager
     Loaded: loaded (/lib/systemd/system/NetworkManager.service; enabled; vendor preset: enabled)
     Active: active (running) since Fri 2024-05-24 18:23:05 EDT; 21h ago
       Docs: man:NetworkManager(8)
   Main PID: 890 (NetworkManager)
      Tasks: 3 (limit: 154501)
     Memory: 12.4M
        CPU: 1min 49.386s
     CGroup: /system.slice/NetworkManager.service
             └─890 /usr/sbin/NetworkManager --no-daemon

May 24 21:04:06 repsys11 NetworkManager[890]: <info>  [1716599046.4879] device (tapd789600c): Activation: starting connection 'tapd789600c' (7e3b1f54-69b5-44af-a3a5-aabac475100e)
May 24 21:04:06 repsys11 NetworkManager[890]: <info>  [1716599046.4884] device (tapd789600c): state change: disconnected -> prepare (reason 'none', sys-iface-state: 'external')
May 24 21:04:06 repsys11 NetworkManager[890]: <info>  [1716599046.4890] device (tapd789600c): state change: prepare -> config (reason 'none', sys-iface-state: 'external')
May 24 21:04:06 repsys11 NetworkManager[890]: <info>  [1716599046.4895] device (tapd789600c): state change: config -> ip-config (reason 'none', sys-iface-state: 'external')
May 24 21:04:06 repsys11 NetworkManager[890]: <info>  [1716599046.4897] device (mpbr0): bridge port tapd789600c was attached
May 24 21:04:06 repsys11 NetworkManager[890]: <info>  [1716599046.4897] device (tapd789600c): Activation: connection 'tapd789600c' enslaved, continuing activation
May 24 21:04:06 repsys11 NetworkManager[890]: <info>  [1716599046.4981] device (tapd789600c): state change: ip-config -> ip-check (reason 'none', sys-iface-state: 'external')
May 24 21:04:06 repsys11 NetworkManager[890]: <info>  [1716599046.5648] device (tapd789600c): state change: ip-check -> secondaries (reason 'none', sys-iface-state: 'external')
May 24 21:04:06 repsys11 NetworkManager[890]: <info>  [1716599046.5654] device (tapd789600c): state change: secondaries -> activated (reason 'none', sys-iface-state: 'external')
May 24 21:04:06 repsys11 NetworkManager[890]: <info>  [1716599046.5665] device (tapd789600c): Activation: successful, device activated.

```

## other network manager services

```bash
ssh brent@reports-alb
$ systemctl status systemd-networkd.service
systemd-networkd.service - Network Configuration
     Loaded: loaded (/lib/systemd/system/systemd-networkd.service; disabled; vendor preset: enabled)
     Active: inactive (dead)
TriggeredBy: ○ systemd-networkd.socket
       Docs: man:systemd-networkd.service(8)
$ systemctl status dhcpcd.service
Unit dhcpcd.service could not be found.
```

## NetworkManager for administrators

### Manuals

Find the manual **[here](https://networkmanager.dev/docs/man-pages/)**.

### Architecture

**[NetworkManager](https://developer.gnome.org/NetworkManager/stable/NetworkManager.html)** is designed to be fully automatic by default. It manages the primary network connection and other network interfaces, like Ethernet, Wi-Fi, and Mobile Broadband devices. To use NetworkManager, its service must be started. Starting up NetworkManager depends on the distribution you are running, but NetworkManager ships with systemd service files to do this for most distributions. NetworkManager will then automatically start other services as it requires them (wpa_supplicant for WPA and 802.1x connections, pppd for mobile broadband).

### Security

NetworkManager supports most network security methods and protocols, WPA/WPA2/WPA3 (Personal and Enterprise), wired 802.1x, MACsec and VPNs. NetworkManager stores network secrets (encryption keys, login information) using secure storage, either in the user’s keyring (for user-specific connections) or protected by normal system administrator permissions (like root) for system-wide connections. Various network operations can be locked down with **[polkit](https://www.freedesktop.org/software/polkit/docs/latest)** for even finer grained control over network connections.

## VPN

NetworkManager has pluggable support for VPN software, including Cisco compatible VPNs (using vpnc), openvpn, and Point-to-Point Tunneling Protocol (PPTP). Support for other vpn clients is welcomed. Simply install the NetworkManager VPN plugin your site uses, and pre-load the user’s machines with the VPN’s settings. The first time they connect, the user will be asked for their passwords.

See the **[VPN page](https://networkmanager.dev/docs/vpn)** for more details.

## Configuration files

NetworkManager.conf is the configuration file for NetworkManager. It is used to set up various aspects of NetworkManager’s behavior.

If a default NetworkManager.conf is provided by your distribution’s packages, you should not modify it, since your changes may get overwritten by package updates. Instead, you can add additional files with .conf extension to the /etc/NetworkManager/conf.d directory. These will be read in order, with later files overriding earlier ones.

Packages might install further configuration snippets to /usr/lib/NetworkManager/conf.d. This directory is parsed first, even before NetworkManager.conf. Scripts can also put per-boot configuration into /run/NetworkManager/conf.d. This directory is parsed second, also before NetworkManager.conf.

```bash
ssh brent@reports-alb
ls /etc/NetworkManager
conf.d  dispatcher.d  dnsmasq.d  dnsmasq-shared.d  NetworkManager.conf  system-connections

cat NetworkManager.conf 
[main]
plugins=ifupdown,keyfile

[ifupdown]
managed=false

[device]
wifi.scan-rand-mac-address=no

ls /etc/NetworkManager/conf.d                     
default-wifi-powersave-on.conf

ls /usr/lib/NetworkManager/conf.d                           
10-dns-resolved.conf  10-globally-managed-devices.conf  20-connectivity-ubuntu.conf  no-mac-addr-change.conf
```

## how is dns resolved in reports-alb

```bash
cat /usr/lib/NetworkManager/conf.d/10-dns-resolved.conf 
[main]
# We need to specify "dns=systemd-resolved" as for the time being our
# /etc/resolv.conf points to resolvconf's generated file instead of
# systemd-resolved's, so the auto-detection does not work.
dns=systemd-resolved
```

On the Fedora project's developer list, systemd developer Lennart Poettering has announced the introduction of a **[/run directory](http://www.h-online.com/open/news/item/Linux-distributions-to-include-run-directory-1219006.html)** in the root directory and provided detailed background explanations. Similar to the existing /var/run/ directory, the new directory is designed to allow applications to store the data they require in order to operate. This includes process IDs, socket information, lock files and other data which is required at run-time but can't be stored in /tmp/ because programs such as tmpwatch could potentially delete it from there.

## Server-like behavior

By default NetworkManager automatically creates a new in-memory connection for every Ethernet device that doesn’t have another candidate connection on disk. These new connections have name “Wired connection 1”, “Wired connection 2” and so on; they have DHCPv4 and IPv6 autoconfiguration enabled.

This behavior is usually not desirable on servers, where all interfaces should be configured explicitly. To disable the creation of such automatic connections, add no-auto-default=* to the [main] configuration section.

Also, NetworkManager requires carrier on an interface before a connection can be activated on it. If there are services that need to bind to the interface address at boot, they might fail if the interface has no carrier. The solution is to disable carrier detection with configuration option ignore-carrier=* in the [main] section.

Note that on Fedora and RHEL there is a NetworkManager-config-server package that install a configuration snippet with the two options described above.

## Unmanaging devices

By default NetworkManager manages all devices found on the system. If you plan to configure an interface manually or through some other tool, you should tell NetworkManager to not manage it.

To do this temporarily until the next reboot use command

```nmcli device set enp1s0 managed no```

If you want the choice to persist after a reboot, add the following snippet to configuration:

```
[device-enp1s0-unmanage]
match-device=interface-name:enp1s0
managed=0
```

Then, remember to reload configuration with systemctl reload NetworkManager.
