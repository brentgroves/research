# **[Bridged network notes]()**

```bash
ssh brent@repsys11
nmcli connection show
NAME                UUID                                  TYPE      DEVICE      
Wired connection 1  5954213d-750c-311b-a126-f1fc1e48ae45  ethernet  eno1        
mpbr0               6b996dc2-344c-458f-abd9-d22f743833a4  bridge    mpbr0       
br-eno1             5e26d07f-41b1-48e1-a437-5033060f2cfc  bridge    br-eno1     
docker0             1e6fdd34-8203-4333-ba75-69a927c53051  bridge    docker0     
localbr             647aead7-7911-4f30-b70b-fb84900a122a  bridge    localbr     
tap50c73101         c5297b45-76f1-4d1d-8003-dce26bea2a4c  tun       tap50c73101 
tapd7333b8f         dfa95920-8857-43ba-b239-c7b2f7c2292e  tun       tapd7333b8f 
tapd789600c         7e3b1f54-69b5-44af-a3a5-aabac475100e  tun       tapd789600c

multipass networks
Name        Type       Description
br-eno1     bridge     Network bridge
docker0     bridge     Network bridge
eno1        ethernet   Ethernet device
eno2        ethernet   Ethernet device
eno3        ethernet   Ethernet device
eno4        ethernet   Ethernet device
enp66s0f0   ethernet   Ethernet device
enp66s0f1   ethernet   Ethernet device
enp66s0f2   ethernet   Ethernet device
enp66s0f3   ethernet   Ethernet device
localbr     bridge     Network bridge
mpbr0       bridge     Network bridge for Multipass

multipass get local.driver
lxd

Step 1: Create a Bridge
The first step is to create a new bridge/switch with a static IP on your host. This is beyond the scope of Multipass but, as an example, here is how this can be achieved with NetworkManager (e.g. on Ubuntu Desktop):

nmcli connection add type bridge con-name localbr ifname localbr \
    ipv4.method manual ipv4.addresses 10.13.31.1/24

```
