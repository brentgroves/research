# **[](https://discourse.ubuntu.com/t/regarding-lxd-agent-for-custom-images/44993/2)**

Ubuntu ships with a tiny package called lxd-agentloader which consists of a systemd unit file, some udev rules and a small bash script

<https://git.launchpad.net/ubuntu/+source/lxd-agent-loader/tree/> 18

This allows the lxd-agent to be copied from the VMs config drive and run on startup.

You can also use cloud-init or do it manually, see

“VM cloud-init” section on:

<https://documentation.ubuntu.com/lxd/en/latest/reference/devices_disk/#types-of-disk-devices> 12
