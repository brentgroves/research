# Network access tests

## Step 5: Verify access from routable networks to the each host IP

```bash
ping 10.184.40.254
ping 10.185.40.254
ping 10.187.40.254
ping 10.189.40.254
ping 10.188.50.254
ping 10.188.220.254
ping 10.188.73.254
ping 10.188.42.254 
ping 10.185.50.254
ping 10.181.50.254

nmap -sP 10.187.40.0/24
nmap -sP 10.188.40.0/24
nmap -sP 10.184.40.0/24
nmap -sP 10.185.40.0/24
nmap -sP 10.189.40.0/24

nmap -sP 10.187.70.0/24
nmap -sP 10.188.73.0/24

```

```yaml
frt: 10.184
mus: 10.181
sou: 10.185
alb1: 10.187
avi: 10.188
alb2: 10.189
```

```bash
microk8s kubectl run -it --tty --rm debug --image=alpine --restart=Never -- sh
ping 10.188.50.79
ping 10.188.220.50
ping 10.188.73.11
ping 10.188.50.212 # laptop
ping 10.188.42.11 
ping 172.20.88.64 # no longer exists
ping 10.185.50.11
ping 10.181.50.15
ping 10.187.40.15 # did not work
# FW rules
curl https://api.snapcraft.io
snapcraft.io store API service - Copyright 2018-2022 Canonical.
```

```bash
# From system with access to Plex databases
telnet test.odbc.plex.com 19995
Trying 38.97.236.97...
Connected to test.odbc.plex.com.
Escape character is '^]'.
Trying 38.97.236.97...
curl -vv telnet://nodejs.org:443
curl -vv telnet://anaconda:443
# ERROR
# curl: (6) Could not resolve host: anaconda
curl -vv telnet://go.dev:443
20:44:27.531431 [0-0] * Host go.dev:443 was resolved.
20:44:27.531620 [0-0] * IPv6: 2001:4860:4802:36::15, 2001:4860:4802:32::15, 2001:4860:4802:34::15, 2001:4860:4802:38::15
20:44:27.533038 [0-0] * IPv4: 216.239.34.21, 216.239.38.21, 216.239.32.21, 216.239.36.21
20:44:27.534016 [0-0] * [SETUP] added
20:44:27.534300 [0-0] *   Trying [2001:4860:4802:36::15]:443...
20:44:27.535704 [0-0] * Immediate connect fail for 2001:4860:4802:36::15: Network unreachable
20:44:27.536456 [0-0] *   Trying [2001:4860:4802:32::15]:443...
20:44:27.537119 [0-0] * Immediate connect fail for 2001:4860:4802:32::15: Network unreachable
20:44:27.537337 [0-0] *   Trying [2001:4860:4802:34::15]:443...
20:44:27.538178 [0-0] * Immediate connect fail for 2001:4860:4802:34::15: Network unreachable
20:44:27.538373 [0-0] *   Trying [2001:4860:4802:38::15]:443...
20:44:27.538544 [0-0] * Immediate connect fail for 2001:4860:4802:38::15: Network unreachable
20:44:27.538737 [0-0] *   Trying 216.239.34.21:443...

curl -vv telnet://golang:443
20:45:33.506383 [0-0] * Could not resolve host: golang
20:45:33.506646 [0-x] * shutting down connection #0
curl: (6) Could not resolve host: golang

Note: Notice IP6 access to these domains are not enabled, but IP4 access is.
# OCI container registries
curl -vv telnet://docker.io:443
curl -vv telnet://k8s.io:443
curl -vv telnet://registry.k8s.io:443
curl -vv telnet://test.odbc.plex.com:19995
curl -vv telnet://quay.io:443
curl -vv telnet://gcr.io:443
curl -vv telnet://mcr.microsoft.com:443
curl -vv telnet://ghcr.io:443

```

## Step 5: Verify access from routable networks to the each host IP

```bash
ping 10.184.40.254
ping 10.185.40.254
ping 10.187.40.254
ping 10.189.40.254

nmap -sP 10.187.40.0/24
nmap -sP 10.188.40.0/24
nmap -sP 10.184.40.0/24
nmap -sP 10.185.40.0/24
nmap -sP 10.189.40.0/24

nmap -sP 10.187.70.0/24
nmap -sP 10.188.73.0/24

```

```yaml
frt: 10.184
mus: 10.181
sou: 10.185
alb1: 10.187
avi: 10.188
alb2: 10.189
```

### Step 5: Repeat for every network that has access to the VM

```bash
ssh brent@10.188.40.230
ping 10.188.50.214
ping 10.188.220.214
```

## Starting and Stopping MicroK8s

MicroK8s will continue running until you decide to stop it. You can stop and start MicroK8s with these simple commands:

```bash
microk8s stop

# … will stop MicroK8s and its services. You can start again any time by running:

microk8s start

# Note that if you leave MicroK8s running, it will automatically restart after a reboot. If you don’t want this to happen, simply remember to run microk8s stop before you power down.
```

## Network tests

- core images required to bring up MicroK8s

  ```bash
  docker.io/calico/cni:v3.28.1
  docker.io/calico/kube-controllers:v3.28.1
  docker.io/calico/node:v3.28.1
  docker.io/cdkbot/hostpath-provisioner:1.5.0
  docker.io/coredns/coredns:1.12.0
  docker.io/library/busybox:1.28.4
  registry.k8s.io/ingress-nginx/controller:v1.12.0
  registry.k8s.io/metrics-server/metrics-server:v0.7.2
  registry.k8s.io/pause:3.10
  ```
