# **[delete docker rules](https://stackoverflow.com/questions/50084582/cant-delete-docker-containers-default-iptables-rule/50084968)**

This is a bit old but in case someone else is looking for how to remove docker completely from your iptables rules here's how I did it, also keep in mind this is on debian so your files/paths may differ.

edit your /etc/iptables.up.rules file, back up file then remove everything with docker in it - there may also be a few additional lines with the local docker subnet (mine was 172.17.x and 172.19.x) - remove them all
flush iptables: iptables -P INPUT ACCEPT && iptables -P OUTPUT ACCEPT && iptables -P FORWARD ACCEPT && iptables -F
reload iptables rules: iptables-restore < /etc/iptables.up.rules
verify/check your rules: iptables -L -n (should no longer have any docker chains or rules)

## answer 2

If you have deleted the docker package than just restart iptables service and it will deleted default docker iptables-

`systemctl restart iptables.service`
