# **[How does NetworkManager get external devices?](https://unix.stackexchange.com/questions/761798/how-does-networkmanager-get-external-devices)**

Where does nmcli device acquire the information about the external devices docker0, virbr0 ?

```bash
# nmcli device console output
DEVICE   TYPE      STATE                   CONNECTION
eno1     ethernet  connected               Wired_eno1
lo       loopback  connected (externally)  lo
docker0  bridge    connected (externally)  docker0
virbr0   bridge    connected (externally)  virbr0
enp5s0   ethernet  unavailable             --
```

Reading **[Get started with NetworkManager on Linux](https://opensource.com/article/22/4/networkmanager-linux)**. I learn that NetworkManager uses the information from D-Bus to initialize each NIC

```The udev daemon creates an entry for each network interface card (NIC) installed in the system in the network rules file. D-Bus signals the presence of a new network device—wired or wireless—to NetworkManager. NetworkManager then listens to the traffic on the D-Bus and responds by creating a configuration for this new device. Such a configuration is, by default, stored only in RAM and is not permanent. It must be created every time the computer is booted.```

But where does udev get the info about the network devices, physical like eno1, enp5s0 or virtual like docker0, virbr0 ?

The kernel generates an udev event for the addition, change or removal of any device, including network devices. Since udev monitors these events, it will become aware of all network devices as soon as the applicable driver detects the hardware.

To query udev for network devices, you cannot use udevadm info -q all -n <device node>, because network devices don't have device nodes. But you can query them by using the sysfs path:

```bash
# udevadm info -q all -p /sys/class/net/<interface name>
# This command will tell you all the possible names for the network interface using the new Predictable Network Interface Names scheme, with the various ID_NET_NAME_* environment variables.

udevadm info -q all -p /sys/class/net/br-eno1             
P: /devices/virtual/net/br-eno1
L: 0
E: DEVPATH=/devices/virtual/net/br-eno1
E: DEVTYPE=bridge
E: INTERFACE=br-eno1
E: IFINDEX=12
E: SUBSYSTEM=net
E: USEC_INITIALIZED=357080517
E: ID_MM_CANDIDATE=1
E: ID_NET_NAMING_SCHEME=v249
E: ID_NET_DRIVER=bridge
E: ID_NET_LINK_FILE=/usr/lib/systemd/network/99-default.link
E: ID_NET_NAME=br-eno1
E: SYSTEMD_ALIAS=/sys/subsystem/net/devices/br-eno1
E: TAGS=:systemd:
E: CURRENT_TAGS=:systemd:

cat /usr/lib/systemd/network/99-default.link                        
#  SPDX-License-Identifier: LGPL-2.1-or-later
#
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it
#  under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation; either version 2.1 of the License, or
#  (at your option) any later version.


[Match]
OriginalName=*

[Link]
NamePolicy=keep kernel database onboard slot path
AlternativeNamesPolicy=database onboard slot path
MACAddressPolicy=persistent

```

This command will list all udev attributes for the network interface device and all its parents (if applicable), which may be useful if you need to write a custom udev rule, e.g. to assign a name for a network interface based on some unusual attribute.
or

```bash
udevadm info -q all -a -p /sys/class/net/<interface name>
udevadm info -q all -a -p /sys/class/net/br-eno1
  looking at device '/devices/virtual/net/br-eno1':
    KERNEL=="br-eno1"
    SUBSYSTEM=="net"
    DRIVER==""
    ATTR{addr_assign_type}=="3"
    ATTR{addr_len}=="6"
    ATTR{address}=="46:3f:25:e1:b5:9c"
    ATTR{brforward}==""
    ATTR{bridge/ageing_time}=="30000"
    ATTR{bridge/bridge_id}=="8000.463f25e1b59c"
    ATTR{bridge/default_pvid}=="1"
    ATTR{bridge/forward_delay}=="1500"
    ATTR{bridge/gc_timer}=="21796"
    ATTR{bridge/group_addr}=="01:80:c2:00:00:00"
    ATTR{bridge/group_fwd_mask}=="0x0"
    ATTR{bridge/hash_elasticity}=="16"
    ATTR{bridge/hash_max}=="4096"
    ATTR{bridge/hello_time}=="200"
    ATTR{bridge/hello_timer}=="70"
    ATTR{bridge/max_age}=="2000"
    ATTR{bridge/multicast_igmp_version}=="2"
    ATTR{bridge/multicast_last_member_count}=="2"
    ATTR{bridge/multicast_last_member_interval}=="100"
    ATTR{bridge/multicast_membership_interval}=="26000"
    ATTR{bridge/multicast_mld_version}=="1"
    ATTR{bridge/multicast_querier}=="0"
    ATTR{bridge/multicast_querier_interval}=="25500"
    ATTR{bridge/multicast_query_interval}=="12500"
    ATTR{bridge/multicast_query_response_interval}=="1000"
    ATTR{bridge/multicast_query_use_ifaddr}=="0"
    ATTR{bridge/multicast_router}=="1"
    ATTR{bridge/multicast_snooping}=="1"
    ATTR{bridge/multicast_startup_query_count}=="2"
    ATTR{bridge/multicast_startup_query_interval}=="3124"
    ATTR{bridge/multicast_stats_enabled}=="0"
    ATTR{bridge/nf_call_arptables}=="0"
    ATTR{bridge/nf_call_ip6tables}=="0"
    ATTR{bridge/nf_call_iptables}=="0"
    ATTR{bridge/no_linklocal_learn}=="0"
    ATTR{bridge/priority}=="32768"
    ATTR{bridge/root_id}=="8000.463f25e1b59c"
    ATTR{bridge/root_path_cost}=="0"
    ATTR{bridge/root_port}=="0"
    ATTR{bridge/stp_state}=="1"
    ATTR{bridge/tcn_timer}=="0"
    ATTR{bridge/topology_change}=="0"
    ATTR{bridge/topology_change_detected}=="0"
    ATTR{bridge/topology_change_timer}=="0"
    ATTR{bridge/vlan_filtering}=="0"
    ATTR{bridge/vlan_protocol}=="0x8100"
    ATTR{bridge/vlan_stats_enabled}=="0"
    ATTR{bridge/vlan_stats_per_port}=="0"
    ATTR{broadcast}=="ff:ff:ff:ff:ff:ff"
    ATTR{carrier}=="0"
    ATTR{carrier_changes}=="3"
    ATTR{carrier_down_count}=="2"
    ATTR{carrier_up_count}=="1"
    ATTR{dev_id}=="0x0"
    ATTR{dev_port}=="0"
    ATTR{dormant}=="0"
    ATTR{duplex}=="unknown"
    ATTR{flags}=="0x1003"
    ATTR{gro_flush_timeout}=="0"
    ATTR{ifalias}==""
    ATTR{ifindex}=="12"
    ATTR{iflink}=="12"
    ATTR{link_mode}=="0"
    ATTR{mtu}=="1500"
    ATTR{name_assign_type}=="3"
    ATTR{napi_defer_hard_irqs}=="0"
    ATTR{netdev_group}=="0"
    ATTR{operstate}=="down"
    ATTR{power/async}=="disabled"
    ATTR{power/control}=="auto"
    ATTR{power/runtime_active_kids}=="0"
    ATTR{power/runtime_active_time}=="0"
    ATTR{power/runtime_enabled}=="disabled"
    ATTR{power/runtime_status}=="unsupported"
    ATTR{power/runtime_suspended_time}=="0"
    ATTR{power/runtime_usage}=="0"
    ATTR{proto_down}=="0"
    ATTR{queues/rx-0/rps_cpus}=="0000,00000000"
    ATTR{queues/rx-0/rps_flow_cnt}=="0"
    ATTR{queues/tx-0/byte_queue_limits/hold_time}=="1000"
    ATTR{queues/tx-0/byte_queue_limits/inflight}=="0"
    ATTR{queues/tx-0/byte_queue_limits/limit}=="0"
    ATTR{queues/tx-0/byte_queue_limits/limit_max}=="1879048192"
    ATTR{queues/tx-0/byte_queue_limits/limit_min}=="0"
    ATTR{queues/tx-0/tx_maxrate}=="0"
    ATTR{queues/tx-0/tx_timeout}=="0"
    ATTR{queues/tx-0/xps_rxqs}=="0"
    ATTR{speed}=="-1"
    ATTR{statistics/collisions}=="0"
    ATTR{statistics/multicast}=="108093"
    ATTR{statistics/rx_bytes}=="1122433244"
    ATTR{statistics/rx_compressed}=="0"
    ATTR{statistics/rx_crc_errors}=="0"
    ATTR{statistics/rx_dropped}=="0"
    ATTR{statistics/rx_errors}=="0"
    ATTR{statistics/rx_fifo_errors}=="0"
    ATTR{statistics/rx_frame_errors}=="0"
    ATTR{statistics/rx_length_errors}=="0"
    ATTR{statistics/rx_missed_errors}=="0"
    ATTR{statistics/rx_nohandler}=="0"
    ATTR{statistics/rx_over_errors}=="0"
    ATTR{statistics/rx_packets}=="283606"
    ATTR{statistics/tx_aborted_errors}=="0"
    ATTR{statistics/tx_bytes}=="4290274"
    ATTR{statistics/tx_carrier_errors}=="0"
    ATTR{statistics/tx_compressed}=="0"
    ATTR{statistics/tx_dropped}=="0"
    ATTR{statistics/tx_errors}=="0"
    ATTR{statistics/tx_fifo_errors}=="0"
    ATTR{statistics/tx_heartbeat_errors}=="0"
    ATTR{statistics/tx_packets}=="56391"
    ATTR{statistics/tx_window_errors}=="0"
    ATTR{testing}=="0"
    ATTR{threaded}=="0"
    ATTR{tx_queue_len}=="1000"
    ATTR{type}=="1"

```
