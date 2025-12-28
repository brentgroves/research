#

# **[Charmed K8s](https://ubuntu.com/kubernetes/charmed-k8s)**

Vast cloud compatibility with OpenStack, VMware, AWS, GCP and Azure support

I have microcloud configured on 3 dell poweredge machines.
Agent's avatar
Can you give me some background to the use case for your k8s environment and technical requirements you're looking for?
Microcloud setups a lxd,ovn,ceph cluster.
04:26 PM
The servers are entirely devoted to Ubuntu MicroCloud with plenty of ram, storage, and 3 network cards each.

I have been using MicroK8s for a couple of years, but am wondering if Ubuntu's Charmed Kubernetes is more robust and fitting for production use.

04:31 PM
A couple points about Charmed K8s: It is pure upstream, usable and supportable // Multi-cloud ready; consistent across clouds // On public clouds, VMware and bare metal // High availability // Built for day-2 operations like upgrades and scaling

04:32 PM
MicroK8s : Pure upstream, usable and supportable // Opinionated // Highly Automated // Run Kubernetes very easily at a small scale - without having to muck about with configuring the Kubernetes // Works great in Edge environments

04:33 PM
Based on your environment size and use of MicroCloud already, I'd lean towards MicroK8s initially for your environment

Do you have a team responsible for managing the k8s environment?

A solution like Charmed Kubernetes is designed for the kind of robustness and production-readiness that a business-critical environment requires
