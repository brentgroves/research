# **[](https://docs.ceph.com/en/reef/rados/operations/monitoring/)**

Monitoring a Cluster
After you have a running cluster, you can use the ceph tool to monitor your cluster. Monitoring a cluster typically involves checking OSD status, monitor status, placement group status, and metadata server status.

Using the command line
Interactive mode
To run the ceph tool in interactive mode, type ceph at the command line with no arguments. For example:

```bash
ceph
health
status
quorum_status
mon stat
```

## Watching a Cluster

Each daemon in the Ceph cluster maintains a log of events, and the Ceph cluster itself maintains a cluster log that records high-level events about the entire Ceph cluster. These events are logged to disk on monitor servers (in the default location /var/log/ceph/ceph.log), and they can be monitored via the command line.

To follow the cluster log, run the following command:

```bash
ceph -w
Ceph will print the status of the system, followed by each log message as it is added. For example:

cluster:
  id:     477e46f1-ae41-4e43-9c8f-72c918ab0a20
  health: HEALTH_OK

services:
  mon: 3 daemons, quorum a,b,c
  mgr: x(active)
  mds: cephfs_a-1/1/1 up  {0=a=up:active}, 2 up:standby
  osd: 3 osds: 3 up, 3 in

data:
  pools:   2 pools, 16 pgs
  objects: 21 objects, 2.19K
  usage:   546 GB used, 384 GB / 931 GB avail
  pgs:     16 active+clean

2017-07-24 08:15:11.329298 mon.a mon.0 172.21.9.34:6789/0 23 : cluster [INF] osd.0 172.21.9.34:6806/20527 boot
2017-07-24 08:15:14.258143 mon.a mon.0 172.21.9.34:6789/0 39 : cluster [INF] Activating manager daemon x
2017-07-24 08:15:15.446025 mon.a mon.0 172.21.9.34:6789/0 47 : cluster [INF] Manager daemon x is now available
```

Instead of printing log lines as they are added, you might want to print only the most recent lines. Run ceph log last [n] to see the most recent n lines from the cluster log.
