# **[](https://www.keepalived.org/)**

What is Keepalived ?
Keepalived is a routing software written in C. The main goal of this project is to provide simple and robust facilities for loadbalancing and high-availability to Linux system and Linux based infrastructures. Loadbalancing framework relies on well-known and widely used Linux Virtual Server (IPVS) kernel module providing Layer4 loadbalancing. Keepalived implements a set of checkers to dynamically and adaptively maintain and manage loadbalanced server pool according their health. On the other hand high-availability is achieved by VRRP protocol. VRRP is a fundamental brick for router failover. In addition, Keepalived implements a set of hooks to the VRRP finite state machine providing low-level and high-speed protocol interactions. In order to offer fastest network failure detection, Keepalived implements BFD protocol. VRRP state transition can take into account BFD hint to drive fast state transition. Keepalived frameworks can be used independently or all together to provide resilient infrastructures.

Keepalived is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.

RESOURCES
Keepalived main website doesn't offer package for any Linux distribution, it only provides source code and code repository. Most of Linux distribution are offering Keepalived package as a mainline package and package maintainers are making a great job maintaining and reporting issues about it.
