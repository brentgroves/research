# **[Setup Multipass VM](https://canonical.com/multipass/docs/configure-static-ips)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

Multipass is the fastest way to create a complete Ubuntu virtual machine on Linux, Windows or macOS, and it’s a great base for using MicroK8s.

## Step 1: **[Setup up host network](./setup_host_network.md)**

## Step 2: **[Install Multipass](./multipass_install.md)**

You can also run multipass networks to confirm the bridge is available for Multipass to connect to.

```bash
multipass networks
Name        Type       Description
br0         bridge     Network bridge with eno1
br1         bridge     Network bridge
eno1        ethernet   Ethernet device
eno2        ethernet   Ethernet device
eno3        ethernet   Ethernet device
eno4        ethernet   Ethernet device
enp66s0f0   ethernet   Ethernet device
enp66s0f1   ethernet   Ethernet device
enp66s0f2   ethernet   Ethernet device
enp66s0f3   ethernet   Ethernet device
mpqemubr0   bridge     Network bridge
```

## Step 3: Create an instance with a specific image

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

## Step 3: Decide how much ram and vcpu to use

```bash
lscpu
Architecture:             x86_64
  CPU op-mode(s):         32-bit, 64-bit
  Address sizes:          46 bits physical, 48 bits virtual
  Byte Order:             Little Endian
CPU(s):                   32
  On-line CPU(s) list:    0-31
Vendor ID:                GenuineIntel
  Model name:             Intel(R) Xeon(R) CPU E5-2650 0 @ 2.00GHz
    CPU family:           6
    Model:                45
    Thread(s) per core:   2
    Core(s) per socket:   8
    Socket(s):            2
    Stepping:             7
    CPU(s) scaling MHz:   45%
    CPU max MHz:          2800.0000
    CPU min MHz:          1200.0000
    BogoMIPS:             4000.10
    Flags:                fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon peb
                          s bts rep_good nopl xtopology nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid dca sse4_1 sse4_2 x2apic popcnt tsc_deadl
                          ine_timer aes xsave avx lahf_lm pti ssbd ibrs ibpb stibp tpr_shadow flexpriority ept vpid xsaveopt dtherm ida arat pln pts vnmi md_clear flush_l1d
Virtualization features:  
  Virtualization:         VT-x
Caches (sum of all):      
  L1d:                    512 KiB (16 instances)
  L1i:                    512 KiB (16 instances)
  L2:                     4 MiB (16 instances)
  L3:                     40 MiB (2 instances)
NUMA:                     
  NUMA node(s):           2
  NUMA node0 CPU(s):      0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30
  NUMA node1 CPU(s):      1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31
Vulnerabilities:          
  Gather data sampling:   Not affected
  Itlb multihit:          KVM: Mitigation: Split huge pages
  L1tf:                   Mitigation; PTE Inversion; VMX conditional cache flushes, SMT vulnerable
  Mds:                    Mitigation; Clear CPU buffers; SMT vulnerable
  Meltdown:               Mitigation; PTI
  Mmio stale data:        Unknown: No mitigations
  Reg file data sampling: Not affected
  Retbleed:               Not affected
  Spec rstack overflow:   Not affected
  Spec store bypass:      Mitigation; Speculative Store Bypass disabled via prctl
  Spectre v1:             Mitigation; usercopy/swapgs barriers and __user pointer sanitization
  Spectre v2:             Mitigation; Retpolines; IBPB conditional; IBRS_FW; STIBP conditional; RSB filling; PBRSB-eIBRS Not affected; BHI Not affected
  Srbds:                  Not affected
  Tsx async abort:        Not affected
```

## Step 3: **[remove an instance](./remove_instance.md)**

## Step 3: Launch VM with extra network interfaces

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

### Step 3: Launch an instance

<!-- You can also leave the MAC address unspecified (just --network name=localbr,mode=manual). If you do so, Multipass will generate a random MAC for you, but you will need to retrieve it in the next step. -->

```bash

# k8s211 machine 2, cluster 1, node 1
multipass launch --network br0 --network br1 --name k8sn211 --cpus 2 --memory 32G --disk 250G 

# errors need to add another config request

[2025-03-05T20:29:05.138] [error] [url downloader] Failed to get https://codeload.github.com/canonical/multipass-blueprints/zip/refs/heads/main: Error opening https://codeload.github.com/canonical/multipass-blueprints/zip/refs/heads/main
[2025-03-05T20:29:05.139] [error] [blueprint provider] Error fetching Blueprints: failed to download from 'https://codeload.github.com/canonical/multipass-blueprints/zip/refs/heads/main': Error opening https://codeload.github.com/canonical/multipass-blueprints/zip/refs/heads/main

multipass info k8sn211
Name:           k8sn211
State:          Running
Snapshots:      0
IPv4:           10.97.219.76
Release:        Ubuntu 24.04.2 LTS
Image hash:     a3aea891c930 (Ubuntu 24.04 LTS)
CPU(s):         2
Load:           0.07 0.23 0.11
Disk usage:     1.9GiB out of 242.1GiB
Memory usage:   625.7MiB out of 31.3GiB
Mounts:         --
```

