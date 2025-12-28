# Microk8s Linamar install try 2

- Used r620_201 server
- setup r620_201_basic.yaml network
- installed microk8s successfull
  - microk8s inspect showed no issues
  - microk8s status showed not running
  - kubectl pods did not start in kubesystem ns did not check others.
- removed microk8s
- Added firewall rules

  - **[Installing MicroK8s Offline or in an airgapped environment](https://microk8s.io/docs/install-offline)**

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

  - all OCI container registries

    ```bash
    *k8s.io
    *docker.io
    *quay.io
    *gcr.io
    *mcr.microsoft.com
    *ghcr.io
    ```

- microk8s start
- microk8s status shows not running
- purged microk8s and rebooted.
- rebooted machine
- installed microk8s

```bash
sudo snap install microk8s --classic --channel=1.32/stable
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
  Report tarball is at /var/snap/microk8s/7731/inspection-report-20250314_161842.tar.gz
```

- check status

```bash
 microk8s kubectl get ns
NAME              STATUS   AGE
default           Active   3m
kube-node-lease   Active   3m
kube-public       Active   3m
kube-system       Active   3m

microk8s kubectl get all -n kube-system
NAME                                           READY   STATUS     RESTARTS   AGE
pod/calico-kube-controllers-5947598c79-g5h4c   0/1     Pending    0          4m2s
pod/calico-node-zs2sp                          0/1     Init:0/2   0          4m2s
pod/coredns-79b94494c7-xmg4c                   0/1     Pending    0          4m2s

NAME               TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                  AGE
service/kube-dns   ClusterIP   10.152.183.10   <none>        53/UDP,53/TCP,9153/TCP   4m7s

NAME                         DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
daemonset.apps/calico-node   1         1         0       1            0           kubernetes.io/os=linux   4m8s

NAME                                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/calico-kube-controllers   0/1     1            0           4m8s
deployment.apps/coredns                   0/1     1            0           4m7s

NAME                                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/calico-kube-controllers-5947598c79   1         1         0       4m3s
replicaset.apps/coredns-79b94494c7                   1         1         0       4m3s
```
