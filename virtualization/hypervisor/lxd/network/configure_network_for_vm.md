# **[](https://www.youtube.com/watch?v=vYK1aLSDVIw)

In this video, we explore LXD networking for Linux virtual machines. LXD offers a variety of different mechanisms to connect your VMs to your physical network, or simply expose services running on them to devices on your network. We'll start out by looking at the default LXD network architecture, and then discuss how forwarding rules are used to access network ports on LXD VMs. Next, we'll discuss MacVLAN and some of the caveats you'll want to consider. Finally, we'll cover bridged networking, which allows LXD virtual machines to share the Linux host's physical network adapter.

We'll also run through a demo of how to set up network forwarding rules, associate a secondary IP address that's dedicated to a virtual machine, and how MacVLAN and bridged LXD profiles are configured.

Documentation for LXD Networking: <https://linuxcontainers.org/lxd/docs/>...
