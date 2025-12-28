AI Overview
Ceph S3 supports object locking functionality, similar to AWS S3 Object Lock, to provide data immutability and protection against accidental deletion or modification. This feature is particularly useful for compliance requirements and ransomware protection.
How Ceph S3 Object Lock Works:
Bucket Versioning:
Object Lock requires bucket versioning to be enabled. When a bucket is created with Object Lock enabled, versioning is automatically enabled as well.
Retention Modes:
Ceph S3 offers two retention modes:
Governance Mode: Allows users with special permissions to overwrite, delete, or alter the object lock settings.
Compliance Mode: Provides the highest level of protection, preventing any user, including the root user, from overwriting, deleting, or altering the object lock settings until the retention period expires.

**Retention Periods:** Objects can be locked for a fixed duration by setting a "Retain until Date." After this date, the object becomes mutable again unless a Legal Hold is also applied.
**Legal Holds:** Legal holds provide an indefinite lock on an object, preventing deletion until the hold is manually removed by a user with the necessary permissions (s3:PutObjectLegalHold). Legal holds do not have an associated retention period.
**Applying Locks:** Object Lock configurations, including default retention periods and modes, can be set at the bucket level. Individual objects can also have specific retention periods and legal holds applied.

Enabling Object Lock:
Object Lock is typically enabled during bucket creation using the S3 API. For example, using the AWS CLI with a Ceph RGW endpoint:
Code

```bash
aws --endpoint=http://RGW_PORT:8080 s3api create-bucket --bucket BUCKET_NAME --object-lock-enabled-for-bucket
```
