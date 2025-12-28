# short summary of calico-node pod issue

## references

**[Issue installing microk8s on network with multiple VLAN #4939](https://github.com/canonical/microk8s/issues/4939)**

```bash
microk8s kubectl get pods -n kube-system
NAME                                       READY   STATUS     RESTARTS   AGE
calico-kube-controllers-5947598c79-g5h4c   0/1     Pending    0          104m
calico-node-zs2sp                          0/1     Init:0/2   0          104m
coredns-79b94494c7-xmg4c                   0/1     Pending    0          104m
```

## look at pod events

```bash
microk8s kubectl describe pod/calico-node-zs2sp -n kube-system

Events:
  Type     Reason                  Age                  From     Message
  ----     ------                  ----                 ----     -------
  Warning  FailedCreatePodSandBox  3m41s                kubelet  Failed to create pod sandbox: rpc error: code = DeadlineExceeded desc = failed to get sandbox image "registry.k8s.io/pause:3.10": failed to pull image "registry.k8s.io/pause:3.10": failed to pull and unpack image "registry.k8s.io/pause:3.10": failed to copy: httpReadSeeker: failed open: failed to do request: Get "<https://prod-registry-k8s-io-us-east-2.s3.dualstack.us-east-2.amazonaws.com/containers/images/sha256:873ed75102791e5b0b8a7fcd41606c92fcec98d56d05ead4ac5131650004c136>": dial tcp 3.5.132.221:443: i/o timeout
  Warning  FailedCreatePodSandBox  46s (x5 over 7m19s)  kubelet  Failed to create pod sandbox: rpc error: code = Unknown desc = failed to get sandbox image "registry.k8s.io/pause:3.10": failed to pull image "registry.k8s.io/pause:3.10": failed to pull and unpack image "registry.k8s.io/pause:3.10": failed to resolve reference "registry.k8s.io/pause:3.10": failed to do request: Head "<https://us-central1-docker.pkg.dev/v2/k8s-artifacts-prod/images/pause/manifests/3.10>": dial tcp 172.253.62.82:443: i/o timeout
  Warning  FailedCreatePodSandBox  2s (x5 over 6m34s)   kubelet  Failed to create pod sandbox: rpc error: code = DeadlineExceeded desc = failed to get sandbox image "registry.k8s.io/pause:3.10": failed to pull image "registry.k8s.io/pause:3.10": failed to pull and unpack image "registry.k8s.io/pause:3.10": failed to resolve reference "registry.k8s.io/pause:3.10": failed to do request: Head "<https://us-central1-docker.pkg.dev/v2/k8s-artifacts-prod/images/pause/manifests/3.10>": dial tcp 172.253.62.82:443: i/o timeout

```

1. prod-registry-k8s-io-us-east-2.s3.dualstack.us-east-2.amazonaws.com
2. *amazonaws.com
3. us-central1-docker.pkg.dev
4. *pkg.dev
