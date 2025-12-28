# **[User Management](https://docs.ceph.com/en/reef/rados/operations/user-management/#user-management)**

This document describes Ceph Client users, and describes the process by which they perform authentication and authorization so that they can access the Ceph Storage Cluster. Users are either individuals or system actors (for example, applications) that use Ceph clients to interact with the Ceph Storage Cluster daemons.

![i1](https://docs.ceph.com/en/reef/_images/ditaa-e4363571a389f38b579ed95f21e5b3b8e719866e.png)

When Ceph runs with authentication and authorization enabled (both are enabled by default), you must specify a user name and a keyring that contains the secret key of the specified user (usually these are specified via the command line). If you do not specify a user name, Ceph will use client.admin as the default user name. If you do not specify a keyring, Ceph will look for a keyring via the keyring setting in the Ceph configuration. For example, if you execute the ceph health command without specifying a user or a keyring, Ceph will assume that the keyring is in /etc/ceph/ceph.client.admin.keyring and will attempt to use that keyring. The following illustrates this behavior:

`ceph health`

Ceph will interpret the command like this:

```bash
ceph -n client.admin --keyring=/etc/ceph/ceph.client.admin.keyring health
```

Alternatively, you may use the CEPH_ARGS environment variable to avoid re-entry of the user name and secret.

For details on configuring the Ceph Storage Cluster to use authentication, see **[Cephx Config Reference](https://docs.ceph.com/en/reef/rados/configuration/auth-config-ref)**. For details on the architecture of Cephx, see **[Architecture - High Availability Authentication](https://docs.ceph.com/en/reef/architecture#high-availability-authentication)**.

## Background

No matter what type of Ceph client is used (for example: Block Device, Object Storage, Filesystem, native API), Ceph stores all data as RADOS objects within pools. Ceph users must have access to a given pool in order to read and write data, and Ceph users must have execute permissions in order to use Ceph’s administrative commands. The following concepts will help you understand Ceph[‘s] user management.

## User

A user is either an individual or a system actor (for example, an application). Creating users allows you to control who (or what) can access your Ceph Storage Cluster, its pools, and the data within those pools.

Ceph has the concept of a type of user. For purposes of user management, the type will always be client. Ceph identifies users in a “period- delimited form” that consists of the user type and the user ID: for example, TYPE.ID, client.admin, or client.user1. The reason for user typing is that the Cephx protocol is used not only by clients but also non-clients, such as Ceph Monitors, OSDs, and Metadata Servers. Distinguishing the user type helps to distinguish between client users and other users. This distinction streamlines access control, user monitoring, and traceability.

Sometimes Ceph’s user type might seem confusing, because the Ceph command line allows you to specify a user with or without the type, depending upon your command line usage. If you specify --user or --id, you can omit the type. For example, client.user1 can be entered simply as user1. On the other hand, if you specify --name or -n, you must supply the type and name: for example, client.user1. We recommend using the type and name as a best practice wherever possible.

Note

A Ceph Storage Cluster user is not the same as a Ceph Object Storage user or a Ceph File System user. The Ceph Object Gateway uses a Ceph Storage Cluster user to communicate between the gateway daemon and the storage cluster, but the Ceph Object Gateway has its own user-management functionality for end users. The Ceph File System uses POSIX semantics, and the user space associated with the Ceph File System is not the same as the user space associated with a Ceph Storage Cluster user.

## Authorization (Capabilities)

Ceph uses the term “capabilities” (caps) to describe the permissions granted to an authenticated user to exercise the functionality of the monitors, OSDs, and metadata servers. Capabilities can also restrict access to data within a pool, a namespace within a pool, or a set of pools based on their application tags. A Ceph administrative user specifies the capabilities of a user when creating or updating that user.

## Capability syntax follows this form

`{daemon-type} '{cap-spec}[, {cap-spec} ...]'`

- **Monitor Caps:** Monitor capabilities include r, w, x access settings, and can be applied in aggregate from pre-defined profiles with profile {name}. For example:

```ini
mon 'allow {access-spec} [network {network/prefix}]'

mon 'profile {name}'
```

The {access-spec} syntax is as follows:

`* | all | [r][w][x]`

The optional {network/prefix} is a standard network name and prefix length in CIDR notation (for example, 10.3.0.0/16). If {network/prefix} is present, the monitor capability can be used only by clients that connect from the specified network.

- **OSD Caps:** OSD capabilities include r, w, x, and class-read and class-write access settings. OSD capabilities can be applied in aggregate from pre-defined profiles with profile {name}. In addition, OSD capabilities allow for pool and namespace settings.

```ini
osd 'allow {access-spec} [{match-spec}] [network {network/prefix}]'

osd 'profile {name} [pool={pool-name}] [namespace={namespace-name}] [network {network/prefix}]'
```

There are two alternative forms of the {access-spec} syntax:

```ini
- | all | [r][w][x] [class-read] [class-write]

class {class name} [{method name}]
```

There are four alternative forms of the optional {match-spec} syntax:

```ini
pool={pool-name} [namespace={namespace-name}] [object_prefix {prefix}]

[pool={pool-name}] namespace={namespace-name} [object_prefix {prefix}]

[pool={pool-name}] [namespace={namespace-name}] object_prefix {prefix}

[namespace={namespace-name}] tag {application} {key}={value}
```

The optional {network/prefix} is a standard network name and prefix length in CIDR notation (for example, 10.3.0.0/16). If {network/prefix} is present, the OSD capability can be used only by clients that connect from the specified network.

- **Manager Caps:** Manager (ceph-mgr) capabilities include r, w, x access settings, and can be applied in aggregate from pre-defined profiles with profile {name}. For example:

```ini
mgr 'allow {access-spec} [network {network/prefix}]'

mgr 'profile {name} [{key1} {match-type} {value1} ...] [network {network/prefix}]'
```

Manager capabilities can also be specified for specific commands, for all commands exported by a built-in manager service, or for all commands exported by a specific add-on module. For example:

```ini
mgr 'allow command "{command-prefix}" [with {key1} {match-type} {value1} ...] [network {network/prefix}]'

mgr 'allow service {service-name} {access-spec} [network {network/prefix}]'

mgr 'allow module {module-name} [with {key1} {match-type} {value1} ...] {access-spec} [network {network/prefix}]'
```

The {access-spec} syntax is as follows:

`- | all | [r][w][x]`

The {service-name} is one of the following:

`mgr | osd | pg | py`

The {match-type} is one of the following:

`= | prefix | regex`

- **Metadata Server Caps:** For administrators, use allow *. For all other users (for example, CephFS clients), consult **[CephFS Client Capabilities](https://docs.ceph.com/en/reef/cephfs/client-auth/)**

Note

The Ceph Object Gateway daemon (radosgw) is a client of the Ceph Storage Cluster. For this reason, it is not represented as a Ceph Storage Cluster daemon type.

The following entries describe access capabilities.

allow

Description
:
Precedes access settings for a daemon. Implies rw for MDS only.

r

Description
:
Gives the user read access. Required with monitors to retrieve the CRUSH map.

w

Description
:
Gives the user write access to objects.

x

Description
:
Gives the user the capability to call class methods (that is, both read and write) and to conduct auth operations on monitors.

class-read

Descriptions
:
Gives the user the capability to call class read methods. Subset of x.

class-write

Description
:
Gives the user the capability to call class write methods. Subset of x.

*, all

Description
:
Gives the user read, write, and execute permissions for a particular daemon/pool, as well as the ability to execute admin commands.

The following entries describe valid capability profiles:

profile osd (Monitor only)

Description
:
Gives a user permissions to connect as an OSD to other OSDs or monitors. Conferred on OSDs in order to enable OSDs to handle replication heartbeat traffic and status reporting.

profile mds (Monitor only)

Description
:
Gives a user permissions to connect as an MDS to other MDSs or monitors.

profile bootstrap-osd (Monitor only)

Description
:
Gives a user permissions to bootstrap an OSD. Conferred on deployment tools such as ceph-volume and cephadm so that they have permissions to add keys when bootstrapping an OSD.

profile bootstrap-mds (Monitor only)

Description
:
Gives a user permissions to bootstrap a metadata server. Conferred on deployment tools such as cephadm so that they have permissions to add keys when bootstrapping a metadata server.

profile bootstrap-rbd (Monitor only)

Description
:
Gives a user permissions to bootstrap an RBD user. Conferred on deployment tools such as cephadm so that they have permissions to add keys when bootstrapping an RBD user.

profile bootstrap-rbd-mirror (Monitor only)

Description
:
Gives a user permissions to bootstrap an rbd-mirror daemon user. Conferred on deployment tools such as cephadm so that they have permissions to add keys when bootstrapping an rbd-mirror daemon.

profile rbd (Manager, Monitor, and OSD)

Description
:
Gives a user permissions to manipulate RBD images. When used as a Monitor cap, it provides the user with the minimal privileges required by an RBD client application; such privileges include the ability to blocklist other client users. When used as an OSD cap, it provides an RBD client application with read-write access to the specified pool. The Manager cap supports optional pool and namespace keyword arguments.

profile rbd-mirror (Monitor only)

Description
:
Gives a user permissions to manipulate RBD images and retrieve RBD mirroring config-key secrets. It provides the minimal privileges required for the user to manipulate the rbd-mirror daemon.

profile rbd-read-only (Manager and OSD)

Description
:
Gives a user read-only permissions to RBD images. The Manager cap supports optional pool and namespace keyword arguments.

profile simple-rados-client (Monitor only)

Description
:
Gives a user read-only permissions for monitor, OSD, and PG data. Intended for use by direct librados client applications.

profile simple-rados-client-with-blocklist (Monitor only)

Description
:
Gives a user read-only permissions for monitor, OSD, and PG data. Intended for use by direct librados client applications. Also includes permissions to add blocklist entries to build high-availability (HA) applications.

profile fs-client (Monitor only)

Description
:
Gives a user read-only permissions for monitor, OSD, PG, and MDS data. Intended for CephFS clients.

profile role-definer (Monitor and Auth)

Description
:
Gives a user all permissions for the auth subsystem, read-only access to monitors, and nothing else. Useful for automation tools. Do not assign this unless you really, really know what you’re doing, as the security ramifications are substantial and pervasive.

profile crash (Monitor and MGR)

Description
:
Gives a user read-only access to monitors. Used in conjunction with the manager crash module to upload daemon crash dumps into monitor storage for later analysis.

Important

If you run the command ceph auth caps client.admin mgr 'allow*', you will remove necessary capabilities from client.admin. To repair this, run a command of the following form from within the /var/lib/ceph/mon/<monitor_name> directory:

```bash
ceph -n mon. --keyring keyring auth caps client.admin mds 'allow *' osd 'allow*' mon 'allow *'
```

Pool
A pool is a logical partition where users store data. In Ceph deployments, it is common to create a pool as a logical partition for similar types of data. For example, when deploying Ceph as a back end for OpenStack, a typical deployment would have pools for volumes, images, backups and virtual machines, and such users as client.glance and client.cinder.

Application Tags
Access may be restricted to specific pools as defined by their application metadata. The *wildcard may be used for the key argument, the value argument, or both. The all tag is a synonym for*.

Namespace
Objects within a pool can be associated to a namespace: that is, to a logical group of objects within the pool. A user’s access to a pool can be associated with a namespace so that reads and writes by the user can take place only within the namespace. Objects written to a namespace within the pool can be accessed only by users who have access to the namespace.

Note

Namespaces are primarily useful for applications written on top of librados. In such situations, the logical grouping provided by namespaces can obviate the need to create different pools. In Luminous and later releases, Ceph Object Gateway uses namespaces for various metadata objects.

The rationale for namespaces is this: namespaces are relatively less computationally expensive than pools, which (pools) can be a computationally expensive method of segregating data sets between different authorized users.

For example, a pool ought to host approximately 100 placement-group replicas per OSD. This means that a cluster with 1000 OSDs and three 3R replicated pools would have (in a single pool) 100,000 placement-group replicas, and that means that it has 33,333 Placement Groups.

By contrast, writing an object to a namespace simply associates the namespace to the object name without incurring the computational overhead of a separate pool. Instead of creating a separate pool for a user or set of users, you can use a namespace.

Note

Namespaces are available only when using librados.

Access may be restricted to specific RADOS namespaces by use of the namespace capability. Limited globbing of namespaces (that is, use of wildcards (*)) is supported: if the last character of the specified namespace is*, then access is granted to any namespace starting with the provided argument.

## Managing Users

User management functionality provides Ceph Storage Cluster administrators with the ability to create, update, and delete users directly in the Ceph Storage Cluster.

When you create or delete users in the Ceph Storage Cluster, you might need to distribute keys to clients so that they can be added to keyrings. For details, see **[Keyring Management](https://docs.ceph.com/en/reef/rados/operations/user-management/#keyring-management)**.
