# AI: can i use ceph cli from host that is not in the ceph cluster

Yes, you can use the Ceph CLI from a host that is not part of the Ceph cluster. You'll need to install the ceph-common package and configure it with the necessary credentials (keyring) and configuration file to interact with the cluster

Here's a breakdown:

1. Install ceph-common:
On the non-cluster host, install the ceph-common package, which includes the Ceph CLI tools (like ceph, rbd, etc.).
For example, on Debian/Ubuntu: sudo apt update && sudo apt install ceph-common
And on Red Hat/CentOS: sudo yum install ceph-common

```bash
# micro11
mkdir ~/ceph
sudo cp /var/snap/microceph/current/conf/ceph.keyring ~/ceph/
[sudo] password for brent: 
brent@micro11:~$ sudo cp /var/snap/microceph/current/conf/ceph.conf ~/ceph/
brent@micro11:~$ ls -alh ~/ceph/
total 16K
drwxrwxr-x 2 brent brent 4.0K Jul 17 22:55 .
drwxr-x--- 6 brent brent 4.0K Jul 17 22:54 ..
-rw-r--r-- 1 root  root   376 Jul 17 22:55 ceph.conf
-rw-r----- 1 root  root   102 Jul 17 22:55 ceph.keyring
brent@micro11:~$ sudo chmod 777 ~/ceph/*
brent@micro11:~$ ls -alh ~/ceph/
total 16K
drwxrwxr-x 2 brent brent 4.0K Jul 17 22:55 .
drwxr-x--- 6 brent brent 4.0K Jul 17 22:54 ..
-rwxrwxrwx 1 root  root   376 Jul 17 22:55 ceph.conf
-rwxrwxrwx 1 root  root   102 Jul 17 22:55 ceph.keyring

# research11
sudo -i
mkdir /mnt/mycephfs
mkdir /etc/ceph
exit


cd ~/src/secrets
lftp brent@10.188.50.201
cd ~/ceph/
get ceph.conf
get ceph.keyring
exit

cp ~/ceph/* /etc/ceph/

ll /etc/ceph/
```

## Client Operations

Download ‘ceph-common’ package:

```bash
sudo apt install ceph-common
Setting system user ceph properties..usermod: unlocking the user's password would result in a passwordless account.
You should set a password with usermod -p to unlock this user's password.
..done
chown: cannot access '/var/log/ceph/*.log*': No such file or directory
Created symlink /etc/systemd/system/multi-user.target.wants/ceph.target → /usr/lib/systemd/system/ceph.target.
Created symlink /etc/systemd/system/multi-user.target.wants/rbdmap.service → /usr/lib/systemd/system/rbdmap.service.
Processing triggers for man-db (2.12.0-4build2) ...
Processing triggers for libc-bin (2.39-0ubuntu8.5) ...

This step is required for mount.ceph i.e. making mount aware of ceph device type.

Fetch the ceph.conf and ceph.keyring file :

Ideally, a keyring file for any Cephx user which has access to CephFs will work. For the sake of simplicity, we are using admin keys in this example.

ls /etc/ceph/
ceph.client.admin.keyring  ceph.conf  ceph.keyring  metadata.yaml
```

The files are located at the paths shown above on any MicroCeph node. The kernel driver, by-default looks into /etc/ceph so we will create symbolic links to that folder.

Mount the filesystem:

```bash
sudo mkdir /mnt/mycephfs
# $ sudo mount -t ceph :/ /mnt/mycephfs/ -o name=admin,fs=newFs
sudo mount -t ceph :/ /mnt/mycephfs/ -o name=admin,fs=lxd_cephfs
ls /mnt/mycephfs/
custom  custom-snapshots
```

Here, we provide the Cephx user (admin in our example) and the fs created earlier (newFs).

With this, you now have a CephFs mounted at /mnt/mycephfs on your client machine that you can perform IO to.

## Perform IO and observe the ceph cluster

Write a file:

```bash
ls /mnt/mycephfs
custom  custom-snapshots
$ cd /mnt/mycephfs
$ sudo dd if=/dev/zero of=random.img count=1 bs=50M
52428800 bytes (52 MB, 50 MiB) copied, 0.0491968 s, 1.1 GB/s

$ ll
...
-rw-r--r-- 1 root root 52428800 Jun 25 16:04 random.img
```

## AI: can i use ceph cli from host that is not in the ceph cluster

Yes, you can use the Ceph CLI from a host that is not part of the Ceph cluster. You'll need to install the ceph-common package and configure it with the necessary credentials (keyring) and configuration file to interact with the cluster

Here's a breakdown:

1. Install ceph-common:
On the non-cluster host, install the ceph-common package, which includes the Ceph CLI tools (like ceph, rbd, etc.).
For example, on Debian/Ubuntu: sudo apt update && sudo apt install ceph-common
And on Red Hat/CentOS: sudo yum install ceph-common
