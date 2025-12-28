# **[Basic Ceph RGW Setup and S3 Access with AWS CLI and Python boto3](https://medium.com/@hojat_gazestani/basic-ceph-rgw-setup-and-s3-access-with-aws-cli-and-python-boto3-c3db142d3b55)**

Object storage solutions are becoming increasingly essential in today's rapidly growing data. Ceph’s RADOS Gateway (RGW) offers a robust, S3-compatible object storage service that can seamlessly integrate with your applications.

In this article, we’ll walk through setting up a basic Ceph RGW, creating a user, connecting with the AWS CLI, managing objects, and even interacting programmatically via Python’s boto3 library.

All commands are also available through my **[GitHub repository](https://github.com/hojat-gazestani/openstack/blob/main/Ceph/octapus/11-Basic%20Ceph%20RGW%20Setup%20and%20S3%20Access%20with%20AWS%20CLI.md)**.

Basic Ceph RGW Setup and S3 Access with AWS CLI
The foundational steps for setting up a Ceph RADOS Gateway (RGW). The deployment of the RGW service using the Ceph Orchestrator. Furthermore, covers the creation of a basic RGW user and the process of connecting to the RGW endpoint utilizing the AWS Command Line Interface (CLI). Finally, indicates it will explain how to upload, list, and generally manage objects within this environment.

## Deploy RGW service

The initial setup and deployment of a RADOS Gateway (RGW) instance within a Ceph storage cluster using the Ceph Orchestrator

## Deploy a basic RADOS Gateway (RGW) instance using Ceph Orchestrator

`ceph orch apply rgw rgw-basic`

## Verify that the RGW service is up and running correctly

```bash
ceph -s | grep rgw
ceph orch ls | grep rgw
ceph orch ps | grep rgw
```

## See the default pools automatically created for RGW

```bash
ceph osd pool ls | grep rgw
```

## TODO How seperate rgw pools

## Create a simple RGW user

The process of creating a basic user account specifically for accessing the RGW service, with associated credentials and permissions

## Create a user account for accessing RGW S3-compatible storage

```bash
radosgw-admin user create --uid={username} --display-name="{display-name}"

radosgw-admin user create --uid=rgwuser-basic --display-name="RGWuser Basic"
Default region name [None]: 
Default output format [None]: json

radosgw-admin user list
radosgw-admin user info --uid rgwuser-basic
{
    "user_id": "rgwuser-basic",
    "display_name": "RGWuser Basic",
    "email": "",
    "suspended": 0,
    "max_buckets": 1000,
    "subusers": [],
    "keys": [
        {
            "user": "rgwuser-basic",
            "access_key": "JOHR9NY712UOTW6DYYMX",
            "secret_key": "ImHtGdxMDQH7PRAkLvheCsKr4VjQr4HKUfblGBA7",
            "active": true,
            "create_date": "2025-08-05T21:40:42.554860Z"
        }
    ],
    "swift_keys": [],
    "caps": [],
    "op_mask": "read, write, delete",
    "default_placement": "",
    "default_storage_class": "",
    "placement_tags": [],
    "bucket_quota": {
        "enabled": false,
        "check_on_raw": false,
        "max_size": -1,
        "max_size_kb": 0,
        "max_objects": -1
    },
    "user_quota": {
        "enabled": false,
        "check_on_raw": false,
        "max_size": -1,
        "max_size_kb": 0,
        "max_objects": -1
    },
    "temp_url_keys": [],
    "type": "rgw",
    "mfa_ids": [],
    "account_id": "",
    "path": "/",
    "create_date": "2025-08-05T21:40:42.554176Z",
    "tags": [],
    "group_ids": []
}
```

## Connect to RGW endpoint using AWS CLI

How to configure and utilize the aws Command Line Interface (AWS CLI) to establish a connection with the deployed RGW endpoint, enabling interaction with the Ceph object storage

## Set up AWS CLI to interact with the Ceph RGW endpoint

```bash
aws configure --profile=rgwuser-basic
access_key: # PAST ACCESS_KEY
secret_key: # PAST SECRET_KEY
output format: json

cat ~/.aws/config
[profile rgwuser-basic]
output = json
cat ~/.aws/credentials
[rgwuser-basic]
aws_access_key_id = JOHR9NY712UOTW6DYYMX
aws_secret_access_key = ImHtGdxMDQH7PRAkLvheCsKr4VjQr4HKUfblGBA7

aws --profile rgwuser-basic --endpoint-url  http://10.188.50.201 s3 ls
```

## Create buckets and upload files to Ceph RGW via AWS CLI

```bash
aws --profile rgwuser-basic --endpoint-url  http://micro11 s3 mb s3://buckebasic --region default
```

## Run on ceph cluster to Confirm that the bucket and objects exist in Ceph directly

`radosgw-admin bucket list`

## Upload, list, and manage objects

the subsequent steps after establishing a connection, including performing common object storage operations such as uploading data, listing the stored objects, and other management tasks using the AWS CLI against the Ceph RGW

```bash
BUCKET_NAME=buckebasic
RGW_ENDPOINT=http://10.188.50.201

# https://docs.aws.amazon.com/cli/latest/reference/s3api/put-object.html

aws --profile rgwuser-basic --endpoint-url ${RGW_ENDPOINT}  s3api put-object --bucket ${BUCKET_NAME} --key testfile --body /etc/services

{
    "ETag": "\"3975f0d8c4e1ecb25f035edfb1ba27ac\""
}

aws s3api put-object \
    --bucket amzn-s3-demo-bucket \
    --key my-dir/MySampleImage.png \
    --body MySampleImage.png

aws --profile rgwuser-basic --endpoint-url ${RGW_ENDPOINT} s3api list-objects --bucket ${BUCKET_NAME}

time aws s3 cp largefile s3://${BUCKET_NAME}/ --endpoint-url=${RGW_ENDPOINT}
```

## **[Get pool values](https://docs.ceph.com/en/mimic/rados/operations/pools/#get-pool-values)**

```bash
ceph osd lspools

ceph osd pool get default.rgw.buckets.data all

radosgw-admin bucket stats | grep num_objects
dd if=/dev/zero of=100mb.file bs=1M count=100

# Run on ceph cluster to verify

BUCKET_NAME=buckebasic
RGW_ENDPOINT=<http://192.168.1.1>
time aws s3 cp 100mb.file s3://${BUCKET_NAME}/ --endpoint-url=${RGW_ENDPOINT}
radosgw-admin bucket list
radosgw-admin bucket stats
for num in {1..50}: do aws --profile rgwuser-basic --endpoint-url  <http://192.168.1.1> s3api list-object --bucket buckebasic --key testfile"${num}" --body /etc/services; done

radosgw-admin bucket stats | grep num_objects

ceph -s | grep objects
for num in {1..50}: do aws --profile rgwuser-basic --endpoint-url  <http://192.168.1.1> s3api delete-object --bucket buckebasic --key testfile"${num}" ; done
ceph osd pool ls | grep replicated

ceph osd pool ls detail
```

## python boto3

demonstrates how to interact with the Ceph Object Gateway Storage (RGW) using the boto3 library after the S3 client has been initialized practical ways to manage objects within your Ceph RGW storage programmatically using Python and the boto3 library utilizing the "AWS S3 CLI for Ceph Object Gateway Storage" for managing your object storage. While this example uses Python, the underlying concepts of uploading, listing, and generating pre-signed URLs are analogous to operations performed using the AWS S3 command-line interface.

```python
import boto3
import os

# Load config from env

config = {
    'endpoint_url': os.environ['RGW_ENDPOINT'],
    'aws_access_key_id': os.environ['AWS_ACCESS_KEY_ID'],
    'aws_secret_access_key': os.environ['AWS_SECRET_ACCESS_KEY']
}

# Initialize S3 client

s3 = boto3.client('s3', **config)

# Test connection

try:
    s3.list_buckets()
    print("✅ Successfully connected to RGW!")
except Exception as e:
    print(f"❌ Connection failed: {str(e)}")

s3 = boto3.client(
    's3',
    endpoint_url='<http://your-rgw:8080>',
    aws_access_key_id='ACCESS_KEY',
    aws_secret_access_key='SECRET_KEY'
)

# Upload

s3.upload_file('100mb.file', 'bucket', '100mb.file')

# List objects

response = s3.list_objects(Bucket='bucket')
for obj in response['Contents']:
    print(obj['Key'])

# Generate pre-signed URL (time-limited access)

url = s3.generate_presigned_url('get_object', Params={'Bucket': 'bucket', 'Key': '100mb.file'}, ExpiresIn=3600)
print(url)
```
