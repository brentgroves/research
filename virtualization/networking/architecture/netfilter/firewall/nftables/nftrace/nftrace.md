# **[Ruleset debug/tracing](https://wiki.nftables.org/wiki-nftables/index.php/Ruleset_debug/tracing)**

**[Back to Research List](../../../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../../../README.md)**

## reference

- **[gentoo](https://wiki.gentoo.org/wiki/Nftables/Examples)**


Since nftables v0.6 and linux kernel 4.6, ruleset debug/tracing is supported.

This is an equivalent of the old iptables method -J TRACE, but with some great improvements.

The steps to enable debug/tracing is the following:

give support in your ruleset for it (set nftrace in any of your rules)
monitor the trace events from the nft tool

## Enabling nftrace

To enable nftrace in a packet, use a rule with this statement:

`meta nftrace set 1`

After all, nftrace is part of the metainformation of a packet.

Of course, you may only enable nftrace for a given matching packet. In the example below, we only enable nftrace for tcp packets:

`ip protocol tcp meta nftrace set 1`


Adjusting nftrace to only your subset of desired packets is key to properly debug the ruleset, otherwise you may get a lot of debug/tracing information which may be overwhelming.

## Use a chain to enable tracing

The recommended way to enable tracing is to add a chain for this purpose.

Register a trace_chain to enable tracing. If you already have a prerouting chain, then make sure your trace_chain priority comes before your existing prerouting chain.

```bash
% nft add chain filter trace_chain { type filter hook prerouting priority -301\; }
% nft add rule filter trace_chain meta nftrace set 1
```

This example assumes you have an existing raw prerouting chain (at priority -300), hence, this is registering a trace chain right before this chain (at priority -301).

Once you are done with rule tracing, you can just delete this chain to disable it:

% nft delete chain filter trace_chain
