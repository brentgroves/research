# **[deploy osd](https://docs.ceph.com/en/reef/cephadm/services/osd/#cephadm-deploy-osds)**

## Listing Storage Devices

In order to deploy an OSD, there must be a storage device that is available on which the OSD will be deployed.

Run this command to display an inventory of storage devices on all cluster hosts:

```bash
ceph orch device ls
```

A storage device is considered available if all of the following conditions are met:

- The device must have no partitions.
- The device must not have any LVM state.
- The device must not be mounted.
- The device must not contain a file system.
- The device must not contain a Ceph BlueStore OSD.
- The device must be larger than 5 GB.

Ceph will not provision an OSD on a device that is not available.

## Creating New OSDs

There are a few ways to create new OSDs:

Tell Ceph to consume any available and unused storage device:

```bash
ceph orch apply osd --all-available-devices
```

Create an OSD from a specific device on a specific host:

`ceph orch daemon add osd *<host>*:*<device-path>*`

For example:

`ceph orch daemon add osd host1:/dev/sdb`

Advanced OSD creation from specific devices on a specific host:

`ceph orch daemon add osd host1:data_devices=/dev/sda,/dev/sdb,db_devices=/dev/sdc,osds_per_device=2`

Create an OSD on a specific LVM logical volume on a specific host:

`ceph orch daemon add osd *<host>*:*<lvm-path>*`

For example:

`ceph orch daemon add osd host1:/dev/vg_osd/lvm_osd1701`

You can use Advanced OSD Service Specifications to categorize device(s) based on their properties. This might be useful in forming a clearer picture of which devices are available to consume. Properties include device type (SSD or HDD), device model names, size, and the hosts on which the devices exist:

`ceph orch apply -i spec.yml`

## Dry Run

The --dry-run flag causes the orchestrator to present a preview of what will happen without actually creating the OSDs.

For example:

```bash
ceph orch apply osd --all-available-devices --dry-run
NAME                  HOST  DATA      DB  WAL
all-available-devices node1 /dev/vdb  -   -
all-available-devices node2 /dev/vdc  -   -
all-available-devices node3 /dev/vdd  -   -
```

## Declarative State

The effect of ceph orch apply is persistent. This means that drives that are added to the system after the ceph orch apply command completes will be automatically found and added to the cluster. It also means that drives that become available (by zapping, for example) after the ceph orch apply command completes will be automatically found and added to the cluster.

We will examine the effects of the following command:

`ceph orch apply osd --all-available-devices`

After running the above command:

- If you add new disks to the cluster, they will automatically be used to create new OSDs.
- When you remove an OSD and clean the LVM physical volume, a new OSD will be created automatically.

If you want to avoid this behavior (disable automatic creation of OSD on available devices), use the unmanaged parameter:

`ceph orch apply osd --all-available-devices --unmanaged=true`

Keep these three facts in mind:

- The default behavior of ceph orch apply causes cephadm constantly to reconcile. This means that cephadm creates OSDs as soon as new drives are detected.
- Setting unmanaged: True disables the creation of OSDs. If unmanaged: True is set, nothing will happen even if you apply a new OSD service.
- ceph orch daemon add creates OSDs, but does not add an OSD service.

