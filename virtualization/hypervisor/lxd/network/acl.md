# **[](https://documentation.ubuntu.com/lxd/stable-5.21/howto/network_acls/)**

How to configure network ACLs
Note

Network ACLs are available for the OVN NIC type, the OVN network and the Bridge network (with some exceptions; see Bridge limitations).

▶
Watch on YouTube
Network ACLs define rules for controlling traffic:

Between instances connected to the same network

To and from other networks

Network ACLs can be assigned directly to the NIC of an instance, or to a network. When assigned to a network, the ACL applies indirectly to all NICs connected to that network.

When an ACL is assigned to multiple instance NICs, either directly or indirectly, those NICs form a logical port group. You can use the name of that ACL to refer to that group in the traffic rules of other ACLs. For more information, see: Subject name selectors (ACL groups).

List ACLs
CLIAPI
To list all ACLs, run:

lxc network acl list
Show an ACL
CLIAPI
To show details about a specific ACL, run:

lxc network acl show <ACL-name>
Example:

lxc network acl show my-acl
Create an ACL
Name requirements
Network ACL names must meet the following requirements:

Must be between 1 and 63 characters long.

Can contain only ASCII letters (a–z, A–Z), numbers (0–9), and dashes (-).

Cannot begin with a digit or a dash.

Cannot end with a dash.

Instructions
CLIAPI
To create an ACL, run:

lxc network acl create <ACL-name> [user.KEY=value ...]
You must provide an ACL name that meets the Name requirements.

You can optionally provide one or more custom user keys to store metadata or other information.

ACLs have no rules upon creation via command line, so as a next step, add rules to the ACL. You can also edit the ACL configuration, or assign the ACL to a network or NIC.

Another way to create ACLs from the command line is to provide a YAML configuration file:

lxc network acl create <ACL-name> < <filename.yaml>
This file can include any other ACL properties, including the egress and ingress properties for defining ACL rules. See the second example in the set below.

Examples

Create an ACL with the name my-acl and an optional custom user key:

lxc network acl create my-acl user.my-key=my-value
Create an ACL using a YAML configuration file:

First, create a file named config.yaml with the following content:

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
Note that the custom user keys are stored under the config property.

The following command creates an ACL from that file’s configuration:

lxc network acl create my-acl < config.yaml
ACL properties
ACLs have the following properties:

⤋⤊
config
User-provided free-form key/value pairs

description
Description of the network ACL

egress
Egress traffic rules

ingress
Ingress traffic rules

name
Unique name of the network ACL in the project

ACL rules
Each ACL contains two lists of rules:

Rules in the egress list apply to outbound traffic from the NIC.

Rules in the ingress list apply to inbound traffic to the NIC.

For both egress and ingress, the rule configuration looks like this:

YAMLJSON
action: <allow|reject|drop>
description: <description>
destination: <destination-IP-range>
destination_port: <destination-port-number>
icmp_code: <ICMP-code>
icmp_type: <ICMP-type>
protocol: <icmp4|icmp6|tcp|udp>
source: <source-of-traffic>
source_port: <source-port-number>
state: <enabled|disabled|logged>
The action property is required.

The state property defaults to "enabled" if unset.

The source and destination properties can be specified as one or more CIDR blocks, IP ranges, or selectors. If left empty, they match any source or destination. Comma-separate multiple values.

If the protocol is unset, it matches any protocol.

The "destination_port" and "source_port" properties and "icmp_code" and "icmp_type" properties are mutually exclusive sets. Although both sets are shown in the same rule above to demonstrate the syntax, they never appear together in practice.

The "destination_port" and "source_port" properties are only available when the "protocol" for the rule is "tcp" or "udp".

The "icmp_code" and "icmp_type" properties are only available when the "protocol" is "icmp4" or "icmp6".

The "state" is "enabled" by default. The "logged" value is used to log traffic to a rule.

For more information, see: Rule properties.

Add a rule
CLIAPI
To add a rule to an ACL, run:

lxc network acl rule add <ACL-name> <egress|ingress> [properties...]
Example

Add an egress rule with an action of drop to my-acl:

lxc network acl rule add my-acl egress action=drop
Remove a rule
CLIAPI
To remove a rule from an ACL, run:

lxc network acl rule remove <ACL-name> <egress|ingress> [properties...]
You must either specify all properties needed to uniquely identify a rule or add --force to the command to delete all matching rules.

Edit a rule
You cannot edit a rule directly. Instead, you must edit the full ACL, which contains the egress and ingress lists.

Rule ordering and application of actions
ACL rules are defined as lists, but their order within the list does not affect how they are applied.

LXD automatically prioritizes rules based on the action property, in the following order:

drop

reject

allow

The default action for unmatched traffic (defaults to reject, see Configure default actions)

When you assign multiple ACLs to a NIC, you do not need to coordinate rule order across them. As soon as a rule matches, its action is applied and no further rules are evaluated.

Rule properties
ACL rules have the following properties:

⤋⤊
action
Action to take for matching traffic

description
Description of the rule

destination
Comma-separated list of destinations

destination_port
Destination ports or port ranges

icmp_code
ICMP message code

icmp_type
Type of ICMP message

protocol
Protocol to match

source
Comma-separated list of sources

source_port
Source ports or port ranges

state
State of the rule

Use selectors in rules
Note

This feature is supported only for the OVN NIC type and the OVN network.

In ACL rules, the source and destination properties support using selectors instead of CIDR blocks or IP ranges. You can only use selectors in the source of ingress rules, and in the destination of egress rules.

Using selectors allows you to define rules for groups of instances instead of managing lists of IP addresses or subnets manually.

There are two types of selectors:

subject name selectors (ACL groups)

network subject selectors

Subject name selectors (ACL groups)
When an ACL is assigned to multiple instance NICs, either directly or through their networks, those NICs form a logical port group. You can use the name of that ACL as a subject name selector to refer to that group in the egress and ingress lists of other ACLs.

For example, if you have an ACL with the name my-acl, you can specify the group of instance NICs that are assigned this ACL as an egress or ingress rule’s source by setting source to my-acl.

Network subject selectors
Use network subject selectors to define rules based on the network that the traffic is coming from or going to.

All network subject selectors begin with the @ symbol. There are two special network subject selectors called @internal and @external. They represent the network’s local and external traffic, respectively.

Here’s an example ACL rule (in YAML) that allows all internal traffic with the specified destination port:

ingress:

- action: allow
    description: Allow HTTP/HTTPS from internal
    protocol: tcp
    source: "@internal"
    destination_port: "80,443"
    state: enabled
If your network supports network peers, you can reference traffic to or from the peer connection by using a network subject selector in the format @<network-name>/<peer-name>. Example:

source: "@my-network/my-peer"
When using a network subject selector, the network that has the ACL assigned to it must have the specified peer connection.
