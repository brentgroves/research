# **[How to configure network ACLs](https://documentation.ubuntu.com/lxd/latest/howto/network_acls/)**

Note

Network ACLs are available for the **[OVN NIC type](https://documentation.ubuntu.com/lxd/latest/reference/devices_nic/#nic-ovn)**, the **[OVN network](https://documentation.ubuntu.com/lxd/latest/reference/network_ovn/#network-ovn)** and the **[Bridge network](https://documentation.ubuntu.com/lxd/latest/reference/network_bridge/#network-bridge)** (with some exceptions; see Bridge limitations).

Network ACLs define rules for controlling traffic:

Between instances connected to the same network

To and from other networks

Network ACLs can be assigned directly to the NIC of an instance, or to a network. When assigned to a network, the ACL applies indirectly to all NICs connected to that network.

When an ACL is assigned to multiple instance NICs, either directly or indirectly, those NICs form a logical port group. You can use the name of that ACL to refer to that group in the traffic rules of other ACLs. For more information, see: **[Subject name selectors (ACL groups)](https://documentation.ubuntu.com/lxd/latest/howto/network_acls/#network-acls-selectors-subject-name)**.

## List ACLs

To list all ACLs, run:

```bash
lxc network acl list
```

## Show an ACL

To show details about a specific ACL, run:

```bash
lxc network acl show <ACL-name>
```

Example:

```bash
lxc network acl show my-acl
```

## Name requirements

Network ACL names must meet the following requirements:

- Must be between 1 and 63 characters long.
- Can contain only ASCII letters (a–z, A–Z), numbers (0–9), and dashes (-).
- Cannot begin with a digit or a dash.
- Cannot end with a dash.

## Instructions

To create an ACL, run:

```bash
lxc network acl create <ACL-name> [user.KEY=value ...]
```

- You must provide an ACL name that meets the Name requirements.
- You can optionally provide one or more custom user keys to store metadata or other information.

ACLs have no rules upon creation via command line, so as a next step, **[add rules](https://documentation.ubuntu.com/lxd/latest/howto/network_acls/#network-acls-rules)** to the ACL. You can also edit the ACL configuration, or **[assign the ACL to a network or NIC](https://documentation.ubuntu.com/lxd/latest/howto/network_acls/#network-acls-assign)**.

Another way to create ACLs from the command line is to provide a YAML configuration file:

```bash
lxc network acl create <ACL-name> < <filename.yaml>
```

This file can include any other **[ACL properties](https://documentation.ubuntu.com/lxd/latest/howto/network_acls/#network-acls-properties)**, including the egress and ingress properties for defining **[ACL rules](https://documentation.ubuntu.com/lxd/latest/howto/network_acls/#network-acls-rules)**. See the second example in the set below.

## Examples

Create an ACL with the name my-acl and an optional custom user key:

```bash
lxc network acl create my-acl user.my-key=my-value
```

Create an ACL using a YAML configuration file:

First, create a file named config.yaml with the following content:

```yaml
description: Allow web traffic from internal network
config:
  user.owner: devops
ingress:

- action: allow
    description: Allow HTTP/HTTPS from internal
    protocol: tcp
    source: "@internal"
    destination_port: "80,443"
    state: enabled
```

Note that the custom user keys are stored under the config property.

The following command creates an ACL from that file’s configuration:

```bash
lxc network acl create my-acl < config.yaml
```
