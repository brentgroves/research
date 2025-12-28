# **[configure network](https://documentation.ubuntu.com/lxd/latest/howto/network_configure/)**

## How to configure a network

To configure an existing network, use either the lxc network set and lxc network unset commands (to configure single settings) or the lxc network edit command (to edit the full configuration). To configure settings for specific cluster members, add the --target flag.

For example, the following command configures a DNS server for a physical network:

```bash
lxc network set UPLINK dns.nameservers=8.8.8.8
```

The available configuration options differ depending on the network type. See Network types for links to the configuration options for each **[network type](https://documentation.ubuntu.com/lxd/latest/howto/network_create/#network-types)**.

There are separate commands to configure advanced networking features. See the following documentation:

- **[How to configure network ACLs](https://documentation.ubuntu.com/lxd/latest/howto/network_acls/)**
- How to configure network forwards
- How to configure network load balancers
- How to configure network zones
- How to create OVN peer routing relationships (OVN only)
