# **[Using iptables-nft: a hybrid Linux firewall](https://www.redhat.com/en/blog/using-iptables-nft-hybrid-linux-firewall)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

With nftables being available in most major distributions, administrators may choose between the old iptables, and its designated successor for the task of adding firewall functionality to a Linux box. What may come as a surprise though is that this is not necessarily an either or decision—there is in fact a middle ground, leveraging the best of both worlds. Or does it rather combine their downsides? This post tries to find out.

Readers should be familiar with Linux netfilter subsystem, at least from a user's point of view. Apart from familiarity with iptables and related commands, basic knowledge of nftables is assumed.

History
Back in September 2012, netfilter maintainer Pablo Neira Ayuso added a patch to iptables repository introducing tools to make use of a compatibility interface which was merged into mainline Linux version 3.13.

The tools were called xtables, xtables-restore, xtables-save and xtables-config. For the first three, syntax compatibility with iptables, iptables-restore and iptables-save was promised. The xtables-config utility was a helper tool to accompany the first three, but it is not used anymore these days so from here we will ignore that it ever existed.

The compatibility layer consists of support for using xtables matches and targets (which is what iptables users know as "extensions") from within nftables rules along with the required netlink API extension for user space.

The Netlink API is a Linux kernel interface that allows user-space applications to communicate with the kernel, primarily for network-related tasks, using a socket-based protocol. It's often seen as an alternative to ioctl for kernel interactions, offering a more flexible and extensible approach.

Although this sounds like no big deal, it indeed allows nftables to behave like iptables: While one could already create nftables base chains at the same hook points and priorities as iptables' built-in chains, with xtables matches and targets being available for use in nftables rules these may be created in a compatible way, too. Consequently, tools were written which may act as drop-in replacement of the traditional ones but leverage nftables internally.

Meanwhile, names have changed a few times to clarify the intended purpose as well as the used back end. Hence running 'make install' in iptables git repository installs the familiar common binary as 'xtables-legacy-multi' and creates symlinks to it with standard names (iptables, ip6tables, etc.) as well as ones with a suffix of -legacy.

For those tools leveraging the compatibility layer, a new common binary named xtables-nft-multi is installed and symlinks with -nft suffix created. The idea behind that is to give distributions the opportunity to easily implement switching between legacy and nft variants.

For example, starting with Fedora 29 users may choose between the two via the Alternatives system which controls what non-suffixed symlinks point at. The suffixed symlinks stay in place though so users may request a specific variant independently of the current configuration.

The following table shows which drop-in replacements are available. They all are supposed to behave exactly like their legacy counterpart and any relevant differences should be reported to the netfilter community.

