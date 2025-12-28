# **[History](https://www.reddit.com/r/devops/comments/1c4kp5o/forgotten_origins_of_lxclxd/)**

As somebody else noted, BSD jails (and before them, the original chroot jails) are one of the earliest ancestors you can look at and say "there's a pretty straight line from here through a bunch of other stuff to Kubernetes". But there are some side trips worth checking out along the way:

IBM had hardware virtualization on its mainframes in the 1960s and released the capability as a product feature in 1972. IBM later developed LXC (which was released in 2008), and I believe I read someplace that their experience with z/VM informed LXC design decisions.

SWSoft (later Parallels) started developing what later became Virtuozzo in 1997 and first released it in 2001. Virtuozzo looked an awful lot like Docker containers would later except without the isolation mechanisms of namespaces and cgroups (which didn't exist yet) -- Virtuozzo used its own modified Linux kernel to enforce isolation.

Solaris had Zones and Containers (more like what we would now call a VM) in 2004/2005.

Google released App Engine as a beta in 2008. If you look at how it ran applications, it looks somewhat like a hybrid of Linux containers and modern "serverless" platforms.

A startup called WebappVM (later Makara) started developing a platform in 2009 that eventually became the version of OpenShift Red Hat got when it bought Makara in 2010. OpenShift 2.0 didn't use Docker (or Kubernetes, because that didn't exist yet) or even the term "container", but you could see that what it was doing was largely the same thing Docker would later (and some of what later "serverless" platforms would look like showed up here as well).

Heroku folks released the 12-Factor App manifesto in 2011. It almost doesn't use the word "containers" at all, and when it does it doesn't mean anything like the current definition (within the manifesto, it means things like web apps running under Tomcat), but if you didn't know when it was written, reading it you would almost think it was just describing how Docker-style containers and container orchestration in general work.

Around the same time the 12-Factor manifesto was being written and Makara was being bought, OpenStack was released. This was the first exposure a lot of folks had to the idea that later became commonly called "cloud-native": apps that weren't designed a certain way didn't run well on early versions of OpenStack.

CoreOS developed the fleet workload orchestrator, that worked by extending systemd units with some Fleet-specific keys. The first public release of fleet was in February 2014.

CoreOS also developed the alternative Docker-compatible rkt container runtime later in 2014. Basically there were things Docker was moving very slowly on like container image signing and secure distribution, and CoreOS was giving them a public nudge. This was one of the things (a bit of a development dustup between Docker and Red Hat around the same time was another) that shortly led to the creation of OCI.

Yeah, LXC is the closest direct ancestor to Docker, but those side branches on the family tree are pretty darn fun to look at.
