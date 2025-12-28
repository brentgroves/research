# research cluster

Don't deploy **[charmed ceph](https://discourse.ubuntu.com/t/deploy-charmed-ceph-on-lxd/56554)** on this cluster, since the machines have little ram.

## uninstall

```bash
sudo -i
lxc remote switch micro11
sudo snap stop lxd 
sudo snap disable lxd 
sudo snap remove --purge lxd
```

## config questions

### bootstrap server research11

reserve dhcp 10.188.40.11, 10.188.40.19

```bash
lxd init

```

Would you like to use LXD clustering? (yes/no) [default=no]: yes
What IP address or DNS name should be used to reach this server? [default=192.0.2.101]: 10.188.40.11
Are you joining an existing cluster? (yes/no) [default=no]: no
What member name should be used to identify this server in the cluster? [default=server1]: research11
Do you want to configure a new local storage pool? (yes/no) [default=yes]:
Name of the storage backend to use (btrfs, dir, lvm, zfs) [default=zfs]:
Create a new ZFS pool? (yes/no) [default=yes]:
Would you like to use an existing empty block device (e.g. a disk or partition)? (yes/no) [default=no]: yes
/dev/sda

### research12

Would you like to use LXD clustering? (yes/no) [default=no]: yes
What IP address or DNS name should be used to reach this server? [default=192.0.2.101]: 10.188.40.19
Are you joining an existing cluster? (yes/no) [default=no]: yes
What member name should be used to identify this server in the cluster? [default=server1]: research12
Do you want to configure a new local storage pool? (yes/no) [default=yes]:
Name of the storage backend to use (btrfs, dir, lvm, zfs) [default=zfs]:
Create a new ZFS pool? (yes/no) [default=yes]:
Would you like to use an existing empty block device (e.g. a disk or partition)? (yes/no) [default=no]: yes
/dev/sda
Do you want to configure a new remote storage pool? (yes/no) [default=no]:
Would you like to connect to a MAAS server? (yes/no) [default=no]:
Would you like to configure LXD to use an existing bridge or host interface? (yes/no) [default=no]:
Would you like to create a new Fan overlay network? (yes/no) [default=yes]:
What subnet should be used as the Fan underlay? [default=auto]:
Would you like stale cached images to be updated automatically? (yes/no) [default=yes]:
Would you like a YAML "lxd init" preseed to be printed? (yes/no) [default=no]:
