# **[](https://canonical-microceph.readthedocs-hosted.com/latest/tutorial/get-started/#enable-rgw)**

Enable RGW
As mentioned before, we will use the Ceph Object Gateway to interact with the object storage cluster we just deployed.

Enable the RGW daemon on your node

```bash
microceph enable rgw
root@micro11:~# microceph status
MicroCeph deployment summary:
- micro11 (10.188.50.201)
  Services: mds, mgr, mon, rgw, osd
  Disks: 1
- micro12 (10.188.50.202)
  Services: mds, mgr, mon, osd
  Disks: 1
- micro13 (10.188.50.203)
  Services: mds, mgr, mon, osd
  Disks: 1
```

Note

By default, the rgw service uses port 80, which may not always be available. If port 80 is occupied, you can specify an alternative port, such as 8080, by adding the --port <port-number> parameter.

## Create an RGW user

MicroCeph is packaged with the standard radosgw-admin tool that manages the rgw service and users. We will now use this tool to create an RGW user called user, with the display name user.

```bash
# sudo radosgw-admin user create --uid=user --display-name=user
radosgw-admin user create --uid=user --display-name=user
{
    "user_id": "user",
    "display_name": "user",
    "email": "",
    "suspended": 0,
    "max_buckets": 1000,
    "subusers": [],
    "keys": [
        {
            "user": "user",
            "access_key": "0GD0JBKVKUNP68CZX54L",
            "secret_key": "kuDhYWHG2UZ3yVrAOAaTgZJwvAyAxJQiIHxaa7UM",
            "active": true,
            "create_date": "2025-07-18T21:59:17.672194Z"
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
    "create_date": "2025-07-18T21:59:17.671271Z",
    "tags": [],
    "group_ids": []
}
```

## Set user secrets

Let’s define secrets for this user, setting access_key to foo, and --secret-key to bar.

```bash
# sudo radosgw-admin key create --uid=user --key-type=s3 --access-key=foo --secret-key=bar
radosgw-admin key create --uid=user --key-type=s3 --access-key=foo --secret-key=bar
{
    "user_id": "user",
    "display_name": "user",
    "email": "",
    "suspended": 0,
    "max_buckets": 1000,
    "subusers": [],
    "keys": [
        {
            "user": "user",
            "access_key": "0GD0JBKVKUNP68CZX54L",
            "secret_key": "kuDhYWHG2UZ3yVrAOAaTgZJwvAyAxJQiIHxaa7UM",
            "active": true,
            "create_date": "2025-07-18T21:59:17.672194Z"
        },
        {
            "user": "user",
            "access_key": "foo",
            "secret_key": "bar",
            "active": true,
            "create_date": "2025-07-18T22:00:42.178622Z"
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
    "create_date": "2025-07-18T21:59:17.671271Z",
    "tags": [],
    "group_ids": []
}

```

## Consuming the storage

Access RGW
Before attempting to consume the object storage in the cluster, validate that you can access RGW by running curl on your node.

Find the IP address of the node running the rgw service:

```bash
microceph status
MicroCeph deployment summary:
- micro11 (10.188.50.201)
  Services: mds, mgr, mon, rgw, osd
  Disks: 1
- micro12 (10.188.50.202)
  Services: mds, mgr, mon, osd
  Disks: 1
- micro13 (10.188.50.203)
  Services: mds, mgr, mon, osd
  Disks: 1
```

Then, run curl from this node.

```bash
curl http://10.188.50.201
<?xml version="1.0" encoding="UTF-8"?><ListAllMyBucketsResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/"><Owner><ID>anonymous</ID></Owner><Buckets></Buckets></ListAllMyBucketsResult>r
```

## Create an S3 bucket

You have verified that your cluster is accessible via RGW. To interact with S3, we need to make sure that the s3cmd utility is installed and configured.

## Install and configure s3cmd

To install s3cmd, run the following command:

```bash
sudo apt-get install s3cmd
```

To configure the s3cmd tool, create a file named .s3cfg in your home directory. This should be an INI-style configuration file with a single [default] section and key-value pairs for configuration.

Run the below command to create the file and configure s3cmd:

