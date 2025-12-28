# Netplan

## references

<https://netplan.io/>

## How does it work?

Netplan reads network configuration from /etc/netplan/*.yaml which are written by administrators, installers, cloud image instantiations, or other OS deployments. During early boot, Netplan generates backend specific configuration files in /run to hand off control of devices to a particular networking daemon.

![](https://assets.ubuntu.com/v1/a1a80854-netplan_design_overview.svg)
