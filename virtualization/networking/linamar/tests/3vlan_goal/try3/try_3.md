# Microk8s Linamar install try 3

## references

- **[Installing MicroK8s Offline or in an airgapped environment](https://microk8s.io/docs/install-offline)**

## Try 3

- Used r620_201 server
- setup r620_201_basic.yaml network
- remove microk8s
- reboot
- Added firewall rules
- installed microk8s successfull
  - microk8s inspect showed no issues
  - microk8s status showed not running
  - kubectl pods did not start in kubesystem ns did not check others.
- removed microk8s
- Added firewall rules
  - AWS Calico container registries
    - prod-registry-k8s-io-us-east-2.s3.dualstack.us-east-2.amazonaws.com
    - *amazonaws.com
    - us-central1-docker.pkg.dev
    - *pkg.dev

- microk8s start
- microk8s status shows not running
- purged microk8s and rebooted.
- rebooted machine
- installed microk8s

```bash
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
cp: cannot stat '/var/snap/microk8s/7731/var/kubernetes/backend/localnode.yaml': No such file or directory

Building the report tarball
  Report tarball is at /var/snap/microk8s/7731/inspection-report-20250314_212615.tar.gz
```

- check status

```bash

microk8s kubectl get ns
NAME              STATUS   AGE
default           Active   3m
kube-node-lease   Active   3m
kube-public       Active   3m
kube-system       Active   3m

microk8s kubectl get pods -n kube-system
NAME                                           READY   STATUS    RESTARTS   AGE
pod/calico-kube-controllers-5947598c79-kdspq   1/1     Running   0          2m4s
pod/calico-node-t82dn                          1/1     Running   0          2m4s
pod/coredns-79b94494c7-twdrh                   1/1     Running   0          2m4s

microk8s kubectl get all
NAME                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.152.183.1   <none>        443/TCP   3m28s

NAME               TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                  AGE
service/kube-dns   ClusterIP   10.152.183.10   <none>        53/UDP,53/TCP,9153/TCP   2m9s

NAME                         DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
daemonset.apps/calico-node   1         1         1       1            1           kubernetes.io/os=linux   2m10s

NAME                                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/calico-kube-controllers   1/1     1            1           2m10s
deployment.apps/coredns                   1/1     1            1           2m9s

NAME                                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/calico-kube-controllers-5947598c79   1         1         1       2m4s
replicaset.apps/coredns-79b94494c7                   1         1         1       2m4s

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
  disabled:
    cert-manager         # (core) Cloud native certificate management
    cis-hardening        # (core) Apply CIS K8s hardening
    community            # (core) The community addons repository
    dashboard            # (core) The Kubernetes dashboard
    gpu                  # (core) Alias to nvidia add-on
    host-access          # (core) Allow Pods connecting to Host services smoothly
    hostpath-storage     # (core) Storage class; allocates storage from host directory
    ingress              # (core) Ingress controller for external access
    kube-ovn             # (core) An advanced network fabric for Kubernetes
    mayastor             # (core) OpenEBS MayaStor
    metallb              # (core) Loadbalancer for your Kubernetes cluster
    metrics-server       # (core) K8s Metrics Server for API access to service metrics
    minio                # (core) MinIO object storage
    nvidia               # (core) NVIDIA hardware (GPU and network) support
    observability        # (core) A lightweight observability stack for logs, traces and metrics
    prometheus           # (core) Prometheus operator for monitoring and logging
    rbac                 # (core) Role-Based Access Control for authorisation
    registry             # (core) Private image registry exposed on localhost:32000
    rook-ceph            # (core) Distributed Ceph storage using Rook
    storage              # (core) Alias to hostpath-storage add-on, deprecated
  ```

## Access Kubernetes

```bash
microk8s kubectl get nodes
NAME     STATUS   ROLES    AGE     VERSION
k8sgw1   Ready    <none>   2d23h   v1.32.2
# …or to see the running services:
microk8s kubectl get services
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.152.183.1   <none>        443/TCP   2d23h
```

## Deploy an app

Of course, Kubernetes is meant for deploying apps and services. You can use the kubectl command to do that as with any Kubernetes. Try installing a demo app:

```bash
microk8s kubectl create deployment nginx --image=nginx
```

It may take a minute or two to install, but you can check the status:

```bash
microk8s kubectl get pods
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

## Starting and Stopping MicroK8s

MicroK8s will continue running until you decide to stop it. You can stop and start MicroK8s with these simple commands:

```bash
microk8s stop

# … will stop MicroK8s and its services. You can start again any time by running:

microk8s start

# Note that if you leave MicroK8s running, it will automatically restart after a reboot. If you don’t want this to happen, simply remember to run microk8s stop before you power down.
```

## **[create a debug pod](https://medium.com/@shambhand2020/create-the-various-debug-or-test-pod-inside-kubernetes-cluster-e4862c767b96)**

```bash
kubectl run -it --tty --rm debug --image=alpine --restart=Never -- sh
microk8s kubectl run -it --tty --rm debug --image=alpine --restart=Never -- sh
# If you don't see a command prompt, try pressing enter.

# ping 10.188.50.202
PING 10.188.50.202 (10.188.50.202): 56 data bytes
64 bytes from 10.188.50.202: seq=0 ttl=63 time=0.750 ms
64 bytes from 10.188.50.202: seq=1 ttl=63 time=0.387 ms
64 bytes from 10.188.50.202: seq=2 ttl=63 time=0.472 ms
^C
If you don't see a command prompt, try pressing enter.
/ # exit
pod "debug" deleted
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
