# **[VM](https://ubuntu.com/server/docs/how-to-create-a-vm-with-multipass)**

**[Back to Research List](../../research_list.md)**\
**[Back to Multipass Menu](./multipass_menu.md)**\
**[Back to Current Status](../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../README.md)**

## How to create a VM with Multipass

Multipass is the recommended method for creating Ubuntu VMs on Ubuntu. It’s designed for developers who want a fresh Ubuntu environment with a single command, and it works on Linux, Windows and macOS.

On Linux it’s available as a snap:

```sudo snap install multipass'''

Find available images
To find available images you can use the ```multipass find``` command, which will produce a list like this:

```bash
Image                       Aliases           Version          Description
snapcraft:core18            18.04             20201111         Snapcraft builder for Core 18
snapcraft:core20            20.04             20210921         Snapcraft builder for Core 20
snapcraft:core22            22.04             20220426         Snapcraft builder for Core 22
snapcraft:devel                               20221128         Snapcraft builder for the devel series
core                        core16            20200818         Ubuntu Core 16
core18                                        20211124         Ubuntu Core 18
18.04                       bionic            20221117         Ubuntu 18.04 LTS
20.04                       focal             20221115.1       Ubuntu 20.04 LTS
22.04                       jammy,lts         20221117         Ubuntu 22.04 LTS
22.10                       kinetic           20221101         Ubuntu 22.10
daily:23.04                 devel,lunar       20221127         Ubuntu 23.04
appliance:adguard-home                        20200812         Ubuntu AdGuard Home Appliance
appliance:mosquitto                           20200812         Ubuntu Mosquitto Appliance
appliance:nextcloud                           20200812         Ubuntu Nextcloud Appliance
appliance:openhab                             20200812         Ubuntu openHAB Home Appliance
appliance:plexmediaserver                     20200812         Ubuntu Plex Media Server Appliance
anbox-cloud-appliance                         latest           Anbox Cloud Appliance
charm-dev                                     latest           A development and testing environment for charmers
docker                                        latest           A Docker environment with Portainer and related tools
jellyfin                                      latest           Jellyfin is a Free Software Media System that puts you in control of managing and streaming your media.
minikube                                      latest           minikube is local Kubernetes
```

## **[How to bridge local LAN using Multipass](https://askubuntu.com/questions/1425752/how-to-bridge-local-lan-using-multipass)**

This method uses LXD.

1. Install LXD.

sudo snap install lxd
2. Connect LXD to Multipass.

snap connect multipass:lxd lxd
3. Tell Multipass to use LXD:

multipass set local.driver=lxd

```bash
ssh repsys11
multipass networks
Name        Type       Description
docker0     bridge     Network bridge
eno1        ethernet   Ethernet device
eno2        ethernet   Ethernet device
eno3        ethernet   Ethernet device
eno4        ethernet   Ethernet device
enp66s0f0   ethernet   Ethernet device
enp66s0f1   ethernet   Ethernet device
enp66s0f2   ethernet   Ethernet device
enp66s0f3   ethernet   Ethernet device
mpbr0       bridge     Network bridge for Multipass
```

<https://gist.github.com/ynott/f4bdc89b940522f2a0e4b32790ddb731>
<https://discourse.ubuntu.com/t/how-to-add-network-interfaces/19544>

```bash
# last try
multipass networks 
Name        Type       Description
br-eno1     bridge     Network bridge with eno1
docker0     bridge     Network bridge
eno1        ethernet   Ethernet device
eno2        ethernet   Ethernet device
eno3        ethernet   Ethernet device
eno4        ethernet   Ethernet device
enp66s0f0   ethernet   Ethernet device
enp66s0f1   ethernet   Ethernet device
enp66s0f2   ethernet   Ethernet device
enp66s0f3   ethernet   Ethernet device
mpbr0       bridge     Network bridge for Multipass

multipass launch --network eno1                 
Launched: idealistic-skunk
multipass exec idealistic-skunk -- ip -br address show scope global
enp5s0           UP             10.182.32.173/24 metric 100 fd42:f307:746a:5edd:5054:ff:fe70:cbc4/64 
# above only had one interface

