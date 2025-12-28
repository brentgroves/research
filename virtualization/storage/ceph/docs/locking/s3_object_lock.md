# **[](https://www.ibm.com/docs/en/storage-ceph/7.1.0?topic=lifecycle-enabling-object-lock-s3)**

Procedure
Create a bucket with object lock enabled:

Syntax

aws --endpoint=http://RGW_PORT:8080 s3api create-bucket --bucket BUCKET_NAME --object-lock-enabled-for-bucket

Example

[root@rgw-2 ~]# aws --endpoint=<http://rgw.ceph.com:8080> s3api create-bucket --bucket worm-bucket --object-lock-enabled-for-bucket

Set a retention period for the bucket:

Syntax

aws --endpoint=http://RGW_PORT:8080 s3api put-object-lock-configuration --bucket BUCKET_NAME --object-lock-configuration { "ObjectLockEnabled": "Enabled", "Rule": { "DefaultRetention": { "Mode": "RETENTION_MODE", "Days": NUMBER_OF_DAYS }}}

Example

[root@rgw-2 ~]# aws --endpoint=<http://rgw.ceph.com:8080> s3api put-object-lock-configuration --bucket worm-bucket --object-lock-configuration '{ "ObjectLockEnabled": "Enabled", "Rule": { "DefaultRetention": { "Mode": "COMPLIANCE", "Days": 10 }}}'

Note:
You can choose either the GOVERNANCE or COMPLIANCE mode for the RETENTION_MODE in S3 object lock, to apply different levels of protection to any object version that is protected by object lock.

In GOVERNANCE mode, users cannot overwrite or delete an object version or alter its lock settings unless they have special permissions.

In COMPLIANCE mode, a protected object version cannot be overwritten or deleted by any user, including the root user in your AWS account. When an object is locked in COMPLIANCE mode, its RETENTION_MODE cannot be changed, and its retention period cannot be shortened. COMPLIANCE mode helps ensure that an object version cannot be overwritten or deleted for the duration of the period.

Put the object into the bucket with a retention time set:

Syntax

aws --endpoint=http://RGW_PORT:8080 s3api put-object --bucket BUCKET_NAME --object-lock-mode RETENTION_MODE --object-lock-retain-until-date "DATE" --key compliance-upload --body TEST_FILE

Example

[root@rgw-2 ~]# aws --endpoint=<http://rgw.ceph.com:8080> s3api put-object --bucket worm-bucket --object-lock-mode COMPLIANCE --object-lock-retain-until-date "2022-05-31" --key compliance-upload --body test.dd
{
    "ETag": ""d560ea5652951637ba9c594d8e6ea8c1"",
    "VersionId": "Nhhk5kRS6Yp6dZXVWpZZdRcpSpBKToD"
}

Upload a new object using the same key:

Syntax

aws --endpoint=http://RGW_PORT:8080 s3api put-object --bucket BUCKET_NAME --object-lock-mode RETENTION_MODE --object-lock-retain-until-date "DATE" --key compliance-upload --body PATH

Example

[root@rgw-2 ~]# aws --endpoint=<http://rgw.ceph.com:8080> s3api put-object --bucket worm-bucket --object-lock-mode COMPLIANCE --object-lock-retain-until-date "2022-05-31" --key compliance-upload --body /etc/fstab
{
    "ETag": ""d560ea5652951637ba9c594d8e6ea8c1"",
    "VersionId": "Nhhk5kRS6Yp6dZXVWpZZdRcpSpBKToD"
}

Command-line options

Set an object lock legal hold on an object version:

Example

[root@rgw-2 ~]# aws --endpoint=<http://rgw.ceph.com:8080> s3api put-object-legal-hold --bucket worm-bucket --key compliance-upload --legal-hold Status=ON

Note: Using the object lock legal hold operation, you can place a legal hold on an object version, thereby preventing an object version from being overwritten or deleted. A legal hold doesn’t have an associated retention period and hence, remains in effect until removed.
List the objects from the bucket to retrieve only the latest version of the object:

Example

[root@rgw-2 ~]# aws --endpoint=<http://rgw.ceph.com:8080> s3api list-objects --bucket worm-bucket

List the object versions from the bucket:

Example

[root@rgw-2 ~]# aws --endpoint=<http://rgw.ceph.com:8080> s3api list-objects --bucket worm-bucket
{
    "Versions": [
        {
            "ETag": ""d560ea5652951637ba9c594d8e6ea8c1"",
            "Size": 288,
            "StorageClass": "STANDARD",
            "Key": "hosts",
            "VersionId": "Nhhk5kRS6Yp6dZXVWpZZdRcpSpBKToD",
            "IsLatest": true,
            "LastModified": "2022-06-17T08:51:17.392000+00:00",
            "Owner": {
                "DisplayName": "Test User in Tenant test",
                "ID": "test$test.user"
            }
            }
        }
    ]
}

Access objects using version-ids:

Example

[root@rgw-2 ~]# aws --endpoint=<http://rgw.ceph.com:8080> s3api get-object --bucket worm-bucket  --key compliance-upload --version-id 'IGOU.vdIs3SPduZglrB-RBaK.sfXpcd' download.1
{
    "AcceptRanges": "bytes",
    "LastModified": "2022-06-17T08:51:17+00:00",
    "ContentLength": 288,
    "ETag": ""d560ea5652951637ba9c594d8e6ea8c1"",
    "VersionId": "Nhhk5kRS6Yp6dZXVWpZZdRcpSpBKToD",
    "ContentType": "binary/octet-stream",
    "Metadata": {},
    "ObjectLockMode": "COMPLIANCE",
    "ObjectLockRetainUntilDate": "2023-06-17T08:51:17+00:00"
}
