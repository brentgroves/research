# **[Mount CephFS](https://docs.ceph.com/en/latest/cephfs/mount-prerequisites)**

Mount CephFS: Prerequisites
You can use CephFS by mounting the file system on a machine or by using cephfs-shell. A system mount can be performed using the kernel driver as well as the FUSE driver. Both have their own advantages and disadvantages. Read the following section to understand more about both of these ways to mount CephFS.

For Windows CephFS mounts, please check the **[ceph-dokan](https://docs.ceph.com/en/latest/cephfs/ceph-dokan)** page.

## Which CephFS Client?

The FUSE client is the most accessible and the easiest to upgrade to the version of Ceph used by the storage cluster, while the kernel client will always gives better performance.

When encountering bugs or performance issues, it is often instructive to try using the other client, in order to find out whether the bug was client-specific or not (and then to let the developers know).

## General Pre-requisite for Mounting CephFS

Before mounting CephFS, ensure that the client host (where CephFS has to be mounted and used) has a copy of the Ceph configuration file (i.e. ceph.conf) and a keyring of the CephX user that has permission to access the MDS. Both of these files must already be present on the host where the Ceph MON resides.

ceph-mds is the metadata server daemon for the Ceph distributed file system. One or more instances of ceph-mds collectively manage the file system namespace.

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

Generate a minimal conf file for the client host and place it at a standard location:

```bash
# on client host

mkdir -p -m 755 /etc/ceph
ssh {user}@{mon-host} "sudo ceph config generate-minimal-conf" | sudo tee /etc/ceph/ceph.conf
```

Alternatively, you may copy the conf file. But the above method generates a conf with minimal details which is usually sufficient. For more information, see Client Authentication and Bootstrap Options.

Ensure that the conf has appropriate permissions:

`chmod 644 /etc/ceph/ceph.conf`

Create a CephX user and get its secret key:

`ssh {user}@{mon-host} "sudo ceph fs authorize cephfs client.foo / rw" | sudo tee /etc/ceph/ceph.client.foo.keyring`

In above command, replace cephfs with the name of your CephFS, foo by the name you want for your CephX user and / by the path within your CephFS for which you want to allow access to the client host and rw stands for both read and write permissions. Alternatively, you may copy the Ceph keyring from the MON host to client host at /etc/ceph but creating a keyring specific to the client host is better. While creating a CephX keyring/client, using same client name across multiple machines is perfectly fine.

If you get 2 prompts for password while running above any of 2 above command, run sudo ls (or any other trivial command with sudo) immediately before these commands.

Ensure that the keyring has appropriate permissions:

chmod 600 /etc/ceph/ceph.client.foo.keyring
Note

There might be few more prerequisites for kernel and FUSE mounts individually, please check respective mount documents.

Brought to you by the Ceph Foundation

The Ceph Documentation is a community resource funded and hosted by the non-profit Ceph Foundation. If you would like to support this and our other efforts, please consider **[joining now](https://ceph.io/en/foundation/join/)**.
