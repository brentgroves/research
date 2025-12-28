# **[Hypervisor to LXD](https://ubuntu.com/engage/hypervisor-to-lxd-case-study?_gl=1*109t8jr*_gcl_au*MTI1MTU0NjkwNS4xNzQxMDk5MzI4)**

Learn how Wyoming Department of Transportation keeps drivers safe and informed by pivoting from hypervisors to LXD!

Cloud-native development and deployment are booming and containerization has been a key driver for this. Docker and Kubernetes are often seen as the only technologies you can use for this purpose. But there are, in fact, many approaches to containerization.

One of them involves system containers, as run by LXD. System containers offer the best of both worlds - the efficiency and density of containers, with the ability to use a full OS and manageability of virtual machines. This was the approach chosen by the Wyoming Department of Transportation (WYDOT) to optimise their database costs and performance.

With the demand for their online services significantly growing over time, WYDOT faced increasingly expensive hypervisor licencing costs. They were looking for an alternative way to host and run their workloads, which would enable them to continue to scale their existing environment in a cost-effective way.

Their initial focus was on finding a performant CentOS alternative, but in discussions with Canonical they realised that in addition to Ubuntu on the operating system side, LXD would be an excellent alternative to running their virtual machines through Microsoft Hyper-V. Moving from hypervisors to LXD system containers on Ubuntu allowed them to significantly improve their performance with a fraction of the resources they previously used.

## Download this case study to learn more about

- How WYDOT pivoted from VMs on Hyper-V to LXD system containers
- The benefits of running your workloads on LXD and the resulting performance improvements
- How Canonical works with customers to enable these changes
