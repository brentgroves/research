# **[](https://canonical-microceph.readthedocs-hosted.com/stable/reference/commands/)**

MicroCeph CLI Commands
Use these commands to initialise, deploy and manage your MicroCeph cluster.

client
cluster
disable
disk
enable
help
init
pool
remote
replication
status

```bash
microceph disk list
Disks configured in MicroCeph:
+-----+----------+--------------------------------------------------------+
| OSD | LOCATION |                          PATH                          |
+-----+----------+--------------------------------------------------------+
| 1   | micro11  | /dev/disk/by-id/wwn-0x6c81f660dba9cd002fef438b174afe15 |
+-----+----------+--------------------------------------------------------+
| 2   | micro12  | /dev/disk/by-id/wwn-0x6c81f660dba9cc002fedeb53d8986a2b |
+-----+----------+--------------------------------------------------------+
| 3   | micro13  | /dev/disk/by-id/wwn-0x6c81f660dbaa01002fef0cf4275f32f1 |
+-----+----------+--------------------------------------------------------+

Available unpartitioned disks on this system:
+-----------+-----------+------+--------------------------------------------------------+
|   MODEL   | CAPACITY  | TYPE |                          PATH                          |
+-----------+-----------+------+--------------------------------------------------------+
| PERC H710 | 465.25GiB | scsi | /dev/disk/by-id/wwn-0x6c81f660dba9cd002ffb00930d3d91c9 |
+-----------+-----------+------+--------------------------------------------------------+
```
