# **[nat](https://wiki.nftables.org/wiki-nftables/index.php/Performing_Network_Address_Translation_(NAT))**

Performing Network Address Translation (NAT)
Jump to navigationJump to search
The nat chain type allows you to perform NAT. This chain type comes with special semantics:

The first packet of a flow is used to look up for a matching rule which sets up the NAT binding for this flow. This also manipulates this first packet accordingly.
No rule lookup happens for follow up packets in the flow: the NAT engine uses the NAT binding information already set up by the first packet to perform the packet manipulation.
Adding a NAT rule to a filter type chain will result in an error.

Stateful NAT
The stateful NAT involves the nf_conntrack kernel engine to match/set packet stateful information and will engage according to the state of connections. This is the most common way of performing NAT and the approach we recommend you to follow.

Be aware that with kernel versions before 4.18, you have to register the prerouting/postrouting chains even if you have no rules there since these chain will invoke the NAT engine for the packets coming in the reply direction. The remaining documentation in this article assumes a newer kernel which doesn't require this inconvenience anymore.

Source NAT
If you want to source NAT the traffic that leaves from your local area network to the Internet, you can create a new table nat with the postrouting chain:

% nft add table nat
% nft 'add chain nat postrouting { type nat hook postrouting priority 100 ; }'
