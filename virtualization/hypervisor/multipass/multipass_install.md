# **[How to install Multipass](https://canonical.com/multipass/docs/install-multipass)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Multipass Menu](./multipass_menu.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

This guide explains how to install and manage Multipass on your system.

## To uninstall Multipass, simply run

```sudo snap remove multipass```

## **[Install Multipass](https://multipass.run/docs/installing-on-linux#heading--install-upgrade-uninstall)**

The Ubuntu Snap Store is located on the domain snapcraft.io.

To install Multipass, simply execute:

```bash
sudo snap install multipass
multipass 1.13.0 from Canonical✓ installed
multipass 1.15.0 from Canonical✓ installed
```

You can also use the edge channel to get the latest development build:

```bash
snap install multipass --edge
```

Make sure you’re part of the group that Multipass gives write access to its **[socket](../../sockets/unix_domain_sockets.md)** (sudo in this case, but it may also be adm or admin, depending on your distribution):

Make sure you’re part of the group that Multipass gives write access to its socket (sudo in this case, but it may also be adm or admin, depending on your distribution):

```bash
$ ls -l /var/snap/multipass/common/multipass_socket
srw-rw---- 1 root sudo 0 Dec 19 09:47 /var/snap/multipass/common/multipass_socket
$ groups | grep sudo
brent adm cdrom sudo dip plugdev lpadmin lxd sambashare docker

```

You can view more information on the snap package using the snap info command:

```bash
snap info multipass
```

You’ve installed Multipass. Time to run your first commands! Use multipass version to check your version or multipass launch to create your first instance.

```bash
sudo multipass launch
or 
multipass install hello-world
```
