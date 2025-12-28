# [Dissecting the Linux Firewall: Introduction to Netfilter's nf_tables](https://anatomic.rip/netfilter_nf_tables/)**

This is an introduction to Netfilter’s nf_tables. While it isn’t a complete study of the internals it can give you a solid base before you start your own research into the module. Or maybe you have experience using tools like iptables and nft and want to see what happens behind the curtain - this article is for you as well.

While I have tried to make it as accessible as possible the article assumes basic knowledge of C and the Linux Kernel.

## What is Netfilter and nf_tables?

Netfilter is a framework in the Linux Kernel. It allows various network operations to be implemented in the form of handlers via hooks. It could be used for filtering, Network Address Translation or port translation. In general it could be summarized as a framework allowing you to direct, modify and control the network flow in a network.

Many userspace programs use netfilter. The most common perhaps is iptables.

The subsystem we will be reviewing is nf_tables. It is responsible for filtering and rerouting packets. It is commonly used for building firewalls as you can create complex rules through which to decide what happens with traffic - if it has to be refused, redirected, modified or accepted.

You can also write your own userspace programs that use the nf_tables subsystem. For that use a library has been developed that significantly simplifies the process - libnftnl (that requires the library libmnl). More on that later.

Note: libmnl and libnftnl also simplify the development of exploits targeting nf_tables :D

## Build a table, assemble a chain, form rules and decide on expressions

When we talk about netfilter internals we will constantly mention expressions used in rules which form chains that are part of tables. That might sound a little bit intimidating but don’t worry we will go over everything.

## Rules

Rules are essentially defined perfectly by their name. They are rules by which packets are filtered. Rules like checking the protocol, the source, the destination, the port, etc. Rules have a verdict - you can decide if you want to drop the packet, reject it or just accept it and go down the chain of rules.

Example: “udp dport 50001 drop” If the protocol is UDP and the destination port is 50001 it will drop the packet.

In the future when we talk about a rule being “executed” we essentially mean that the packet going through is being evaluated against the rule to determine if the packet fits the rule or not.

## Chains

Chains are essentially linear structures of rules. After one rule is checked it goes to the next one. Sometimes the verdict might make the execution jump to another chain. However we always have a base chain. A base chain is where the execution begins from. If there is a rule that checks if the protocol is UDP you can make it so that the execution jumps to another chain that has just rules for UDP packets.

Execution always begins from a base chain because they are the chains attached to a netfilter hook. We will talk extensively about hooks later but they essentially show when a chain should be executed. If an input hook is being used then the chain will be executed against incoming packets - if an output hook - against outgoing packets.

## Tables

Tables are the top-level structures. They contain the chains. Chains can only jump to another chain on the same table.

Tables belong to a particular family. The family defines what type of packets will be handled by the chains in the table. The families are - ip, ip6, inet, arp, bridge, netdev.

Tables belonging to the families ip and ip6 see only IPv4 and IPv6 packets respectively. The inet family allows a table to see both IPv4 and IPv6 packets.

The arp family allows tables to see ARP-level traffic while tables belonging to the bridge family only see packets traversing bridges.

The netdev family allows base chains to be attached to a particular network interface. Such base chains will then see all network traffic on that interface. That means that ARP traffic can be handled from here as well. The netdev family is only used when the base chains of the table will use the ingress hook but more on that later.

## Expressions

Expressions are like little operations where you can pass the arguments. They perform actions on packets. Expressions, executed (or rather evaluated) one after another form a rule. An example for an expression is the payload expression nft_payload_expr. It copies data from the packet’s headers and saves it into the registers. The registers are like a local data storage that you can write to and read from with expressions. They can be used to pass data between expressions.

So in conclusion: Expressions are operators we can use by providing them with arguments. Multiple expressions that will be evaluated one after the other form a rule. Multiple rules chained together form a chain.

    Ex: If we have the rule udp dport 50001 drop We first compare the protocol if it is udp with an expression Then we check if the destination port is 50001 with another expression and then if both are true we use another expression to drop the package - by setting a verdict

## Registers

We will now take a look at a very essential part - The Registers. Registers store data in them. That data can be accessed or modified by expressions by targetting a specific register. Although registers can be viewed as separate it is most of the time useful to see them as one continuous buffer of data where the register index is just an offset of the buffer.

But how much data can we store in the registers? That part might be a little bit confusing

Originally there were five 16 byte registers. One verdict register and four data registers - each is 16 bytes. In total 80 bytes.

Verdict (16) + 4 * data (16) = 80

But now stuff is a little different - there is still one 16 byte register - the verdict register but now the data registers can be addressed as sixteen each 4 bytes.

Verdict(16) + 16 * data (4) = 80

Data registers
So the data registers used to be four - each 16 bytes. Now they are sixteen - each 4 bytes.

We can view the registers as one continuous buffer of data where the registers are just offsets in that buffer. Well that would mean we just have two types of offsets. The first type is every 16 bytes. The second type is every 4 bytes.
