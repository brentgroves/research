# Delete rules

```bash
sudo su

iptables -L FORWARD

## how to delete
iptables -L FORWARD --line-numbers
num  target     prot opt source               destination         
1    LIBVIRT_FWX  all  --  anywhere             anywhere            
2    LIBVIRT_FWI  all  --  anywhere             anywhere            
3    LIBVIRT_FWO  all  --  anywhere             anywhere            
4    ACCEPT     all  --  10.1.0.0/16          anywhere             /* generated for MicroK8s pods */
5    ACCEPT     all  --  anywhere             10.1.0.0/16          /* generated for MicroK8s pods */
6    ACCEPT     all  --  anywhere             anywhere            
7    ACCEPT     all  --  anywhere             anywhere            
8    ACCEPT     tcp  --  anywhere             192.168.0.2          tcp dpt:http-alt state NEW,RELATED,ESTABLISHED
9    ACCEPT     tcp  --  anywhere             192.168.0.2          tcp dpt:http-alt state NEW,RELATED,ESTABLISHED

# for wireless
iptables -t nat -A POSTROUTING -s 192.168.0.0/255.255.255.0 -o wlp114s0f0 -j MASQUERADE
iptables -t nat -L POSTROUTING --line-numbers
# Warning: iptables-legacy tables present, use iptables-legacy to see them
Chain POSTROUTING (policy ACCEPT)
num  target     prot opt source               destination         
1    LIBVIRT_PRT  all  --  anywhere             anywhere            
2    MASQUERADE  all  --  192.168.0.0/24       anywhere            
3    MASQUERADE  all  --  192.168.0.0/24       anywhere    

sudo iptables -D POSTROUTING 2
sudo iptables -t nat -S

# for wireless
iptables -A FORWARD -i wlp114s0f0 -o veth0 -j ACCEPT
iptables -L FORWARD --line-numbers
# Warning: iptables-legacy tables present, use iptables-legacy to see them
Chain FORWARD (policy ACCEPT)
num  target     prot opt source               destination         
1    LIBVIRT_FWX  all  --  anywhere             anywhere            
2    LIBVIRT_FWI  all  --  anywhere             anywhere            
3    LIBVIRT_FWO  all  --  anywhere             anywhere            
4    ACCEPT     all  --  10.1.0.0/16          anywhere             /* generated for MicroK8s pods */
5    ACCEPT     all  --  anywhere             10.1.0.0/16          /* generated for MicroK8s pods */
6    ACCEPT     all  --  anywhere             anywhere            
7    ACCEPT     all  --  anywhere             anywhere            
8    ACCEPT     tcp  --  anywhere             192.168.0.2          tcp dpt:http-alt state NEW,RELATED,ESTABLISHED
9    ACCEPT     tcp  --  anywhere             192.168.0.2          tcp dpt:http-alt state NEW,RELATED,ESTABLISHED

sudo iptables -D FORWARD 8
sudo iptables -S

sudo iptables -t nat -S
# for wireless
iptables -t nat -A PREROUTING -p tcp -i wlp114s0f0 --dport 6000 -j DNAT --to-destination 192.168.0.2:8080
iptables -t nat -L PREROUTING --line-numbers
# Warning: iptables-legacy tables present, use iptables-legacy to see them
Chain PREROUTING (policy ACCEPT)
num  target     prot opt source               destination         
1    DNAT       tcp  --  anywhere             anywhere             tcp dpt:x11 to:192.168.0.2:8080

sudo iptables -D PREROUTING 8

iptables -t nat -S

iptables -A FORWARD -p tcp -d 192.168.0.2 --dport 8080 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

iptables -t nat -L FORWARD --line-numbers

iptables -S
