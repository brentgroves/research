# **[Advanced Routing HOWTO](https://tldp.org/HOWTO/Adv-Routing-HOWTO/index.html)**

A good tutorial about routing using iproute2.

3.1 **[Why iproute2](why_iproute2.md)**

4.0 Rules - routing policy database

If you have a large router, you may well cater for the needs of different people, who should be served differently. The routing policy database allows you to do this by having multiple sets of routing tables.

If you want to use this feature, make sure that your kernel is compiled with the "IP: advanced router" and "IP: policy routing" features.

When the kernel needs to make a routing decision, it finds out which table needs to be consulted. By default, there are three tables. The old 'route' tool modifies the main and local tables, as does the ip tool (by default).

The default rules:

```bash
[ahu@home ahu]$ ip rule list
0: from all lookup local 
32766: from all lookup main 
32767: from all lookup default
```

This lists the priority of all rules. We see that all rules apply to all packets ('from all'). We've seen the 'main' table before, it is output by ip route ls, but the 'local' and 'default' table are new.

If we want to do fancy things, we generate rules which point to different tables which allow us to override system wide routing rules.

For the exact semantics on what the kernel does when there are more matching rules, see Alexey's ip-cref documentation.

4.1. **[Simple source policy routing](simple_source_policy_routing.md)**
