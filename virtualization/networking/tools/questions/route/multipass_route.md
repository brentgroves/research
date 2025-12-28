# **[routes for multipass](https://discourse.ubuntu.com/t/how-to-use-multipass-remotely/26360/2)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

if you’re after exposing the instances on your network, --network is the way to go. Would you please file an issue with some details?

https://github.com/canonical/multipass/issues/new?labels=bug&template=bug_report.md 48

As for ensuring connectivity between your host and remote instances, that would require setting up routes appropriately on your workstation, which would roughly be ip route add <network> via <multipass host IP>. Assuming that you’re on Linux:

```bash
ssh brent@k8shv4
# Ran list a little later and everything looks ok
multipass list              
Name                    State             IPv4             Image
maas                    Running           10.72.173.107    Ubuntu 24.04 LTS
                                          10.10.10.1
exit

ip route list 
default via 192.168.1.1 dev enp0s31f6 proto dhcp metric 100 
169.254.0.0/16 dev docker0 scope link metric 1000 linkdown 
172.17.0.0/16 dev docker0 proto kernel scope link src 172.17.0.1 linkdown 
172.19.0.0/16 dev br-2c4c88ba5dfd proto kernel scope link src 172.19.0.1 linkdown 
192.168.1.0/24 dev enp0s31f6 proto kernel scope link src 192.168.1.210 metric 100 

sudo ip route add 10.72.173.107/32 via 192.168.1.65
sudo ip route delete 10.72.173.107/32 via 192.168.1.65

# sudo ip route del 10.72.173.0/24 via 192.168.1.65 
# sudo ip route add 10.72.173.0/24 via 192.168.1.65

ip route list                                    
default via 192.168.1.1 dev enp0s31f6 proto dhcp metric 100 
10.72.173.0/24 via 192.168.1.65 dev enp0s31f6 
169.254.0.0/16 dev docker0 scope link metric 1000 linkdown 
172.17.0.0/16 dev docker0 proto kernel scope link src 172.17.0.1 linkdown 
172.19.0.0/16 dev br-2c4c88ba5dfd proto kernel scope link src 172.19.0.1 linkdown 
192.168.1.0/24 dev enp0s31f6 proto kernel scope link src 192.168.1.210 metric 100 

# curl http://<MAAS_IP>:5240/MAAS
http://10.72.173.107:5240/MAAS
# MULTIPASS_SERVER_ADDRESS=10.72.173.107:51001 multipass list

# MULTIPASS_SERVER_ADDRESS=10.72.173.107:51001 multipass launch
```

## example

```bash
$ MULTIPASS_SERVER_ADDRESS=10.2.0.9:51001 multipass launch
Launched: passionate-macaw

$ multipass shell passionate-macaw              
shell failed: ssh connection failed: 'Timeout connecting to 192.168.66.23'

$ sudo ip route add 192.168.66.0/24 via 10.2.0.9

$ multipass exec passionate-macaw -- uname -a   
Linux passionate-macaw 5.4.0-96-generic #109-Ubuntu SMP Wed Jan 12 18:07:25 UTC 2022 aarch64 aarch64 aarch64 GNU/Linux
On any other host adding the appropriate route should equally work :).