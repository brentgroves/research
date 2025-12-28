# **[ruleset operations](https://wiki.nftables.org/wiki-nftables/index.php/Operations_at_ruleset_level)**

Using native nft syntax
Linux Kernel 3.18 includes some improvements regarding the available operations to manage your ruleset as a whole.

listing
Listing the complete ruleset:

```% nft list ruleset```

Listing the ruleset per family:

```bash
 % nft list ruleset arp
 % nft list ruleset ip
 % nft list ruleset ip6
 % nft list ruleset bridge
 % nft list ruleset inet
```

These commands will print all tables/chains/sets/rules of the given family.

flushing
In addition, you can also flush (erase, delete, wipe) the complete ruleset:

```% nft flush ruleset```

Also per family:

```bash
 % nft flush ruleset arp
 % nft flush ruleset ip
 % nft flush ruleset ip6
 % nft flush ruleset bridge
 % nft flush ruleset inet
 ```

## backup/restore

You can combine these two commands above to backup your ruleset:

```bash
# echo "flush ruleset" > backup.nft
# nft list ruleset >> backup.nft

# backup 
cp /etc/nftables.conf ~/backup/
sudo rm /etc/nftables.conf
sudo touch /etc/nftables.conf
sudo chmod 666 /etc/nftables.conf
echo "#!/usr/sbin/nft -f" > /etc/nftables.conf
echo "flush ruleset" >> /etc/nftables.conf
sudo nft list ruleset >> /etc/nftables.conf
 

# example
sudo nft add table ip test
# make this a low priority chain
sudo nft 'add chain ip test input { type filter hook input priority 100 ; }'
sudo nft 'add chain ip test output { type filter hook output priority 100 ; }'
sudo nft 'add rule test output ip daddr 8.8.8.8 counter'

# backup 
cp /etc/nftables.conf ~/backup/
sudo rm /etc/nftables.conf
sudo touch /etc/nftables.conf
sudo chmod 666 /etc/nftables.conf
echo "flush ruleset" > /etc/nftables.conf
sudo nft list ruleset >> /etc/nftables.conf

# reboot system and see if test table persists

reboot

 ```

## How to load ruleset automically

```% sudo nft -f backup.nft```

## **[automtic rule replacement](https://wiki.nftables.org/wiki-nftables/index.php/Atomic_rule_replacement)**

## Warning about Shell scripting + nftables

With iptables it was common to use a bash script comprised of multiple iptables commands to configure a firewall. This is sub-optimal because it is not atomic, that is to say that during the few fractions of a second that your bash script takes to run your firewall is in a partially configured state. Nftables introduces atomic rule replacement with the -f option. This is different from bash scripts because nftables will read in all of the included config files, create the config object in memory alongside the existing config, and then in one atomic operation it swaps the old config for the new one meaning there is no moment when the firewall is partially configured.

## Atomic Rule Replacement

You can use the -f option to atomically update your ruleset:

```% nft -f file```

Where file contains your ruleset.

You can save your ruleset by storing the existing listing in a file, ie.

```% nft list table filter > filter-table```

Then you can restore it by using the -f option:

```% nft -f filter-table```

Notes
Please, take these notes into consideration:

- **Table Creation:** you may have to create the table with nft create table ip filter before you can load the file exported with nft list table filter > filter-table otherwise you will hit errors because the table does not exist. Newer nftables releases behave with more consistency regarding this.
- **Duplicate Rules:** If you prepend the flush table filter line at the very beginning of the filter-table file, you achieve atomic ruleset replacement equivalent to what iptables-restore provides. The kernel handles the rule commands in the file in one single transaction, so basically the flushing and the load of the new rules happens in one single shot. If you choose not to flush your tables then you will see duplicate rules for each time you reloaded the config.
- **Flushing Sets:** flush table filter will not flush any sets defined in that table. To flush sets as well, use flush ruleset (available since Linux 3.17 ) or delete the sets explicitly. Early versions (Linux <=3.16) do not allow you to import a set if it already exists, but this is allowed in later versions.
- What happens when you include 2 files which each have a statement for the filter table? If you have two included files both with statements for the filter table, but one adds a rule allowing traffic from 192.168.1.1 and the other allows traffic from 192.168.1.2 then both rules will be included in the chain, even if one or both files contains a flush statement.
- What about flush statements in either, or neither file? If there are any flush commands in any included file then those will be run at the moment the config swap is executed, not at the moment the file is loaded. If you do not include a flush statement in any included file, you will get duplicate rules. If you do include a flush statement, you will not get duplicate rules and the config from *both* files will be included.
