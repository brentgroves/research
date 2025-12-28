# **[K8s and OpenStack](https://ubuntu.com/blog/kubernetes-vs-openstack)**

## OpenStack on Kubernetes

In turn, running the OpenStack control plane on top of Kubernetes also has its pros. Most importantly, it provides better isolation of OpenStack services, effectively decoupling them from the underlying operating system (OS). Furthermore, in such a setup, OpenStack can benefit from lifecycle management capabilities offered by Kubernetes, making historically complex operations, such as upgrades, way easier. Finally, standardising on K8s makes OpenStack’s architecture relatively lightweight, effectively transforming it into something that everyone can play with, even on their workstation.

Try **[OpenStack on Kubernetes](https://microstack.run/?_gl=1*vzb68q*_gcl_au*MTczMDcyNjk4MC4xNzQ0NzQ3NzU2*_ga*MzM1MDA1MDIwLjE3NDQ3NDc3NTQ.*_ga_5LTL1CNEJM*czE3NDc0MTUzNzkkbzMkZzEkdDE3NDc0MTUzNzkkajYwJGwwJGgw)**

## How to stack the stack?

Wait  a second. So is the desired setup Kubernetes on OpenStack on Kubernetes?

You guessed right! Even though it sounds awkward, this architecture setup has the most advantages, effectively enabling you to combine the best of both worlds on one platform. Among the various platforms available out there, Ubuntu stands out for its versatility. Ubuntu provides streamlined access to both OpenStack and Kubernetes, effectively empowering developers with all necessary infrastructure tools. Now, when it comes to production environments, an optional commercial subscription provides access to enterprise-class services.
