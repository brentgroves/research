# **[Using iptables-nft: a hybrid Linux firewall](https://developers.redhat.com/blog/2020/08/18/iptables-the-two-variants-and-their-relationship-with-nftables)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

In Red Hat Enterprise Linux (RHEL) 8, the userspace utility program iptables has a close relationship to its successor, nftables. The association between the two utilities is subtle, which has led to confusion among Linux users and developers. In this article, I attempt to clarify the relationship between the two variants of iptables and its successor program, nftables.

## The kernel API

In the beginning, there was only iptables. It lived a good, long life in Linux history, but it wasn't without pain points. Later, nftables appeared. It presented an opportunity to learn from the mistakes made with iptables and improve on them.

The most important nftables improvement, in the context of this article, is the kernel API. The kernel API is how user space programs the kernel. You can use either the nft command or a variant of the iptables command to access the kernel API. We'll focus on the iptables variant.

## Two variants of the iptables command

The two variants of the iptables command are:

- legacy: Often referred to as iptables-legacy.
- nf_tables: Often referred to as iptables-nft.

The newer iptables-nft command provides a bridge to the nftables kernel API and infrastructure. You can find out which variant is in use by looking up the iptables version. For iptables-nft, the variant will be shown in parentheses after the version number, denoted as nf_tables:

```bash
# ubuntu server
sudo update-alternatives --config iptables
[sudo] password for brent: 
There are 2 choices for the alternative iptables (providing /usr/sbin/iptables).

  Selection    Path                       Priority   Status
------------------------------------------------------------
* 0            /usr/sbin/iptables-nft      20        auto mode
  1            /usr/sbin/iptables-legacy   10        manual mode
  2            /usr/sbin/iptables-nft      20        manual mode

root@rhel-8 # iptables -V
iptables v1.8.4 (nf_tables)
```

For iptables-legacy, the variant will either be absent, or it will show legacy in parentheses:

```bash
root@rhel-7 # iptables -V
iptables v1.4.21
```

You can also identify iptables-nft by checking whether the iptables binary is a symbolic link to xtables-nft-multi:

```bash
root@rhel-8 # ls -al /usr/sbin/iptables
lrwxrwxrwx. 1 root root 17 Mar 17 10:22 /usr/sbin/iptables -> xtables-nft-multi
# from ubuntu desktop
ls -al /usr/sbin/iptables
lrwxrwxrwx 1 root root 26 Apr  8  2024 /usr/sbin/iptables -> /etc/alternatives/iptables
 brent@isdev  ~/src/pki  ls -al /etc/alternatives/iptables
lrwxrwxrwx 1 root root 22 Aug 27  2024 /etc/alternatives/iptables -> /usr/sbin/iptables-nft
```

## Using iptables-nft

As I noted earlier, the nftables utility improves the kernel API. The iptables-nft command allows iptables users to take advantage of the improvements. The iptables-nft command uses the newer nftables kernel API but reuses the legacy packet-matching code. As a result, you get the following benefits while using the familiar iptables command:

- Atomic rules updates.
- Per-network namespace locking.
- No file-based locking (for example: /run/xtables.lock).
- Fast updates to the incremental ruleset.

These benefits are mostly transparent to the user.

Note: The userspace command for nftables is nft. It has its own syntax and grammar.

## Packet matching is the same

It's important to understand that while there are two variants of iptables, packet matching utilizes the same code. Regardless of the variant that you are using, the same packet-matching features are available and behave identically. Another term for the packet matching code in the kernel is xtables.  Both variants, iptables-legacy and iptables-nft, use the same xtables code. This diagram provides a visual aid. I included nft for completeness:

+--------------+     +--------------+     +--------------+
|   iptables   |     |   iptables   |     |     nft      |   USER
|    legacy    |     |     nft      |     |  (nftables)  |   SPACE
+--------------+     +--------------+     +--------------+
       |                          |         |
====== | ===== KERNEL API ======= | ======= | =====================
       |                          |         |
+--------------+               +--------------+
|   iptables   |               |   nftables   |              KERNEL
|      API     |               |     API      |              SPACE
+--------------+               +--------------+
             |                    |         |
             |                    |         |
          +--------------+        |         |     +--------------+
          |   xtables    |--------+         +-----|   nftables   |
          |    match     |                        |    match     |
          +--------------+                        +--------------+

## The iptables rules appear in the nftables rule listing

An interesting consequence of iptables-nft using nftables infrastructure is that the iptables ruleset appears in the nftables rule listing. Let's consider an example based on a simple rule:

```bash
root@rhel-8 # iptables -A INPUT -s 10.10.10.0/24 -j ACCEPT
```

Showing this rule through the iptables command yields what we might expect:

```bash
root@rhel-8 # iptables -nL INPUT
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
ACCEPT     all  --  10.10.10.0/24        0.0.0.0/0
```

But it will also be shown in the nft ruleset:

```bash
root@rhel-8 # nft list ruleset
table ip filter {
    chain INPUT {
        type filter hook input priority filter; policy accept;
        ip saddr 10.10.10.0/24 counter packets 0 bytes 0 accept
    }
}
```

Note how the iptables rule was automatically translated into the nft syntax. Studying the automatic translation is one way to discover the nft equivalents of the iptables rules. In some cases, however, there isn't a direct equivalent. In those cases, nft will let you know by showing a comment like this one:

table ip nat {
    chain PREROUTING {
        meta l4proto tcp counter packets 0 bytes 0 # xt_REDIRECT
    }
}

## Summary

To summarize, the iptables-nft variant utilizes the newer nftables kernel infrastructure. This gives the variant some benefits over iptables-legacy while allowing it to remain a 100% compatible drop-in replacement for the legacy command. Note, however, that iptables-nft and nftables are not equivalent. They merely share infrastructure.

It is also important to note that while iptables-nft can supplant iptables-legacy, you should never use them simultaneously.
