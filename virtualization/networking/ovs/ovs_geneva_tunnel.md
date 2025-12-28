# **[OpenvSwitch. Geneve tunnel](https://albertomolina.wordpress.com/2022/12/04/openvswitch-geneve-tunnel/)**

Some previous blog post have been written about OpenvSwitch:

OpenvSwitch. Basic usage
OpenvSwitch. Managing simple flows
In this post, the configuration of an overlay network with Geneve is going to be shown, allowing L2 communications between two virtual machines running on different hosts. This feature is extremely useful in cloud computing and Geneve is an encapsulation protocol recently proposed to replace GRE and VXLAN. Geneve is fully supported on OpenvSwitch and it’s the encapsulation protocol used by OVN and it’s becoming the standard encapsulation protocol in many OpenStack deployments.
