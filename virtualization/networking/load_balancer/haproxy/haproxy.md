# **[](https://www.haproxy.org/#desc)**

## Performance

As shown in this test run on AWS ARM-based Graviton2, HAProxy scales very well with threads and was shown to be able to reach 2 million requests/s over SSL and 100 Gbps for forwarded traffic.

This is made possible thanks to its event-driven architecture that allows to react extremely quickly to I/O events, its parallelism on SMP machines provided by light multi-threading, a task scheduler that permanently composes between low-latency and high throughput, and generally speaking a permanent quest of resource savings at every single architecture layer. These efforts tend to cost a bit in development time but are immediately valued by users who are able to reduce their number of machines upgrade after upgrade. For the vast majority of common loads, the HAProxy process is simply not noticed, which tends to make its users forget it, sometimes resulting in questions regarding extremely old versions.

Please consult this section for more information on the architecture details and some performance test results.

## Reliability - keeping high-traffic sites online since 2002

HAProxy is first known for being extremely robust. The core team developers tend to be irritated by certain bugs they fix, but this is because their job is to see them all. Most users report having never ever faced any single crash and claim that HAProxy is the most solid part of their infrastructure. Finding machines with HAProxy processes being up for more than 3 years is not exceptional at all!

All this is not an accident, though. A lot of efforts are made in that direction, to provide excellent observability on what is happening, and an amazing number of protections against bad behaviors. HAProxy is built with many checks for unacceptable situations (impossible conditions, endless loops, etc) that in other products might result in service outages or data corruption, but in HAProxy will immediately result in a crash with a dump of the problem. This rigor pays off since most users have never faced such an issue, thanks to the few who faced them and provided useful reports allowing to fix the problem early.

The development process also encourages quality, with a long term maintenance cycle: versions are maintained for 5 years by the same developers who code the new features. This encourages them to write high quality code and commit messages that correspond to the highest standards. A regression testing suite is used and run along development by all developers and before merging code, as well as after on a wide variety of platforms thanks to the continuous integration (CI) system.

The principle of "eating one's dog's food" applies here as well: haproxy.org runs on the latest development release. This usually helps spot a bug or two per major version before it hits a release. But in addition it maintains a permanent pressure on the development team to release something they're confident in.

The program having been designed from its early age to be extremely conservative on resource usage, a significant number of settings are calculated at startup time and enforce many limits on number of sockets, connections, streams etc, guaranteeing that any processing that was started will complete.

Security - Hardened by default
Security is a very important concern when deploying a software load balancer, because it runs at the edge and takes all the dirty traffic. It is possible to harden the OS, to limit the number of open ports and accessible services, but the load balancer itself stays exposed. The unified and non-fantasist coding style aims at avoiding common traps when writing or reviewing code. Some high standards are sought when it comes to dealing with unvalidated data. Non-portable functions and those having unreliable behaviors are avoided or replaced. Input data gets sanitized very early in the lower layers. Resource usage is carefully controlled. Dangling pointers are forbidden in the code via careful release functions. These standards already help eliminate a great deal of uncertainty in the code itself.

Since zero-bug is not reasonable, the product embarks a number of defensive measures, such as chroot, privilege drops, fork prevention, strict protocol validation, checks for impossible states and detailed traces in case of violation detection, etc. All these usually result in an attempt to exploit a real bug in a failure or possibly a crash. These measures have to be purposely disabled by the user using sufficiently evocative commands so that the reason for doing so has to be regularly questioned.

I also find it important to credit **[Loadbalancer.org](http://www.loadbalancer.org/)**. I am not affiliated with them at all but like us, they have contributed a fair amount of time and money to the project to add new features and they help users on the mailing list, so I have some respect for what they do. They're a UK-based company and their load balancer also employs HAProxy, though it is somewhat different from the ALOHA.
