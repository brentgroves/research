# **[Network configuration](https://cloudinit.readthedocs.io/en/latest/reference/network-config.html)**

**[Back to Research List](../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../README.md)**

## Default behaviour

Cloud-init searches for network configuration in order of increasing precedence; each item overriding the previous.

- Datasource: For example, OpenStack may provide network config in the MetaData Service.
- System config: A network: entry in /etc/cloud/cloud.cfg.d/* configuration files.
- Kernel command line: ip= or network-config=<Base64 encoded YAML config string>

Cloud-init will write out the following files representing the network-config processed:

/run/cloud-init/network-config.json: world-readable JSON containing the selected source network-config JSON used by cloud-init network renderers.

User-data cannot change an instance’s network configuration. In the absence of network configuration in any of the above sources, cloud-init will write out a network configuration that will issue a DHCP request on a “first” network interface.

Note

The network-config value is expected to be a Base64 encoded YAML string in Networking config Version 1 or **[Networking config Version 2](https://cloudinit.readthedocs.io/en/latest/reference/network-config-format-v2.html#network-config-v2)** format. Optionally, it can be compressed with gzip prior to Base64 encoding.