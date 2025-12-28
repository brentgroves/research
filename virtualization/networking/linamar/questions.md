# Linamar Network Questions

## How to collect data from moxa server

configure a trunk port in albion for 50 and 70 vlans and make 50 the default for untagged traffic. Listen on 70 IP and send data to 10.188.50.202 or Azure SQL db.

## Can I see 10.187.50.0/24 from Avilla

change address of laptop to 10.187.220.230/24.
No, if 10.187.220.51, can connect to 10.187.73.0/24, there must be a host route setup from Avilla to Albion.

```bash
ip route show table all
...
nmap -v -sn 10.187.220.0/24
no hosts
```

## Are there any IP network routes from 10.188 to 10.187 or vise-versa?

Yes. The following routes exist.

10.187.40.0/24 to 10.188.40.0/24
10.188.40.0/24 to 10.187.40.0/24

```bash
ssh brent@10.188.40.230
nmap -v -sn 10.188.73.0/24
no hosts
If Mach2 is able to communicate with the honda vlan there my be a host route instead of network route.

traceroute 10.187.40.123
Note: no gateway entry.
1 10.188.40.251 // Jared said this is a fortigate ip
2 10.187.249.11 // Goes to the AOS transport circuit.
3 10.187.40.123 // host

AOS transport circuit
10.x.10.11
10.y.10.11

traceroute 10.188.50.202
1 10.188.40.251 // ?
2 10.188.50.202

ssh brent@10.187.40.123
traceroute 10.188.50.202
_gateway (10.187.40.254)
10.188.249.1
10.188.50.202
```

## Can I see honda vlan 70 from 220 address

No. There is not a network route from 10.188.220.0/24 to 10.187.73.0/24

Is the Avilla 73 vlan cofigured with access to the 220 vlan?
Is this a routing rule that has been created on the Avilla FW 10.188.255.11?

src: 10.188.220.230
dest: 10.188.73.0/24
result: did not work.

maybe the route is a host only route such as:
src: 10.188.220.50
dst: 10.188.73.0/24

## What Avilla VLAN has access to Albion Kobe VLAN

Look at core IP router:

to (Alvilla): 10.188.40.0/24
via: 10.187.40.0/24
