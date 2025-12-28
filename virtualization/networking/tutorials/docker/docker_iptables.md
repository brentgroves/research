# **[IPTables and Docker](https://medium.com/@ebuschini/iptables-and-docker-95e2496f0b45#id_token=eyJhbGciOiJSUzI1NiIsImtpZCI6IjIzZjdhMzU4Mzc5NmY5NzEyOWU1NDE4ZjliMjEzNmZjYzBhOTY0NjIiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTYyOTYwMzU4MzQtazFrNnFlMDYwczJ0cDJhMmphbTRsamRjbXMwMHN0dGcuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTYyOTYwMzU4MzQtazFrNnFlMDYwczJ0cDJhMmphbTRsamRjbXMwMHN0dGcuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTM3NzAwNDYwNDMyMTAxNTEyNTIiLCJlbWFpbCI6ImJyZW50Lmdyb3Zlc0BnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwibmJmIjoxNzQ1NTI5OTU2LCJuYW1lIjoiYnJlbnQgZ3JvdmVzIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hL0FDZzhvY0xyV2tISmQ5NFZUMUFlY0lLRTRFV2ZKaGd5S29HX09GUDVpd29SRlB6eUdkWHpMMTA9czk2LWMiLCJnaXZlbl9uYW1lIjoiYnJlbnQiLCJmYW1pbHlfbmFtZSI6Imdyb3ZlcyIsImlhdCI6MTc0NTUzMDI1NiwiZXhwIjoxNzQ1NTMzODU2LCJqdGkiOiI1YmI0MjQ4NTNkN2JmNGRiMjliMDI1ZjZkNDc2ZWU3YzllODNlNDFkIn0.araqDusUai_QLNNu3XZ5uEYse5C9tGTrcWtudHcQUiwYo2l_zxBjBwyGYL0up6tqB1_mRL0YcXc1blYmQv3CbsLQReQlKJV_hTja0qiWesSyYfDgsm3wuCgtY9yPkGFcbU09zDek6QiXi2OfJ2mQIwoUXdfVRNRcltLAHneypBItfDP2CyDxMX_sdHxqJcLZsfacDgjju_P9AcOuRdIplbJLSdfvEUEStSzaqlSswo1jUlxU9TnxnCXQIxAbZnX_cnB8Y9DXNMeh2yn5TyR4BMKxDx6wW7cgKoUd9ZGvODVekL-XZbUSWMKH_e_kqA7ni-8qjvL8d3gXnbFekJK48w)**

In this post I will be talking about the nightmare of all Ops people that have to deal with Docker.

We all know that Docker is awesome.

It makes our lives really easy, but there is one problem. It works with IPTables for who don’t know the default firewall on Linux .

Docker creates IPTables rules for you and it becomes really hard to manage if you need to control what goes in and out your server when you install Docker in production.

## The issue

Let’s say you have a container that listen on port 443 . You only want to allow traffic from your load balancers as it handles some of the security for you. Nothing really hard right?

The naive approach is to create a rules on the default INPUT chain which will have kind of the following:

`iptables -A INPUT -p tcp --dport 443 -s 172.16.0.0/26 -m state --state NEW,ESTABLISHED`

This rule says: allow new and established inbound traffic from the 172.16.0.0/26 network to the port 443 on the tcp protocol.

You put your iptables -A INPUT -j DROP at the end and then you are happy because you think it works! So you try from your machine and the port is still open for you. Hummm, weird?

Not that weird. The issue here is that since Docker creates interfaces for the container when you don’t specify --net=host . Those interfaces have an IP address on it. They usually are using the 172.17.0.0/24 network. And the most important of all, they are only routable from the host, not to the rest of the network — that’s why you do -p to expose the port so the host will listen and forward the traffic to the container.

## Forwarding traffic 101

Each container invocation will create a rule looking like this:

`iptables -A DOCKER -d 172.17.0.2/32 ! -i docker0 -o docker0 -p tcp -m tcp — dport 443 -j ACCEPT`

Which is the exported port and says that accept everything that does not come from the docker interface to the docker interface to the ip of the container.

This DOCKER chain is referenced in the FORWARD chain like this: -A FORWARD -o docker0 -j DOCKER . The FORWARD chain is there when traffic is transferred from interfaces to interfaces.

```bash
Chain DOCKER (1 references)
pkts bytes target prot opt in out source destination
0 0 ACCEPT tcp — !docker0 docker0 0.0.0.0/0 172.17.0.2 tcp dpt:443
```

Well as you can, this is not it because there are no packets that have match that rule so far!

We need to dig deeper. So let’s take a step back and understand how the iptables filtering and ordering works. A quick google search yields the following:

![i1](https://miro.medium.com/v2/resize:fit:720/format:webp/1*OIoNQkH4RTSm-eY2lUMBcQ.jpeg)

So the INPUT chain is only processed after deciding if the packet needed to be nat’ed or not.

It is clear that there is something else in the process.

What I did not know is that there were multiple tables in iptables ! The default table is called filter and it’s the most used one.

But packets are processed by the nat tables first!!

`-A PREROUTING -m addrtype — dst-type LOCAL -j DOCKER`

Dammit, everything is routed to the DOCKER chain in the nat table!!!!

`-A DOCKER ! -i docker0 -p tcp -m tcp — dport 443 -j DNAT — to-destination 172.17.0.2:443`

And here we go, the packet’s destination is changed to 172.17.0.2:443 , so any filtering on INPUT will not work…

How are we going to be able to block the traffic without touching to Docker.

Some people have talked about the DOCKER-USER chain, which would do the work, but you kind of have the same problem because of the NAT. Some other people said to deactivate the Docker feature to maintain the rules directly. This is a really bad idea, as you don’t want to re-invent some intelligence that will do that for you.

Remember? You only want to protect your server, not mess up with actual workflow. Well my friends, I have the solution for you.

It’s from a bag of tricks. We need to act in the nat tables in order to block stuff.

The idea is quite simple:
