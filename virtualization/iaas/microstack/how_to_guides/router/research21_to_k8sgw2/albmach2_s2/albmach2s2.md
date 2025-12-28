# SystemD iptables Albion Mach2 Port Forwarding

`PD-ALB-MACH2-S2.linamar.com (10.187.220.52)`

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

## Albion Mach2 port forwarding

Tried to run as iptables commands as User=brent but it did not work even with CAP_NET_RAW set.

```bash
# <https://unix.stackexchange.com/questions/694357/how-to-invoke-iptables-from-systemd-unit-file>

CapabilityBoundingSet=CAP_SETGID CAP_SETUID CAP_SYS_RESOURCE CAP_NET_ADMIN CAP_NET_RAW

# User=brent
# Group=brent
```

## accessible from firewall machine test

```bash
# openssl s_client -showcerts -connect 10.188.220.50:443 -servername reports11 -CApath /etc/ssl/certs -
openssl s_client -showcerts -connect 10.187.220.52:443
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
...
```

## deploy service

```bash
# from 1st terminal
journalctl -u albmach2s2.service -f 
# or if there were issues starting service
journalctl -f 

# from 2nd terminal
pushd .
cd ~/src/repsys/research/m_z/systemd/iptables/albmach2s2
mkdir -p /etc/myscripts/albmach2s2/
sudo cp albmach2*.sh /etc/myscripts/albmach2s2/
ls -alh /etc/myscripts/albmach2s2/
total 24K
drwxr-xr-x 2 root root 4.0K May  9 15:46 .
drwxr-xr-x 3 root root 4.0K May  9 15:40 ..
-rwxr-xr-x 1 root root 4.5K May  9 15:46 albmach2s2start.sh
-rwxr-xr-x 1 root root 4.2K May  9 15:46 albmach2s2stop.sh


sudo cp albmach2s2.service /etc/systemd/system/
# sudo systemctl daemon-reload
sudo systemctl start albmach2s2


# from 1st terminal
journalctl -u albmach2.service -f 
May 09 15:58:57 research21 systemd[1]: Finished albmach2s2.service - Iptables firewall rules for Port Forwarding to PD-ALB-MACH2-S2.linamar.com (10.187.220.51).

# check log
cat /etc/myscripts/albmach2s2/log       
Starting Albion Mach2 S2 service using albmach2s2start.sh at Fri May  9 03:58:57 PM EDT 2025
Successfully started albmach2 S2 service using albmach2s2start.sh at Fri May  9 03:58:57 PM EDT 2025

## check it out
systemctl status albmach2s2.service
● albmach2s2.service - Iptables firewall rules for Port Forwarding to PD-ALB-MACH2-S2.linamar.com (10.187.220.51)
     Loaded: loaded (/etc/systemd/system/albmach2s2.service; disabled; preset: enabled)
     Active: active (exited) since Fri 2025-05-09 15:58:57 EDT; 2min 27s ago
    Process: 717353 ExecStart=/etc/myscripts/albmach2s2/albmach2s2start.sh (code=exited, status=0/SUCCESS)
   Main PID: 717353 (code=exited, status=0/SUCCESS)
        CPU: 32ms

May 09 15:58:57 research21 albmach2s2start.sh[717353]: start log level 1
May 09 15:58:57 research21 albmach2s2start.sh[717353]: start log level 2
May 09 15:58:57 research21 albmach2s2start.sh[717353]: start log level 3
May 09 15:58:57 research21 albmach2s2start.sh[717353]: start log level 4
May 09 15:58:57 research21 albmach2s2start.sh[717353]: Ending the start script...
May 09 15:58:57 research21 albmach2s2start.sh[717355]: iptables: Bad rule (does a matching rule exist in that chain?).
May 09 15:58:57 research21 albmach2s2start.sh[717357]: iptables: Bad rule (does a matching rule exist in that chain?).
May 09 15:58:57 research21 albmach2s2start.sh[717359]: iptables: Bad rule (does a matching rule exist in that chain?).
May 09 15:58:57 research21 albmach2s2start.sh[717361]: iptables: Bad rule (does a matching rule exist in that chain?).
May 09 15:58:57 research21 systemd[1]: Finished albmach2s2.service - Iptables firewall rules for Port Forwarding to PD-ALB-MACH2-S2.linamar.com (10.187.220.51).

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
