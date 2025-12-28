# ip link

## references

<http://www.policyrouting.org/iproute2.doc.html#ss9.1.1>

## ip link - network device configuration

A link refers a network device. The ip link object and the corresponding command set allows viewing and manipulating the state of network devices. The commands for the link object are just two, set and show.

## Abbreviations: set, s

## Warning

You can request multiple parameter changes with ip link. If you request multiple parameter changes and any ONE change fails then ip aborts immediately after the failure thus the parameter changes previous to the failure have completed and are not backed out on abort. This is the only case where using the ip command can leave your system in an unpredictable state. The solution is to avoid changing multiple parameters with one ip link set call. Use as many individual ip link set commands as necessary to perform the actions you desire.

## Arguments

* dev NAME (default) --- NAME specifies the network device to operate on

* up / down --- change the state of the device to UP or to DOWN

* arp on / arp off --- change NOARP flag status on the device

Note that this operation is not allowed if the device is already in the UP state. Since neither the ip utility nor the kernel check for this condition, you can get very unpredictable results changing the flag while the device is running. It is better to set the device down then issue this command.

* multicast on / multicast off --- change MULTICAST flag on the device.

* dynamic on / dynamic off --- change DYNAMIC flag on the device.

* name NAME --- change name of the device.

Note that this operation is not recommended if the device is running or has some addresses already configured. You can break your systems security and screw up other networking daemons and programs by changing the device name while the device is running or has addressing assigned.

* txqueuelen NUMBER / txqlen NUMBER --- change transmit queue length of the device

* mtu NUMBER --- change MTU of the device.

* address LLADDRESS --- change station address of the interface.

* broadcast LLADDRESS, brd LLADDRESS or peer LLADDRESS --- change link layer broadcast address or peer address in the case of a POINTOPOINT interface

Note that for most physical network devices (Ethernet, TokenRing, etc) changing the link layer broadcast address will break networking. Do not use this argument if you do not understand what this operation really does.

* The ip command does not allow changing the PROMISC or ALLMULTI flags as these flags are considered obsolete and should not be changed administratively.

Examples:

ip link set dummy address 000000000001 --- change station address of the interface dummy.

ip link set dummy up --- start the interface dummy.

```bash
scc.sh reports1.yaml microk8s

kubectl get nodes -o wide
NAME        STATUS   ROLES    AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
reports13   Ready    <none>   76d   v1.28.3   10.1.0.112    <none>        Ubuntu 22.04.3 LTS   5.15.0-88-generic   containerd://1.6.15
reports11   Ready    <none>   76d   v1.28.3   10.1.0.110    <none>        Ubuntu 22.04.3 LTS   5.15.0-88-generic   containerd://1.6.15
reports12   Ready    <none>   76d   v1.28.3   10.1.0.111    <none>        Ubuntu 22.04.3 LTS   6.2.0-36-generic    containerd://1.6.15

```

## examine k8s virtual network

```bash
nvim /etc/hosts 
# 10.1.0.8 is used by the kong ingress controller
10.1.0.8        reports1.busche-cnc.com

ping 10.1.0.8                                  
PING 10.1.0.8 (10.1.0.8) 56(84) bytes of data.
From 10.1.0.112 icmp_seq=2 Redirect Host(New nexthop: 10.1.0.8)
# since 10.1.0.112 is reports13 ssh there
ssh brent@reports13
```
