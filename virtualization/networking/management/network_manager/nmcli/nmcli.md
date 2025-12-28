# **[nmcli](https://networkmanager.dev/docs/api/latest/nmcli.html)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Networking Menu](../networking_menu.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

**[nmcli](https://networkmanager.dev/docs/api/latest/nmcli.html)** is a command-line client for NetworkManager. It allows controlling NetworkManager and reporting its status. For more information please refer to nmcli(1) manual page.

## [nmcli examples](https://networkmanager.dev/docs/api/latest/nmcli-examples.html)**

The purpose of this manual page is to provide you with various examples and usage scenarios of nmcli.

## Examples

List all network manager connections

```bash
ssh brent@reports-alb
nmcli -p con show 
======================================
  NetworkManager connection profiles
======================================
NAME                UUID                                  TYPE      DEVICE          
---------------------------------------------------------------------------------------------------------------------------
Wired connection 1  c031620b-0f27-3dea-9352-8b45b7a8b2ea  ethernet  enp0s25         
mpqemubr0           a89655e1-3df3-4eb0-b640-2b7f00ce2789  bridge    mpqemubr0       
br-860dc0d9b54b     390335bd-c36c-4bd3-b188-90aab3bbebbb  bridge    br-860dc0d9b54b 
br-924b3db7b366     1439fb5a-1611-4682-b90b-2e944bf36900  bridge    br-924b3db7b366 
br-b543cc541f49     c06fe11e-e0fd-4d3b-950e-b2b0c16a3b1a  bridge    br-b543cc541f49 
br-ef440bd353e1     fc87473a-82ab-48ed-9f67-61bafbf0b2eb  bridge    br-ef440bd353e1 
docker0             79954717-f033-4c83-96df-636f6dcef469  bridge    docker0         
tap-d951e26a898     8c208343-21f8-4fc2-9f2c-6856138b63f7  tun       tap-d951e26a898 

nmcli -p con show docker0
===============================================================================
       Active connection details (79954717-f033-4c83-96df-636f6dcef469)
===============================================================================
GENERAL.NAME:                           docker0
GENERAL.UUID:                           79954717-f033-4c83-96df-636f6dcef469
GENERAL.DEVICES:                        docker0
GENERAL.IP-IFACE:                       docker0
GENERAL.STATE:                          activated
GENERAL.DEFAULT:                        no
GENERAL.DEFAULT6:                       no
GENERAL.SPEC-OBJECT:                    --
GENERAL.VPN:                            no
GENERAL.DBUS-PATH:                      /org/freedesktop/NetworkManager/ActiveConnection/6
GENERAL.CON-PATH:                       /org/freedesktop/NetworkManager/Settings/6
GENERAL.ZONE:                           --
GENERAL.MASTER-PATH:                    --
IP4.ADDRESS[1]:                         172.17.0.1/16
IP4.GATEWAY:                            --
IP4.ROUTE[1]:                           dst = 172.17.0.0/16, nh = 0.0.0.0, mt = 0
-------------------------------------------------------------------------------

===============================================================================
                     Connection profile details (docker0)
===============================================================================
connection.id:                          docker0
connection.uuid:                        79954717-f033-4c83-96df-636f6dcef469
connection.stable-id:                   --
connection.type:                        bridge
connection.interface-name:              docker0
connection.autoconnect:                 no
connection.autoconnect-priority:        0
connection.autoconnect-retries:         -1 (default)
connection.multi-connect:               0 (default)
connection.auth-retries:                -1
connection.timestamp:                   1716671660
connection.read-only:                   no
connection.permissions:                 --
connection.zone:                        --
connection.master:                      --
connection.slave-type:                  --
connection.autoconnect-slaves:          -1 (default)
...
ipv4.method:                            manual
ipv4.dns:                               --
ipv4.dns-search:                        --
ipv4.dns-options:                       --
ipv4.dns-priority:                      0
ipv4.addresses:                         172.17.0.1/16
ipv4.gateway:                           --
ipv4.routes:                            --
...
bridge.mac-address:                     --
bridge.stp:                             no
bridge.priority:                        32768
bridge.forward-delay:                   15
bridge.hello-time:                      2
bridge.max-age:                         20
bridge.ageing-time:                     300
bridge.group-forward-mask:              0
bridge.multicast-snooping:              yes
bridge.multicast-startup-query-interval:3124
bridge.vlan-filtering:                  no
bridge.vlan-default-pvid:               1
bridge.vlans:                           --
...
```

Example 1. Listing available Wi-Fi APs

```$ nmcli device wifi list```

This command shows how to list available Wi-Fi networks (APs). You can also use --fields option for displaying different columns. nmcli -f all dev wifi list will show all of them.

Example 2. Connect to a password-protected wifi network

```bash
nmcli device wifi connect "$SSID" password "$PASSWORD"
nmcli --ask device wifi connect "$SSID"
```

Example 4. Listing NetworkManager polkit permissions

```$ nmcli general permissions```

This command shows configured polkit permissions for various NetworkManager operations. These permissions or actions (using polkit language) are configured by a system administrator and are not meant to be changed by users. The usual place for the polkit configuration is /usr/share/polkit-1/actions/org.freedesktop.NetworkManager.policy. pkaction command can display description for polkit actions.

```pkaction --action-id org.freedesktop.NetworkManager.network-control --verbose```

More information about polkit can be found at <http://www.freedesktop.org/wiki/Software/polkit>.

Example 5. Listing NetworkManager log level and domains

```bash
$ nmcli general logging
LEVEL  DOMAINS
INFO   PLATFORM,RFKILL,ETHER,WIFI,BT,MB,DHCP4,DHCP6,PPP,WIFI_SCAN,IP4,IP6,A
UTOIP4,DNS,VPN,SHARING,SUPPLICANT,AGENTS,SETTINGS,SUSPEND,CORE,DEVICE,OLPC,
WIMAX,INFINIBAND,FIREWALL,ADSL,BOND,VLAN,BRIDGE,DBUS_PROPS,TEAM,CONCHECK,DC
B,DISPATCH
This command shows current NetworkManager logging status.
```

Example 11. Adding an ethernet connection profile with manual IP configuration

```bash
$ nmcli con add con-name my-con-em1 ifname em1 type ethernet \
  ip4 192.168.100.100/24 gw4 192.168.100.1 ip4 1.2.3.4 ip6 abbe::cafe
$ nmcli con mod my-con-em1 ipv4.dns "8.8.8.8 8.8.4.4"
$ nmcli con mod my-con-em1 +ipv4.dns 1.2.3.4
$ nmcli con mod my-con-em1 ipv6.dns "2001:4860:4860::8888 2001:4860:4860::8844"
$ nmcli -p con show my-con-em1
The first command adds an Ethernet connection profile named my-con-em1 that is bound to interface name em1. The profile is configured with static IP addresses. Three addresses are added, two IPv4 addresses and one IPv6. The first IP 192.168.100.100 has a prefix of 24 (netmask equivalent of 255.255.255.0). Gateway entry will become the default route if this profile is activated on em1 interface (and there is no connection with higher priority). The next two addresses do not specify a prefix, so a default prefix will be used, i.e. 32 for IPv4 and 128 for IPv6. The second, third and fourth commands modify DNS parameters of the new connection profile. The last con show command displays the profile so that all parameters can be reviewed.
```
