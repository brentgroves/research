# **[Basic Ceph RGW Setup and S3 Access with AWS CLI and Python boto3](https://medium.com/@hojat_gazestani/basic-ceph-rgw-setup-and-s3-access-with-aws-cli-and-python-boto3-c3db142d3b55)**

Object storage solutions are becoming increasingly essential in today's rapidly growing data. Ceph’s RADOS Gateway (RGW) offers a robust, S3-compatible object storage service that can seamlessly integrate with your applications.

In this article, we’ll walk through setting up a basic Ceph RGW, creating a user, connecting with the AWS CLI, managing objects, and even interacting programmatically via Python’s boto3 library.

All commands are also available through my **[GitHub repository](https://github.com/hojat-gazestani/openstack/blob/main/Ceph/octapus/11-Basic%20Ceph%20RGW%20Setup%20and%20S3%20Access%20with%20AWS%20CLI.md)**.

Basic Ceph RGW Setup and S3 Access with AWS CLI
The foundational steps for setting up a Ceph RADOS Gateway (RGW). The deployment of the RGW service using the Ceph Orchestrator. Furthermore, covers the creation of a basic RGW user and the process of connecting to the RGW endpoint utilizing the AWS Command Line Interface (CLI). Finally, indicates it will explain how to upload, list, and generally manage objects within this environment.

## See the default pools automatically created for RGW

```bash
ceph osd pool ls | grep rgw
```

## **[Get pool values](https://docs.ceph.com/en/mimic/rados/operations/pools/#get-pool-values)**

```bash
ceph osd lspools

ceph osd pool get default.rgw.buckets.data all

size: 3
min_size: 2
pg_num: 1
pgp_num: 1
crush_rule: microceph_auto_host
hashpspool: true
nodelete: false
nopgchange: false
nosizechange: false
write_fadvise_dontneed: false
noscrub: false
nodeep-scrub: false
use_gmt_hitset: 1
fast_read: 0
pg_autoscale_mode: on
eio: false
bulk: true

radosgw-admin bucket stats | grep num_objects
dd if=/dev/zero of=100mb.file bs=1M count=100

