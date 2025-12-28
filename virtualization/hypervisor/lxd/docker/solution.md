# **[Docker in LXD container](https://forums.docker.com/t/use-docker-as-vm-with-persistent-storage/138254/3)**

LXD and Docker could run on the same host, but you could have network issues as Docker writes firewall rules and that is not really compatible with LXD. I know it from experience, because on a server I had to configure LXD, someone else installed Docker and suddenly my virtual machines didn’t have access to the internet and internal traffic didn’t work either so I had to add additional firewall rules and start a proxy on the host to forward traffic to the vitual machines…

So if you need LXD, use that for running containers and virtual machines. If you need Docker too, run a virtual machine with LXD and run Docker containers in that virtual machine. You could run Docker in an LXC container too, but that is not trivial and requires additional parameters and privileges.
