# **[]()

## AI Overview: use virt-manager to connect to lxd container

Connecting Virt-Manager to KVM Hosts Easily – CubicleNate's ...
To manage LXD containers with virt-manager, you'll first need to ensure LXC and virt-manager are installed and properly configured to work with each other. Specifically, you'll need the libvirt LXC driver and potentially SSH keys set up for remote connections. You can then add a new connection in virt-manager using the lxc:/// URI, which should allow you to see and manage your LXD containers.

This **[video](https://www.youtube.com/watch?v=d8oNFVveodA)** demonstrates how to add a new connection to virt-manager for managing LXD containers:

Configure virt-manager:
Open virt-manager and click on "File" -> "Add Connection...".
Select "LXC (LXD)" as the connection type.
Enter the URI lxc:/// and click "Connect".
If you're connecting to a remote LXD server, you may need to configure SSH keys for authentication.
