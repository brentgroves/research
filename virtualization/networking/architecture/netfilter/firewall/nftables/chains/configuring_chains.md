# **[Configuring chains](https://wiki.nftables.org/wiki-nftables/index.php/Configuring_chains)**

**[Back to Research List](../../../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../../../README.md)**

As in iptables, with nftables you attach your **[rules](https://wiki.nftables.org/wiki-nftables/index.php/Simple_rule_management)** to chains. Unlike in iptables, there are no predefined chains like INPUT, OUTPUT, etc. Instead, to filter packets at a particular processing step, you explicitly create a base chain with name of your choosing, and attach it to the appropriate **[Netfilter hook](https://wiki.nftables.org/wiki-nftables/index.php/Netfilter_hooks)**. This allows very flexible configurations without slowing Netfilter down with built-in chains not needed by your ruleset.

## Syntactic conventions

Naturally, in order to make use of nftables commands and directives, it is necessary to become familiar with them, along with their supported grammar. Even with that knowledge, users sometimes experience difficulties where passing nftables commands as arguments to the nft(8) utility. That's because shells recognise certain characters as metacharacters and treat them in a special way unless they are quoted.

Throughout this article, examples that begin with the hash character (U+23) can be taken as examples of valid shell code. That is, they are syntactically valid if entered into any implementation of the Shell Command Language, including bash. By contrast, examples that do not begin with the hash character can be interpreted as either synopses of nftables grammar, similar in style to the nft(8) man page, or as examples of complete rulesets, if so indicated.

As such, examples of shell code shall generally be of the following form.

# nft 'nftables commands go here'

Note that enclosing the nftables commands within single quotes is a straightforward way of preventing the shell from interpreting characters as metacharacters, most notably the semicolon. Rather, the shell will consider all that is between the pair of single quotes as a single word before passing it on to the nft(8) utility as a single argument, verbatim. Another way to prevent the shell from attempting to parse metacharacters is to run nft(8) in its interactive mode.

`# nft -i`

In that case, nft(8) will directly interpret any further input given until such time as it is either interrupted, encounters the end-of-file (EOF) condition, or encounters the "quit" command. In most terminal emulators, EOF can be conveyed with the Ctrl+D key combination.

Examples describing nftables grammar shall employ square brackets (U+5B, U+5D) to denote optional components of syntax, and angle brackets (U+3C, U+3D) to denote user-specified values.

## Adding base chains

Base chains are those that are registered into the **[Netfilter hooks](https://wiki.nftables.org/wiki-nftables/index.php/Netfilter_hooks)**, i.e. these chains see packets flowing through your Linux TCP/IP stack. The syntax for adding base chains is as follows.

`add chain [<family>] <table_name> <chain_name> { type <type> hook <hook> [device <device>] priority <priority> ; [policy <policy> ;] [comment <comment> ;] }`

The following example shows how to add a new base chain input to the filter table (which must have been previously created):

`# nft 'add chain ip filter input { type filter hook input priority 0; }'`

- ip: Matches only IPv4 packets. This is the default if you do not specify an address family.