## Step 3: Use the ip utility to display the link status of devices in br0 and br1

```bash
# Bridge 0
ip link show master br0
5: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br0 state UP mode DEFAULT group default qlen 1000
    link/ether b8:ca:3a:6a:38:7c brd ff:ff:ff:ff:ff:ff
    altname enp1s0f0
14: tap0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel master br0 state UNKNOWN mode DEFAULT group default qlen 1000
    link/ether fe:21:f6:5e:ec:63 brd ff:ff:ff:ff:ff:ff
# Bridge 1
ip link show master br1
10: vlan220@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br1 state UP mode DEFAULT group default qlen 1000
    link/ether b8:ca:3a:6a:38:7c brd ff:ff:ff:ff:ff:ff
18: tap1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel master br1 state UNKNOWN mode DEFAULT group default qlen 1000
    link/ether fe:1a:e4:66:7b:3a brd ff:ff:ff:ff:ff:ff    
```

## Step 4: Configure the extra interfaces

### retrieve the hardware address

See how multipass configured the network. Until I can figure out how to pass the hardware address manaully during launch we will have to grab the one multipass or lxd creates.

```bash

multipass exec -n k8sn211 -- sudo cat /etc/netplan/50-cloud-init.yaml
network:
  version: 2
  ethernets:
    default:
      match:
        macaddress: "52:54:00:4a:f4:2e"
      dhcp-identifier: "mac"
      dhcp4: true
    extra0:
      match:
        macaddress: "52:54:00:34:6f:ca"
      optional: true
      dhcp-identifier: "mac"
      dhcp4: true
      dhcp4-overrides:
        route-metric: 200
    extra1:
      match:
        macaddress: "52:54:00:46:3b:fd"
      optional: true
      dhcp-identifier: "mac"
      dhcp4: true
      dhcp4-overrides:
        route-metric: 200
```

### Step 4: update netplan with static IPs and routes

**[netplan directory](./netplan/)**

```bash

# Make sure the mac address remains the same

multipass exec -n k8sn211 -- sudo bash -c 'cat << EOF > /etc/netplan/50-cloud-init.yaml
network:
  version: 2
  ethernets:
    default:
      match:
        macaddress: "52:54:00:4a:f4:2e"
      dhcp-identifier: "mac"
      dhcp4: true
    extra0:
      match:
        macaddress: "52:54:00:34:6f:ca"
      optional: true
      dhcp4: false
      dhcp6: false
      addresses:
      - 10.188.50.214/24
      nameservers:
         addresses:
         - 10.225.50.203
         - 10.224.50.203
      routes:
      - to: 10.188.40.0/24
        via: 10.188.50.254
      - to: 10.188.42.0/24
        via: 10.188.50.254
      - to: 10.184.40.0/24
        via: 10.188.50.254
      - to: 10.184.42.0/24
        via: 10.188.50.254
      - to: 10.181.40.0/24
        via: 10.188.50.254
      - to: 10.181.42.0/24
        via: 10.188.50.254
      - to: 10.185.40.0/24
        via: 10.188.50.254
      - to: 10.185.42.0/24
        via: 10.188.50.254
      - to: 10.187.40.0/24
        via: 10.188.50.254
      - to: 10.187.42.0/24
        via: 10.188.50.254
      - to: 10.189.40.0/24
        via: 10.188.50.254
      - to: 10.189.42.0/24
        via: 10.188.50.254
      - to: 172.20.88.0/24
        via: 10.188.50.254
    extra1:
      match:
        macaddress: "52:54:00:46:3b:fd"
      optional: true
      dhcp4: false
      dhcp6: false
      addresses:
      - 10.188.220.214/24
      nameservers:
         addresses:
         - 10.225.50.203
         - 10.224.50.203
      routes:
      - to: 10.188.73.0/24
        via: 10.188.220.254
EOF'

# verify yaml

multipass exec -n k8sn211 -- sudo cat /etc/netplan/50-cloud-init.yaml
network:
  version: 2
  ethernets:
    default:
      match:
        macaddress: "52:54:00:4a:f4:2e"
      dhcp-identifier: "mac"
      dhcp4: true
    extra0:
      match:
        macaddress: "52:54:00:34:6f:ca"
      optional: true
      dhcp4: false
      dhcp6: false
      addresses:
      - 10.188.50.214/24
      nameservers:
         addresses:
         - 10.225.50.203
         - 10.224.50.203
      routes:
      - to: 10.188.40.0/24
        via: 10.188.50.254
      - to: 10.188.42.0/24
        via: 10.188.50.254
      - to: 172.20.88.0/24
        via: 10.188.50.254
    extra1:
      match:
        macaddress: "52:54:00:46:3b:fd"
      optional: true
      dhcp4: false
      dhcp6: false
      addresses:
      - 10.188.220.214/24
      nameservers:
         addresses:
         - 10.225.50.203
         - 10.224.50.203
      routes:
      - to: 10.188.73.0/24
        via: 10.188.220.254
```

