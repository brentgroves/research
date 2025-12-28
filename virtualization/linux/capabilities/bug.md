# **[bug](https://bugs.launchpad.net/ubuntu/+source/lxd/+bug/2057927)**

Since I upgraded to Noble the lxd vga console doesn't work anymore. I am using the lxd latest/stable snap (5.20-f3dd836). When trying to attach a vga console to an lxd vm I get:

unshare: write failed /proc/self/uid_map: Operation not permitted

It seems to be related to apparmor, I can see a matching DENIAL message in dmesg:

[ 4735.233989] audit: type=1400 audit(1710419600.517:300): apparmor="DENIED" operation="capable" class="cap" profile="unprivileged_userns" pid=13157 comm="unshare" capability=21 capname="sys_admin"

## response 1

I see a basically identical message (and dmesg apparmor output) with "lxc profile edit default":

  unshare: write failed /proc/self/uid_map: Operation not permitted

And the dmesg entry:

  [ 194.625507] audit: type=1400 audit(1711709095.424:293): apparmor="DENIED" operation="capable" class="cap" profile="unprivileged_userns" pid=6885 comm="unshare" capability=21 capname="sys_admin"

## Please can you confirm if still an issue on lxd 5.21/stable as this is the current supported version. Thanks

I just tested 5.21/stable and couldn't reproduce as it properly disable the /proc/sys/kernel/apparmor_restrict_unprivileged_userns and /proc/sys/kernel/apparmor_restrict_unprivileged_unconfined that would otherwise have caused those denials.

Marking as incomplete until you can reproduce with 5.21/stable (5.20 being EOL). Thanks

$ lxd --version
5.21.1 LTS
$ lxc console --type=vga testinstance
unshare: write failed /proc/self/uid_map: Operation not permitted