multipass launch --network eno1 --network name=mpbr0,mode=manual
[2024-05-24T19:41:13.246] [error] [lxd request] Error waiting on operation: (409) Failed start validation for device "eth0": Instance DNS name "airy-quahog" conflict between "eth0" and "eth2" because both are connected to same network
launch failed: Error waiting on operation: (409) Failed start validation for device "eth0": Instance DNS name "airy-quahog" conflict between "eth0" and "eth2" because both are connected to same network

multipass launch --network eno1 --network name=br-eno1,mode=manual
# above did not work
multipass launch 20.04 --network br-eno1
nothing will give me wo ips

ssh brent@10.1.2.139

Thank you Lord for every trial and problem you allow me to go through today.
sudo nmcli connection add type bridge con-name localbr ifname localbr \
    ipv4.method manual ipv4.addresses 10.1.0.126/22

This will create a bridge named localbr with IP 10.13.31.1/24. You can see the new device and address with ip -c -br addr show dev localbr. This should show:
exit
ip -c -br addr show dev localbr
localbr          DOWN           10.1.0.126/22 

You can also run multipass networks to confirm the bridge is available for Multipass to connect to.

Step 2: Launch an instance with a manual network
Next we launch an instance with an extra network in manual mode, connecting it to this bridge:

multipass launch --name test1 --network name=localbr,mode=manual,mac="52:54:00:4b:ab:cd"

You can also leave the MAC address unspecified (just --network name=localbr,mode=manual). If you do so, Multipass will generate a random MAC for you, but you will need to retrieve it in the next step.

Step 3: Configure the extra interface
We now need to configure the manual network interface inside the instance. We can achieve that using Netplan. The following command plants the required Netplan configuration file in the instance:

$ multipass exec -n test1 -- sudo bash -c 'cat << EOF > /etc/netplan/10-custom.yaml
network:
    version: 2
    ethernets:
        extra0:
            dhcp4: no
            match:
                macaddress: "52:54:00:4b:ab:cd"
            addresses: [10.1.0.126/22]
EOF'

The IP address needs to be unique and in the same subnet as the bridge. The MAC address needs to match the extra interface inside the instance: either the one provided in step 2 or the one Multipass generated (you can find it with ip link).

If you want to set a different name for the interface, you can add a set-name property.

Step 4: Apply the new configuration
We now tell netplan apply the new configuration inside the instance:

multipass exec -n test1 -- sudo netplan apply
You may also use netplan try, to have the outcome reverted if something goes wrong.

Step 5: Confirm that it works
You can confirm that the new IP is present in the instance with Multipass:

multipass info test1
Name:           test1
State:          Running
IPv4:           10.182.32.10
                10.1.0.126
Release:        Ubuntu 24.04 LTS
Image hash:     08c7ba960c16 (Ubuntu 24.04 LTS)
CPU(s):         1
Load:           0.13 0.32 0.18
Disk usage:     1.2GiB out of 9.6GiB
Memory usage:   341.5MiB out of 945.6MiB
Mounts: 

The command above should show two IPs, the second of which is the one we just configured (10.13.31.13). You can use ping to confirm that it can be reached from the host:

ping 10.1.0.126
Conversely, you can also ping from the instance to the host:

multipass exec -n test1 -- ping 10.1.0.126

thank you Father for allowing me enjoy my work no matter if I succeed or fail.  You can not fail if you do not give up and I am in control of if you succeed or not.

```

## Launch a fresh instance of the Ubuntu Jammy (22.04) LTS

You can launch a fresh instance by specifying either the image name from the list (in this example, 22.04) or using an alias, if the image has one.

```bash
multipass networks
multipass set local.bridged-network=en01
multipass get local.bridged-network

# Passing --bridged and --network bridged are shortcuts to --network <name>, where <name> is configured via multipass set local.bridged-interface.
multipass launch 22.04 -n vm01 --bridged
Multipass needs to create a bridge to connect to eno1.
This will temporarily disrupt connectivity on that interface.

