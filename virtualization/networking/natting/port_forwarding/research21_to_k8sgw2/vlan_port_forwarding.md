# **[Linux Gateway using iptables](https://superuser.com/questions/1286555/iptables-port-forwarding-with-internal-snat#:~:text=1%20Answer,%2D%2Dto%2Dsource%20192.168.2.5)**

**[Back to Research List](../../../../../../research_list.md)**\
**[Back to Current Tasks](../../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../../README.md)**

In networking, a **packet** is the basic unit of data transmitted over a network, typically at the network layer (Layer 3 of the OSI model). A **frame**, on the other hand, encapsulates a packet and other information for transmission across a specific network technology at the data link layer (Layer 2 of the OSI model). Think of **it like putting a letter (the packet) into an envelope (the frame)** for mailing.

![iptfc1](https://miro.medium.com/v2/resize:fit:720/format:webp/1*OIoNQkH4RTSm-eY2lUMBcQ.jpeg)**

| Tables↓/Chains→               | PREROUTING | INPUT | FORWARD | OUTPUT | POSTROUTING |
|-------------------------------|------------|-------|---------|--------|-------------|
| (routing decision)            |            |       |         | ✓      |             |
| raw                           | ✓          |       |         | ✓      |             |
| (connection tracking enabled) | ✓          |       |         | ✓      |             |
| mangle                        | ✓          | ✓     | ✓       | ✓      | ✓           |
| nat (DNAT)                    | ✓          |       |         | ✓      |             |
| (routing decision)            | ✓          |       |         | ✓      |             |
| filter                        |            | ✓     | ✓       | ✓      |             |
| security                      |            | ✓     | ✓       | ✓      |             |
| nat (SNAT)                    |            | ✓     |         |        | ✓           |

- Incoming packets destined for the local system: PREROUTING -> INPUT
- Incoming packets destined to another host: PREROUTING -> FORWARD -> POSTROUTING
- Locally generated packets: OUTPUT -> POSTROUTING

![ipt](https://stuffphilwrites.com/wp-content/uploads/2024/05/FW-IDS-iptables-Flowchart-v2024-05-22-768x978.png)**

## **[Architecture](https://www.digitalocean.com/community/tutorials/a-deep-dive-into-iptables-and-netfilter-architecture)**

## **[summary](https://superuser.com/questions/1286555/iptables-port-forwarding-with-internal-snat#:~:text=1%20Answer,%2D%2Dto%2Dsource%20192.168.2.5)**

## rules

- allow forwarding *to* destination ip:port
- allow forwarding *from* destination ip:port
- nat packets identified by arrival at external IP / port to have
*destination* internal ip:port
- nat packets identified by arrival at internal IP / port to have
*source* internal network IP of gateway machine

```bash
# Gateway = 1.2.3.4/192.168.2.5, internal server = 192.168.2.10
sudo su
iptables -S
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT

# allow inbound and outbound forwarding
# iptables -A FORWARD -p tcp -d 192.168.2.10 --dport 54321 -j ACCEPT
iptables -A FORWARD -p tcp -d 10.188.50.202 --dport 8080 -j ACCEPT
# iptables -A FORWARD -p tcp -s 192.168.2.10 --sport 54321 -j ACCEPT
iptables -A FORWARD -p tcp -s 10.188.50.202 --sport 8080 -j ACCEPT

iptables -S
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
-A FORWARD -s 10.188.50.202/32 -p tcp -m tcp --sport 8080 -j ACCEPT
-A FORWARD -d 10.188.50.202/32 -p tcp -m tcp --dport 8080 -j ACCEPT

# iptables -t nat -S
# route packets arriving at external IP/port to LAN machine
iptables -t nat -A PREROUTING -p tcp -d 10.187.40.123 --dport 8080 -j DNAT --to-destination 10.188.50.202:8080

# rewrite packets going to LAN machine (identified by address/port)
# to originate from gateway's internal address
iptables -t nat -A POSTROUTING -p tcp -d 10.188.50.202 --dport 8080 -j SNAT --to-source 10.187.40.123

iptables -t nat -S
-P PREROUTING ACCEPT
-P INPUT ACCEPT
-P OUTPUT ACCEPT
-P POSTROUTING ACCEPT
-A PREROUTING -d 10.187.40.123/32 -p tcp -m tcp --dport 8080 -j DNAT --to-destination 10.188.50.202:8080
-A POSTROUTING -d 10.188.50.202/32 -p tcp -m tcp --dport 8080 -j SNAT --to-source 10.187.40.123
```

## request and response flow

1. client requests 10.187.40.123:8080
2. gateway changes destination to 10.188.50.202:8080
It's ok to forward packets to 10.188.50.202:8080
`iptables -A FORWARD -p tcp -d 10.188.50.202 --dport 8080 -j ACCEPT`
Netfilter hook changes the destination of packet.
iptables -t nat -A PREROUTING -p tcp -d 10.187.40.123 --dport 8080 -j DNAT --to-destination 10.188.50.202:8080
3. gateway changes source from client to gateway's ip 10.187.40.123.
`iptables -t nat -A POSTROUTING -p tcp -d 10.188.50.202 --dport 8080 -j SNAT --to-source 10.187.40.123`
Netfilter keeps track of network request's original source IP for reversal of response.
4. Netsocket service host completes request and responds to the natted gateway IP.
5. Netfilter recognizes the response as being from the client machine's request and changes the destination from the gateway's IP to the client's IP.
`iptables -A FORWARD -p tcp -s 10.188.50.202 --sport 8080 -j ACCEPT`
I'm unsure of if netfilter also changes the source IP from the Netsocket service host to the gateway's IP.

## Run a Python Flask web server

So, with that set up, we should be able to run a server on 10.188.50.202:8080. Using this Python code in the file server.py

```python
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello from Flask!\n'

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
```

Start the server.

```bash
ssh brent@10.188.50.202
# namespace has no dns so add dependancies in default namespace
mkdir -p ~/src/python/veths_and_namespaces
cd ~/src/python/veths_and_namespaces
uv init
Initialized project `veths-and-namespaces-md`
uv add flask
Using CPython 3.13.3
Creating virtual environment at: .venv
⠇ veths-and-namespaces==0.1.
...then we run it:

uv run server.py
```

From another terminal on the gateway machine start tcpdump

```bash
sudo tcpdump -i enp0s25 'src 10.187.40.18 and dst 10.187.40.123 and dst port 8080'
```

From another machine with access to the gateway machine.

```bash
curl https://10.188.40.123:8080

Hello from Flask!
```

## Make IPTable rules persistent

There are many programs which add network rules using IPtables such as KVM, docker, and MicroK8s.  These programs don't just save and restore all IPtable rules.  I don't want to either. I only want to save the IPtable rules needed to get port forwarding from 10.187.40.123 to 10.188.50.202 to work.  Do this using Systemd.

Make **[IPtable rules permanent](https://www.tutorialspoint.com/run-a-script-on-startup-in-linux#:~:text=Make%20the%20script%20file%20executable,scriptname%20defaults%22%20in%20the%20terminal.)** without disrupting other programs such as KVM, docker, and MicroK8s which also add there own rules.
