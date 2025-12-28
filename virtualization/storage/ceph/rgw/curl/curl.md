# access ceph rgw from curl example

## **[](https://stackoverflow.com/questions/70891761/ceph-rados-aws-s3-api-bucket-policy-via-curl)**

Accessing Ceph RGW (RADOS Gateway) using curl typically involves interacting with its S3-compatible API or its Swift-compatible API. The method depends on the desired interaction and the authentication mechanism.

1. S3-compatible API Access (most common for object storage):
This method uses AWS Signature Version 4 for authentication. You will need your AWS Access Key ID and Secret Access Key for the RGW user.

```bash
curl -X GET \
  -H "Host: <rgw-endpoint>" \
  -H "X-Amz-Date: <timestamp>" \
  -H "Authorization: AWS4-HMAC-SHA256 Credential=<access-key-id>/<date>/<region>/s3/aws4_request,SignedHeaders=host;x-amz-date,Signature=<signature>" \
  "http://<rgw-endpoint>/<bucket-name>/<object-key>"
```

<rgw-endpoint>: The hostname or IP address and port of your Ceph RGW instance (e.g., myrgw.example.com:80).
<timestamp>: The current UTC timestamp in ISO 8601 format (e.g., 20250805T170900Z).
<access-key-id>: Your RGW user's AWS Access Key ID.
<date>: The date part of the timestamp (e.g., 20250805).
<region>: The region configured for your RGW (often us-east-1 or a custom region).
<signature>: The calculated AWS Signature Version 4 signature. This is the most complex part and typically requires a programmatic approach or a tool to generate.
<bucket-name>: The name of the S3 bucket.
<object-key>: The key (path) to the object within the bucket.
Example (simplified, assumes pre-signed URL or a tool handling signature generation):
Code

curl "<http://myrgw.example.com:80/mybucket/myobject.txt>"
