# **[How to recover a MicroCloud cluster](https://documentation.ubuntu.com/microcloud/latest/microcloud/how-to/recover/#howto-recover)**

Note

Each MicroCloud service uses the Dqlite distributed database for highly-available storage. While the cluster recovery process is similar for each service, this document only covers cluster recovery for the microcloudd daemon. For cluster recovery procedures for LXD, MicroCeph and MicroOVN, see:

**[How to recover a LXD cluster](https://documentation.ubuntu.com/microcloud/latest/lxd/howto/cluster_recover/#cluster-recover)**

**[MicroOVN Launchpad Bug](https://bugs.launchpad.net/microovn/+bug/2072377)**

**[MicroCeph Issue](https://github.com/canonical/microceph/issues/380)**

MicroCloud requires a majority of the database voters (a quorum) to be accessible in order to perform database operations. If a cluster has less than a quorum of voters up and accessible, then database operations will no longer be possible on the entire cluster.

If the loss of quorum is temporary (e.g. some members temporarily lose power), database operations will be restored when the offline members come back online.

This document describes how to recover database access if the offline members have been lost without the possibility of recovery (e.g. disk failure).

Recovery procedure
Shut down all cluster members before performing cluster recovery:

sudo snap stop microcloud
Once all cluster members are shut down, determine which Dqlite database is most up to date. Look for files in /var/snap/microcloud/common/state/database whose filenames are two numbers separated by a dash (i.e. 0000000000056436-0000000000056501). The largest second number in that directory is the end index of the most recently closed segment (56501 in the example). The cluster member with the highest end index is the most up to date.

On the most up-to-date cluster member, use the following command to reconfigure the Dqlite roles for each member:

`sudo microcloud cluster recover`

## As indicated by the output of the above command, copy /var/snap/microcloud/common/state/recovery_db.tar.gz to the same path on each cluster member

Restart MicroCloud. The recovered database tarball will be loaded on daemon startup. Once a quorum of voters have been started, the MicroCloud database will become available.

sudo snap start microcloud
Backups
MicroCloud creates a backup of the database directory before performing the recovery operation to ensure that no data is lost. The backup tarball is created in /var/snap/microcloud/common/state/. If the cluster recovery operation fails, use the following commands to restore the existing database:

```bash
cd /var/snap/microcloud/common/state
sudo mv database broken_db
sudo tar -xf db_backup.TIMESTAMP.tar.gz
```
