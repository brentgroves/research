# Network Management

**[Back to Research List](../../../research_list.md)**\
**[Back to Networking Menu](../networking_menu.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

By default network management on Ubuntu Core is handled by **[systemd’s networkd](https://www.freedesktop.org/software/systemd/man/latest/systemd-networkd.service.html)** and **[netplan](https://launchpad.net/netplan)**. However, when NetworkManager is installed, it will take control of all networking devices in the system by creating a netplan configuration file in which it sets itself as the default network renderer.

**Note:** On reports-alb and repsys11 networkd was not running and NetworkManager was.
