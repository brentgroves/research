# **[Delete rules without line numbers](https://phoenixnap.com/kb/iptables-delete-rule)**

List iptables Rules Based on Specifications
The standard command to list rules based on specifications is:

```bash
sudo iptables -S
```

The output print rules as a list of specifications. However, to list only rules for a specific chain, include the chain's name:

```bash
sudo iptables -t nat -S
-P PREROUTING ACCEPT
-P INPUT ACCEPT
-P OUTPUT ACCEPT
-P POSTROUTING ACCEPT
-A POSTROUTING -s 192.168.0.0/24 -o enp0s25 -j MASQUERADE
```

## Delete iptables Rules by Specifications

Use -D with a rule specification to remove that specific rule. To make the process more straightforward, run the command with the -S argument first.

The output lists all iptables rules and specifications. Choose a rule to delete and copy/paste the specification into the following command:

```bash
sudo iptables -D [specification]

```

Warning: When copying the specification, omit the -A option.

For example, to delete the -A INPUT -j DROP rule from the list, execute:

```bash
# sudo iptables -D INPUT -j DROP
sudo iptables -t nat -S
-P PREROUTING ACCEPT
-P INPUT ACCEPT
-P OUTPUT ACCEPT
-P POSTROUTING ACCEPT
-A POSTROUTING -s 192.168.0.0/24 -o enp0s25 -j MASQUERADE
# Delete rule by specification
# iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o enp0s25 -j MASQUERADE
sudo iptables -t nat -D POSTROUTING -s 192.168.0.0/24 -o enp0s25 -j MASQUERADE
sudo iptables -t nat -S
-P PREROUTING ACCEPT
-P INPUT ACCEPT
-P OUTPUT ACCEPT
-P POSTROUTING ACCEPT
```
