# Command List

## start here

Use tcpdump to watch traffic on WiFi interface and veth1 interface.

```bash
sudo su
ip netns add netns1
ip link add veth0 type veth peer name veth1
ip link set veth1 netns netns1
ip addr add 192.168.0.1/24 dev veth0
ip link set dev veth0 up

ip netns exec netns1 /bin/bash
ip addr add 192.168.0.2/24 dev veth1
ip link set dev veth1 up
ip route add default via 192.168.0.1

cat /proc/sys/net/ipv4/ip_forward
0
echo 1 > /proc/sys/net/ipv4/ip_forward
cat /proc/sys/net/ipv4/ip_forward
1
# or
sudo sysctl -w net.ipv4.ip_forward=1 (temporarily enables forwarding)

exit

iptables -P FORWARD DROP
iptables -L FORWARD


# for wireless
iptables -t nat -A POSTROUTING -s 192.168.0.0/255.255.255.0 -o wlp114s0f0 -j MASQUERADE
sudo iptables -t nat -S

# for wireless
iptables -A FORWARD -i wlp114s0f0 -o veth0 -j ACCEPT
sudo iptables -S

sudo iptables -t nat -S
# for wireless
iptables -t nat -A PREROUTING -p tcp -i wlp114s0f0 --dport 6000 -j DNAT --to-destination 192.168.0.2:8080
iptables -t nat -S

iptables -A FORWARD -p tcp -d 192.168.0.2 --dport 8080 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -S
