# Microk8s Linamar install try 5

## try 5: configure k8sgw2 with 2 tagged vlans

Do this until r620s have access to VMs on core switch configured for the VLAN 1220 and 10.187.220.0/24 subnet.

## references

- **[Installing MicroK8s Offline or in an airgapped environment](https://microk8s.io/docs/install-offline)**

- Used r620_202 server
- use r620_202_vlan_50_220_tagged.yaml netplan configuration to create 2 tagged vlans and 2 bridges for k8sn211 microk8s node.

- **[setup multipass vm](setup_multipass_vm.md)**

```bash
ssh brent@10.188.50.202
multipass list
Name                    State             IPv4             Image
k8sn2                   Stopped           --               Ubuntu 24.04 LTS
k8sn211                 Running           10.97.219.76     Ubuntu 24.04 LTS
                                          10.188.50.214
                                          10.188.220.214
                                          10.1.146.192
ssh ubuntu@10.188.50.214
# installed microk8s on try 3
sudo snap install microk8s --classic --channel=1.32/stable
[sudo] password for brent: 
microk8s (1.32/stable) v1.32.2 from Canonical✓ installed
microk8s inspect
Inspecting system
Inspecting Certificates
Inspecting services
  Service snap.microk8s.daemon-cluster-agent is running
  Service snap.microk8s.daemon-containerd is running
  Service snap.microk8s.daemon-kubelite is running
  Service snap.microk8s.daemon-k8s-dqlite is running
  Service snap.microk8s.daemon-apiserver-kicker is running
  Copy service arguments to the final report tarball
Inspecting AppArmor configuration
Gathering system information
  Copy processes list to the final report tarball
  Copy disk usage information to the final report tarball
  Copy memory usage information to the final report tarball
  Copy server uptime to the final report tarball
  Copy openSSL information to the final report tarball
  Copy snap list to the final report tarball
  Copy VM name (or none) to the final report tarball
  Copy current linux distribution to the final report tarball
  Copy asnycio usage and limits to the final report tarball
  Copy inotify max_user_instances and max_user_watches to the final report tarball
  Copy network configuration to the final report tarball
Inspecting kubernetes cluster
  Inspect kubernetes cluster
Inspecting dqlite
  Inspect dqlite
cp: cannot stat '/var/snap/microk8s/7964/var/kubernetes/backend/localnode.yaml': No such file or directory

Building the report tarball
  Report tarball is at /var/snap/microk8s/7964/inspection-report-20250411_161835.tar.gz
```

- check status

```bash

microk8s kubectl get ns
NAME              STATUS   AGE
default           Active   24d
innodb            Active   9d
kube-node-lease   Active   24d
kube-public       Active   24d
kube-system       Active   24d
mysql-operator    Active   15d

microk8s kubectl get pods -n kube-system
NAME                                       READY   STATUS    RESTARTS       AGE
calico-kube-controllers-5947598c79-66kgs   1/1     Running   4 (6d9h ago)   24d
calico-node-gmsmh                          1/1     Running   1 (6d9h ago)   11d
coredns-79b94494c7-827cn                   1/1     Running   4 (6d9h ago)   24d
hostpath-provisioner-c778b7559-72qfj       1/1     Running   5 (6d9h ago)   24d

microk8s kubectl get all
NAME                         READY   STATUS    RESTARTS       AGE
pod/mysql-0                  1/1     Running   3 (6d9h ago)   15d
pod/nginx-5869d7778c-9qpbk   1/1     Running   4 (6d9h ago)   24d

NAME                 TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
service/kubernetes   ClusterIP   10.152.183.1     <none>        443/TCP          24d
service/mysql-svc    NodePort    10.152.183.209   <none>        3306:30031/TCP   15d

NAME                    READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx   1/1     1            1           24d

NAME                               DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-5869d7778c   1         1         1       24d

NAME                     READY   AGE
statefulset.apps/mysql   1/1     15d

microk8s status
microk8s is running
high-availability: no
  datastore master nodes: 127.0.0.1:19001
  datastore standby nodes: none
addons:
  enabled:
    dns                  # (core) CoreDNS
    ha-cluster           # (core) Configure high availability on the current node
    helm                 # (core) Helm - the package manager for Kubernetes
    helm3                # (core) Helm 3 - the package manager for Kubernetes
    hostpath-storage     # (core) Storage class; allocates storage from host directory
    rbac                 # (core) Role-Based Access Control for authorisation
    storage              # (core) Alias to hostpath-storage add-on, deprecated
  disabled:
    cert-manager         # (core) Cloud native certificate management
    cis-hardening        # (core) Apply CIS K8s hardening
    community            # (core) The community addons repository
    dashboard            # (core) The Kubernetes dashboard
    gpu                  # (core) Alias to nvidia add-on
    host-access          # (core) Allow Pods connecting to Host services smoothly
    ingress              # (core) Ingress controller for external access
    kube-ovn             # (core) An advanced network fabric for Kubernetes
    mayastor             # (core) OpenEBS MayaStor
    metallb              # (core) Loadbalancer for your Kubernetes cluster
    metrics-server       # (core) K8s Metrics Server for API access to service metrics
    minio                # (core) MinIO object storage
    nvidia               # (core) NVIDIA hardware (GPU and network) support
    observability        # (core) A lightweight observability stack for logs, traces and metrics
    prometheus           # (core) Prometheus operator for monitoring and logging
    registry             # (core) Private image registry exposed on localhost:32000
    rook-ceph            # (core) Distributed Ceph storage using Rook
```

## Access Kubernetes

```bash
microk8s kubectl get nodes
NAME      STATUS   ROLES    AGE     VERSION
k8sn211   Ready    <none>   3m46s   v1.32.2
# …or to see the running services:
microk8s kubectl get services
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
kubernetes   ClusterIP   10.152.183.1     <none>        443/TCP          24d
mysql-svc    NodePort    10.152.183.209   <none>        3306:30031/TCP   15d
```

## Deploy an app

Of course, Kubernetes is meant for deploying apps and services. You can use the kubectl command to do that as with any Kubernetes. Try installing a demo app:

```bash
microk8s kubectl create deployment nginx --image=nginx
```

Remember I already installed this on previous tries.

It may take a minute or two to install, but you can check the status:

```bash
microk8s kubectl get pods
NAME                     READY   STATUS    RESTARTS        AGE
mysql-0                  1/1     Running   3 (6d10h ago)   15d
nginx-5869d7778c-9qpbk   1/1     Running   4 (6d10h ago)   24d
```

## Use add-ons

MicroK8s uses the minimum of components for a pure, lightweight Kubernetes. However, plenty of extra features are available with a few keystrokes using “add-ons” - pre-packaged components that will provide extra capabilities for your Kubernetes, from simple DNS management to machine learning with Kubeflow!

To start it is recommended to add DNS management to facilitate communication between services. For applications which need storage, the ‘hostpath-storage’ add-on provides directory space on the host. These are easy to set up:

```bash
microk8s enable dns
Infer repository core for addon dns
Addon core/dns is already enabled

microk8s enable hostpath-storage
nfer repository core for addon hostpath-storage
Enabling default storage class.
WARNING: Hostpath storage is not suitable for production environments.
         A hostpath volume can grow beyond the size limit set in the volume claim manifest.

[sudo] password for brent: 
deployment.apps/hostpath-provisioner created
storageclass.storage.k8s.io/microk8s-hostpath created
serviceaccount/microk8s-hostpath created
clusterrole.rbac.authorization.k8s.io/microk8s-hostpath created
clusterrolebinding.rbac.authorization.k8s.io/microk8s-hostpath created
Storage will be available soon.

microk8s status
microk8s is running
high-availability: no
  datastore master nodes: 127.0.0.1:19001
  datastore standby nodes: none
addons:
  enabled:
    dns                  # (core) CoreDNS
    ha-cluster           # (core) Configure high availability on the current node
    helm                 # (core) Helm - the package manager for Kubernetes
    helm3                # (core) Helm 3 - the package manager for Kubernetes
    hostpath-storage     # (core) Storage class; allocates storage from host directory
    storage              # (core) Alias to hostpath-storage add-on, deprecated
```

## **[create a debug pod](https://medium.com/@shambhand2020/create-the-various-debug-or-test-pod-inside-kubernetes-cluster-e4862c767b96)**

It will exec into the pod with ssh. Next install curl with apk add curl and we are good to go. Similarly you can install the telnet with apk update && apk add busybox-extras, nslookup and dig with apk update && apk add bind-tools

```bash
# fetch https://dl-cdn.alpinelinux.org/alpine/v3.21/main/x86_64/APKINDEX.tar.gz
kubectl run -it --tty --rm debug --image=alpine --restart=Never -- sh
microk8s kubectl run -it --tty --rm debug --image=alpine --restart=Never -- sh
# If you don't see a command prompt, try pressing enter.
```

Next install curl with apk add curl and we are good to go. Similarly you can install the telnet with apk update && apk add busybox-extras, nslookup and dig with apk update && apk add bind-tools

```bash
apk add curl
apk update && apk add busybox-extras
apk update && apk add bind-tools
```

It will create a ephemeral pod, as soon as you are done with your debug or test pressing control + D will pods "debug" deleted

## Step 5: verify the VM can access routable networks

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
