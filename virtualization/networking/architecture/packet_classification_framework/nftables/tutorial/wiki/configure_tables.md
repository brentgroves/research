# **[Configure Tables](https://wiki.nftables.org/wiki-nftables/index.php/Configuring_tables)**

Tables are the top-level containers within an nftables ruleset; they hold chains, sets, maps, flowtables, and stateful objects.

Each table belongs to exactly one family. So your ruleset requires at least one table for each family you want to filter.

family refers to a one of the following table types: ip, arp, ip6, bridge, inet, netdev. It defaults to ip.

Following are some basic operations and commands for configuring tables:

## Adding tables

```bash
% nft add table ip filter
```

## Show/List tables

```% nft list tables```

## Deleting tables

```% nft delete table ip foo```

Troubleshooting: Since Linux kernel 3.18, you can delete a table and its contents with this command. Earlier kernels require you to flush the table's contents first, otherwise you hit an error:

```bash
% nft delete table filter
<cmdline>:1:1-19: Error: Could not delete table: Device or resource busy
delete table filter
^^^^^^^^^^^^^^^^^
```

## Flushing tables

You can delete all the rules that belong to this table with the following command:

```bash
% nft flush table ip filter
```

This removes the rules for every chain that you register in that table.

Note: nft flush table ip filter will not flush Sets defined within that table, and will cause an error if the table to be flushed does not exist and you're using Linux <4.9.0, which you can overcome by flushing the ruleset.
