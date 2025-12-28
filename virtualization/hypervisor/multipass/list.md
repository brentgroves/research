# **[Multipass list](https://multipass.run/docs/list-command)**

**[Back to Research List](../../research_list.md)**\
**[Back to Multipass Menu](./multipass_menu.md)**\
**[Back to Current Status](../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../README.md)**

The multipass list command lists available instances or snapshots. With no options, it presents a generic view of instances, with some of their properties:

```bash
multipass list
Name                    State             IPv4             Image
my-juju-vm              Running           10.42.209.100    Ubuntu 22.04 LTS
                                          10.213.0.1
                                          10.1.32.128
# repsys
multipass shell my-juju-vm    
shell failed: The following errors occurred:
instance "my-juju-vm" does not exist
```
