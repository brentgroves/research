# Linamar Network Questions

## Can we access internet domains

Issue: Can't install snaps
Fix: Added more domains to trust using <https://snapcraft.io/docs/network-requirements>

AI results

If you can't install Snap Store apps, the most likely reasons are: missing or outdated "snapd" package (the Snap daemon), incorrect system permissions, network issues preventing access to the Snap Store, or a problem with your specific Linux distribution's Snap integration; you should check if the "snapd" service is running properly, verify your internet connection, and if necessary, manually install or update "snapd" using your system's package manager.

### Troubleshooting steps

Check Snapd installation:
Open a terminal and run snap --version. If it shows an error, you need to install "snapd" using your distribution's package manager.
To update "snapd": sudo snap install snapd --classic

```bash
sudo systemctl status snapd
# cant install snapstore apps
snap --version
snap    2.67
snapd   2.67
series  16
ubuntu  24.04
kernel  6.8.0-54-generic
```

## Verify system permissions

Ensure you have sufficient user privileges to install snaps.

If necessary, use sudo before the "snap" command.

```bash
sudo snap install curl
Download snap "curl" (2283) from channel "stable"    
# does not work

which multipass
/snap/bin/multipass
```

### Check network connectivity

Make sure you have a stable internet connection to access the Snap Store.

### Generate debug info

One of the best ways to solve an issue is to understand when and where the error is encountered, and there are several levels of output that can be generated.

The snap changes and snap tasks <change-id> commands, for example, output details about what changed during the last refresh:

```bash
snap changes
snap changes
ID   Status  Spawn               Ready               Summary
5    Done    today at 17:21 UTC  today at 17:33 UTC  Auto-refresh snaps "core24", "multipass"
6    Error   today at 20:11 UTC  today at 20:14 UTC  Install "htop" snap
7    Error   today at 20:22 UTC  today at 20:24 UTC  Install "curl" snap
```

The snap daemon documents its operations to the system log. This can be retrieved and viewed with the following command:

