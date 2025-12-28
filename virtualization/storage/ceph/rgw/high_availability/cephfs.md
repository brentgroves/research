# how does mds work with keepalived

Using Keepalived for Ceph Metadata Server (MDS) high availability is an optional, external method of providing a floating Virtual IP (VIP) to clients. The MDS daemon has its own built-in, native failover mechanism that typically manages the high availability process more efficiently, rendering Keepalived unnecessary for the core function of MDS failover.

How native Ceph MDS failover works
Ceph's built-in failover uses the Ceph Monitor cluster and an active-standby MDS architecture to manage metadata server availability.
MDS Daemons: In a high-availability CephFS configuration, you deploy more MDS daemons than there are active ranks (max_mds). For example, with max_mds set to one, you would deploy at least two MDS daemons.
Active and Standby States:
One MDS daemon is up:active and handles all metadata requests.
Other MDS daemons remain in up:standby mode, ready to take over if the active MDS fails.
Failure Detection: The Ceph monitors constantly check the health of the active MDS. If the active MDS stops sending a beacon message, the monitors mark it as failed.
Automatic Failover: Upon detecting a failure, the Ceph monitors automatically promote one of the standby MDS daemons to become up:active, minimizing downtime for metadata operations.
Standby-Replay (optional): For even faster failover, you can configure a standby MDS to be in standby_replay mode, where it follows the active MDS's metadata journal. This reduces the time needed for the newly active MDS to fully take over.
The limited role of Keepalived with MDS
Because Ceph's native failover is robust and automated, using Keepalived is not a standard practice for MDS high availability. However, it can be used for related network-level services, such as the Ceph management gateway. If you did integrate Keepalived, the setup would look like this:
For a legacy or non-standard configuration:
Virtual IP (VIP): Keepalived would manage a VIP, allowing clients to always connect to the same network address.
Health Checks: Instead of relying on Ceph's internal failure detection, Keepalived would run health checks on the MDS daemon. It can track a process (like ceph-mds) to determine the health of the host.
Active/Passive Failover:
The node running the active MDS would also run Keepalived in MASTER state, which holds the VIP.
A standby MDS node would run Keepalived in BACKUP state, monitoring the MASTER.
If Keepalived on the MASTER detects a failure, it relinquishes the VIP.
The BACKUP node then takes over the VIP and promotes its MDS to active.
The primary limitations of using Keepalived for MDS:
Redundancy: It duplicates the failure detection and failover logic that is already handled internally by Ceph.
Inefficiency: It relies on an external health check, which may be slower to react to MDS daemon problems than the Ceph monitors.
Complexity: It adds an extra layer of configuration and potential points of failure that are unnecessary for standard MDS high availability.
Conclusion
For Ceph MDS high availability, the recommended approach is to leverage Ceph's native active-standby or multi-active MDS architecture, which is specifically designed and optimized for this purpose. The Ceph monitor cluster handles all failover logic efficiently, so a separate solution like Keepalived is not required for the MDS daemons themselves. Keepalived is better suited for providing high availability for front-end load balancers or gateways that need a floating VIP.

## [mds states](https://docs.ceph.com/en/reef/cephfs/mds-states/#:~:text=The%20Metadata%20Server%20(MDS)%20goes,to%20operate%20as%20a%20standby.)**

**[](https://www.ibm.com/docs/en/storage-ceph/8.0.0?topic=overview-implementing-ha-cephfs-nfs-service#:~:text=You%20can%20deploy%20NFS%20with,NFS%20servers%20when%20they%20fail.)**

**[](<https://docs.ceph.com/en/mimic/cephfs/multimds/#:~:text=Increasing%20the%20MDS%20active%20cluster,the%20expected%20result%20of%20commands.&text=The%20newly%20created%20rank%20(1,enter%20this%20'active%20state>'.)*

```bash
ceph fs ls
name: lxd_cephfs, metadata pool: lxd_cephfs_meta, data pools: [lxd_cephfs_data ]
name: indFs, metadata pool: ind_cephfs_meta, data pools: [ind_cephfs_data ]

ceph fs get lxd_cephfs
Filesystem 'lxd_cephfs' (1)
fs_name lxd_cephfs
epoch   19
flags   12 joinable allow_snaps allow_multimds_snaps
created 2025-07-15T22:27:13.562653+0000
modified        2025-09-05T23:32:16.655454+0000
tableserver     0
root    0
session_timeout 60
session_autoclose       300
max_file_size   1099511627776
max_xattr_size  65536
required_client_features        {}
last_failure    0
last_failure_osd_epoch  330
compat  compat={},rocompat={},incompat={1=base v0.20,2=client writeable ranges,3=default file layouts on dirs,4=dir inode in separate object,5=mds uses versioned encoding,6=dirfrag is stored in omap,7=mds uses inline data,8=no anchor table,9=file layout v2,10=snaprealm v2,11=minor log segments,12=quiesce subvolumes}
max_mds 1
in      0
up      {0=44121}
failed
damaged
stopped
data_pools      [4]
metadata_pool   3
inline_data     disabled
balancer
bal_rank_mask   -1
standby_count_wanted    1
qdb_cluster     leader: 44121 members: 44121
[mds.micro11{0:44121} state up:active seq 19 addr [v2:10.188.50.201:6800/507780230,v1:10.188.50.201:6801/507780230] compat {c=[1],r=[1],i=[1fff]}]

ceph fs get lxd_cephfs max_mds
ceph fs set <fs_name> max_mds
```
