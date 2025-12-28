# **[Basic Ceph RGW Setup and S3 Access with AWS CLI and Python boto3](https://medium.com/@hojat_gazestani/basic-ceph-rgw-setup-and-s3-access-with-aws-cli-and-python-boto3-c3db142d3b55)**

Object storage solutions are becoming increasingly essential in today's rapidly growing data. Ceph’s RADOS Gateway (RGW) offers a robust, S3-compatible object storage service that can seamlessly integrate with your applications.

In this article, we’ll walk through setting up a basic Ceph RGW, creating a user, connecting with the AWS CLI, managing objects, and even interacting programmatically via Python’s boto3 library.

All commands are also available through my **[GitHub repository](https://github.com/hojat-gazestani/openstack/blob/main/Ceph/octapus/11-Basic%20Ceph%20RGW%20Setup%20and%20S3%20Access%20with%20AWS%20CLI.md)**.

## Deploying the RGW Service

We need to deploy the RADOS Gateway (RGW) instance in the Ceph storage cluster. Thanks to the Ceph Orchestrator, this is straightforward.

```bash
# Deploy a basic RADOS Gateway (RGW) instance using Ceph Orchestrator.
microceph does NOT use orch
ceph orch apply rgw rgw-basic

# Verify that the RGW service is running.
ceph -s | grep rgw
ceph orch ls | grep rgw
ceph orch ps | grep rgw

# Check the default pools created for RGW.
ceph osd pool ls | grep rgw
ceph osd pool ls
lxd_remote
.mgr
lxd_cephfs_meta
lxd_cephfs_data
ind_cephfs_meta
ind_cephfs_data
.rgw.root
default.rgw.log
default.rgw.control
default.rgw.meta
default.rgw.buckets.index
default.rgw.buckets.data
```
