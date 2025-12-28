# **[Multipass Port Forwarding with IPTables](https://discourse.ubuntu.com/t/multipass-port-forwarding-with-iptables/18741)**

**[Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Research List](../../../../research_list.md)**\
**[Back Main](../../../../../README.md)**

## references

- **[How to Bridge Two Network Interfaces in Linux Using Netplan](https://www.tecmint.com/netplan-bridge-network-interfaces/)**
- **[bridge commands](https://developers.redhat.com/articles/2022/04/06/introduction-linux-bridging-commands-and-features#spanning_tree_protocol)
- **[Create an instance with multiple network interfaces](https://multipass.run/docs/create-an-instance#heading--create-an-instance-with-multiple-network-interfaces)**

Port Forwarding can be performed with IPTables to an instance from a Linux host.


## FORWARD Chain
When adding an IPTables port forward, but sure to use the -I (capital i) to insert the rule. In the examples below, the rules are inserted at position 1 in the forward chain. Each time a rule is added, it just pushes the next ones down. The Insert chain is needed because the default is to insert Forward rules at the end of the Forward chain.

## Forward Port 443 to Ubuntu multipass instance

```bash
sudo iptables -t nat -I PREROUTING 1 -i wlp1s0 -p tcp --dport 443 -j DNAT --to-destination 10.219.36.119:443
sudo iptables -I FORWARD 1 -p tcp -d 10.219.36.119 --dport 443 -j ACCEPT
```

## Forward Port 3389 to Ubuntu multipass instance

```bash
sudo iptables -t nat -I PREROUTING 1 -i wlp1s0 -p tcp --dport 3389 -j DNAT --to-destination 10.219.36.120:3389
sudo iptables -I FORWARD 1 -p tcp -d 10.219.36.120 --dport 3389 -j ACCEPT
```

Those will be pushed to beginning of the Forward chain (Notice how port 80 rule was pushed down since 3389 was inserted at line 1):

