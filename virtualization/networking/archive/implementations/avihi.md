# **[avahi](https://en.wikipedia.org/wiki/Avahi_(software))**

**[Back to Research List](../../research_list.md)**\
**[Back to Networking Menu](./networking_menu.md)**\
**[Back to Current Status](../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../README.md)**

Avahi is a free zero-configuration networking (zeroconf) implementation, including a system for multicast DNS and DNS Service Discovery. It is licensed under the GNU Lesser General Public License (LGPL).

Avahi is a system which enables programs to publish and discover services and hosts running on a local network. For example, a user can plug a computer into a network and have Avahi automatically advertise the network services running on its machine, facilitating user access to those services.

## Software architecture

Architectural overview of the Avahi software framework
Avahi implements the Apple Zeroconf specification, mDNS, DNS-SD and RFC 3927/IPv4LL. Other implementations include Apple's Bonjour framework (the mDNSResponder component of which is licensed under the Apache License).

Avahi provides a set of language bindings (Python, Mono, etc.) and ships with most Linux and BSD distributions. Because of its modularized architecture, major desktop components like GNOME Virtual file system and KDE input/output architecture already integrate Avahi.
