# **[OVN inner workings](https://discuss.linuxcontainers.org/t/would-love-to-understand-the-inner-workings-of-the-ovn-network/17439)**

The chart below is my current understanding.

![i1](https://discuss.linuxcontainers.org/uploads/default/original/2X/a/ae3062552b8e78c8dc1c59b8309268b9343e36c6.jpeg)

  First of all, I will introduce this diagram a little, and then ask some questions.The three rectangles standing vertically represent my three LXD servers.And I deployed the OVN cluster on these three servers.

  I created an OVN network and then used OVN commands to try to understand what the topology of the OVN network looked like.

here is command:

- ovs-vsctl show
- ovn-nbctl show
- ovn-sbctl show

 I found that the container is first connected to a logical switch, then the switch is connected to a logical router, and then the logical router is connected to a bridge with the name “lxdovn2”.The lxdovn2 bridge is connected to another bridge with the name br-int.The br-int bridge is remotely connected to the br-int bridge of another lxd server.
