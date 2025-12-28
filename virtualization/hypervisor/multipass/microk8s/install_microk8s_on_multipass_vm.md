# **[Installing MicroK8s with multipass](https://microk8s.io/docs/install-multipass)**

**[Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Research List](../../../../research_list.md)**\
**[Back Main](../../../../../README.md)**

## references

- **[How to Bridge Two Network Interfaces in Linux Using Netplan](https://www.tecmint.com/netplan-bridge-network-interfaces/)**
- **[bridge commands](https://developers.redhat.com/articles/2022/04/06/introduction-linux-bridging-commands-and-features#spanning_tree_protocol)
- **[Create an instance with multiple network interfaces](https://multipass.run/docs/create-an-instance#heading--create-an-instance-with-multiple-network-interfaces)**

## Note

This process assumes you are using Ubuntu 24.04 server or OS that is using networkd or an OS which is setup with NetworkMangager but is completely integrated with Netplan 1.0 such as I think Ubuntu 24.04 desktop. It also assumes microk8s is installed on a Ubuntu 22.04 vm.

## **[Install multipass](../multipass_install.md)**

Multipass is the fastest way to create a complete Ubuntu virtual machine on Linux, Windows or macOS, and it’s a great base for using MicroK8s.

## **[Create a Bridge](../create_bridges_with_netplan.md)**

```yaml
# This file is generated from information provided by the datasource.  Changes
# to it will not persist across an instance reboot.  To disable cloud-init's
# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    ethernets:
        eno1:
            addresses:
            - 10.1.0.125/22
            nameservers:
                addresses:
                - 10.1.2.69
                - 10.1.2.70
                - 172.20.0.39
                search: [BUSCHE-CNC.COM]
            routes:
            -   to: default
                via: 10.1.1.205
        eno2:
            dhcp4: no
        eno3:
            dhcp4: true
        eno4:
            dhcp4: true
        enp66s0f0:
            dhcp4: true
        enp66s0f1:
            dhcp4: true
        enp66s0f2:
            dhcp4: true
        enp66s0f3:
            dhcp4: true
    bridges:
        br0:
            dhcp4: no
            addresses:
            - 10.1.0.126/22
            nameservers:
                addresses:
                - 10.1.2.69
                - 10.1.2.70
                - 172.20.0.39
                search: [BUSCHE-CNC.COM]
            interfaces: [eno2]
        br1:
            dhcp4: no
            addresses:
            - 10.13.31.1/24
    version: 2
```

Show bridge details in a pretty JSON format (which is a good way to get bridge key-value pairs):

```bash
# ip -j -p -d link show br0
ip -j -p -d link show br0

# show tap devices and master bridges
bridge link show
# bridge link show master br0
7: eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 5 
13: tap434bfb4d: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master mpbr0 state forwarding priority 32 cost 2 
14: tap34dcb760: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 2 
15: tap7a27ad4e: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master mpbr0 state forwarding priority 32 cost 2 
16: tapf48799c9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br1 state forwarding priority 32 cost 2
```

## Create an instance with a specific image

To find out what images are available, run:

```bash
multipass find
Image                       Aliases           Version          Description
core                        core16            20200818         Ubuntu Core 16
core18                                        20211124         Ubuntu Core 18
core20                                        20230119         Ubuntu Core 20
core22                                        20230717         Ubuntu Core 22
20.04                       focal             20240612         Ubuntu 20.04 LTS
22.04                       jammy             20240626         Ubuntu 22.04 LTS
23.10                       mantic            20240619         Ubuntu 23.10
24.04                       noble,lts         20240622         Ubuntu 24.04 LTS
```

## Launch VM with extra network interface

The full multipass help launch output explains the available options:

```bash
$  multipass help launch
Usage: multipass launch [options] [[<remote:>]<image> | <url>]
```

## **[Notes launch command](https://multipass.run/docs/launch-command)**

```bash
--network <spec>                      Add a network interface to the
                                        instance, where <spec> is in the
                                        "key=value,key=value" format, with the
                                        following keys available:
                                         name: the network to connect to
                                        (required), use the networks command for
                                        a list of possible values, or use
                                        'bridged' to use the interface
                                        configured via `multipass set
                                        local.bridged-network`.
                                         mode: auto|manual (default: auto)
                                         mac: hardware address (default:
                                        random).
                                        You can also use a shortcut of "<name>"
                                        to mean "name=<name>".
```

With multipass installed, you can now create a VM to run MicroK8s. At least 4 Gigabytes of RAM and 40G of storage is recommended – we can pass these
requirements when we launch the VM:

```bash
# can't get manual mode in which you pass the hardware address to work
# multipass launch --name test3 --network name=mybr,mode=manual,mac="7f:71:f0:b2:55:dd"

multipass launch --network br0 --name microk8s-vm --memory 4G --disk 40G 22.04
# Add memory if going to run only sql server
multipass launch --network br0 --name microk8s-vm --memory 8G --disk 80G 22.04

multipass list
Name                    State             IPv4             Image
microk8s-vm             Running           10.127.233.194   Ubuntu 24.04 LTS
                                          10.1.2.143
test1                   Running           10.127.233.173   Ubuntu 24.04 LTS
                                          10.1.0.128
test2                   Running           10.127.233.24    Ubuntu 24.04 LTS
                                          10.13.31.201

```

Use the ip utility to display the link status of Ethernet devices that are ports of a specific bridge:

```bash
ip link show master br0
7: eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br0 state UP mode DEFAULT group default qlen 1000
    link/ether b8:ca:3a:6a:37:19 brd ff:ff:ff:ff:ff:ff
    altname enp1s0f1
14: tap34dcb760: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br0 state UP mode DEFAULT group default qlen 1000
    link/ether 5a:8a:38:e5:66:f1 brd ff:ff:ff:ff:ff:ff
18: tap38ceeb39: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br0 state UP mode DEFAULT group default qlen 1000
    link/ether ce:80:f5:53:04:fb brd ff:ff:ff:ff:ff:ff

```

## retrieve the hardware address

See how multipass configured the network. Until I can figure out how to pass the hardware address manaully during launch we will have to grab the one multipass or lxd creates.

```bash
multipass exec -n microk8s-vm -- sudo networkctl -a status
# skip multipass default network interface
...
enp6s0
                   Link File: /usr/lib/systemd/network/99-default.link
                Network File: /run/systemd/network/10-netplan-extra0.network
                       State: routable (configured)
                Online state: online                                         
                        Type: ether
                        Path: pci-0000:06:00.0
                      Driver: virtio_net
                      Vendor: Red Hat, Inc.
                       Model: Virtio 1.0 network device
            Hardware Address: 52:54:00:6e:60:8a
                         MTU: 1500 (min: 68, max: 65535)
                       QDisc: mq
IPv6 Address Generation Mode: eui64
    Number of Queues (Tx/Rx): 2/2
            Auto negotiation: no
                     Address: 10.1.2.143 (DHCP4 via 10.1.2.69)
                              fe80::5054:ff:fe6e:608a
                     Gateway: 10.1.1.205
                         DNS: 10.1.2.69
                              10.1.2.70
                              172.20.0.39
              Search Domains: BUSCHE-CNC.COM
           Activation Policy: up
         Required For Online: yes
             DHCP4 Client ID: IAID:0x24721ac8/DUID
           DHCP6 Client DUID: DUID-EN/Vendor:0000ab11345612d63ead6a74

Jun 25 22:43:01 microk8s-vm systemd-networkd[730]: enp6s0: Configuring with /run/systemd/network/10-netplan-extra0.network.
Jun 25 22:43:01 microk8s-vm systemd-networkd[730]: enp6s0: Link UP
Jun 25 22:43:01 microk8s-vm systemd-networkd[730]: enp6s0: Gained carrier
Jun 25 22:43:01 microk8s-vm systemd-networkd[730]: enp6s0: DHCPv4 address 10.1.2.143/22, gateway 10.1.1.205 acquired from 10.1.2.69
Jun 25 22:43:02 microk8s-vm systemd-networkd[730]: enp6s0: Gained IPv6LL
```

## Step 3: Configure the extra interface

We now need to configure the manual network interface inside the instance. We can achieve that using Netplan. The following command plants the required Netplan configuration file in the instance:

```bash
multipass exec -n microk8s-vm -- sudo bash -c 'cat /etc/netplan/50-cloud-init.yaml'
# This file is generated from information provided by the datasource.  Changes
# to it will not persist across an instance reboot.  To disable cloud-init's
# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    ethernets:
        default:
            dhcp4: true
            match:
                macaddress: 52:54:00:b7:ef:90
        extra0:
            dhcp4: true
            dhcp4-overrides:
                route-metric: 200
            match:
                macaddress: 52:54:00:a6:3d:3e
            optional: true
    version: 2

multipass exec -n microk8s-vm -- sudo bash -c 'cat << EOF > /etc/netplan/50-cloud-init.yaml
network:
    ethernets:
        default:
            dhcp4: true
            match:
                macaddress: 52:54:00:b7:ef:90
        extra0:
            addresses:
            - 10.1.0.129/22
            nameservers:
                addresses:
                - 10.1.2.69
                - 10.1.2.70
                - 172.20.0.39
                search: [BUSCHE-CNC.COM]
            match:
                macaddress: 52:54:00:a6:3d:3e
            optional: true
    version: 2
EOF'

# verify yaml

multipass exec -n microk8s-vm -- sudo bash -c 'cat /etc/netplan/50-cloud-init.yaml'
network:
    ethernets:
        default:
            dhcp4: true
            match:
                macaddress: 52:54:00:b7:ef:90
        extra0:
            addresses:
            - 10.1.0.129/22
            nameservers:
                addresses:
                - 10.1.2.69
                - 10.1.2.70
                - 172.20.0.39
                search: [BUSCHE-CNC.COM]
            match:
                macaddress: 52:54:00:a6:3d:3e
            optional: true
    version: 2

# if all looks good apply network changes
multipass exec -n microk8s-vm -- sudo netplan apply
WARNING:root:Cannot call Open vSwitch: ovsdb-server.service is not running.
# https://stackoverflow.com/questions/77352932/ovsdb-server-service-from-no-where
# If the package isn't installed, there's no reason to warn that a non-existent service can't be restarted.
# You can also install the Open vSwitch package, even if you're not planning to use it:

#      apt-get install openvswitch-switch

# The spurious warning message problem goes away. Not elegant, but it works.


# check network interfaces with networkd cli
multipass exec -n microk8s-vm -- sudo networkctl -a status
# skip multipass default network interfaces
...
 ● 3: enp6s0                                                                    
                     Link File: /usr/lib/systemd/network/99-default.link
                  Network File: /run/systemd/network/10-netplan-extra0.network
                          Type: ether
                         State: routable (configured)
                  Online state: unknown
                          Path: pci-0000:06:00.0
                        Driver: virtio_net
                        Vendor: Red Hat, Inc.
                         Model: Virtio network device
                    HW Address: 52:54:00:a6:3d:3e
                           MTU: 1500 (min: 68, max: 65535)
                         QDisc: mq
  IPv6 Address Generation Mode: eui64
          Queue Length (Tx/Rx): 2/2
              Auto negotiation: no
                         Speed: n/a
                       Address: 10.1.0.129
                                fe80::5054:ff:fea6:3d3e
                           DNS: 10.1.2.69
                                10.1.2.70
                                172.20.0.39
                Search Domains: BUSCHE-CNC.COM
             Activation Policy: up
           Required For Online: no
             DHCP6 Client DUID: DUID-EN/Vendor:0000ab11cd86ad425e510a3f0000

Jun 26 21:41:57 microk8s-vm systemd-networkd[625]: enp6s0: Link UP
Jun 26 21:41:57 microk8s-vm systemd-networkd[625]: enp6s0: Gained carrier
Jun 26 21:41:57 microk8s-vm systemd-networkd[625]: enp6s0: DHCPv4 address 10.1.3.159/22 via 10.1.1.205
Jun 26 21:41:59 microk8s-vm systemd-networkd[625]: enp6s0: Gained IPv6LL
Jun 26 21:50:34 microk8s-vm systemd-networkd[625]: enp6s0: Re-configuring with /run/systemd/network/10-netplan-extra0.network
Jun 26 21:50:34 microk8s-vm systemd-networkd[625]: enp6s0: DHCP lease lost
Jun 26 21:50:34 microk8s-vm systemd-networkd[625]: enp6s0: DHCPv6 lease lost
Jun 26 21:50:34 microk8s-vm systemd-networkd[625]: enp6s0: Re-configuring with /run/systemd/network/10-netplan-extra0.network
Jun 26 21:50:34 microk8s-vm systemd-networkd[625]: enp6s0: DHCPv6 lease lost

```

## Step 5: Confirm that it works

You can confirm that the new IP is present in the instance with Multipass:

```bash
multipass info microk8s-vm
Name:           microk8s-vm
State:          Running
IPv4:           10.127.233.200
                10.1.0.129
Release:        Ubuntu 22.04.4 LTS
Image hash:     2a9392698c8e (Ubuntu 22.04 LTS)
CPU(s):         1
Load:           0.00 0.00 0.00
Disk usage:     1.6GiB out of 77.5GiB
Memory usage:   247.8MiB out of 7.7GiB
Mounts:         --

```

You can use ping to confirm that it can be reached from another host on lan:

```bash
ping -c 1 -n 10.1.0.129
PING 10.1.0.129 (10.1.0.129) 56(84) bytes of data.
64 bytes from 10.1.0.129: icmp_seq=1 ttl=64 time=1.31 ms

--- 10.1.0.129 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 1.309/1.309/1.309/0.000 ms
```

Confirm VM can ping lan and wan

```bash
multipass exec -n microk8s-vm -- ping -c 1 -n 10.1.0.113
PING 10.1.0.113 (10.1.0.113) 56(84) bytes of data.
64 bytes from 10.1.0.113: icmp_seq=1 ttl=64 time=0.560 ms

--- 10.1.0.113 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.560/0.560/0.560/0.000 ms

multipass exec -n microk8s-vm -- ping -c 1 -n google.com
PING google.com (142.250.191.238) 56(84) bytes of data.
64 bytes from 142.250.191.238: icmp_seq=1 ttl=57 time=9.04 ms

--- google.com ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 9.039/9.039/9.039/0.000 ms

```

## **[install microk8s](https://microk8s.io/docs/install-multipass)**

We can now find the static IP address which has been allocated. Running:

```bash
multipass list
Name                    State             IPv4             Image
microk8s-vm             Running           10.127.233.194   Ubuntu 24.04 LTS
                                          10.1.0.129
test1                   Running           10.127.233.173   Ubuntu 24.04 LTS
                                          10.1.0.128
test2                   Running           10.127.233.24    Ubuntu 24.04 LTS
                                          10.13.31.201
```

Take a note of this IP as services will become available there when accessed
from the host machine.

To work within the VM environment more easily, you can run a shell:

```bash
multipass shell microk8s-vm
```

Then install the MicroK8s snap and configure the network:
<https://microk8s.io/docs/getting-started>

```bash
sudo snap install microk8s --classic --channel=1.30/stable
sudo iptables -P FORWARD ACCEPT
The iptables command is necessary to permit traffic between the VM and host.
sudo iptables -S
# Warning: iptables-legacy tables present, use iptables-legacy to see them
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
-A FORWARD -s 10.1.0.0/16 -m comment --comment "generated for MicroK8s pods" -j ACCEPT
-A FORWARD -d 10.1.0.0/16 -m comment --comment "generated for MicroK8s pods" -j ACCEPT

```

## Join the microk8s group

MicroK8s creates a group to enable seamless usage of commands which require admin privilege. To add your current user to the group and gain access to the .kube caching directory, run the following two commands:

```bash
sudo usermod -a -G microk8s $USER
mkdir ~/.kube
sudo chown -f -R $USER ~/.kube
# You will also need to re-enter the session for the group update to take place:
su - $USER
-or-
sudo usermod -a -G microk8s $USER  
sudo chown -f -R $USER ~/.kube  
newgrp microk8s  
sudo reboot  
```

## Check each node for necessary changes

```bash
microk8s inspect
Inspecting system
Inspecting Certificates
Inspecting services
  Service snap.microk8s.daemon-cluster-agent is running
  Service snap.microk8s.daemon-containerd is running
  Service snap.microk8s.daemon-kubelite is running
  Service snap.microk8s.daemon-k8s-dqlite is running
  Service snap.microk8s.daemon-apiserver-kicker is running
  Copy service arguments to the final report tarball
Inspecting AppArmor configuration
Gathering system information
  Copy processes list to the final report tarball
  Copy disk usage information to the final report tarball
  Copy memory usage information to the final report tarball
  Copy server uptime to the final report tarball
  Copy openSSL information to the final report tarball
  Copy snap list to the final report tarball
  Copy VM name (or none) to the final report tarball
  Copy current linux distribution to the final report tarball
  Copy asnycio usage and limits to the final report tarball
  Copy inotify max_user_instances and max_user_watches to the final report tarball
  Copy network configuration to the final report tarball
Inspecting kubernetes cluster
  Inspect kubernetes cluster
Inspecting dqlite
  Inspect dqlite
cp: cannot stat '/var/snap/microk8s/6876/var/kubernetes/backend/localnode.yaml': No such file or directory

Building the report tarball
  Report tarball is at /var/snap/microk8s/6876/inspection-report-20240626_220925.tar.gz


# Do what inspect tells you to do.

```

## perform status check

```bash
microk8s status
microk8s is running
high-availability: no
  datastore master nodes: 127.0.0.1:19001
  datastore standby nodes: none
addons:
  enabled:
    dns                  # (core) CoreDNS
    ha-cluster           # (core) Configure high availability on the current node
    helm                 # (core) Helm - the package manager for Kubernetes
    helm3                # (core) Helm 3 - the package manager for Kubernetes
  disabled:
    cert-manager         # (core) Cloud native certificate management
    cis-hardening        # (core) Apply CIS K8s hardening
    community            # (core) The community addons repository
    dashboard            # (core) The Kubernetes dashboard
    gpu                  # (core) Alias to nvidia add-on
    host-access          # (core) Allow Pods connecting to Host services smoothly
    hostpath-storage     # (core) Storage class; allocates storage from host directory
    ingress              # (core) Ingress controller for external access
    kube-ovn             # (core) An advanced network fabric for Kubernetes
    mayastor             # (core) OpenEBS MayaStor
    metallb              # (core) Loadbalancer for your Kubernetes cluster
    metrics-server       # (core) K8s Metrics Server for API access to service metrics
    minio                # (core) MinIO object storage
    nvidia               # (core) NVIDIA hardware (GPU and network) support
    observability        # (core) A lightweight observability stack for logs, traces and metrics
    prometheus           # (core) Prometheus operator for monitoring and logging
    rbac                 # (core) Role-Based Access Control for authorisation
    registry             # (core) Private image registry exposed on localhost:32000
    rook-ceph            # (core) Distributed Ceph storage using Rook
    storage              # (core) Alias to hostpath-storage add-on, deprecated
```

## Enable RBAC

```bash
microk8s enable rbac
Infer repository core for addon rbac
Enabling RBAC
Reconfiguring apiserver
Restarting apiserver
RBAC is enabledm

```

## install kubectl

```bash
sudo snap install kubectl  --classic
cd ~
cd .kube
microk8s config > repsys11_sql_server.yaml
cat repsys11_sql_server.yaml
cp repsys11_sql_server.yaml ~/.kube/config

```

## add to config files

```bash
multipass shell microk8s-vm
cat repsys11_sql_server.yaml
# copy and paste
cd ~/src/k8s/all-config-files
touch repsys11_sql_server.yaml
# copy and paste config file and replace the server ip with the static one from the bridged network interface.
nvim repsys11_sql_server.yaml

# scc.sh repsys11_sql_server.yaml microk8s

```

## **[create a debug pod](https://medium.com/@shambhand2020/create-the-various-debug-or-test-pod-inside-kubernetes-cluster-e4862c767b96)**

```bash
kubectl run -it --tty --rm debug --image=alpine --restart=Never -- sh
If you don't see a command prompt, try pressing enter.
/ # exit
pod "debug" deleted
```
