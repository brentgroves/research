# **[Keyring Management](https://docs.ceph.com/en/reef/rados/operations/user-management/#keyring-management)**

When you access Ceph via a Ceph client, the Ceph client will look for a local keyring. Ceph presets the keyring setting with four keyring names by default. For this reason, you do not have to set the keyring names in your Ceph configuration file unless you want to override these defaults (which is not recommended). The four default keyring names are as follows:

```bash

# The $cluster metavariable found in the first two default keyring names above is your Ceph cluster name as defined by the name of the Ceph configuration file: for example, if the Ceph configuration file is named ceph.conf, then your Ceph cluster name is ceph and the second name above would be ceph.keyring. The $name metavariable is the user type and user ID: for example, given the user client.admin, the first name above would be ceph.client.admin.keyring.

/etc/ceph/$cluster.$name.keyring
/etc/ceph/$cluster.keyring
/etc/ceph/keyring
/etc/ceph/keyring.bin

ll /var/snap/microceph/current/conf
total 32
drwxr-xr-x 2 root root 4096 Jul 18 21:56 ./
drwxr-xr-x 4 root root 4096 Jul 15 22:26 ../
-rw------- 1 root root  151 Jul 15 22:26 ceph.client.admin.keyring
lrwxrwxrwx 1 root root   68 Jul 18 21:56 ceph.client.radosgw.gateway.keyring -> /var/snap/microceph/common/data/radosgw/ceph-radosgw.gateway/keyring
-rw-r--r-- 1 root root  376 Jul 15 22:27 ceph.conf
-rw-r----- 1 root root  102 Jul 15 22:27 ceph.keyring
-rw-r--r-- 1 root root   64 Jul 15 18:11 metadata.yaml
-rw-r--r-- 1 root root  266 Jul 18 21:56 radosgw.conf
```

Note

When running commands that read or write to /etc/ceph, you might need to use sudo to run the command as root.

After you create a user (for example, client.ringo), you must get the key and add it to a keyring on a Ceph client so that the user can access the Ceph Storage Cluster.

The User Management section details how to list, get, add, modify, and delete users directly in the Ceph Storage Cluster. In addition, Ceph provides the ceph-authtool utility to allow you to manage keyrings from a Ceph client.

## Creating a Keyring

When you use the procedures in the Managing Users section to create users, you must provide user keys to the Ceph client(s). This is required so that the Ceph client(s) can retrieve the key for the specified user and authenticate that user against the Ceph Storage Cluster. Ceph clients access keyrings in order to look up a user name and retrieve the user’s key.

The ceph-authtool utility allows you to create a keyring. To create an empty keyring, use --create-keyring or -C. For example:

ceph-authtool --create-keyring /path/to/keyring
When creating a keyring with multiple users, we recommend using the cluster name (of the form $cluster.keyring) for the keyring filename and saving the keyring in the /etc/ceph directory. By doing this, you ensure that the keyring configuration default setting will pick up the filename without requiring you to specify the filename in the local copy of your Ceph configuration file. For example, you can create ceph.keyring by running the following command:

```bash
sudo ceph-authtool -C /etc/ceph/ceph.keyring
```
