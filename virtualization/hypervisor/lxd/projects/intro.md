# **[Introduction to LXD projects](https://ubuntu.com/tutorials/introduction-to-lxd-projects#1-overview)**

logical separation of resources

1. Overview
LXD is a container hypervisor providing a REST API to manage LXC containers. It provides a virtual machine like experience without incurring the overhead of a traditional hypervisor.

However when you are managing lots of containers providing different services, it can become confusing to see which containers are dependent on each other.

The projects feature is designed to help in this situation by providing the ability to group one or more containers together into related “projects” that can be used with the lxc tool.

This tutorial will show how to create LXD projects, add containers into a project and explore the features that can be specified at a project level.

## Requirements

- LXD snap installed and running (although we will cover this briefly if not)
- You should know how to create and launch a LXD container

2. Installing LXD Snap
We will need LXD installed and running before we can use it to create a project.

The easiest way to stay up to date with LXD is to use the Snap package.

We can install LXD using Snap as follows:

snap install lxd
If you are running Ubuntu 18.04 LTS or earlier then you may already have LXD installed as an apt package.

You can migrate your containers to the newer Snap package and remove the old packages by running:

lxd.migrate -yes
If this is the first time you have used LXD, then you also need to initialise it.

You can run lxd init without the --auto flag if you want to answer a series of questions about how it should be setup. Otherwise if you want to accept the defaults then lxd init --auto will do.

lxd init --auto
Lets check that LXD is working by running:

lxc ls
If you don’t get any errors, then we can move onto the next step!

Note: If you already had LXD installed you may need to logout and log back in again for the lxc command to recognise the new Snap package.
