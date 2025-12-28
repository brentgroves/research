# **[security group rule](https://docs.openstack.org/python-openstackclient/pike/cli/command-objects/security-group-rule.html)**

**[Back to Research List](../../../../../research_list.md)**\
**[Back to Current Tasks](../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../README.md)**

A security group rule specifies the network access rules for servers and other resources on the network.

Compute v2, Network v2

security group rule create¶
Create a new security group rule

```bash
openstack security group rule create
    [--remote-ip <ip-address> | --remote-group <group>]
    [--dst-port <port-range> | [--icmp-type <icmp-type> [--icmp-code <icmp-code>]]]
    [--protocol <protocol>]
    [--ingress | --egress]
    [--ethertype <ethertype>]
    [--project <project> [--project-domain <project-domain>]]
    [--description <description>]
    <group>
```