if all looks good apply network changes

```bash
multipass exec -n k8sn211 -- sudo netplan apply
```

## Step 4: Confirm IPs have been added

You can confirm that the new IP is present in the instance with Multipass:

```bash

multipass info k8sn211
Name:           k8sn211
State:          Running
Snapshots:      0
IPv4:           10.97.219.76
                10.188.50.214
                10.188.220.214
Release:        Ubuntu 24.04.2 LTS
Image hash:     a3aea891c930 (Ubuntu 24.04 LTS)
CPU(s):         2
Load:           0.01 0.00 0.00
Disk usage:     1.9GiB out of 242.1GiB
Memory usage:   580.1MiB out of 31.3GiB
Mounts:         --
```

## Step 5: Show vm routing table

```bash
ssh brent@10.188.50.202
multipass shell k8sn211
ip route
default via 10.97.219.1 dev ens3 proto dhcp src 10.97.219.76 metric 100 
10.97.219.0/24 dev ens3 proto kernel scope link src 10.97.219.76 metric 100 
10.97.219.1 dev ens3 proto dhcp scope link src 10.97.219.76 metric 100 
10.181.40.0/24 via 10.188.50.254 dev ens4 proto static 
10.181.42.0/24 via 10.188.50.254 dev ens4 proto static 
10.184.40.0/24 via 10.188.50.254 dev ens4 proto static 
10.184.42.0/24 via 10.188.50.254 dev ens4 proto static 
10.185.40.0/24 via 10.188.50.254 dev ens4 proto static 
10.185.42.0/24 via 10.188.50.254 dev ens4 proto static 
10.187.40.0/24 via 10.188.50.254 dev ens4 proto static 
10.187.42.0/24 via 10.188.50.254 dev ens4 proto static 
10.188.40.0/24 via 10.188.50.254 dev ens4 proto static 
10.188.42.0/24 via 10.188.50.254 dev ens4 proto static 
10.188.50.0/24 dev ens4 proto kernel scope link src 10.188.50.214 
10.188.73.0/24 via 10.188.220.254 dev ens5 proto static 
10.188.220.0/24 dev ens5 proto kernel scope link src 10.188.220.214 
10.189.40.0/24 via 10.188.50.254 dev ens4 proto static 
10.189.42.0/24 via 10.188.50.254 dev ens4 proto static 
172.20.88.0/24 via 10.188.50.254 dev ens4 proto static 
```

## Step 5: verify the VM can access routable networks

```yaml
frt: 10.184
mus: 10.181
sou: 10.185
alb1: 10.187
avi: 10.188
alb2: 10.189
```

```bash
ssh brent@10.188.50.202
multipass shell k8sn211
ping 10.188.50.79
ping 10.188.220.50
ping 10.188.73.11
ping 10.188.40.230
ping 10.188.42.11
ping 172.20.88.64
ping 10.185.50.11
ping 10.181.50.15
ping 10.187.40.15
# FW rules
curl https://api.snapcraft.io
snapcraft.io store API service - Copyright 2018-2022 Canonical.
# Test snap
sudo snap install hello-world
```

## Step 5: Verify access from routable networks to the each host IP

```yaml
frt: 10.184
mus: 10.181
sou: 10.185
alb1: 10.187
avi: 10.188
alb2: 10.189
```

### Step 5: Repeat for every network that has access to the VM

```bash
ssh brent@10.188.40.230
ping 10.188.50.214
ping 10.188.220.214
```

## Step 6: **[Enable ssh to VM](./ssh_into_mutipass_vms.md)**

## Step 6: **[Set multipass ubuntu password](https://askubuntu.com/questions/1230753/login-and-password-for-multipass-instance)**

In multipass instance, set a password to ubuntu user. Needed to ftp from dev system. Multipass has transfer command but only works from the host.

```bash
ssh ubuntu@10.188.50.214
sudo passwd ubuntu
```

## Step 7: **[Install Ubuntu Server software](../../../../../linux/ubuntu24_04/server-install.md)**
