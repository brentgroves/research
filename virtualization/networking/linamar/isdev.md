# isdev

routes:

Ubuntu desktop 24.04 can have two default routes, often due to having both Ethernet and Wi-Fi connections active, with the system prioritizing the route with the lower metric (or hop count).

Note:

Both access to github using https port 443 and ssh port 22 is working by using 10.188.50.212 for https and Linamar-Wifi for ssh without adding specific route using nmcli.

## process to add specific routes using nmcli

### Not needed in network manager when multiple default routes provide all of the access needed

```bash
github -> 10.188.50.212
curl -vv telnet://github.com:443
# wifi on we have 2 default routes and the wired route is preferred
ip route show 
default via 10.188.50.254 dev enxf8e43bed63bd proto static metric 100 
default via 172.25.189.254 dev wlp114s0f0 proto dhcp src 172.25.188.34 metric 600 

# make wired connections metric 800 so that normally Linamar wifi will be used. Changes are not live.
nmcli connection modify "Linamar-Wifi" ipv4.route-metric 600
# Changes are not activiated until you bring the connection up again
nmcli connection up "Linamar-Wifi"
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/8)

nmcli connection modify "Wired connection 1" ipv4.route-metric 800
# Changes are not activiated until you bring the connection up again
nmcli connection up "Wired connection 1"
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/8)

# verify route metrics were changed
ip route show     
default via 172.25.189.254 dev wlp114s0f0 proto dhcp src 172.25.188.34 metric 600 
default via 10.188.50.254 dev enxf8e43bed63bd proto static metric 800 
10.188.50.0/24 dev enxf8e43bed63bd proto kernel scope link src 10.188.50.212 metric 800 
140.82.112.0/24 via 10.188.50.254 dev enxf8e43bed63bd proto static metric 100 
172.25.188.0/23 dev wlp114s0f0 proto kernel scope link src 172.25.188.34 metric 600 

# https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/configuring_and_managing_networking/configuring-static-routes_configuring-and-managing-networking#how-to-use-the-nmcli-command-to-configure-a-static-route_configuring-static-routes

# Make routes to domain not accessable to Linamar Wifi
ping github.com
140.82.112.3
nmcli connection show

# For Github using https port 443
# nmcli connection modify connection_name ipv4.routes "ip[/prefix] [next_hop] [metric] [attribute=value] [attribute=value] ..."
nmcli connection modify "Wired connection 1" +ipv4.routes "140.82.112.0/24 10.188.50.254 90"
nmcli connection modify "Wired connection 1" +ipv4.routes "140.82.113.0/24 10.188.50.254 90"

## to delete the route add minus before ipv4.routes
nmcli connection modify "Wired connection 1" -ipv4.routes "140.82.112.0/24"
# Changes are not activiated until you bring the connection up again
nmcli connection up "Wired connection 1"

# For Github using SSH port 22
## First delete the Github Https port 443 route by adding the minus before ipv4.routes
nmcli connection modify "Wired connection 1" -ipv4.routes "140.82.112.0/24"


## This is not necessary if Linamar-Wifi has the lowest default route metric.
nmcli connection modify "Linamar-Wifi" ipv4.routes "140.82.112.0/24 172.25.189.254 100"

nmcli connection up "Linamar-Wifi"
# How to find the route used for an destination IP
# The syntax is as follows:
# ip route get to {IPv4_address_here}
# ip route get to {IPv6_address_here}

# Verify github.com is accessed from wired connection.
ip route get to 140.82.112.3
140.82.112.3 via 10.188.50.254 dev enxf8e43bed63bd src 10.188.50.212 uid 1000 
    cache 
Outputs indicating that 140.82.112.3 can be reached via the enxf8e43bed63bd interface with 10.188.50.254 as source IP:

```

## Test the new configuration

```bash
curl -vv telnet://github.com:443
curl -vv telnet://google.com:443 # works as expected

# Traceroute always takes 172.25.189.254 even for github
 traceroute github.com
traceroute to github.com (140.82.114.4), 64 hops max
  1   172.25.189.254  3.279ms  4.361ms  3.083ms 
  2   64.184.36.160  5.042ms  4.853ms  5.311ms 
  3   67.217.162.1  9.814ms  7.465ms  7.571ms 

traceroute google.com   
traceroute to google.com (142.250.191.110), 64 hops max
  1   172.25.189.254  8.703ms  4.451ms  5.666ms 
  2   64.184.36.160  7.555ms  6.254ms  8.608ms 
  3   4.71.246.193  17.498ms  16.446ms  15.372ms 
  4   *  *  * 
  5   4.68.127.114  13.256ms  14.533ms  12.204ms 
  6   *  *  * 
  7   142.251.60.20  15.153ms  11.700ms  10.990ms 
  8   192.178.105.216  11.075ms  11.563ms  11.019ms 
  9   142.250.191.110  11.539ms  10.882ms  10.905ms 

# From system with access to Plex databases
curl -vv telnet://test.odbc.plex.com:19995
curl -vv telnet://odbc.plex.com:19995
curl -vv telnet://mgsqlmi.public.48d444e7f69b.database.windows.net:3342
curl -vv telnet://repsys1.database.windows.net:1433

# github pull ssh
cd ~/src/mobexsql
git pull
ok
startday.sh
ok
```
