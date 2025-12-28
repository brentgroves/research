# **[](https://docs.ceph.com/en/latest/radosgw/s3/authentication/)**

Authentication and ACLs
Requests to the RADOS Gateway (RGW) can be either authenticated or unauthenticated. RGW assumes unauthenticated requests are sent by an anonymous user. RGW supports canned ACLs.

## Authentication

Requests are authenticated with AWS Signatures which are derived from the user’s credentials (S3 access key and secret key).

Most S3 clients and AWS SDKs will generate these signatures for you, given the necessary credentials. When issuing raw HTTP requests, these signatures must be added manually.

## AWS Signature v4

Please refer to the official documentation in **[Authenticating Requests (AWS Signature Version 4)](https://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-authenticating-requests.html)**.

The following values of the x-amz-content-sha256 request header are supported:

- Actual payload checksum value
- UNSIGNED-PAYLOAD
- STREAMING-UNSIGNED-PAYLOAD-TRAILER
- STREAMING-AWS4-HMAC-SHA256-PAYLOAD
- STREAMING-AWS4-HMAC-SHA256-PAYLOAD-TRAILER

## what AWS Signature Version are support by ceph

Ceph's Rados Gateway (RGW), which provides Amazon S3-compatible object storage, supports both AWS Signature Version 2 (SigV2) and AWS Signature Version 4 (SigV4).
While AWS itself has deprecated SigV2, Ceph RGW continues to support it for compatibility with older clients and applications that may still rely on it. However, for new deployments and maximum security, it is recommended to utilize AWS Signature Version 4, which is the more current and secure authentication method.

## AWS Signature v2

Please refer to the official documentation in **[Authenticating Requests (AWS Signature Version 2)](https://docs.aws.amazon.com/AmazonS3/latest/userguide/auth-request-sig-v2.html)**.

Note

While v2 signatures have been deprecated in AWS, RGW continues to support them.
