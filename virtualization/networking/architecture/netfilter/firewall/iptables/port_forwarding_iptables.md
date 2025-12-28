# **[A simple port forwarding on ubuntu using iptables.](https://medium.com/@richardrolfe/a-simple-port-forwarding-on-ubuntu-using-iptables-b94a8b47a8d9)**


**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

I came across an odd use case in my home lab. I had installed a multiroom Wi-Fi system and as a result had two subnets 192.168.0.x internet connection was on this subnet and 192.168.1.x that host all other systems and Wi-Fi.

The result of this was it made forwarding external ports from the internet router on 192.168.0.1 impossible as the web UI assumed you would never want to forward an external port to another subnet. It would only allow me to forward to hosts in the same subnet. It was not possible to forward the port to a webserver in the 192.168.1.x subnet for example.

To get around this limitation I used a raspberry pi I had spare. I connected this with ethernet cable on the internet router and also connected it via Wi-Fi to the other subnet at 192.168.1.x. ( multiroom Wi-Fi network )

So now I can forward external ports from the router to the raspberry pi. However I could not find a straightforward way to forward the port to another host in the subnet 192.168.1.x.

I found some helpful posts on stack overflow and came up with the following commands :

```bash
iptables -F
iptables -t nat -F
iptables -t mangle -F
iptables -X

IF=eth0
PORT_FROM=80
PORT_TO=80
DEST=192.168.1.175
iptables -t nat -A PREROUTING -i $IF -p tcp — dport $PORT_FROM -j DNAT — to $DEST:$PORT_TO
iptables -t nat -A POSTROUTING -p tcp -d $DEST — dport $PORT_TO -j MASQUERADE
```

```bash
export IF=eno1
export PORT_FROM=5240
export PORT_TO=5240
export DEST=10.72.173.107
iptables -t nat -A PREROUTING -i $IF -p tcp -- dport $PORT_FROM -j DNAT -- to $DEST:$PORT_TO
iptables -t nat -A POSTROUTING -p tcp -d $DEST — dport $PORT_TO -j MASQUERADE
```

The man page for the commands is here :

Ubuntu Manpage: **[iptables/ip6tables - administration tool for IPv4/IPv6 packet filtering and NAT](https://manpages.ubuntu.com/manpages/trusty/en/man8/iptables.8.html?source=post_page-----b94a8b47a8d9--------------------------------)**