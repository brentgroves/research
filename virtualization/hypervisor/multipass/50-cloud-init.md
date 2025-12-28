# 50-cloud-init

When multipass creates a ubuntu 22.04/24.04 instance it will create an cloud init file:

```bash
ls /etc/netplan
50-cloud-init.yaml
```

## theory/speculation

If you pass a cloud-init.yaml file as an argument to multipass launch it will use it to initialize the instance but if you don't pass a cloud-init.yaml file multipass creates a generic file with dhcp networking configured.

Since I didn't pass a file to multipass launch the 50-cloud-init.yaml file looked like this:

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

I then edited this file to configure the extra interface to be a static ip as such:

```bash
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
```
