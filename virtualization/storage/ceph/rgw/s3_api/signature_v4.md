# **[](https://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-authenticating-requests.html)**

Every interaction with Amazon S3 is either authenticated or anonymous. This section explains request authentication with the AWS Signature Version 4 algorithm.

Note
If you use the AWS SDKs (see Sample Code and Libraries) to send your requests, you don't need to read this section because the SDK clients authenticate your requests by using access keys that you provide. Unless you have a good reason not to, you should always use the AWS SDKs. In Regions that support both signature versions, you can request AWS SDKs to use specific signature version. For more information, see Sending authenticated requests using the AWS SDKs. You need to read this section only if you are implementing the AWS Signature Version 4 algorithm in your custom client.

## Authentication with AWS Signature Version 4 provides some or all of the following, depending on how you choose to sign your request

**Verification of the identity of the requester** – Authenticated requests require a signature that you create by using your access keys (access key ID, secret access key). For information about getting access keys, see Understanding and Getting Your Security Credentials in the AWS General Reference. If you are using temporary security credentials, the signature calculations also require a security token. For more information, see **[Requesting Temporary Security Credentials](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp_request.html)** in the IAM User Guide.

**In-transit data protection** – In order to prevent tampering with a request while it is in transit, you use some of the request elements to calculate the request signature. Upon receiving the request, Amazon S3 calculates the signature by using the same request elements. If any request component received by Amazon S3 does not match the component that was used to calculate the signature, Amazon S3 will reject the request.

**Protect against reuse of the signed portions of the request** – The signed portions (using AWS Signatures) of requests are valid within 15 minutes of the timestamp in the request. An unauthorized party who has access to a signed request can modify the unsigned portions of the request without affecting the request's validity in the 15 minute window. Because of this, we recommend that you maximize protection by signing request headers and body, making HTTPS requests to Amazon S3, and by using the s3:x-amz-content-sha256 condition key (see Amazon S3 Signature Version 4 Authentication Specific Policy Keys) in AWS policies to require users to sign Amazon S3 request bodies.

Note
Amazon S3 supports Signature Version 4, a protocol for authenticating inbound API requests to AWS services, in all AWS Regions. At this time, AWS Regions created before January 30, 2014 will continue to support the previous protocol, Signature Version 2. Any new Regions after January 30, 2014 will support only Signature Version 4 and therefore all requests to those Regions must be made with Signature Version 4. For more information about **[AWS Signature Version 2](https://docs.aws.amazon.com/AmazonS3/latest/userguide/RESTAuthentication.html)**, see Signing and Authenticating REST Requests in the Amazon Simple Storage Service User Guide.

## Authentication Methods

You can express authentication information by using one of the following methods:

HTTP Authorization header – Using the HTTP Authorization header is the most common method of authenticating an Amazon S3 request. All of the Amazon S3 REST operations (except for browser-based uploads using POST requests) require this header. For more information about the Authorization header value, and how to calculate signature and related options, see **[Authenticating Requests: Using the Authorization Header (AWS Signature Version 4)](https://docs.aws.amazon.com/AmazonS3/latest/API/sigv4-auth-using-authorization-header.html)**.
