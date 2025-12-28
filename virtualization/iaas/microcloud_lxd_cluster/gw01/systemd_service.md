# SystemD iptables Moto Gateway service

## references

- **[systemd unit files](https://unix.stackexchange.com/questions/694357/how-to-invoke-iptables-from-systemd-unit-file)**

```bash
[Unit]
Description=Iptables firewall rules
After=network.target

[Service]
Type=oneshot
WorkingDirectory=/path/to/your/project
ExecStart=/etc/myiptables/recreate_rules.sh
User=your_user
Group=your_group

[Install]
WantedBy=multi-user.target
```

In this example:

- Description: Provides a description for the service.
- After: Specifies that the service should start after the network is up.
- WorkingDirectory: Sets the working directory for the script.
- ExecStart: Defines the shell script to execute.
- User and Group: Define the user and group to run the script as.
- Restart: Configures the service to restart on failure.
- WantedBy: Specifies that the service should be enabled for multi-user targets.

## port forwarding

Tried to run as iptables commands as User=brent but it did not work even with CAP_NET_RAW set.

```bash
# <https://unix.stackexchange.com/questions/694357/how-to-invoke-iptables-from-systemd-unit-file>

CapabilityBoundingSet=CAP_SETGID CAP_SETUID CAP_SYS_RESOURCE CAP_NET_ADMIN CAP_NET_RAW

# User=brent
# Group=brent
```

## gw01 gateway test

```bash
ssh brent@gw01
ping 172.16.2.1
# from a vm on the 172.16.2.0/24 ping the internet with gateway set to 172.16.2.1.
ssh brent@172.16.2.2
ping google.com
```

## deploy service

```bash
ssh brent@gw01
sudo mkdir -p /etc/rules/moto/
exit

cd ~/src/repsys/research/m_z/virtualization/networking/natting/gateway/gw01/
lftp brent@gw01
cd /etc/rules/gw01
mput *.sh 
cd /etc/systemd/system/
mput gw01.service
exit
ssh brent@gw01
sudo chmod 777 /etc/systemd/system/gw01.service
ls -alh /etc/systemd/system/gw01.service
sudo chmod 777 /etc/rules/gw01/*
ls -alh /etc/rules/gw01/

# sudo systemctl daemon-reload
sudo systemctl start gw01


journalctl -u gw01.service -f 
# or if there were issues starting service
journalctl -f 

# from 2nd terminal
pushd .
cd ~/src/repsys/research/m_z/virtualization/networking/natting/gateway/moto
sudo mkdir -p /etc/rules/moto/
sudo cp moto*.sh /etc/rules/moto/
ls -alh /etc/rules/moto/
drwxr-xr-x 2 root root 4.0K Jun 13 16:18 .
drwxr-xr-x 3 root root 4.0K Jun 13 15:50 ..
-rwxr-xr-x 1 root root 3.9K Jun 13 16:18 motostart.sh
-rwxr-xr-x 1 root root 4.0K Jun 13 16:18 motostop.sh

sudo cp moto.service /etc/systemd/system/
ls /etc/systemd/system/moto.service
# sudo systemctl daemon-reload
sudo systemctl start moto


# from 1st terminal
journalctl -u moto.service -f 
Jun 13 16:21:22 moto.busche-cnc.com systemd[1]: Starting Iptables rules to make moto a gateway for 172.16.2.0/24....
Jun 13 16:21:22 moto.busche-cnc.com motostart.sh[86105]: Starting the start script...
Jun 13 16:21:22 moto.busche-cnc.com motostart.sh[86105]: start log level 1
Jun 13 16:21:22 moto.busche-cnc.com motostart.sh[86105]: start log level 2
Jun 13 16:21:22 moto.busche-cnc.com motostart.sh[86105]: start log level 3
Jun 13 16:21:22 moto.busche-cnc.com motostart.sh[86105]: start log level 4
Jun 13 16:21:22 moto.busche-cnc.com motostart.sh[86105]: Ending the start script...
Jun 13 16:21:22 moto.busche-cnc.com motostart.sh[86107]: iptables: Bad rule (does a matching rule exist in that chain?).
Jun 13 16:21:22 moto.busche-cnc.com motostart.sh[86109]: iptables: Bad rule (does a matching rule exist in that chain?).
Jun 13 16:21:22 moto.busche-cnc.com systemd[1]: Finished Iptables rules to make moto a gateway for 172.16.2.0/24..

# check log
cat /etc/rules/moto/log       
Starting moto service using motostart.sh at Fri Jun 13 04:21:22 PM EDT 2025
Successfully started moto service using motostart.sh at Fri Jun 13 04:21:22 PM EDT 2025

## check it out
systemctl status moto.service
● moto.service - Iptables rules to make moto a gateway for 172.16.2.0/24.
     Loaded: loaded (/etc/systemd/system/moto.service; disabled; vendor preset: enabled)
     Active: active (exited) since Fri 2025-06-13 16:21:22 EDT; 2min 8s ago
    Process: 86105 ExecStart=/etc/rules/moto/motostart.sh (code=exited, status=0/SUCCESS)
   Main PID: 86105 (code=exited, status=0/SUCCESS)
        CPU: 10ms

Jun 13 16:21:22 moto.busche-cnc.com systemd[1]: Starting Iptables rules to make moto a gateway for 172.16.2.0/24....
Jun 13 16:21:22 moto.busche-cnc.com motostart.sh[86105]: Starting the start script...
Jun 13 16:21:22 moto.busche-cnc.com motostart.sh[86105]: start log level 1
Jun 13 16:21:22 moto.busche-cnc.com motostart.sh[86105]: start log level 2
Jun 13 16:21:22 moto.busche-cnc.com motostart.sh[86105]: start log level 3
Jun 13 16:21:22 moto.busche-cnc.com motostart.sh[86105]: start log level 4
Jun 13 16:21:22 moto.busche-cnc.com motostart.sh[86105]: Ending the start script...
Jun 13 16:21:22 moto.busche-cnc.com motostart.sh[86107]: iptables: Bad rule (does a matching rule exist in that chain?).
Jun 13 16:21:22 moto.busche-cnc.com motostart.sh[86109]: iptables: Bad rule (does a matching rule exist in that chain?).
Jun 13 16:21:22 moto.busche-cnc.com systemd[1]: Finished Iptables rules to make moto a gateway for 172.16.2.0/24..

# verify rules were added
sudo iptables -S                
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
-A FORWARD -d 10.187.220.52/32 -p tcp -m tcp --dport 443 -j ACCEPT
-A FORWARD -s 10.187.220.52/32 -p tcp -m tcp --sport 443 -j ACCEPT

sudo iptables -t nat -S
-P PREROUTING ACCEPT
-P INPUT ACCEPT
-P OUTPUT ACCEPT
-P POSTROUTING ACCEPT
-A PREROUTING -d 10.187.40.123/32 -p tcp -m tcp --dport 443 -j DNAT --to-destination 10.187.220.52:443
-A POSTROUTING -d 10.187.220.52/32 -p tcp -m tcp --dport 443 -j SNAT --to-source 10.187.40.123

```

## test from research21

Does the natting rules mess up normal access to mach2 from the port forwarding host? Works as expected the firewall rules does not hamper connecting to mach2 directly from research21.

```bash
# openssl s_client -showcerts -connect 10.188.220.50:443 -servername reports11 -CApath /etc/ssl/certs -
openssl s_client -showcerts -connect 10.187.220.52:443
Cant use SSL_get_servername
depth=2 C = US, ST = Indiana, L = Albion, O = Mobex Global, CN = Root CA
verify error:num=19:self-signed certificate in certificate chain
verify return:1
depth=2 C = US, ST = Indiana, L = Albion, O = Mobex Global, CN = Root CA
verify return:1
depth=1 C = US, ST = Indiana, O = Mobex Global, CN = Intermediate CA
verify return:1
depth=0 C = US
verify return:1
...

# Works as expected the firewall rules does not hamper connecting to mach2 directly from research21
```

## test from other machine

```bash
# from port forwarding host
sudo tcpdump -i enp0s25 'dst 10.187.40.123 and src 10.188.50.202'
# sudo tcpdump -i enp0s25 'dst 10.187.220.52 and src 10.187.40.123'

# go to k8s server
ssh brent@10.188.50.202
# verify it has no access to mach2 server
ping 10.187.220.52
# no access
openssl s_client -showcerts -connect 10.187.220.52:443
# no access

# now try to access the mach2 server via the port forwarding host.
# openssl s_client -showcerts -connect 10.188.220.50:443 -servername reports11 -CApath /etc/ssl/certs -
openssl s_client -showcerts -connect 10.187.40.123:443
Cant use SSL_get_servername
depth=2 C = US, ST = Indiana, L = Albion, O = Mobex Global, CN = Root CA
verify error:num=19:self-signed certificate in certificate chain
verify return:1
depth=2 C = US, ST = Indiana, L = Albion, O = Mobex Global, CN = Root CA
verify return:1
depth=1 C = US, ST = Indiana, O = Mobex Global, CN = Intermediate CA
verify return:1
depth=0 C = US
verify return:1

...

# Works as expected the firewall rules does not hamper connecting to mach2 directly from research21
```

## stop the service

```bash

# stop service
sudo systemctl stop albmach2s2

# check status
systemctl status albmach2s2.service

May 08 15:36:56 research21 systemd[1]: Finished iptest3.service - Iptables firewall rules test3.
May 08 15:39:00 research21 systemd[1]: Stopping iptest3.service - Iptables firewall rules test3...
May 08 15:39:00 research21 iptest3stop.sh[661615]: Starting the stop script...
May 08 15:39:00 research21 iptest3stop.sh[661615]: stop log level 1
May 08 15:39:00 research21 iptest3stop.sh[661615]: stop log level 2
May 08 15:39:00 research21 iptest3stop.sh[661615]: stop log level 3
May 08 15:39:00 research21 iptest3stop.sh[661615]: stop log level 4
May 08 15:39:00 research21 iptest3stop.sh[661615]: Ending the stop script...
May 08 15:39:00 research21 systemd[1]: iptest3.service: Deactivated successfully.
May 08 15:39:00 research21 systemd[1]: Stopped iptest3.service - Iptables firewall rules test3.

## look at log file
cat /etc/myscripts/albmach2s2/log       


Starting Albion Mach2 S2 service using albmach2s2start.sh at Fri May  9 03:58:57 PM EDT 2025
Successfully started albmach2 S2 service using albmach2s2start.sh at Fri May  9 03:58:57 PM EDT 2025
Stopping albmach2s2 service using albmach2s2stop.sh at Fri May  9 05:42:32 PM EDT 2025
Successfully Stopped albmach2s2 service using albmach2s2stop.sh at Fri May  9 05:42:32 PM EDT 2025

# verify rules were deleted
sudo iptables -S                
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT

sudo iptables -t nat -S
-P PREROUTING ACCEPT
-P INPUT ACCEPT
-P OUTPUT ACCEPT
-P POSTROUTING ACCEPT
```

## enable service

```bash
sudo systemctl enable albmach2s2
[sudo] password for brent:
Created symlink /etc/systemd/system/multi-user.target.wants/albmach2s2.service → /etc/systemd/system/albmach2s2.service.
```

## verify service running after reboot

```bash
sudo reboot now

# after reboot
# verify rules were added
sudo iptables -S                
[sudo] password for brent: 
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
-A FORWARD -d 10.187.220.52/32 -p tcp -m tcp --dport 443 -j ACCEPT
-A FORWARD -s 10.187.220.52/32 -p tcp -m tcp --sport 443 -j ACCEPT

sudo iptables -t nat -S
-P PREROUTING ACCEPT
-P INPUT ACCEPT
-P OUTPUT ACCEPT
-P POSTROUTING ACCEPT
-A PREROUTING -d 10.187.40.123/32 -p tcp -m tcp --dport 443 -j DNAT --to-destination 10.187.220.52:443
-A POSTROUTING -d 10.187.220.52/32 -p tcp -m tcp --dport 443 -j SNAT --to-source 10.187.40.123

# test access from kwsgw2
ssh brent@10.188.50.202
openssl s_client -showcerts -connect 10.187.40.123:443
CONNECTED(00000003)
Can't use SSL_get_servername
depth=2 C = US, ST = Indiana, L = Albion, O = Mobex Global, CN = Root CA
verify error:num=19:self-signed certificate in certificate chain
verify return:1
depth=2 C = US, ST = Indiana, L = Albion, O = Mobex Global, CN = Root CA
verify return:1
depth=1 C = US, ST = Indiana, O = Mobex Global, CN = Intermediate CA
verify return:1
depth=0 C = US
verify return:1

```
