# **[How to auto start LXD containers VM at boot time in Linux](https://www.cyberciti.biz/faq/how-to-auto-start-lxd-containers-at-boot-time-in-linux/)**

am using LXD (“Linux container”) based VM. How do I set an LXD container to start on boot in Linux operating system using lxc command?

We can always start the container when LXD starts on boot. All you have to do is set boot.autostart to true. You can define the order to start the containers in (starting with highest first) using boot.autostart.priority (the default value is 0) option. Next we can define the number of seconds to wait after the container started before starting the next one using the boot.autostart.delay option. This page explains how to auto start an LXD container at boot time using the lxc command.

Syntax to auto start LXD containers VM using the lxc command
Above discussed keys can be set using the lxc tool with the following syntax:

```bash
lxc config set {container-name} {key} {value}
lxc config set {container-name} boot.autostart {true|false}
lxc config set {container-name} boot.autostart.priority integer
lxc config set {container-name} boot.autostart.delay integer
```

How do I set an LXD container to start on boot in Ubuntu Linux 16.10?
Type the following command:
lxc config set {container-name} boot.autostart true

Set an LXD container name ‘nginx-vm’ to start on boot
lxc config set nginx-vm boot.autostart true

You can verify setting using the following syntax:
lxc config get {container-name} boot.autostart
lxc config get nginx-vm boot.autostart

Sample outputs:

true
You can the 10 seconds to wait after the container started before starting the next one using the following syntax:
lxc config set nginx-vm boot.autostart.delay 10

Finally, define the order to start the containers in by setting with highest value. Make sure db_vm container start first and next start nginx_vm
lxc config set db_vm boot.autostart.priority 100
lxc config set nginx_vm boot.autostart.priority 99

Use the following bash for loop on Linux to view all values:

```bash
#!/bin/bash
echo 'The current values of each vm boot parameters:'
for c in db_vm nginx_vm memcache_vm
do
   echo "*** VM: $c ***"
   for v in boot.autostart boot.autostart.priority boot.autostart.delay 
   do
      echo "Key: $v => $(lxc config get $c $v)"
   done
      echo ""
done
```

![i1](https://www.cyberciti.biz/media/new/faq/2017/02/Autostarting-LXD-containers-values.jpg)

```bash
Another way is to grab all lxd VMs using
#!/bin/bash
#
#x=$(lxc list -c n | awk '{ print $2}'  | sed -e '/^$/d' -e '/^NAME/d')
#A better way instead of using the sed and awk
#
x=$(lxc list --format csv -c n)
echo 'The current values of each vm boot parameters:'
for c in $x
do
   echo "*** VM: $c ***"
   for v in boot.autostart boot.autostart.priority boot.autostart.delay 
   do
      echo "Key: $v => $(lxc config get $c $v)"
   done
      echo ""
done
```

Conclusion
You learned how to auto-start an LXD container in Linux using the lxc command. An important variable for each LXD container are as follows::

boot.autostart – Always start the container when LXD starts when set to true. Another possible value is false.
boot.autostart.delay – Number of seconds (integer) to wait after the container started before starting the next one (default 0).
boot.autostart.priority– What order to start the containers in (starting with highest). In other words, LXD container ‘c1’ has 10 and ‘c2’ has value 5, then c1 will start first.
