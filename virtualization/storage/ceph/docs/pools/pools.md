# **[pools](https://docs.ceph.com/en/mimic/rados/operations/pools)**

When you first deploy a cluster without creating a pool, Ceph uses the default pools for storing data. A pool provides you with:

**Resilience:** You can set how many OSD are allowed to fail without losing data. For replicated pools, it is the desired number of copies/replicas of an object. A typical configuration stores an object and one additional copy (i.e., size = 2), but you can determine the number of copies/replicas. For erasure coded pools, it is the number of coding chunks (i.e. m=2 in the erasure code profile)

**Placement Groups:** You can set the number of placement groups for the pool. A typical configuration uses approximately 100 placement groups per OSD to provide optimal balancing without using up too many computing resources. When setting up multiple pools, be careful to ensure you set a reasonable number of placement groups for both the pool and the cluster as a whole.

**CRUSH Rules:** When you store data in a pool, placement of the object and its replicas (or chunks for erasure coded pools) in your cluster is governed by CRUSH rules. You can create a custom CRUSH rule for your pool if the default rule is not appropriate for your use case.

**Snapshots:** When you create snapshots with ceph osd pool mksnap, you effectively take a snapshot of a particular pool.

To organize data into pools, you can list, create, and remove pools. You can also view the utilization statistics for each pool.

## List Pools

To list your cluster’s pools, execute:

```bash
ceph osd lspools
1 lxd_remote
2 .mgr
3 lxd_cephfs_meta
4 lxd_cephfs_data
5 ind_cephfs_meta
6 ind_cephfs_data
7 .rgw.root
8 default.rgw.log
9 default.rgw.control
10 default.rgw.meta
11 default.rgw.buckets.index
12 default.rgw.buckets.data
```

## Show Pool Statistics¶

To show a pool’s utilization statistics, execute:

`rados df`

## Create a Pool

Before creating pools, refer to the Pool, PG and CRUSH Config Reference. Ideally, you should override the default value for the number of placement groups in your Ceph configuration file, as the default is NOT ideal. For details on placement group numbers refer to setting the number of placement groups

Note Starting with Luminous, all pools need to be associated to the application using the pool. See Associate Pool to Application below for more information.
For example:

osd pool default pg num = 100
osd pool default pgp num = 100
To create a pool, execute:

ceph osd pool create {pool-name} {pg-num} [{pgp-num}] [replicated] \
     [crush-rule-name] [expected-num-objects]
ceph osd pool create {pool-name} {pg-num}  {pgp-num}   erasure \
     [erasure-code-profile] [crush-rule-name] [expected_num_objects]
Where:

{pool-name}

Description
The name of the pool. It must be unique.

Type
String

Required
Yes.

{pg-num}

Description
The total number of placement groups for the pool. See Placement Groups for details on calculating a suitable number. The default value 8 is NOT suitable for most systems.

Type
Integer

Required
Yes.

Default
8

{pgp-num}

Description
The total number of placement groups for placement purposes. This should be equal to the total number of placement groups, except for placement group splitting scenarios.

Type
Integer

Required
Yes. Picks up default or Ceph configuration value if not specified.

Default
8

{replicated|erasure}

Description
The pool type which may either be replicated to recover from lost OSDs by keeping multiple copies of the objects or erasure to get a kind of generalized RAID5 capability. The replicated pools require more raw storage but implement all Ceph operations. The erasure pools require less raw storage but only implement a subset of the available operations.

Type
String

Required
No.

Default
replicated

[crush-rule-name]

Description
The name of a CRUSH rule to use for this pool. The specified rule must exist.

Type
String

Required
No.

Default
For replicated pools it is the rule specified by the osd pool default crush rule config variable. This rule must exist. For erasure pools it is erasure-code if the default erasure code profile is used or {pool-name} otherwise. This rule will be created implicitly if it doesn’t exist already.

[erasure-code-profile=profile]

Description
For erasure pools only. Use the erasure code profile. It must be an existing profile as defined by osd erasure-code-profile set.

Type
String

Required
No.

When you create a pool, set the number of placement groups to a reasonable value (e.g., 100). Consider the total number of placement groups per OSD too. Placement groups are computationally expensive, so performance will degrade when you have many pools with many placement groups (e.g., 50 pools with 100 placement groups each). The point of diminishing returns depends upon the power of the OSD host.

See Placement Groups for details on calculating an appropriate number of placement groups for your pool.

[expected-num-objects]

Description
The expected number of objects for this pool. By setting this value ( together with a negative filestore merge threshold), the PG folder splitting would happen at the pool creation time, to avoid the latency impact to do a runtime folder splitting.

Type
Integer

Required
No.

Default
0, no splitting at the pool creation time.
