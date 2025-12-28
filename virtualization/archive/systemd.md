# **[Systemd](https://www.digitalocean.com/community/tutorials/understanding-systemd-units-and-unit-files)**

**[Back to Research List](../../research_list.md)**\
**[Back to Networking Menu](./networking_menu.md)**\
**[Back to Current Status](../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../README.md)**

Increasingly, Linux distributions are adopting the systemd init system. This powerful suite of software can manage many aspects of your server, from services to mounted devices and system states.

In systemd, a unit refers to any resource that the system knows how to operate on and manage. This is the primary object that the systemd tools know how to deal with. These resources are defined using configuration files called unit files.

In this guide, we will introduce you to the different units that systemd can handle. We will also be covering some of the many directives that can be used in unit files in order to shape the way these resources are handled on your system.
