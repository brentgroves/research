# **[Single-node guide](https://canonical.com/microstack/docs/single-node-guided)**

## **[egress requirements](https://discourse.ubuntu.com/t/manage-a-proxied-environment/43946)**

This tutorial shows how to install OpenStack (based on project Sunbeam). It will deploy an OpenStack 2024.1 (Caracal) cloud.

Requirements
You will need a single machine whose requirements are:

- physical or virtual machine running Ubuntu 24.04 LTS
- a multi-core amd64 processor (ideally with 4+ cores)
- a minimum of 16 GiB of free memory
- 100 GiB of SSD storage available on the root disk
- two network interfaces
- primary: for access to the OpenStack control plane
- secondary: for remote access to cloud VMs

Caution: Any change in IP address of the local host will be detrimental to the deployment. A virtual host will generally have a more stable address.

Important: For environments constrained by a proxy server, the target machine must first be configured accordingly. See section Configure for the proxy at the OS level on the **[Manage a proxied environment page](https://canonical.com/microstack/docs/proxied-environment)** before proceeding.

## Control plane networking

The network associated with the primary network interface requires a range of approximately ten IP addresses that will be used for API service endpoints.

For the purposes of this tutorial, the following configuration is in place:

```yaml
CIDR: 192.168.1.0/24
Gateway: 192.168.1.1
Address range: 192.168.1.201-192.168.1.220
Interface name on machine: eno1
```

## External networking

The network associated with the secondary network interface requires a range of IP addresses that will be sufficient for allocating floating IP addresses to VMs. This will, in turn, allow them to be contacted by remote hosts.

For the purposes of this tutorial, the following configuration is in place:

```yaml
# Network component Value
CIDR: 192.168.1.0/24
Gateway: 192.168.1.1
Address range: 192.168.1.101-192.168.1.200
Interface name on machine: eno2
```

## Deploy the cloud

The cloud deployment process consists of several stages: installing a snap, preparing the cloud node machine, bootstrapping the cloud, and finally configuring the cloud.

Note: During the deployment process you will be asked to input information in order to configure your new cloud. These questions are explained in more detail on the Interactive configuration prompts page in the reference section.

## Install the openstack snap

Begin by installing the openstack snap:

```bash
sudo snap install openstack
2025-06-06T18:32:13Z INFO Waiting for automatic snapd restart...
2025-06-06T18:32:15Z INFO Waiting for automatic snapd restart...
openstack (2024.1/stable) 2024.1 from Canonical✓ installed
```

## Prepare the machine

As a prerequisite, Sunbeam needs a Juju controller deployed to LXD. --bootstrap option will set it up automatically, for a more detailed procedure refer to Bootstrap LXD based Juju controller on single node.

Sunbeam can generate a script to ensure that the machine has all of the required dependencies installed and is configured correctly for use in OpenStack - you can review this script using:

```bash
sunbeam prepare-node-script --bootstrap
```

or the script can be directly executed in this way:

```bash
sunbeam prepare-node-script --bootstrap | bash -x && newgrp snap_daemon
```

The script will ensure some software requirements are satisfied on the host. In particular, it will:

- install openssh-server if it is not found
- configure passwordless sudo for all commands for the current user (NOPASSWD:ALL)

## Bootstrap the cloud

Deploy the OpenStack cloud using the cluster bootstrap command:

```bash
sunbeam cluster bootstrap
```

You will first be prompted whether or not to enable network proxy usage. If ‘Yes’, several sub-questions will be asked.

```bash
Use proxy to access external network resources? [y/n] (y):
http_proxy ():
https_proxy ():
no_proxy ():
```

Note that proxy settings can also be supplied by using a manifest (see **[Deployment manifest](https://canonical.com/microstack/docs/manifest)**).

When prompted, enter the CIDR and the address range for the control plane networking. Here we use the values given earlier:

```bash
# try 1
sunbeam cluster bootstrap
Management network should be available on every node of the deployment. It is used for communication between the nodes of the deployment. Requires CIDR format, can be a comma-separated list.
Management network (192.168.1.0/24): 172.16.1.0/24
This will configure the proxy settings for the deployment. Resources will be fetched from the internet via the proxy.
Use proxy to access external network resources? [y/n] (n): 

An unexpected error has occurred. Please see https://canonical-openstack.readthedocs-hosted.com/en/latest/how-to/troubleshooting/inspecting-the-cluster/ for troubleshooting information.
Error: No local IP address found for CIDR 172.16.1.0/24

# try 2
sunbeam cluster bootstrap
# Management network should be available on every node of the deployment. It is used for communication between the nodes of the deployment. Requires CIDR format, can be a comma-separated list.
Management network (192.168.1.0/24): 
# This will configure the proxy settings for the deployment. Resources will be fetched from the internet via the proxy.
Use proxy to access external network resources? [y/n] (n): 
# This will configure number of databases, single for entire cluster or multiple databases with one per openstack service.
Enter database topology: single/multi (cannot be changed later) (single): 
# A region is general division of OpenStack services. It cannot be changed once set.
Enter a region name (cannot be changed later) (RegionOne): 
# OpenStack services are exposed via virtual IP addresses. This range should contain at least ten addresses and must not overlap with external network CIDR. To access APIs from a remote host, the range must
# reside within the subnet that the primary network interface is on.
# On multi-node deployments, the range must be addressable from all nodes in the deployment.
OpenStack APIs IP ranges (172.16.1.201-172.16.1.240): 
# Node has been bootstrapped with roles: control, compute

```

## Configure the cloud

Now configure the deployed cloud using the configure command:

```bash
sunbeam configure --openrc demo-openrc
```

The --openrc option specifies a regular user (non-admin) cloud init file (demo-openrc here).

A series of questions will now be asked. Below is a sample output of an entire interactive session. The values in square brackets, when present, provide acceptable values. A value in parentheses is the default value. Here we use the values given earlier:

```bash
Local or remote access to VMs [local/remote] (local): remote
External network (172.16.2.0/24):
External network’s gateway (172.16.2.1):
Populate OpenStack cloud with demo user, default images, flavors etc [y/n] (y):
Username to use for access to OpenStack (demo):
Password to use for access to OpenStack (mt********):
Project network (192.168.0.0/24):
Enable ping and SSH access to instances? [y/n] (y):
External network’s allocation range (172.16.2.2-172.16.2.254):
External network’s type [flat/vlan] (flat):
Writing openrc to demo-openrc ... done
External network’s interface [eno1/eno2] (eno1): eno2
```
