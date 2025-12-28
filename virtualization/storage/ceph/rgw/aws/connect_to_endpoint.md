# **[Basic Ceph RGW Setup and S3 Access with AWS CLI and Python boto3](https://medium.com/@hojat_gazestani/basic-ceph-rgw-setup-and-s3-access-with-aws-cli-and-python-boto3-c3db142d3b55)**

Object storage solutions are becoming increasingly essential in today's rapidly growing data. Ceph’s RADOS Gateway (RGW) offers a robust, S3-compatible object storage service that can seamlessly integrate with your applications.

In this article, we’ll walk through setting up a basic Ceph RGW, creating a user, connecting with the AWS CLI, managing objects, and even interacting programmatically via Python’s boto3 library.

All commands are also available through my **[GitHub repository](https://github.com/hojat-gazestani/openstack/blob/main/Ceph/octapus/11-Basic%20Ceph%20RGW%20Setup%20and%20S3%20Access%20with%20AWS%20CLI.md)**.

## Connect to RGW endpoint using AWS CLI

How to configure and utilize the aws Command Line Interface (AWS CLI) to establish a connection with the deployed RGW endpoint, enabling interaction with the Ceph object storage

## Set up AWS CLI to interact with the Ceph RGW endpoint

```bash
aws configure --profile=rgwuser-basic
access_key: # PAST ACCESS_KEY
secret_key: # PAST SECRET_KEY
output format: json

cat ~/.aws/config
cat ~/.aws/credentials

aws --profile rgwuser-basic --endpoint-url  http://10.188.50.201 s3 ls
2025-08-05 18:10:30 buck1
2025-08-05 18:15:13 buckebasic
```
