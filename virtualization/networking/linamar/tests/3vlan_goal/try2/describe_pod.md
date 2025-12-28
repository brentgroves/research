# detailed summary of calico-node pod issue

## references

**[Issue installing microk8s on network with multiple VLAN #4939](https://github.com/canonical/microk8s/issues/4939)**

## describe pod

```bash
microk8s kubectl describe pod/calico-node-zs2sp -n kube-system
Name:                 calico-node-zs2sp
Namespace:            kube-system
Priority:             2000001000
Priority Class Name:  system-node-critical
Service Account:      calico-node
Node:                 k8sgw1/10.188.50.201
Start Time:           Fri, 14 Mar 2025 16:17:01 +0000
Labels:               controller-revision-hash=59f6d5f95c
                      k8s-app=calico-node
                      pod-template-generation=1
Annotations:          <none>
Status:               Pending
IP:                   10.188.50.201
IPs:
  IP:           10.188.50.201
Controlled By:  DaemonSet/calico-node
Init Containers:
  upgrade-ipam:
    Container ID:  
    Image:         docker.io/calico/cni:v3.28.1
    Image ID:
    Port:          <none>
    Host Port:     <none>
    Command:
      /opt/cni/bin/calico-ipam
      -upgrade
    State:          Waiting
      Reason:       PodInitializing
    Ready:          False
    Restart Count:  0
    Environment Variables from:
      kubernetes-services-endpoint  ConfigMap  Optional: true
    Environment:
      KUBERNETES_NODE_NAME:        (v1:spec.nodeName)
      CALICO_NETWORKING_BACKEND:  <set to the key 'calico_backend' of config map 'calico-config'>  Optional: false
    Mounts:
      /host/opt/cni/bin from cni-bin-dir (rw)
      /var/lib/cni/networks from host-local-net-dir (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-5lnlp (ro)
  install-cni:
    Container ID:  
    Image:         docker.io/calico/cni:v3.28.1
    Image ID:
    Port:          <none>
    Host Port:     <none>
    Command:
      /opt/cni/bin/install
    State:          Waiting
      Reason:       PodInitializing
    Ready:          False
    Restart Count:  0
    Environment Variables from:
      kubernetes-services-endpoint  ConfigMap  Optional: true
    Environment:
      CNI_CONF_NAME:         10-calico.conflist
      CNI_NETWORK_CONFIG:    <set to the key 'cni_network_config' of config map 'calico-config'>  Optional: false
      KUBERNETES_NODE_NAME:   (v1:spec.nodeName)
      CNI_MTU:               <set to the key 'veth_mtu' of config map 'calico-config'>  Optional: false
      SLEEP:                 false
      CNI_NET_DIR:           /var/snap/microk8s/current/args/cni-network
    Mounts:
      /host/etc/cni/net.d from cni-net-dir (rw)
      /host/opt/cni/bin from cni-bin-dir (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-5lnlp (ro)
Containers:
  calico-node:
    Container ID:
    Image:          docker.io/calico/node:v3.28.1
    Image ID:
    Port:           <none>
    Host Port:      <none>
    State:          Waiting
      Reason:       PodInitializing
    Ready:          False
    Restart Count:  0
    Requests:
      cpu:      250m
    Liveness:   exec [/bin/calico-node -felix-live] delay=10s timeout=10s period=10s #success=1 #failure=6
    Readiness:  exec [/bin/calico-node -felix-ready] delay=0s timeout=10s period=10s #success=1 #failure=3
    Environment Variables from:
      kubernetes-services-endpoint  ConfigMap  Optional: true
    Environment:
      DATASTORE_TYPE:                     kubernetes
      WAIT_FOR_DATASTORE:                 true
      NODENAME:                            (v1:spec.nodeName)
      CALICO_NETWORKING_BACKEND:          <set to the key 'calico_backend' of config map 'calico-config'>  Optional: false
      CLUSTER_TYPE:                       k8s,bgp
      IP:                                 autodetect
      IP_AUTODETECTION_METHOD:            first-found
      CALICO_IPV4POOL_VXLAN:              Always
      CALICO_IPV6POOL_VXLAN:              Never
      FELIX_IPINIPMTU:                    <set to the key 'veth_mtu' of config map 'calico-config'>  Optional: false
      FELIX_VXLANMTU:                     <set to the key 'veth_mtu' of config map 'calico-config'>  Optional: false
      FELIX_WIREGUARDMTU:                 <set to the key 'veth_mtu' of config map 'calico-config'>  Optional: false
      CALICO_IPV4POOL_CIDR:               10.1.0.0/16
      CALICO_DISABLE_FILE_LOGGING:        true
      FELIX_DEFAULTENDPOINTTOHOSTACTION:  ACCEPT
      FELIX_IPV6SUPPORT:                  false
      FELIX_HEALTHENABLED:                true
      FELIX_FEATUREDETECTOVERRIDE:        ChecksumOffloadBroken=true
    Mounts:
      /host/etc/cni/net.d from cni-net-dir (rw)
      /lib/modules from lib-modules (ro)
      /run/xtables.lock from xtables-lock (rw)
      /var/lib/calico from var-lib-calico (rw)
      /var/log/calico/cni from cni-log-dir (ro)
      /var/run/calico from var-run-calico (rw)
      /var/run/nodeagent from policysync (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-5lnlp (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   False
  Initialized                 False
  Ready                       False
  ContainersReady             False
  PodScheduled                True
Volumes:
  lib-modules:
    Type:          HostPath (bare host directory volume)
    Path:          /lib/modules
    HostPathType:  
  var-run-calico:
    Type:          HostPath (bare host directory volume)
    Path:          /var/snap/microk8s/current/var/run/calico
    HostPathType:  
  var-lib-calico:
    Type:          HostPath (bare host directory volume)
    Path:          /var/snap/microk8s/current/var/lib/calico
    HostPathType:  
  xtables-lock:
    Type:          HostPath (bare host directory volume)
    Path:          /run/xtables.lock
    HostPathType:  FileOrCreate
  sys-fs:
    Type:          HostPath (bare host directory volume)
    Path:          /sys/fs/
    HostPathType:  DirectoryOrCreate
  cni-bin-dir:
    Type:          HostPath (bare host directory volume)
    Path:          /var/snap/microk8s/current/opt/cni/bin
    HostPathType:  DirectoryOrCreate
  cni-net-dir:
    Type:          HostPath (bare host directory volume)
    Path:          /var/snap/microk8s/current/args/cni-network
    HostPathType:  
  cni-log-dir:
    Type:          HostPath (bare host directory volume)
    Path:          /var/snap/microk8s/common/var/log/calico/cni
    HostPathType:  
  host-local-net-dir:
    Type:          HostPath (bare host directory volume)
    Path:          /var/snap/microk8s/current/var/lib/cni/networks
    HostPathType:  
  policysync:
    Type:          HostPath (bare host directory volume)
    Path:          /var/snap/microk8s/current/var/run/nodeagent
    HostPathType:  DirectoryOrCreate
  kube-api-access-5lnlp:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   Burstable
Node-Selectors:              kubernetes.io/os=linux
Tolerations:                 :NoSchedule op=Exists
                             :NoExecute op=Exists
                             CriticalAddonsOnly op=Exists
                             node.kubernetes.io/disk-pressure:NoSchedule op=Exists
                             node.kubernetes.io/memory-pressure:NoSchedule op=Exists
                             node.kubernetes.io/network-unavailable:NoSchedule op=Exists
                             node.kubernetes.io/not-ready:NoExecute op=Exists
                             node.kubernetes.io/pid-pressure:NoSchedule op=Exists
                             node.kubernetes.io/unreachable:NoExecute op=Exists
                             node.kubernetes.io/unschedulable:NoSchedule op=Exists
Events:
  Type     Reason                  Age                  From     Message
  ----     ------                  ----                 ----     -------
  Warning  FailedCreatePodSandBox  3m41s                kubelet  Failed to create pod sandbox: rpc error: code = DeadlineExceeded desc = failed to get sandbox image "registry.k8s.io/pause:3.10": failed to pull image "registry.k8s.io/pause:3.10": failed to pull and unpack image "registry.k8s.io/pause:3.10": failed to copy: httpReadSeeker: failed open: failed to do request: Get "<https://prod-registry-k8s-io-us-east-2.s3.dualstack.us-east-2.amazonaws.com/containers/images/sha256:873ed75102791e5b0b8a7fcd41606c92fcec98d56d05ead4ac5131650004c136>": dial tcp 3.5.132.221:443: i/o timeout
  Warning  FailedCreatePodSandBox  46s (x5 over 7m19s)  kubelet  Failed to create pod sandbox: rpc error: code = Unknown desc = failed to get sandbox image "registry.k8s.io/pause:3.10": failed to pull image "registry.k8s.io/pause:3.10": failed to pull and unpack image "registry.k8s.io/pause:3.10": failed to resolve reference "registry.k8s.io/pause:3.10": failed to do request: Head "<https://us-central1-docker.pkg.dev/v2/k8s-artifacts-prod/images/pause/manifests/3.10>": dial tcp 172.253.62.82:443: i/o timeout
  Warning  FailedCreatePodSandBox  2s (x5 over 6m34s)   kubelet  Failed to create pod sandbox: rpc error: code = DeadlineExceeded desc = failed to get sandbox image "registry.k8s.io/pause:3.10": failed to pull image "registry.k8s.io/pause:3.10": failed to pull and unpack image "registry.k8s.io/pause:3.10": failed to resolve reference "registry.k8s.io/pause:3.10": failed to do request: Head "<https://us-central1-docker.pkg.dev/v2/k8s-artifacts-prod/images/pause/manifests/3.10>": dial tcp 172.253.62.82:443: i/o timeout

  ```

## Add these domains to firewall whitelist

1. prod-registry-k8s-io-us-east-2.s3.dualstack.us-east-2.amazonaws.com
2. *amazonaws.com
3. us-central1-docker.pkg.dev
4. *pkg.dev