Do you want to continue (yes/no)? 
Configuring vm01 - waiting

multipass launch 22.04 -n vm01 --network eno1
$ multipass launch 22.04
Launched: cleansing-guanaco
```

This command is equivalent to: multipass launch jammy or multipass launch lts in the list above. It will launch an instance based on the specified image, and provide it with a random name – in this case, cleansing-guanaco.

Check out the running instances
You can check out the currently running instance(s) by using the “multipass list` command:

```bash
$ multipass list                                                  
Name                    State             IPv4             Image
cleansing-guanaco       Running           10.140.26.17     Ubuntu 22.04 LTS
```

## Learn more about the VM instance you just launched

You can use the multipass info command to find out more details about the VM instance parameters:

```bash
$ multipass info cleansing-guanaco 
Name:           cleansing-guanaco
State:          Running
IPv4:           10.140.26.17
Release:        Ubuntu 22.04.1 LTS
Image hash:     dc5b5a43c267 (Ubuntu 22.04 LTS)
Load:           0.45 0.19 0.07
Disk usage:     1.4G out of 4.7G
Memory usage:   168.3M out of 969.5M
Mounts:         --

multipass info my-juju-vm
Name:           my-juju-vm
State:          Running
Snapshots:      0
IPv4:           10.42.209.100
                10.213.0.1
                10.1.32.128
Release:        Ubuntu 22.04.4 LTS
Image hash:     da76b0ef1cd4 (Ubuntu 22.04 LTS)
CPU(s):         4
Load:           0.73 0.91 1.01
Disk usage:     15.7GiB out of 48.4GiB
Memory usage:   2.4GiB out of 7.7GiB
Mounts:         --
```

multipass launch 22.04 -n vm02 --network br-eno1

## Connect to a running instance

To enter the VM you created, use the shell command:

```bash
$ multipass shell cleansing-guanaco 
Welcome to Ubuntu 22.04.1 LTS (GNU/Linux 5.15.0-53-generic x86_64)
(...)

ubuntu@cleansing-guanaco:~$
```

## Disconnect from the instance

Don’t forget to log out (or Ctrl + D) when you are done, or you may find yourself heading all the way down the Inception levels…

## Run commands inside an instance from outside

```bash
$ multipass exec cleansing-guanaco -- lsb_release -a
# The lsb_release command prints certain LSB (Linux Standard Base) and Distribution information.
No LSB modules are available.
Distributor ID: Ubuntu
Description: Ubuntu 22.04.1 LTS
Release: 22.04
Codename: jammy
```

## Stop or start an instance

You can stop an instance to save resources using the stop command:

```bash
$ multipass stop cleansing-guanaco
You can start it back up again using the start command:

$ multipass start cleansing-guanaco
```

## Delete the instance

Once you are finished with the instance, you can delete it as follows:

```bash
$ multipass delete cleansing-guanaco
It will now show up as deleted when you use the list command:

$ multipass list
Name                    State             IPv4             Image
cleansing-guanaco       Deleted           --               Not Available
```

And when you want to completely get rid of it (and any other deleted instances), you can use the purge command:

```bash
$ multipass purge
Which we can check again using list:

$ multipass list
No instances found.
```

## Integrate with the rest of your virtualization

You might have other virtualization already based on libvirt, either through using the similar older uvtool or through the more common virt-manager.

You might, for example, want those guests to be on the same bridge to communicate with each other, or if you need access to the graphical output for some reason.

Fortunately it is possible to integrate this by using the libvirt backend of Multipass:

```bash
sudo multipass set local.driver=libvirt
```

Now when you start a guest you can also access it via tools like virt-manager or virsh:

```bash
$ multipass launch lts
Launched: engaged-amberjack 

$ virsh list
 Id    Name                           State
----------------------------------------------------
 15    engaged-amberjack              running
```

## Get help

You can use the following commands on the CLI:

```bash
multipass help
multipass help <command>
multipass help --all
```
