# **[Extreme switch LACP to Ubuntu Bond](https://community.extremenetworks.com/t5/extremeswitching-exos-switch/extreme-switch-lacp-to-ubuntu-bond/m-p/97579)**

## references

- **[Ubuntu 22.04 LTS Network Bonding – Active/Standby](https://geekmungus.co.uk/?p=3981)**
Hi

I have a 2 x Ubuntu systems that will be utilised as Frontend Load Balancers. I have configured the internal VRRP between the two servers with Keppalive D successfully. Now I need to configure the netplan yaml file with the Bond to 2 x Extreme switches. What is the best way to configure the LACP bond on the extreme switches please?

Yes, a single LAG from one device that goes to 2 EXOS switches is an MLAG topology.

You can find an MLAG config guide here:
<https://extreme-networks.my.site.com/ExtrArticleDetail?an=000079895>

View solution in original post

## **[How To: Configure MLAG](https://extreme-networks.my.site.com/ExtrArticleDetail?an=000079895)**

![mlag](https://extreme-networks.my.site.com/servlet/rtaImage?eid=ka8Um000003ip8L&feoid=00N2T000004t2YK&refid=0EM3400000012D5)
