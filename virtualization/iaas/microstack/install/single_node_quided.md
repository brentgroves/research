# **[Single-node guided](https://canonical.com/microstack/docs/single-node-guided)**

## **[egress requirements](https://discourse.ubuntu.com/t/manage-a-proxied-environment/43946)**

## Notes

The openstack-hypervisor is not installed in Canonical howto docs, but we can still create virtual machines. My guess is Canonical does not use nova but qemu.

This tutorial shows how to install OpenStack (based on project Sunbeam). It will deploy an OpenStack 2024.1 (Caracal) cloud.

<https://discourse.ubuntu.com/t/single-node-guide/35765>

## Requirements

You will need a single machine whose requirements are:

- physical or virtual machine running Ubuntu 24.04 LTS
- a multi-core amd64 processor (ideally with 4+ cores)
- a minimum of 16 GiB of free memory
- 100 GiB of SSD storage available on the root disk
- two network interfaces
- primary: for access to the OpenStack control plane
- secondary: for remote access to cloud VMs

Caution: Any change in IP address of the local host will be detrimental to the deployment. A virtual host will generally have a more stable address.

Important: For environments constrained by a proxy server, the target machine must first be configured accordingly. See section Configure for the proxy at the OS level on the **[Manage a proxied environment](https://canonical.com/microstack/docs/proxied-environment)** page before proceeding.

## Control plane networking

The network associated with the primary network interface requires a range of approximately ten IP addresses that will be used for API service endpoints.

For the purposes of this tutorial, the following configuration is in place:

| Network component         | Value                     |
|---------------------------|---------------------------|
| CIDR                      | 172.16.1.0/24             |
| Gateway                   | 172.16.1.1                |
| Address range             | 172.16.1.201-172.16.1.220 |
| Interface name on machine | eno1                      |

External networking
The network associated with the secondary network interface requires a range of IP addresses that will be sufficient for allocating floating IP addresses to VMs. This will, in turn, allow them to be contacted by remote hosts.

For the purposes of this tutorial, the following configuration is in place:

| Network component         | Value                   |
|---------------------------|-------------------------|
| CIDR                      | 172.16.2.0/24           |
| Gateway                   | 172.16.2.1              |
| Address range             | 172.16.2.2-172.16.2.254 |
| Interface name on machine | eno2                    |

## Deploy the cloud

The cloud deployment process consists of several stages: installing a snap, preparing the cloud node machine, bootstrapping the cloud, and finally configuring the cloud.

Note: During the deployment process you will be asked to input information in order to configure your new cloud. These questions are explained in more detail on the **[Interactive configuration prompts](https://canonical.com/microstack/docs/interactive-prompts)** page in the reference section.

## Install the openstack snap

Begin by installing the openstack snap:

```bash
sudo snap install openstack
2025-06-10T17:03:39Z INFO Waiting for automatic snapd restart...
openstack (2024.1/stable) 2024.1 from Canonical✓ installed

```

## Prepare the machine

As a prerequisite, Sunbeam needs a Juju controller deployed to LXD. --bootstrap option will set it up automatically, for a more detailed procedure refer to **[Bootstrap LXD based Juju controller on single node](https://canonical.com/microstack/docs/bootstrap-lxd-based-juju-controller)**.

Sunbeam can generate a script to ensure that the machine has all of the required dependencies installed and is configured correctly for use in OpenStack - you can review this script using:

```bash
sunbeam prepare-node-script --bootstrap
```

or the script can be directly executed in this way:

```bash
sunbeam prepare-node-script --bootstrap | bash -x && newgrp snap_daemon
++ lsb_release -sc
+ '[' noble '!=' noble ']'
++ whoami
+ USER=brent
++ id -u
+ '[' 1000 -eq 0 -o brent = root ']'
+ SUDO_ASKPASS=/bin/false
+ sudo -A whoami
+ sudo grep -r brent /etc/sudoers /etc/sudoers.d
+ grep NOPASSWD:ALL
+ for pkg in openssh-server curl sed
+ dpkg -s openssh-server
+ for pkg in openssh-server curl sed
+ dpkg -s curl
+ for pkg in openssh-server curl sed
+ dpkg -s sed
+ sudo usermod --append --groups snap_daemon brent
+ '[' -f /home/brent/.ssh/id_ed25519 ']'
+ cat /home/brent/.ssh/id_ed25519.pub
++ hostname --all-ip-addresses
+ ssh-keyscan -H 172.24.188.57
# 172.24.188.57:22 SSH-2.0-OpenSSH_9.6p1 Ubuntu-3ubuntu13.11
# 172.24.188.57:22 SSH-2.0-OpenSSH_9.6p1 Ubuntu-3ubuntu13.11
# 172.24.188.57:22 SSH-2.0-OpenSSH_9.6p1 Ubuntu-3ubuntu13.11
# 172.24.188.57:22 SSH-2.0-OpenSSH_9.6p1 Ubuntu-3ubuntu13.11
# 172.24.188.57:22 SSH-2.0-OpenSSH_9.6p1 Ubuntu-3ubuntu13.11
+ grep -E 'HTTPS?_PROXY' /etc/environment
+ curl -s -m 10 -x '' api.charmhub.io
+ grep -E -q 'HTTPS?_PROXY=' /etc/environment
+ grep -E -q NO_PROXY= /etc/environment
+ sudo snap connect openstack:ssh-keys
+ sudo snap install --channel 3.6/stable juju
snap "juju" is already installed, see 'snap help refresh'
+ mkdir -p /home/brent/.local/share
+ mkdir -p /home/brent/.config/openstack
++ snap list openstack --unicode=never --color=never
++ grep openstack
+ snap_output='openstack  2024.1   727  2024.1/stable  canonical**  -'
++ awk -v col=4 '{print $col}'
+ track=2024.1/stable
+ [[ 2024.1/stable =~ edge ]]
+ [[ 2024.1/stable == \- ]]
+ [[ 2024.1/stable =~ beta ]]
+ [[ 2024.1/stable =~ candidate ]]
+ risk=stable
+ [[ stable != \s\t\a\b\l\e ]]
+ sudo snap install lxd --channel 5.21/stable
lxd (5.21/stable) 5.21.3-c5ae129 from Canonical✓ installed
++ whoami
+ USER=brent
+ sudo usermod --append --groups lxd brent
++ sudo --user brent lxc network list --format csv
++ grep lxdbr0
If this is your first time running LXD on this machine, you should also run: lxd init
To start your first container, try: lxc launch ubuntu:24.04
Or for a virtual machine: lxc launch ubuntu:24.04 --vm

+ '[' -n '' ']'
++ sudo --user brent lxc storage list --format csv
+ '[' -z '' ']'
+ echo 'Bootstrapping LXD'
Bootstrapping LXD
+ cat
+ sudo --user brent lxd init --preseed
+ grep -E -q 'HTTPS?_PROXY=' /etc/environment
+ echo 'Bootstrapping Juju onto LXD'
Bootstrapping Juju onto LXD
+ sudo --user brent juju show-controller
{}
+ '[' 1 -ne 0 ']'
+ set -e
+ printenv
+ grep -q '^HTTP_PROXY'
+ sudo --user brent juju bootstrap localhost
Creating Juju controller "localhost-localhost" on localhost/localhost
Looking for packaged Juju agent version 3.6.5 for amd64
Located Juju agent version 3.6.5-ubuntu-amd64 at https://streams.canonical.com/juju/tools/agent/3.6.5/juju-3.6.5-linux-amd64.tgz
To configure your system to better support LXD containers, please see: https://documentation.ubuntu.com/lxd/en/latest/explanation/performance_tuning/
Launching controller instance(s) on localhost/localhost...
 - juju-abebe7-0 (arch=amd64)                   
Installing Juju agent on bootstrap instance
Waiting for address
Attempting to connect to 10.159.97.95:22
Connected to 10.159.97.95
Running machine configuration script...
Bootstrap agent now started
Contacting Juju controller at 10.159.97.95 to verify accessibility...

Bootstrap complete, controller "localhost-localhost" is now available
Controller machines are in the "controller" model

Now you can run
        juju add-model <model-name>
to create a new model to deploy workloads.
+ echo 'Juju bootstrap complete, you can now bootstrap sunbeam!'
Juju bootstrap complete, you can now bootstrap sunbeam!
```

The script will ensure some software requirements are satisfied on the host. In particular, it will:

install openssh-server if it is not found
configure passwordless sudo for all commands for the current user (NOPASSWD:ALL)

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

```

## Configure the cloud

Now configure the deployed cloud using the configure command:

```bash
sunbeam configure --openrc demo-openrc
VMs will be accessible only from the local host or only from remote hosts. For remote, you must specify the network interface dedicated to VM access traffic. The intended remote hosts must have 
connectivity to this interface.
Local or remote access to VMs [local/remote] (local): 
Network from which the instances will be remotely accessed (outside OpenStack). Takes the form of a CIDR block.
External network - arbitrary but must not be in use (172.16.2.0/24): 
VMs intended to be accessed from remote hosts will be assigned dedicated addresses from a portion of the physical network (outside OpenStack). Takes the form of an IP range.
External network's allocation range (172.16.2.2-172.16.2.254): 
Type of network to use for external access.
External network's type  [flat/vlan] (flat): 
If enabled, demonstration resources will be created on the cloud.
Populate OpenStack cloud with demo user, default images, flavors etc [y/n] (y): 
Username for the demonstration user.
Username to use for access to OpenStack (demo): 
Password for the demonstration user.
Password to use for access to OpenStack (oA********): 
Network range for the private network for the demonstration user's project. Typically an unroutable network (RFC 1918).
Project network (192.168.0.0/24): 
A list of DNS server IP addresses (comma separated) that should be used for external DNS resolution from cloud instances. If not specified, the system's default nameservers will be used.
Project network's nameservers (8.8.8.8 8.8.4.4): 
If enabled, security groups will be created with rules to allow ICMP and SSH access to instances.
Enable ping and SSH access to instances? [y/n] (y): 
⠸ Generating openrc for cloud admin usage ... Writing openrc to demo-openrc ... done
The cloud has been configured for sample usage.
You can start using the OpenStack client or access the OpenStack dashboard at http://172.16.1.204:80/openstack-horizon
```

The --openrc option specifies a regular user (non-admin) cloud init file (demo-openrc here).

A series of questions will now be asked. Below is a sample output of an entire interactive session. The values in square brackets, when present, provide acceptable values. A value in parentheses is the default value. Here we use the values given earlier:

| Local or remote access to VMs                       | If ‘local’ is selected then VMs will only be accessible from the local host, whereas if ‘remote’ is selected then VMs will only be accessible from remote hosts.  For the remote case, you will subsequently be asked to specify what network interface to dedicate to VM access traffic. The intended remote hosts must have connectivity to this interface.                                                                                                                                |
|-----------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| External network - arbitrary but must not be in use | Question will appear for local access only.  CIDR of network for assigning addresses to VMs intended to be accessed from the local host. It is arbitrary but should not conflict with another network known to the host.                                                                                                                                                                                                                                                                     |
| External network                                    | Question will appear for remote access only.  CIDR of network for assigning addresses to VMs intended to be accessed from remote hosts. It represents a portion of the physical network (outside of the OpenStack installation) whose IP addresses are dedicated for this purpose.  Caution: If you opted to access OpenStack APIs externally in the bootstrap step and you opted to access OpenStack VMs externally in the current configure step, ensure that these ranges do not overlap. |
| External network’s gateway                          | Question will appear for remote access only.  IP address of existing default gateway for external network.                                                                                                                                                                                                                                                                                                                                                                                   |
| External network’s allocation range                 | VMs intended to be accessed from remote hosts will be assigned dedicated addresses from a portion of the physical network (outside OpenStack). Takes the form of an IP range.                                                                                                                                                                                                                                                                                                                |
| External network’s type                             | Network type for access to external network - ‘flat’ (untagged) or ‘vlan’ (tagged).                                                                                                                                                                                                                                                                                                                                                                                                          |
| External network’s segmentation id                  | Question will appear for VLAN network type only.  VLAN ID to use for the external network.                                                                                                                                                                                                                                                                                                                                                                                                   |
| External network’s interface                        | Question will appear for remote access only.  The network interface used for external access to VMs. The interface should be connected to an appropriate physical network. Detected unconfigured (free) interfaces will be listed as acceptable values. However, an interface not appearing in the list can still be entered.  Remote hosts intending to access VMs must be able to contact this interface.                                                                                  |                                                |

## local host access only

```bash
# VMs will be accessible only from the local host or only from remote hosts. For remote, you must specify the network interface dedicated to VM access traffic. The intended remote hosts
# must have connectivity to this interface.
Local or remote access to VMs [local/remote] (local):
Network from which the instances will be remotely accessed (outside OpenStack). Takes the form of a CIDR block.
External network - arbitrary but must not be in use (172.16.2.0/24):
VMs intended to be accessed from remote hosts will be assigned dedicated addresses from a portion of the physical network (outside OpenStack). Takes the form of an IP range.
External network's allocation range (172.16.2.2-172.16.2.254):
Type of network to use for external access.
External network's type  [flat/vlan] (flat):
If enabled, demonstration resources will be created on the cloud.
Populate OpenStack cloud with demo user, default images, flavors etc [y/n] (y):
Username for the demonstration user.
Username to use for access to OpenStack (demo):
Password for the demonstration user.
Password to use for access to OpenStack (8u********):
Network range for the private network for the demonstration user's project. Typically an unroutable network (RFC 1918).
Project network (192.168.0.0/24):
A list of DNS server IP addresses (comma separated) that should be used for external DNS resolution from cloud instances. If not specified, the system's default nameservers will be
used.
Project network's nameservers (10.92.6.1 8.8.4.4 8.8.8.8):
If enabled, security groups will be created with rules to allow ICMP and SSH access to instances.
Enable ping and SSH access to instances? [y/n] (y):
⠴ Generating openrc for cloud admin usage ... Writing openrc to demo-openrc ... done
The cloud has been configured for sample usage.
You can start using the OpenStack client or access the OpenStack dashboard at <http://172.16.1.204:80/openstack-horizon>
```

## error

```bash
Error: Error opening file for Image: Error downloading image from "http://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img": Get "http://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img": OpenStack connection error, retries exhausted. Aborting. Last error was: dial tcp: lookup cloud-images.ubuntu.com on 127.0.0.53:53: read udp 127.0.0.1:45102->127.0.0.53:53: i/o timeout

  with openstack_images_image_v2.ubuntu,
  on main.tf line 57, in resource "openstack_images_image_v2" "ubuntu":
  57: resource "openstack_images_image_v2" "ubuntu" {


Error configuring cloud
Traceback (most recent call last):
  File "/snap/openstack/727/lib/python3.12/site-packages/sunbeam/core/terraform.py", line 207, in apply
    process = subprocess.run(
              ^^^^^^^^^^^^^^^
  File "/usr/lib/python3.12/subprocess.py", line 571, in run
    raise CalledProcessError(retcode, process.args,
subprocess.CalledProcessError: Command '['/snap/openstack/727/bin/terraform', 'apply', '-auto-approve', '-no-color']' returned non-zero exit status 1.

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/snap/openstack/727/lib/python3.12/site-packages/sunbeam/commands/configure.py", line 539, in run
    self.tfhelper.apply()
  File "/snap/openstack/727/lib/python3.12/site-packages/sunbeam/core/terraform.py", line 225, in apply
    raise TerraformException(str(e))
sunbeam.core.terraform.TerraformException: Command '['/snap/openstack/727/bin/terraform', 'apply', '-auto-approve', '-no-color']' returned non-zero exit status 1.
Error: Command '['/snap/openstack/727/bin/terraform', 'apply', '-auto-approve', '-no-color']' returned non-zero exit status 1.
```

sudo service systemd-resolved.service status
sudo service systemd-networkd status
sudo service systemd-networkd restart

## remote host access

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

Any remote hosts intending to connect to VMs on this node (remote access in first question) must have connectivity with the interface selected for external traffic (last question above).

## Launch a VM

Verify the cloud by launching a VM called ‘test’ based on the ‘ubuntu’ image (Ubuntu 22.04 LTS). The launch command is used:

```bash
sunbeam launch ubuntu --name test
# Launching an OpenStack instance ... 
# Access the instance by running the following command:
ssh -i /home/brent/snap/openstack/727/sunbeam ubuntu@172.16.2.76

# this is the private key
less /home/brent/snap/openstack/727/sunbeam

```

Connect to the VM over SSH. If remote VM access has been enabled, you will need the private SSH key given in the above output from the launching node. Copy it to the connecting host. Note that the VM will not be ready instantaneously; waiting time is mostly determined by the cloud’s available resources.

Actual output research21:

```bash
# Launching an OpenStack instance ... 
# Access the instance by running the following command:
ssh -i /home/brent/snap/openstack/727/sunbeam ubuntu@172.16.2.76

# The authenticity of host '172.16.2.76 (172.16.2.76)' can't be established.
# ED25519 key fingerprint is SHA256:J1LeAOAsCgzh/LLXeqrRqxl+A7smLolIrF+WodI8LiQ.
# This key is not known by any other names.
# Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
# Warning: Permanently added '172.16.2.76' (ED25519) to the list of known hosts.
Welcome to Ubuntu 24.04.2 LTS (GNU/Linux 6.8.0-60-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Mon May 19 18:50:57 UTC 2025

  System load:  0.16              Processes:             93
  Usage of /:   55.5% of 2.84GB   Users logged in:       0
  Memory usage: 37%               IPv4 address for ens3: 192.168.0.211
  Swap usage:   0%

Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status



The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

```

## Related how-tos

Now that OpenStack is set up, be sure to check out the following howto guides:

- **[Accessing the OpenStack dashboard](https://canonical.com/microstack/docs/dashboard)**
- **[Using the OpenStack CLI](https://canonical.com/microstack/docs/cli)**

<https://discourse.ubuntu.com/t/single-node-guide/35765>
