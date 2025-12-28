# **[MicroK8s in LXD](https://microk8s.io/docs/install-lxd#:~:text=remains%20well%20isolated.-,Installing%20LXD,image%20only%20works%20on%20x86_64%20)**

MicroK8s can also be installed inside an LXD VM. This is a great way, for example, to test out clustered MicroK8s without the need for multiple physical hosts.

Why an LXD virtual machine and not a container? In order to run certain Kubernetes services, the LXD container would need to be a privileged container. While this is possible, it is not the recommended pattern as it allows the root user in the container to be the root user on the host. Also, newer versions of Ubuntu and systemd require operations (such as mounting to the /proc directory) that cannot be safely handled with privileged containers. By using virtual machines, we ensure that the Kubernetes environment remains well isolated.

## Start an LXD VM for MicroK8s

We can now create the VM that MicroK8s will run in.

```bash
lxc launch ubuntu:22.04 k8s-vm --vm -c limits.cpu=2 -c limits.memory=4GB
```

## Install MicroK8s in an LXD VM

First, we’ll need to install MicroK8s within the VM.

```bash
lxc exec k8s-vm -- sudo snap install microk8s --classic
```

## Accessing MicroK8s Services Within LXD

Assuming you left the default bridged networking when you initially setup LXD, there is minimal effort required to access MicroK8s services inside the LXD VM.

Simply note the eth0 interface IP address from

```bash
lxc list k8s-vm
```

and use this to access services running inside the VM.

## Exposing Services To Node

You’ll need to expose the deployment or service to the VM itself before you can access it via the LXD VM’s IP address. This can be done using kubectl expose. This example will expose the deployment’s port 80 to a port assigned by Kubernetes.

Microbot
In this example, we will use Microbot as it provides a simple HTTP endpoint to expose. These steps can be applied to any other deployment.

First, let’s deploy Microbot (please note this image only works on x86_64).

```bash
lxc exec k8s-vm -- sudo microk8s kubectl create deployment microbot --image=dontrebootme/microbot:v1
```

Then check that the deployment has come up.

```bash
lxc exec k8s-vm -- sudo microk8s kubectl get all

NAME                            READY   STATUS    RESTARTS   AGE
pod/microbot-6d97548556-hchb7   1/1     Running   0          21m

NAME                       TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
service/kubernetes         ClusterIP   10.152.183.1     <none>        443/TCP        21m

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/microbot   1/1     1            1           21m

NAME                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/microbot-6d97548556   1         1         1       21m
```

As we can see, Microbot is running. Let’s expose it to the LXD VM.

```bash
lxc exec k8s-vm -- sudo microk8s kubectl expose deployment microbot --type=NodePort --port=80 --name=microbot-service
```

We can now get the assigned port. In this example, it’s 32750.

```bash
lxc exec k8s-vm -- sudo microk8s kubectl get service microbot-service
```

NAME               TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
microbot-service   NodePort   10.152.183.188   <none>        80:32750/TCP   27m
With this, we can access Microbot from our host but using the VM’s address that we noted earlier.

```bash
curl 10.245.108.37:32750
```

## Dashboard

The dashboard addon has a built in helper. Start the Kubernetes dashboard

```bash
lxc exec k8s-vm -- microk8s dashboard-proxy
```

and replace 127.0.0.1 with the VM’s IP address we noted earlier.
