# Delete namespaces

```bash
# delete netns1
ip netns exec netns1 /bin/bash
ip route
ip route del 192.168.0.0/24 dev veth1
ip link set dev lo down
ip link set dev veth1 down
ip addr delete 192.168.0.2/24 dev veth1

exit

ip link set dev veth0 down
ip addr delete 192.168.0.1/24 dev veth0
ip link delete veth0

ip netns delete netns1

# delete netns2
ip netns exec netns2 /bin/bash
ip route
ip route del 192.168.1.0/24 dev veth3
ip link set dev lo down
ip link set dev veth3 down
ip addr delete 192.168.1.2/24 dev veth3

exit

ip link set dev veth2 down
ip addr delete 192.168.1.1/24 dev veth2
ip link delete veth2

ip netns delete netns2

```
