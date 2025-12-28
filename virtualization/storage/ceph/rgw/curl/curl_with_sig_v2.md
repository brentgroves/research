# **[curl and AWS Signature Version 2]()**

While AWS Signature Version 2 was previously used for authenticating requests to some AWS services, particularly Amazon S3, it is now largely deprecated and AWS strongly recommends using AWS Signature Version 4 for all new applications and for migrating existing applications.

## Using curl with AWS Signature Version 2

If you are dealing with a legacy system or a specific scenario that still relies on AWS Signature Version 2 (though this is increasingly rare and discouraged), you would need to manually construct the signed request with curl. This involves:

## Obtaining your AWS Access Key ID and Secret Access Key

### Creating a Canonicalized String to Sign

This string is a specific format that includes the HTTP method, content-MD5 (if applicable), content-type (if applicable), date (in UTC), and the canonicalized resource path.

A "canonicalized string" refers to a standardized, unique representation of a string, particularly when multiple equivalent forms of that string exist. The process of converting a string into its canonical form is called "canonicalization."

### Calculating the Signature

This involves using your Secret Access Key to sign the Canonicalized String to Sign with HMAC-SHA1.

### Including the Signature in the Request

The signature, along with your Access Key ID and the date, is typically included in the Authorization header of the curl request.
Example (Illustrative - not for production use with new applications):
Code

```bash
curl -v -H "Authorization: AWS <YOUR_ACCESS_KEY_ID>:<YOUR_SIGNATURE>" \
    -H "Date: <UTC_DATE_STRING>" \
    https://<BUCKET_NAME>.s3.amazonaws.com/<OBJECT_KEY>
```

## Why AWS Signature Version 4 is preferred

AWS Signature Version 4 offers enhanced security features, including:
Improved key derivation: It uses a more secure key derivation process, creating service-, region-, and date-specific signing keys.
Reduced latency: Optimized authentication checks can lead to faster request processing.
Enhanced protection against key reuse: The derived keys provide better isolation and protection.
Recommendation:
For any new development or modernization efforts, prioritize using AWS Signature Version 4 with curl or AWS SDKs, as it is the current standard for secure and robust authentication with AWS services. If you encounter legacy systems using Signature Version 2, consider migrating them to Version 4 for improved security and future compatibility.
