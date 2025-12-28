# Delete and recreate rules

## kill servers

```bash
ps -ef | grep python
kill pid
```

## reverse all forwarding rules

```bash
# List them
# iptables -A FORWARD -i enx803f5d090eb3 -o veth0 -p tcp --syn --dport 8080 -m conntrack --ctstate NEW -j ACCEPT
# iptables -A FORWARD -i enx803f5d090eb3 -o veth0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
# iptables -A FORWARD -i veth0 -o enx803f5d090eb3 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

iptables -L FORWARD --line-numbers
Chain FORWARD (policy ACCEPT)
num  target     prot opt source               destination         
1    ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:http-alt flags:FIN,SYN,RST,ACK/SYN ctstate NEW
2    ACCEPT     all  --  anywhere             anywhere             ctstate RELATED,ESTABLISHED
3    ACCEPT     all  --  anywhere             anywhere             ctstate RELATED,ESTABLISHED

iptables -P FORWARD ACCEPT
iptables -L FORWARD --line-numbers
iptables -D FORWARD 6
iptables -D FORWARD 5
iptables -D FORWARD 4
iptables -D FORWARD 3
iptables -D FORWARD 2
iptables -D FORWARD 1

```

## Reverse all nat rules

```bash
# iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o enx803f5d090eb3 -j MASQUERADE
# iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o enx803f5d090eb3 -j MASQUERADE

iptables -t nat -L POSTROUTING --line-numbers
iptables -t nat -D POSTROUTING 2
iptables -t nat -D POSTROUTING 1

# sudo iptables -t nat -A PREROUTING -i enx803f5d090eb3 -p tcp --dport 8080 -j DNAT --to-destination 192.168.0.2
# sudo iptables -t nat -A PREROUTING -i enx803f5d090eb3 -p tcp --dport 6000 -j DNAT --to-destination 192.168.0.2:8080
# sudo iptables -t nat -A PREROUTING -i enx803f5d090eb3 -p tcp --dport 8081 -j DNAT --to-destination 192.168.1.2:8080

iptables -t nat -L PREROUTING --line-numbers
iptables -t nat -D PREROUTING 3
iptables -t nat -D PREROUTING 2
iptables -t nat -D PREROUTING 1
```

## virtual interface

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