```bash
sudo journalctl --no-pager -u snapd
sudo journalctl --no-pager -u snapd
Jan 27 23:36:19 k8shv1 systemd[1]: Starting snapd.service - Snap Daemon...
Jan 27 23:36:20 k8shv1 snapd[1345]: overlord.go:271: Acquiring state lock file
Jan 27 23:36:20 k8shv1 snapd[1345]: overlord.go:276: Acquired state lock file
Jan 27 23:36:20 k8shv1 snapd[1345]: daemon.go:247: started snapd/2.63.1+24.04 (series 16; classic) ubuntu/24.04 (amd64) linux/6.8.0-41-generic.
Jan 27 23:36:20 k8shv1 snapd[1345]: daemon.go:340: adjusting startup timeout by 30s (pessimistic estimate of 30s plus 5s per snap)
Jan 27 23:36:20 k8shv1 snapd[1345]: backends.go:58: AppArmor status: apparmor is enabled and all features are available
Jan 27 23:36:20 k8shv1 snapd[1345]: helpers.go:150: error trying to compare the snap system key: system-key missing on disk
Jan 27 23:36:20 k8shv1 systemd[1]: Started snapd.service - Snap Daemon.
Jan 27 23:36:52 k8shv1 snapd[1345]: stateengine.go:149: state ensure error: Get "https://api.snapcraft.io/api/v1/snaps/sections": dial tcp: lookup api.snapcraft.io on 127.0.0.53:53: server misbehaving
Jan 27 23:36:55 k8shv1 snapd[1345]: daemon.go:519: gracefully waiting for running hooks
Jan 27 23:36:55 k8shv1 snapd[1345]: daemon.go:521: done waiting for running hooks
Jan 27 23:36:58 k8shv1 snapd[1345]: overlord.go:515: Released state lock file
Jan 27 23:36:58 k8shv1 snapd[1345]: daemon stop requested to wait for socket activation
Jan 27 23:36:58 k8shv1 systemd[1]: snapd.service: Deactivated successfully.
-- Boot b9edfa6a9b5543068aa3cba4958b8d4e --
Jan 27 23:53:03 k8shv1 systemd[1]: Starting snapd.service - Snap Daemon...
Jan 27 23:53:03 k8shv1 snapd[1157]: overlord.go:271: Acquiring state lock file
Jan 27 23:53:03 k8shv1 snapd[1157]: overlord.go:276: Acquired state lock file
Jan 27 23:53:03 k8shv1 snapd[1157]: patch.go:64: Patching system state level 6 to sublevel 1...
Jan 27 23:53:03 k8shv1 snapd[1157]: patch.go:64: Patching system state level 6 to sublevel 2...
Jan 27 23:53:03 k8shv1 snapd[1157]: patch.go:64: Patching system state level 6 to sublevel 3...
Jan 27 23:53:03 k8shv1 snapd[1157]: daemon.go:247: started snapd/2.63.1+24.04 (series 16; classic) ubuntu/24.04 (amd64) linux/6.8.0-41-generic.
Jan 27 23:53:04 k8shv1 snapd[1157]: daemon.go:340: adjusting startup timeout by 30s (pessimistic estimate of 30s plus 5s per snap)
Jan 27 23:53:04 k8shv1 snapd[1157]: backends.go:58: AppArmor status: apparmor is enabled and all features are available
Jan 27 23:53:04 k8shv1 systemd[1]: Started snapd.service - Snap Daemon.
Jan 27 23:53:48 k8shv1 snapd[1157]: stateengine.go:149: state ensure error: Get "https://api.snapcraft.io/api/v1/snaps/sections": net/http: request canceled while waiting for connection (Client.Timeout exceeded while awaiting headers)
Jan 27 23:54:19 k8shv1 snapd[1157]: daemon.go:519: gracefully waiting for running hooks
Jan 27 23:54:19 k8shv1 snapd[1157]: daemon.go:521: done waiting for running hooks
Jan 27 23:54:22 k8shv1 snapd[1157]: overlord.go:515: Released state lock file
Jan 27 23:54:22 k8shv1 snapd[1157]: daemon stop requested to wait for socket activation
Jan 27 23:54:22 k8shv1 systemd[1]: snapd.service: Deactivated successfully.
Feb 10 20:05:20 k8sgw1 systemd[1]: Starting snapd.service - Snap Daemon...
Feb 10 20:05:20 k8sgw1 systemd[1]: snapd.service: Deactivated successfully.
Feb 10 20:05:20 k8sgw1 systemd[1]: Stopped snapd.service - Snap Daemon.
Feb 10 20:05:20 k8sgw1 systemd[1]: Starting snapd.service - Snap Daemon...
Feb 10 20:05:20 k8sgw1 snapd[60415]: overlord.go:274: Acquiring state lock file
Feb 10 20:05:20 k8sgw1 snapd[60415]: overlord.go:279: Acquired state lock file
Feb 10 20:05:20 k8sgw1 snapd[60415]: patch.go:64: Patching system state level 6 to sublevel 1...
Feb 10 20:05:20 k8sgw1 snapd[60415]: patch.go:64: Patching system state level 6 to sublevel 2...
Feb 10 20:05:21 k8sgw1 snapd[60415]: patch.go:64: Patching system state level 6 to sublevel 3...
Feb 10 20:05:21 k8sgw1 snapd[60415]: daemon.go:250: started snapd/2.66.1+24.04 (series 16; classic) ubuntu/24.04 (amd64) linux/6.8.0-41-generic.
Feb 10 20:05:21 k8sgw1 snapd[60415]: daemon.go:353: adjusting startup timeout by 30s (pessimistic estimate of 30s plus 5s per snap)
Feb 10 20:05:21 k8sgw1 snapd[60415]: backends.go:58: AppArmor status: apparmor is enabled and all features are available
Feb 10 20:05:21 k8sgw1 snapd[60415]: helpers.go:160: error trying to compare the snap system key: system-key versions not comparable
Feb 10 20:05:21 k8sgw1 systemd[1]: Started snapd.service - Snap Daemon.
Feb 10 20:05:26 k8sgw1 snapd[60415]: daemon.go:548: gracefully waiting for running hooks
Feb 10 20:05:26 k8sgw1 snapd[60415]: daemon.go:550: done waiting for running hooks
Feb 10 20:05:29 k8sgw1 snapd[60415]: overlord.go:518: Released state lock file
Feb 10 20:05:29 k8sgw1 snapd[60415]: daemon stop requested to wait for socket activation
Feb 10 20:05:29 k8sgw1 systemd[1]: snapd.service: Deactivated successfully.
Feb 10 20:07:16 k8sgw1 systemd[1]: Starting snapd.service - Snap Daemon...
Feb 10 20:07:16 k8sgw1 snapd[71866]: overlord.go:274: Acquiring state lock file
Feb 10 20:07:16 k8sgw1 snapd[71866]: overlord.go:279: Acquired state lock file
Feb 10 20:07:16 k8sgw1 snapd[71866]: daemon.go:250: started snapd/2.66.1+24.04 (series 16; classic) ubuntu/24.04 (amd64) linux/6.8.0-41-generic.
Feb 10 20:07:16 k8sgw1 snapd[71866]: daemon.go:353: adjusting startup timeout by 30s (pessimistic estimate of 30s plus 5s per snap)
Feb 10 20:07:16 k8sgw1 snapd[71866]: backends.go:58: AppArmor status: apparmor is enabled and all features are available
Feb 10 20:07:16 k8sgw1 systemd[1]: Started snapd.service - Snap Daemon.
Feb 10 20:07:16 k8sgw1 snapd[71866]: api_snaps.go:468: Installing snap "multipass" revision unset
Feb 10 20:07:16 k8sgw1 snapd[71866]: store_download.go:142: no host system xdelta3 available to use deltas
Feb 10 20:07:22 k8sgw1 snapd[71866]: daemon.go:548: gracefully waiting for running hooks
Feb 10 20:07:22 k8sgw1 snapd[71866]: daemon.go:550: done waiting for running hooks
Feb 10 20:07:25 k8sgw1 snapd[71866]: overlord.go:518: Released state lock file
Feb 10 20:07:25 k8sgw1 systemd[1]: snapd.service: Deactivated successfully.
Feb 10 20:07:25 k8sgw1 systemd[1]: snapd.service: Scheduled restart job, restart counter is at 1.
Feb 10 20:07:25 k8sgw1 systemd[1]: Starting snapd.service - Snap Daemon...
```

