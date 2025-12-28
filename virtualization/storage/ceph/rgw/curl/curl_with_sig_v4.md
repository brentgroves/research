# **[curl and AWS Signature Version 4]()**

AWS Signature Version 4 (SigV4) is the process used by Amazon Web Services (AWS) to authenticate requests made to its various services. When interacting with AWS APIs, you need to sign your requests using this algorithm to prove your identity and authorize the action.

## Using curl with AWS Signature Version 4

While curl itself is a versatile command-line tool for transferring data with URLs, directly handling SigV4 signing with curl alone requires manual implementation of the complex signing process. This involves generating various components like the canonical request, string to sign, and finally, the signature itself using cryptographic hashes and your AWS credentials.

However, there are more convenient ways to use curl for AWS SigV4:
--aws-sigv4 option in recent curl versions:

Newer versions of curl (e.g., FileMaker 21, and potentially other platforms and distributions) have introduced a built-in --aws-sigv4 option. This option simplifies the process significantly by allowing curl to automatically handle the SigV4 signing for you. You provide your AWS credentials and the service information, and curl manages the signature generation and inclusion in the request headers.

```bash
curl --aws-sigv4 "aws:amz:${region}:${service}" --user "${iamKey}:${iamSecret}" \
         -H "Content-Type: application/json" \
         "${aws_api_endpoint}" -d "${request_body}"
```
