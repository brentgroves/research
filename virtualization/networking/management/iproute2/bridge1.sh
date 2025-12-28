ip link add name br0 type bridge
ip link set dev br0 up
ip address add 10.1.0.138/22 dev br0
ip route append default via 10.1.1.205 dev br0
ip link set eno3 master br0
ip address del 10.1.0.138/22 dev eno3
