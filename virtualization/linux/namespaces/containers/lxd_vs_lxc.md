# **[LXD vs LXC](https://blog.purestorage.com/purely-educational/lxc-vs-lxd-linux-containers-demystified/#:~:text=LXD%20(Linux%20Container%20Daemon)%20builds,with%20a%20daemon%2Dbased%20architecture.)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../a_status/detailed_status.md)**\
**[Back to Main](../../../../../README.md)**

LXD ( [lɛks'di:] 🔈) is a modern, secure and powerful system container and virtual machine manager. It provides a unified experience for running and managing full Linux systems inside containers or virtual machines.

## AI Overview

LXD builds upon LXC, offering a more user-friendly and feature-rich experience for managing Linux containers, while LXC is a low-level tool for creating and managing containers. LXD simplifies container management with a daemon-based architecture and a REST API, whereas LXC provides direct kernel-level interaction.

Here's a more detailed comparison:
LXC (Linux Containers):
Low-level:
LXC provides a set of tools, templates, libraries, and language bindings for interacting with the Linux kernel's containerization features.
Flexibility:
LXC offers a high degree of flexibility and control over container configuration, allowing users to fine-tune various aspects of the container environment.
Direct Kernel Interaction:
LXC interacts directly with the Linux kernel to create and manage containers.
Commands:
LXC uses commands like lxc-create, lxc-start, and lxc-destroy to manage containers.
Portability:
LXC increases the portability of individual apps by making it possible to distribute them inside containers
LXD (Linux Container Daemon):
User-friendly:
LXD provides a more intuitive and user-friendly experience for managing Linux containers, simplifying the process for users.
Daemon-based:
LXD uses a daemon-based architecture, with a dedicated background service (daemon) handling container management tasks.
REST API:
LXD offers a REST API for managing containers over the network, enabling remote management and automation.
Features:
LXD provides advanced features not available in LXC, including live container migration, snapshots, and resource restrictions.
Security:
The LXD daemon can take advantage of host-level security features to make containers more secure.
Sharing:
LXD simplifies the process of sharing networking and data storage with containers.
LXD is built on LXC:
LXD uses LXC under the hood to create and manage containers, but it extends LXC's functionality with a more user-friendly interface and additional features.
LXD configuration:
The LXD server can be configured through a set of key/value configuration options.
LXD command:
The lxc command is the LXD front-end.
