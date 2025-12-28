# **[Single-node quickstart](https://canonical.com/microstack/docs/single-node)**

## **[egress requirements](https://discourse.ubuntu.com/t/manage-a-proxied-environment/43946)**

## Notes

The openstack-hypervisor is not installed in Canonical howto docs, but we can still create virtual machines. My guess is Canonical does not use nova but qemu.

## Single-node quickstart

This tutorial shows how to install OpenStack (based on project Sunbeam) in the simplest way possible. It will deploy an OpenStack 2024.1 (Caracal) cloud.

The cloud will only allow access to its VMs from the local host. To enable access from any host on your network, follow the Single-node guided tutorial instead.

## Requirements

You will need a single machine whose requirements are:

physical or virtual machine running Ubuntu 24.04 LTS
a multi-core amd64 processor ideally with 4+ cores
a minimum of 16 GiB of free memory
100 GiB of SSD storage available on the root disk

Caution: Any change in IP address of the local host will be detrimental to the deployment. A virtual host will generally have a more stable address.

## Deploy the cloud

## Install the openstack snap

Duration: 5 minutes
Depending on internet connection speed to required resources may be shorter or longer.

Begin by installing the openstack snap:

```bash
sudo snap install openstack
```

## Prepare the machine

Sunbeam can generate a script to ensure that the machine has all of the required dependencies installed and is configured correctly for use in OpenStack - you can review this script using:

```bash
sunbeam prepare-node-script --bootstrap

+ echo 'Sunbeam requires the LXD bridge to be called anything except lxdbr0'
Sunbeam requires the LXD bridge to be called anything except lxdbr0
+ exit 1

# uninstalled the lxd snap and the following script reinstalled it

sunbeam prepare-node-script --bootstrap | bash -x && newgrp snap_daemon
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

## Bootstrap the cloud

Deploy the OpenStack cloud using the cluster bootstrap command:

```bash
# sunbeam cluster bootstrap
sunbeam cluster bootstrap --accept-defaults

```

You will first be prompted whether or not to enable network proxy usage. If ‘Yes’, several sub-questions will be asked.

Use proxy to access external network resources? [y/n] (y):
http_proxy ():
https_proxy ():
no_proxy ():
Note that proxy settings can also be supplied by using a manifest (see Deployment manifest).

When prompted, enter the CIDR and the address range for the control plane networking. Here we use the values given earlier:

Management network (172.16.1.0/24):
OpenStack APIs IP ranges (172.16.1.201-172.16.1.240): 172.16.1.201-172.16.1.220

## Configure the cloud and obtain credentials

Now configure the deployed cloud using the configure command:

```bash
sunbeam configure --openrc demo-openrc
# VMs will be accessible only from the local host or only from remote hosts. For remote, you must specify the network interface dedicated to VM access traffic. The intended remote hosts 
# must have connectivity to this interface.

172.24.188.57/23
gw:172.24.189.254
8.8.8.8 8.8.4.4
```

The --openrc option specifies a regular user (non-admin) cloud init file (demo-openrc here).

A series of questions will now be asked. Below is the output of an entire interactive session on research21. The values in square brackets, when present, provide acceptable values. A value in parentheses is the default value. Here we use the values given earlier:

```bash
sunbeam configure --openrc demo-openrc    

VMs will be accessible only from the local host or only from remote hosts. For remote, you must specify the network interface dedicated to VM access traffic. The intended remote hosts 
must have connectivity to this interface.
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
You can start using the OpenStack client or access the OpenStack dashboard at http://172.16.1.204:80/openstack-horizon

```

## Launch a VM

Verify the cloud by launching a VM called ‘test’ based on the ‘ubuntu’ image (Ubuntu 22.04 LTS). The launch command is used:

```bash
sunbeam launch ubuntu --name test
```

Sample output:

```bash
Launching an OpenStack instance ... 
Access the instance by running the following command:
`ssh -i /home/brent/snap/openstack/727/sunbeam ubuntu@172.16.2.76`

```

Connect to the VM over SSH. If remote VM access has been enabled, you will need the private SSH key given in the above output from the launching node. Copy it to the connecting host. Note that the VM will not be ready instantaneously; waiting time is mostly determined by the cloud’s available resources.

## Related how-tos

Now that OpenStack is set up, be sure to check out the following howto guides:

- **[Accessing the OpenStack dashboard](https://canonical.com/microstack/docs/dashboard)**
- **[Using the OpenStack CLI](https://canonical.com/microstack/docs/cli)**

<https://discourse.ubuntu.com/t/single-node-guide/35765>
