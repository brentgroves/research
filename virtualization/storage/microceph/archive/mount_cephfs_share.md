# **[Mount MicroCeph backed CephFs shares](https://canonical-microceph.readthedocs-hosted.com/latest/how-to/mount-cephfs-share/)**

CephFs (Ceph Filesystem) are filesystem shares backed by the Ceph storage cluster. This tutorial will guide you with mounting CephFs shares using MicroCeph.

The above will be achieved by creating an fs on the MicroCeph deployed Ceph cluster, and then mounting it using the kernel driver.

MicroCeph Operations:
Check Ceph cluster’s status:

```bash
$ sudo ceph -s
  cluster:
    id:     d2a9147c-e5b7-4848-822b-b10927455163
    health: HEALTH_OK
 
  services:
    mon: 3 daemons, quorum micro11,micro12,micro13 (age 2d)
    mgr: micro11(active, since 2d), standbys: micro12, micro13
    mds: 1/1 daemons up, 2 standby
    osd: 3 osds: 3 up (since 2d), 3 in (since 2d)
 
  data:
    volumes: 1/1 healthy
    pools:   4 pools, 97 pgs
    objects: 1.26k objects, 3.2 GiB
    usage:   13 GiB used, 5.4 TiB / 5.5 TiB avail
    pgs:     97 active+clean

```

Create data/metadata pools for CephFs:

```bash
ceph osd lspools
1 lxd_remote
2 .mgr
3 lxd_cephfs_meta
4 lxd_cephfs_data
# For even more detailed information about the pools, you can use: ceph osd pool ls detail.

ceph osd pool ls detail
pool 1 'lxd_remote' replicated size 3 min_size 2 crush_rule 2 object_hash rjenkins pg_num 32 pgp_num 32 autoscale_mode on last_change 45 flags hashpspool,selfmanaged_snaps stripe_width 0 application rbd read_balance_score 1.31
pool 2 '.mgr' replicated size 3 min_size 2 crush_rule 2 object_hash rjenkins pg_num 1 pgp_num 1 autoscale_mode on last_change 37 flags hashpspool stripe_width 0 pg_num_max 32 pg_num_min 1 application mgr read_balance_score 3.00
pool 3 'lxd_cephfs_meta' replicated size 3 min_size 2 crush_rule 2 object_hash rjenkins pg_num 32 pgp_num 32 autoscale_mode on last_change 39 flags hashpspool stripe_width 0 pg_autoscale_bias 4 pg_num_min 16 recovery_priority 5 application cephfs read_balance_score 1.31
pool 4 'lxd_cephfs_data' replicated size 3 min_size 2 crush_rule 2 object_hash rjenkins pg_num 32 pgp_num 32 autoscale_mode on last_change 40 flags hashpspool stripe_width 0 application cephfs read_balance_score 1.03

sudo ceph osd pool create ind_cephfs_meta
pool 'ind_cephfs_meta' created
sudo ceph osd pool create ind_cephfs_data
pool 'ind_cephfs_data' created
ceph osd lspools
1 lxd_remote
2 .mgr
3 lxd_cephfs_meta
4 lxd_cephfs_data
5 ind_cephfs_meta
6 ind_cephfs_data

# Create CephFs share:

ceph fs new indFs ind_cephfs_meta ind_cephfs_data
  Pool 'ind_cephfs_data' (id '6') has pg autoscale mode 'on' but is not marked as bulk.
  Consider setting the flag by running
    # ceph osd pool set ind_cephfs_data bulk true
new fs with metadata pool 5 and data pool 6

# In Ceph, the pg_autoscale_mode and bulk flags on a pool are related but distinct. Enabling pg_autoscale_mode allows Ceph to automatically adjust the number of Placement Groups (PGs) based on usage, while the bulk flag indicates that a pool is expected to grow large and should start with a higher initial number of PGs. If a pool has pg_autoscale_mode enabled but is not marked as bulk, the autoscaler will initially start with a minimal number of PGs and add more as needed based on usage. 

ceph fs ls
name: lxd_cephfs, metadata pool: lxd_cephfs_meta, data pools: [lxd_cephfs_data ]
name: indFs, metadata pool: ind_cephfs_meta, data pools: [ind_cephfs_data ]
```

Mount the filesystem:

```bash
mkdir /mnt/mycephfs
mount -t ceph :/ /mnt/mycephfs/ -o name=admin,fs=indFs
umount /mnt/mycephfs
ls -alh /mnt/mycephfs
total 4.5K
drwxrwxrwx 2 root  root     4 Jul 18 17:26 .
drwxr-xr-x 6 root  root  4.0K Aug  4 18:01 ..
-rw-r--r-- 1 root  root     0 Jul 18 17:13 test2.md
-rw-rw-r-- 1 brent brent   16 Jul 18 17:25 test3.md
-rw-r--r-- 1 root  root     0 Jul 18 17:15 test4.md
-rw-rw-r-- 1 brent brent    0 Jul 18 17:09 test.md
```