For cephadm, see also **[Disabling automatic deployment of daemons](https://docs.ceph.com/en/reef/cephadm/services/#cephadm-spec-unmanaged)**.

## Remove an OSD

Removing an OSD from a cluster involves two steps:

1. Evacuating all placement groups (PGs) from the OSD
2. Removing the PG-free OSD from the cluster

The following command performs these two steps:

`ceph orch osd rm <osd_id(s)> [--replace] [--force] [--zap]`

### Example

```bash
ceph orch osd rm 0
ceph orch osd rm 1138 --zap
```

Expected output:

`Scheduled OSD(s) for removal`

OSDs that are not safe to destroy will be rejected. Adding the --zap flag directs the orchestrator to remove all LVM and partition information from the OSD’s drives, leaving it a blank slate for redeployment or other reuse.

After removing OSDs, if the drives the OSDs were deployed on once again become available, cephadm may automatically try to deploy more OSDs on these drives if they match an existing drivegroup spec. If you deployed the OSDs you are removing with a spec and don’t want any new OSDs deployed on the drives after removal, it’s best to modify the drivegroup spec before removal. Either set unmanaged: true to stop it from picking up new drives at all, or modify it in some way that it no longer matches the drives used for the OSDs you wish to remove. Then re-apply the spec. For more info on drivegroup specs see **[Advanced OSD Service Specifications](https://docs.ceph.com/en/reef/cephadm/services/osd/#drivegroups)**. For more info on the declarative nature of cephadm in reference to deploying OSDs, see **[Declarative State](https://docs.ceph.com/en/reef/cephadm/services/osd/#cephadm-osd-declarative)**

Monitoring OSD State During OSD Removal

You can query the state of OSD operations during the process of removing OSDS by running the following command:

```bash
ceph orch osd rm status
OSD_ID  HOST         STATE                    PG_COUNT  REPLACE  FORCE  STARTED_AT
2       cephadm-dev  done, waiting for purge  0         True     False  2020-07-17 13:01:43.147684
3       cephadm-dev  draining                 17        False    True   2020-07-17 13:01:45.162158
4       cephadm-dev  started                  42        False    True   2020-07-17 13:01:45.162158
```

When no PGs are left on the OSD, it will be decommissioned and removed from the cluster.

After removing an OSD, if you wipe the LVM physical volume in the device used by the removed OSD, a new OSD will be created. For more information on this, read about the unmanaged parameter in **[Declarative State](https://docs.ceph.com/en/reef/cephadm/services/osd/#cephadm-osd-declarative)**.

## Stopping OSD Removal

It is possible to stop queued OSD removals by using the following command:

`ceph orch osd rm stop <osd_id(s)>`

### Example 1

```bash
ceph orch osd rm stop 4
```

Expected output:

`Stopped OSD(s) removal`

This resets the initial state of the OSD and takes it off the removal queue.

## Replacing an OSD

`ceph orch osd rm <osd_id(s)> --replace [--force]`

Example:

`ceph orch osd rm 4 --replace`

Expected output:

`Scheduled OSD(s) for replacement`

This follows the same procedure as the procedure in the “Remove OSD” section, with one exception: the OSD is not permanently removed from the CRUSH hierarchy, but is instead assigned a ‘destroyed’ flag.

Note

The new OSD that will replace the removed OSD must be created on the same host as the OSD that was removed.

## Preserving the OSD ID

The ‘destroyed’ flag is used to determine which OSD ids will be reused in the next OSD deployment.

If you use OSDSpecs for OSD deployment, your newly added disks will be assigned the OSD ids of their replaced counterparts. This assumes that the new disks still match the OSDSpecs.

Use the --dry-run flag to make certain that the ceph orch apply osd command does what you want it to. The --dry-run flag shows you what the outcome of the command will be without making the changes you specify. When you are satisfied that the command will do what you want, run the command without the --dry-run flag.

The name of your OSDSpec can be retrieved with the command ceph orch ls

Alternatively, you can use your OSDSpec file:

`ceph orch apply -i <osd_spec_file> --dry-run`

Expected output:

```bash
NAME                  HOST  DATA     DB WAL
<name_of_osd_spec>    node1 /dev/vdb -  -
```

When this output reflects your intention, omit the --dry-run flag to execute the deployment.

Erasing Devices (Zapping Devices)
Erase (zap) a device so that it can be reused. zap calls ceph-volume zap on the remote host.

`ceph orch device zap <hostname> <path>`

Example command:

`ceph orch device zap my_hostname /dev/sdx`

If the unmanaged flag is not set, cephadm automatically deploys

drives that match the OSDSpec. For example, if you specify the all-available-devices option when creating OSDs, when you zap a device the cephadm orchestrator automatically creates a new OSD in the device. To disable this behavior, see **[Declarative State](https://docs.ceph.com/en/reef/cephadm/services/osd/#cephadm-osd-declarative)**.

## Automatically tuning OSD memory

OSD daemons will adjust their memory consumption based on the osd_memory_target config option (several gigabytes, by default). If Ceph is deployed on dedicated nodes that are not sharing memory with other services, cephadm can automatically adjust the per-OSD memory consumption based on the total amount of RAM and the number of deployed OSDs.

Cephadm sets osd_memory_target_autotune to true by default which is unsuitable for hyperconverged infrastructures.

Cephadm will start with a fraction (mgr/cephadm/autotune_memory_target_ratio, which defaults to .7) of the total RAM in the system, subtract off any memory consumed by non-autotuned daemons (non-OSDs, for OSDs for which osd_memory_target_autotune is false), and then divide by the remaining OSDs.

The final targets are reflected in the config database with options like:

```bash
WHO   MASK      LEVEL   OPTION              VALUE
osd   host:foo  basic   osd_memory_target   126092301926
osd   host:bar  basic   osd_memory_target   6442450944
```

Both the limits and the current memory consumed by each daemon are visible from the ceph orch ps output in the MEM LIMIT column:

```bash
NAME        HOST  PORTS  STATUS         REFRESHED  AGE  MEM USED  MEM LIMIT  VERSION                IMAGE ID      CONTAINER ID
osd.1       dael         running (3h)     10s ago   3h    72857k     117.4G  17.0.0-3781-gafaed750  7015fda3cd67  9e183363d39c
osd.2       dael         running (81m)    10s ago  81m    63989k     117.4G  17.0.0-3781-gafaed750  7015fda3cd67  1f0cc479b051
osd.3       dael         running (62m)    10s ago  62m    64071k     117.4G  17.0.0-3781-gafaed750  7015fda3cd67  ac5537492f27
```

To exclude an OSD from memory autotuning, disable the autotune option for that OSD and also set a specific memory target. For example,

```bash
ceph config set osd.123 osd_memory_target_autotune false
ceph config set osd.123 osd_memory_target 16G
```