## GitHub builds have old account details

If your Ubuntu One account details change after Build from GitHub has been configured, the new account details are not reflected in the packages built and published from GitHub.

Due to the nature of the GitHub to Snapcraft authentication link, account details are retained for the lifetime of that link from the point of its creation. To force an update after changing your publisher details, you need to recreate that link as follows:

For each snap that you control:
Go to the Build tab (<https://snapcraft.io/><SNAP-NAME>/builds)
Select “Disconnect repo”
Sign out of snapcraft.io AND login.ubuntu.com
For good measure, purge all cookies
Sign back into snapcraft.io
Confirm that your account name and other details are correct
For each snap that you control:
Go to the Build tab
Select on the GitHub “Log in” button and reconnect to the appropriate GitHub repo

### Test Policy Change

1. Please change the range of this policy from 10.188.50.[200-203] to 10.188.50.[200-212]
  Reason: To create 1 backup and 1 development Kubernetes Cluster in addition to the production cluster.

2. Please grant Snap Store access.

Can't install/update the Ubuntu MicroK8s software without accessing the **[Canonical's Snap Store](https://microk8s.io/docs/getting-started)**.

To access the Snap Store, you typically need a firewall rule that allows outbound connections to the following domains over HTTPS (port 443): "store.canonical.com" and "api.snapcraft.io"; this will enable your system to communicate with the Snap Store servers to download and install applications.

Key points about the firewall rule:

- Protocol: TCP
- Port: 80/443
- Action: Allow
- Destination: "store.canonical.com" and "api.snapcraft.io"

```bash

```

## Can we access 188.220 and 187.220

The site FW does not allow traffic to pass across sub-nets unless a rule is added to a FW policy.

Try adding an ip address for both subnets and a route to 10.187.40.0/24.

It does not work. Can't get an ip on subnet 10.187.50.0/24 to work at all from the switch ports I am using. I assume I would need a firewall rule to get this to work.

```bash
# r620_201_187
sudo netplan apply
ip route
default via 10.188.50.254 dev eno1 proto static 
10.41.219.0/24 dev mpqemubr0 proto kernel scope link src 10.41.219.1 
10.187.220.0/24 dev vlan220 proto kernel scope link src 10.187.220.201 
10.188.50.0/24 dev eno1 proto kernel scope link src 10.188.50.201 

ip a
...
6: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:98 brd ff:ff:ff:ff:ff:ff
    altname enp1s0f0
    inet 10.188.50.201/24 brd 10.188.50.255 scope global eno1
       valid_lft forever preferred_lft forever
    inet6 fe80::baca:3aff:fe6a:3598/64 scope link 
       valid_lft forever preferred_lft forever
...
10: vlan220@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:98 brd ff:ff:ff:ff:ff:ff
    inet 10.187.220.201/24 brd 10.187.220.255 scope global vlan220
       valid_lft forever preferred_lft forever
    inet6 fe80::baca:3aff:fe6a:3598/64 scope link 
       valid_lft forever preferred_lft forever
```

## Can we access 70 vlan

Jared said we should be able to access it from 220.

```bash
# r620_201_70.yaml
ip route
default via 10.188.50.254 dev eno1 proto static 
10.41.219.0/24 dev mpqemubr0 proto kernel scope link src 10.41.219.1 
10.188.50.0/24 dev eno1 proto kernel scope link src 10.188.50.201 
10.188.220.0/24 dev vlan220 proto kernel scope link src 10.188.220.201
```

There is no route to to 10.188.70.0/24 so the default route would be taken and that is via 10.188.50.254

so we need a route to 10.188.70.0/24 via 10.188.220.254.  If the 220 gw has a route to 10.188.70.0/24 then it will work.

```yaml
      routes:
      - to: 10.188.70.0/24
        via: 10.188.220.254
```

### **[How to add route to vlan interface](https://s55ma.radioamater.si/2024/05/17/configuring-vlan-routing-with-netplan-policy-based-routing/)**

```yaml
network:
  version: 2
  ethernets:
    eno1:
      dhcp4: false
      addresses:
      - 10.188.50.201/24    
      routes:
      - to: default
        via: 10.188.50.254
      nameservers:
        addresses:
        - 10.225.50.203
        - 10.224.50.203
  vlans:
    vlan220:
      id: 220
      link: eno1
      addresses:
      - 10.188.220.201/24
      routes:
        - to: 10.188.73.0/24
          via: 10.188.220.254     
```

### Test it

it works.

```bash
# 10.188.73.0/24 route was added

ip route
default via 10.188.50.254 dev eno1 proto static 
10.41.219.0/24 dev mpqemubr0 proto kernel scope link src 10.41.219.1 
10.188.50.0/24 dev eno1 proto kernel scope link src 10.188.50.201 
10.188.73.0/24 via 10.188.220.254 dev vlan220 proto static 
10.188.220.0/24 dev vlan220 proto kernel scope link src 10.188.220.201 

 nmap -v -sn 10.188.73.0/24
Starting Nmap 7.94SVN ( https://nmap.org ) at 2025-02-28 19:20 UTC
Initiating Ping Scan at 19:20
Scanning 256 hosts [2 ports/host]
Completed Ping Scan at 19:20, 3.11s elapsed (256 total hosts)
Initiating Parallel DNS resolution of 6 hosts. at 19:20
Completed Parallel DNS resolution of 6 hosts. at 19:20, 0.05s elapsed
...
Nmap scan report for 10.188.73.11
Host is up (0.0033s latency).
Nmap scan report for 10.188.73.12
Host is up (0.0047s latency).
Nmap scan report for 10.188.73.13
Host is up (0.0017s latency).
Nmap scan report for 10.188.73.14
Host is up (0.0016s latency).
Nmap scan report for 10.188.73.15
Host is up (0.014s latency).
Nmap scan report for 10.188.73.16
Host is up (0.00063s latency).
...
```

## Can we access both vlan from vm and give vm network reachable IP

test with r620_203.yaml

### multipass docs

### AI Overview

Learn more
To make a Multipass VM network accessible, you need to configure the network settings to use a "bridged" network mode, which essentially connects the VM directly to your host machine's physical network, allowing external access by using the VM's assigned IP address; this is typically done when launching the VM with the --network flag and specifying the desired network interface on your host machine.
Key steps:

Launch with bridged network: When creating a new Multipass VM, use the --network option with the name of your host network interface to enable bridged networking:

```bash
    multipass launch --name myvm --network enp0s3  
```

Replace enp0s3 with the actual name of your network interface on your host machine.
Check VM IP address: Once the VM is running, use multipass exec myvm ip addr show to find the assigned IP address.
Access the VM: You can now access the VM from other devices on your network using its IP address.

### **[How to configure static IPs](https://canonical.com/multipass/docs/configure-static-ips)**

Step 1: Create a Bridge

Notes:

- Don't add ip's or anything else to the physical network interfaces.
- Add the IP addresses, routes, and nameservers to the bridge.

```yaml
network:
  version: 2
  ethernets:
    eno1:
      dhcp4: false
      dhcp6: false
  vlans:
    vlan220:
      id: 220
      link: eno1
      addresses:
      - 10.188.220.203/24    
  bridges:
    br0:
      dhcp4: false
      dhcp6: false  
      addresses:
      - 10.188.50.203/24    
      routes:
      - to: default
        via: 10.188.50.254
      nameservers:
        addresses:
        - 10.225.50.203
      interfaces: [eno1]
```

### Step 2: Launch an instance with a manual network

You can also leave the MAC address unspecified (just --network name=localbr,mode=manual). If you do so, Multipass will generate a random MAC for you, but you will need to retrieve it in the next step.

```bash

multipass launch --name test --network name=br0
multipass launch --network br0 --name k8sn1 --cpus 2 --memory 32G --disk 250G 

```

## Step 3: Configure the extra interface

### retrieve the hardware address

See how multipass configured the network. Until I can figure out how to pass the hardware address manaully during launch we will have to grab the one multipass or lxd creates.
Note: On repsys11-c2-n2 the 50-cloud-init.yaml file already had the correct mac address.

```bash
multipass exec -n test -- sudo cat /etc/netplan/50-cloud-init.yaml
...
macaddress: "52:54:00:ca:42:da"
```

### update netplan with hardware address

```bash

# Make sure the mac address matches the extra0 macaddress

multipass exec -n test -- sudo bash -c 'cat << EOF > /etc/netplan/50-cloud-init.yaml
network:
  version: 2
  ethernets:
    default:
      match:
        macaddress: "52:54:00:e3:2e:3b"
      dhcp-identifier: "mac"
      dhcp4: true
    extra0:
      addresses:
      - 10.188.50.204/24
      nameservers:
         addresses:
         - 10.225.50.203
         - 10.224.50.203
      routes:
      - to: 10.188.40.0/24
        via: 10.188.50.254
      match:
        macaddress: "52:54:00:ca:42:da"
      optional: true
EOF'

# verify

multipass exec -n test -- sudo cat /etc/netplan/50-cloud-init.yaml

ip route
default via 10.130.245.1 dev ens3 proto dhcp src 10.130.245.2 metric 100 
10.130.245.0/24 dev ens3 proto kernel scope link src 10.130.245.2 metric 100 
10.130.245.1 dev ens3 proto dhcp scope link src 10.130.245.2 metric 100 
10.188.50.0/24 dev ens4 proto kernel scope link src 10.188.50.204 
```

if all looks good apply network changes

```bash
multipass exec -n test -- sudo netplan apply
multipass list
Name                    State             IPv4             Image
foo                     Running           10.130.245.158   Ubuntu 24.04 LTS
test                    Running           10.130.245.2     Ubuntu 24.04 LTS

# was route to 10.188.40.0/24 added
multipass shell test                                          10.188.50.204
ip route
default via 10.130.245.1 dev ens3 proto dhcp src 10.130.245.2 metric 100 
10.130.245.0/24 dev ens3 proto kernel scope link src 10.130.245.2 metric 100 
10.130.245.1 dev ens3 proto dhcp scope link src 10.130.245.2 metric 100 
10.188.40.0/24 via 10.188.50.254 dev ens4 proto static 
10.188.50.0/24 dev ens4 proto kernel scope link src 10.188.50.204 

ping 10.188.40.230
PING 10.188.40.230 (10.188.40.230) 56(84) bytes of data.
64 bytes from 10.188.40.230: icmp_seq=1 ttl=63 time=2.96 ms
64 bytes from 10.188.40.230: icmp_seq=2 ttl=63 time=1.91 ms
^C
--- 10.188.40.230 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 1.913/2.438/2.963/0.525 ms
```

## Step 5: Confirm that it works

You can confirm that the new IP is present in the instance with Multipass:

```bash
multipass info test
Name:           test
State:          Running
Snapshots:      0
IPv4:           10.130.245.2
                10.188.50.204
Release:        Ubuntu 24.04.2 LTS
Image hash:     9856e7bdfc4e (Ubuntu 24.04 LTS)
CPU(s):         1
Load:           0.01 0.01 0.00
Disk usage:     1.8GiB out of 4.8GiB
Memory usage:   298.7MiB out of 955.8MiB
Mounts:         --
```

The command above should show two IPs, the second of which is the one we just configured (10.13.31.13). You can use ping to confirm that it can be reached from the host:

```bash
ping 10.188.50.204
```

Conversely, you can also ping from the instance to the host:

```bash
multipass exec -n test -- ping 10.188.50.202
# works
multipass exec -n test -- ping 10.188.220.202
# works
```

## **[multipass ubuntu password set](https://askubuntu.com/questions/1230753/login-and-password-for-multipass-instance)**

In multipass instance, set a password to ubuntu user. Needed to ftp from dev system. Multipass has transfer command but only works from the host.

```bash
sudo passwd ubuntu
```

## **[Setup ssh to VMs](./ssh_into_mutipass_vms.md)**

### how does multipass vm access the internet

A Multipass virtual machine accesses the internet by leveraging the host machine's network connection, essentially "sharing" the host's internet access; meaning the VM uses the same network interface and IP configuration as the host machine to reach the internet, with the underlying hypervisor managing the traffic between the VM and the host network.

Setup k8sgw2,50.201, using the r620_201.yaml then install multipass.

```bash
multipass list
Name                    State             IPv4             Image
luminous-louvar         Running           10.41.219.209    Ubuntu 24.04 LTS
ip route show table all
default via 10.188.50.254 dev eno1 proto static 
10.41.219.0/24 dev mpqemubr0 proto kernel scope link src 10.41.219.1 
10.188.50.0/24 dev eno1 proto kernel scope link src 10.188.50.201 
10.188.220.0/24 dev vlan220 proto kernel scope link src 10.188.220.201 

ip a s
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
...
11: mpqemubr0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 52:54:00:de:88:9b brd ff:ff:ff:ff:ff:ff
    inet 10.41.219.1/24 brd 10.41.219.255 scope global mpqemubr0
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fede:889b/64 scope link 
       valid_lft forever preferred_lft forever
12: tap-1370c02f459: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master mpqemubr0 state UP group default qlen 1000
    link/ether 2e:cd:43:31:e6:bc brd ff:ff:ff:ff:ff:ff
    inet6 fe80::2ccd:43ff:fe31:e6bc/64 scope link 
       valid_lft forever preferred_lft forever

```

## How to collect data from moxa server

configure a trunk port in albion for 50 and 70 vlans and make 50 the default for untagged traffic. Listen on 70 IP and send data to 10.188.50.202 or Azure SQL db.