<!-- https://s3tools.org/kb/showall2.htm#14 -->
host_base = s3.amazonaws.com
host_bucket = %(bucket)s.s3.amazonaws.com

```bash
user@host:~$
cat > ~/.s3cfg <<EOF
[default]
access_key = foo
secret_key = bar
host_base = micro11
host_bucket = micro11/%(bucket)
check_ssl_certificate = False
check_ssl_hostname = False
use_https = False
EOF

    # [default]
    # access_key = your_access_key
    # secret_key = your_secret_key
    # host_base = microceph_cluster_ip_or_hostname
    # host_bucket = microceph_cluster_ip_or_hostname/%(bucket)
    # check_ssl_certificate = False  ; Set to True if using HTTPS with a valid certificate
    # check_ssl_hostname = False     ; Set to True if using HTTPS with a valid certificate
    # use_https = False              ; Set to True to use HTTPS

cat > ~/.s3cfg <<EOF
[default]
access_key = foo
secret_key = bar
host_base = 10.188.50.201
host_bucket = 10.188.50.201/%(bucket)
check_ssl_certificate = False
check_ssl_hostname = False
use_https = False
EOF

```

Instead of running this command, you can of course also set up the configuration file using your favourite editor.

This configuration will do the following:

- Configure secret and access key that we had set earlier.
- Configure the host to contact. We have named our host ubuntu, so this is what we will set here.
- Configure the host bucket template. The host bucket scheme allows users to specify virtual hosting style access or other access modes. For our uses, we will set it to the host name, followed by the bucket name.
- Finally, we did not configure SSL/TLS for our endpoint, so we are disabling it for s3cmd as well.

As a good security practice, it should also be ensured that the .s3cfg file is only readable by the user as it does contain the secret key. Run chmod like this:

```bash
user@host:~$
chmod 0600 ~/.s3cfg
```

## Create a bucket

You have verified that your cluster is accessible via RGW. Now, let’s create a bucket using the s3cmd tool:

```bash
s3cmd mb -P s3://mybucket
Bucket 's3://mybucket/' created
s3cmd mb -P s3://mybucket2
Bucket 's3://mybucket2/' created
```

Note

The -P flag ensures that the bucket is publicly visible, enabling you to access stored objects easily via a public URL.

```bash
user@host:~$
Bucket 's3://mybucket/' created
```

Our bucket is successfully created.

Upload an image into the bucket

```bash
s3cmd put -P ~/Downloads/TB-202305_to_202405_on_06-07_DM.xlsx s3://mybucket2
s3cmd put -P ~/Downloads/cat.jpg s3://mybucket
upload: '/home/brent/Downloads/cat.jpg' -> 's3://mybucket/cat.jpg'  [1 of 1]
 21439 of 21439   100% in    2s     6.99 KB/s  done
Public URL of the object is: http://micro11/mybucket/cat.jpg

curl http://10.188.50.201/mybucket2/TB-202305_to_202405_on_06-07_DM.xlsx
curl http://10.188.50.201/mybucket2/TB-202305_to_202405_on_06-07_DM.xlsx

http://10.188.50.201/mybucket/cat.jpg
http://10.188.50.201/mybucket/tb.xlsx

s3cmd put -P ~/Downloads/t3.txt s3://mybucket
s3cmd put -P ~/Downloads/tb.xlsx s3://mybucket
s3cmd put -P ~/Downloads/t4.txt s3://mybucket

s3cmd put ~/Downloads/t6.txt s3://mybucket/my-folder/my-file.txt

s3cmd get s3://mybucket/t7.txt t8.txt
s3cmd get s3://mybucket/t8.txt t8b.txt
http://10.188.50.201/mybucket/my-folder/tb.xlsx
http://10.188.50.201/mybucket/my-folder/my-file.txt
http://10.188.50.201/mybucket/t1.txt
http://10.188.50.201/mybucket/t3.txt
http://10.188.50.201/mybucket/t4.txt
http://10.188.50.201/mybucket/t5.txt
http://10.188.50.201/mybucket/t6.txt
http://10.188.50.201/mybucket/test.txt

```

The output shows that your image is stored in a publicly accessible S3 bucket. You can now click on the public object URL in the output to view the image in your browser.