![c](https://www.redhat.com/rhdc/managed-files/Screenshot%20from%202019-07-20%2017-12-37.png)

But there's more: An additional tool named xtables-monitor acts as a netlink event listener. It supports monitoring ruleset changes as well as trace events. The latter are triggered by rules calling the TRACE target (which, unlike legacy iptables, no longer creates kernel log entries).

To aid in migrating from iptables to nftables, a few tools exist which provide translation:

![t](https://www.redhat.com/rhdc/managed-files/styles/wysiwyg_full_width/private/Screenshot%20from%202019-07-20%2017-12-53.png.webp?itok=IURb6Gda)

All these tools are text converters only, they won't alter the running firewall configuration.

## Implementation Details

From a high level view, iptables-nft parses the iptables syntax on command line, creates appropriate nftables commands, packs them into netlink messages and submits them to kernel. Like nft itself, it uses libnftnl so it implements a full nftables client, not just a (textual) syntax converter.

For listing or dumping the ruleset, it contains a small nftables expression decoder which is incomplete, but powerful enough to handle all instructions it can create.

Ruleset management can be divided into two major parts: Handling the foundational environment consisting of tables and base chains (which appear as always present and non-changeable to legacy iptables users) and creation of rules and custom chains. The latter is simple, but the first two deserve a closer look:

## Dealing with the empty default ruleset

The most obvious change in nftables is the lack of a pre-defined set of tables and chains. Nft-variants therefore keep a standard empty ruleset definition which they apply before handling the actual command. At time of writing, this happens even for commands not modifying the ruleset, such as

```bash
iptables-nft --list
# Warning: iptables-legacy tables present, use iptables-legacy to see them
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:domain /* generated for Multipass network mpqemubr0 */
ACCEPT     udp  --  anywhere             anywhere             udp dpt:domain /* generated for Multipass network mpqemubr0 */
ACCEPT     udp  --  anywhere             anywhere             udp dpt:bootps /* generated for Multipass network mpqemubr0 */

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         
ACCEPT     all  --  anywhere             anywhere             /* generated for Multipass network mpqemubr0 */
ACCEPT     all  --  10.195.222.0/24      anywhere             /* generated for Multipass network mpqemubr0 */
ACCEPT     all  --  anywhere             10.195.222.0/24      ctstate RELATED,ESTABLISHED /* generated for Multipass network mpqemubr0 */
REJECT     all  --  anywhere             anywhere             /* generated for Multipass network mpqemubr0 */ reject-with icmp-port-unreachable
REJECT     all  --  anywhere             anywhere             /* generated for Multipass network mpqemubr0 */ reject-with icmp-port-unreachable

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         
ACCEPT     tcp  --  anywhere             anywhere             tcp spt:domain /* generated for Multipass network mpqemubr0 */
ACCEPT     udp  --  anywhere             anywhere             udp spt:domain /* generated for Multipass network mpqemubr0 */
ACCEPT     udp  --  anywhere             anywhere             udp spt:bootps /* generated for Multipass network mpqemubr0 */

(1)
# 
sudo iptables-nft -L INPUT
# Warning: iptables-legacy tables present, use iptables-legacy to see them
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:domain /* generated for Multipass network mpqemubr0 */
ACCEPT     udp  --  anywhere             anywhere             udp dpt:domain /* generated for Multipass network mpqemubr0 */
ACCEPT     udp  --  anywhere             anywhere             udp dpt:bootps /* generated for Multipass network mpqemubr0 */

(2)
# nft list ruleset
    table ip filter {
        chain INPUT {
            type filter hook input priority 0; policy accept;
        }

        chain FORWARD {
            type filter hook forward priority 0; policy accept;
        }

        chain OUTPUT {
            type filter hook output priority 0; policy accept;
        }
    }

```

The listing above shows the effect of --list' command in (1) to the system's nftables ruleset in (2). Note that although all base chains of filter table are created at once, additional tables will be created when calling iptables-nft with --table parameters other than the default of filter.

## Conversion of rules into nftables VM instructions

Iptables features two kinds of matches and targets: Ones that are built-in and those implemented in extensions (contained in a shared-object in user space and typically accompanied by a kernel module).

Built-in matches (e.g. on input/output interface or source/destination IP address) and targets (i.e., verdicts like ACCEPT, DROP, etc. and chain jumps) are parsed by iptables binary directly. In iptables-nft, these are converted into native nf_tables expressions.

Extensions (called in iptables via -m or, with a few exceptions, -j parameter) are still parsed by the extension modules themselves, so iptables-nft reuses that code. This is necessary anyway since compat expressions expect a payload exactly as created by those extension parsers.

To get a better idea of what is going on in the background, one should look at generated VM instructions. Here nft prints them if --debug=netlink option was given and debug output has been compiled in. With iptables-nft, netlink debug output must be enabled at compile-time and can't be toggled at runtime.

## Simple cases

So an iptables-nft rule which does not use any extension creates the same VM instructions as an equivalent nft one. As an example:

iptables-nft -A INPUT -i eth0 -s 10.0.0.0/8 -j ACCEPT
is identical to:

nft add rule ip filter INPUT meta iifname "eth0" ip saddr 10.0.0.0/8 counter accept

Here are the instructions generated for both of them:

# instruct nf_tables to place name of the incoming interface

# name in register 1

[ meta load iifname => reg 1 ]

# instruct nf_tables to compare register 1 with "eth0\\0"

[ cmp eq reg 1 0x30687465 0x00000000 ]

# instruct nf_tables to load the ip header source address

# and place it in register 1

[ payload load 4b @ network header + 12 => reg 1 ]

# ... and mask out everything in register 1 except the 8 topmost bits

[ bitwise reg 1 = (reg=1 & 0x000000ff ) ^ 0x00000000 ]

# and compare register 1 with "10"

[ cmp eq reg 1 0x0000000a ]

# increment a counter

[ counter pkts 0 bytes 0 ]

# store the "accept" verdict in register 0 (the nf_tables control register)

[ immediate reg 0 accept ]

Note that, apart from the different internal representation, the same rule behaves differently when created by legacy iptables. Due to iptables' design, all standard matches (source/destination interface/address) are always present. Hence the above rule in legacy iptables:

iptables-legacy -A INPUT -i eth0 -s 10.0.0.0/8 -j ACCEPT
is really:

iptables-legacy -A INPUT -i eth0 -o "+" -s 10.0.0.0/8 -d 0.0.0.0/0 -j ACCEPT

## Extensions

Extended matches and targets are embedded into the nftables rule via compat expression. A sample rule using the conntrack match:

iptables-nft -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
yields a "match" expression in VM code:

[ match name conntrack rev 3 ]
[ counter pkts 0 bytes 0 ]
[ immediate reg 0 accept ]

Likewise, a sample rule using MARK target:

iptables-nft -A INPUT -j MARK --set-mark 1
causes creation of a "target" expression:

[ counter pkts 0 bytes 0 ]
[ target name MARK rev 2 ]
Note how the pseudo-code does not include extension parameters—from libnftnl's point of view, these payloads are opaque. The only information given is extension name and revision as those are generic fields amongst all extension payloads.

Interoperability
First of all, running legacy iptables and nftables rulesets in parallel is not a good idea at all. It is possible, but one may very likely run into all kinds of hard to diagnose problems so this may safely be considered a dead end.

Mixing iptables-nft and nft on the other hand is not unproblematic, either. A good rule of thumb to avoid issues is to not touch the tables iptables-nft creates with nft. When parsing the ruleset, iptables-nft does some sanity checks on the chains and rules contained within the tables it claims ownership of. In case it finds something unexpected (e.g. additional base chains or rules with unsupported expressions), it aborts with an unspecific error message:

# iptables-nft -L

iptables v1.8.2 (nf_tables): table `filter' is incompatible, use 'nft' tool.

So, what happens if one uses nft tool to list a ruleset generated by iptables-nft? If xtables support was enabled at compile-time, the nft command is able to print the compat expressions. Internally, it uses the same code as iptables-translate to convert a given iptables match or target into an equivalent nft statement:

# iptables-nft -A FORWARD -m mark --mark 0x23 -j ACCEPT

# nft list chain ip filter FORWARD

table ip filter {
  chain FORWARD {
      type filter hook forward priority filter; policy accept;
      mark 0x23 counter packets 0 bytes 0 accept
  }
}

This is misleading as the printed rule is indistinguishable from a native nftables rule. Yet it is still a big improvement to nft's behaviour without xtables support up to (and including) version 0.9.0 which simply omitted compat expressions from output. Just recently this problem has been addressed by replacing the expression with a pound sign following the extension's name:

# nft list chain ip filter FORWARD

table ip filter {
  chain FORWARD {
      type filter hook forward priority filter; policy accept;
      # xt_mark counter packets 0 bytes 0 accept
  }
}
Obviously, this rule will get lost during a regular ruleset save and restore operation in nft, so not quite an optimal alternative, either.

iptables vs. iptables-nft vs. nft
In comparison to legacy iptables, iptables-nft has a few clear benefits: With back end transactions being atomic, there is no need for the global xtables lock which has proven problematic in environments with large and/or rapidly changing rulesets.

The same holds tue for the fact that legacy iptables has to replace the whole ruleset for every small change - in nftables, ruleset updates are incremental making most operations cheap and fast despite the actual ruleset size. Finally, there is xtables-monitor allowing to display ruleset updates in real-time.

The drawbacks on the other hand are missing features by a large part. For instance, there is no broute table in ebtables-nft and no FORWARD chain in arptables-nft. Some extensions are missing, too. Examples are ebtables' string and among matches or iptables' CLUSTERIP target. Some users may value the better compatibility of legacy iptables. There are distributions which don't even support nftables yet. The changed logging output of iptables' TRACE target may break setups relying upon the old behaviour. Obviously, iptables-nft's code base is less proven which means it may contain bugs and certainly has performance problems in some situations.

When compared to nft, iptables-nft might be preferable because the old syntax is retained and so legacy firewall managing applications may be integrated into nftables transparently. Also there are fewer "surprises" since matches and targets continue to behave just like before.

Skipping the compat stage and migrating to nft directly is recommended because there is no functional limitation as a trade-off for compatibility. In fact, iptables-nft misses out on about all of nftables' awesomeness like sets and maps, flexibility in creating rules regarding counters and multiple actions (e.g. mark, log and jump to other chain), etc.

Also, compat expressions are larger than equivalent native ones, evaluation might be less well performing due to the extra indirection, too. Upstream development focuses on nftables, so new features and fixes will land there first. Given that iptables-nft is merely a crutch, it may vanish along with legacy iptables in a (not so distant) future. Hence migration efforts are way better spent in nftables. A homogeneous system running nftables only obviously avoids any interoperability issues between iptables-nft and nft tools.
