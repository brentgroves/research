# **[Configuring tables](https://wiki.nftables.org/wiki-nftables/index.php/Configuring_tables)**

Jump to navigationJump to search
Tables are the top-level containers within an nftables ruleset; they hold chains, sets, maps, flowtables, and stateful objects.

Each table belongs to exactly one family. So your ruleset requires at least one table for each family you want to filter.

Following are some basic operations and commands for configuring tables:

## Adding tables

```% nft add table ip filter```
