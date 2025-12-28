# **[Is it possible to mix Docker containers with LXC containers](https://askubuntu.com/questions/1441909/is-it-possible-to-mix-docker-containers-with-lxc-containers)**

One of the major challenges we're facing with dockerizing our apps is that there are a lot of dependencies that need to be installed. LXC has been great at that as they provide a "full linux system". However, we're faced with the need to add already prepared docker containers to the cluster that we're already running.

So is it possible to mix docker containers with LXC containers?

## answer

This is definitely possible, and also feasible. Docker and LXC/LXD serve different purposes.

Docker containers are geared towards running specific applications inside each container, and thus each container is more of a "one-trick pony".

LXC containers are intended to provide a persistent VM-like system in each container, so these are better for experiments and testing on full systems.

However, note that Docker and LXC/LXD are two different ecosystems, that aren't aware of each other. So any orchestration and interaction between the two needs to be set up separately for each.

![i1](https://i.sstatic.net/z7cDA.jpg)

## another response

LXD and Docker could run on the same host, but you could have network issues as Docker writes firewall rules and that is not really compatible with LXD. I know it from experience, because on a server I had to configure LXD, someone else installed Docker and suddenly my virtual machines didn’t have access to the internet and internal traffic didn’t work either so I had to add additional firewall rules and start a proxy on the host to forward traffic to the vitual machines…

So if you need LXD, use that for running containers and virtual machines. If you need Docker too, run a virtual machine with LXD and run Docker containers in that virtual machine. You could run Docker in an LXC container too, but that is not trivial and requires additional parameters and privileges.
