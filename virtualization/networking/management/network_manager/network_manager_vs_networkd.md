# **[NetworkMangager vs Networkd](https://askubuntu.com/questions/1429945/what-is-the-default-ubuntu-server-22-04-network-renderer)**

**[Back to Research List](../../research_list.md)**\
**[Back to Networking Menu](./networking_menu.md)**\
**[Back to Current Status](../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../README.md)**

"I do not understand the relation between them." Oversimplification: NetworkManager is designed for user choice of interfaces, like connecting to a new WiFi network, or choosing between multiple connections. networkd is designed for interfaces and connections that are consistent and unchanging. NetworkManger is not included in a stock install of Ubuntu Server 22.04, since servers generally do not have frequently-changing interfaces. If you really do have both installed, the network renderer will be whatever you specified in your Netplan YAML.
