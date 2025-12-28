# templink not expiring

Try deleting browser cache for the past hour.

AWS S3 pre-signed URLs are designed with an expiration mechanism, and a "non-expiring" or "temp link not expiring" scenario is generally not the intended behavior. If a pre-signed URL appears to not expire, it usually indicates a misconfiguration or a misunderstanding of how the expiration is handled.

Possible reasons for a seemingly non-expiring pre-signed URL:

## Very Long Expiration Time

While AWS S3 pre-signed URLs have a maximum signature expiry of 7 days (with Signature Version 4 and IAM user credentials), you might have inadvertently set a very long expiration time, making it seem like it doesn't expire within your testing window.

## Using IAM User Credentials for Longest Expiry

If you are using IAM user credentials (not temporary STS credentials from an assumed role), you can generate pre-signed URLs with a maximum expiration of 7 days. If you're expecting a shorter expiration and it's not happening, verify the type of credentials used.

## Bypassing Expiration with a Proxy or Application Layer

Some applications or services might implement a proxy or a custom endpoint that generates a new pre-signed URL on demand, effectively refreshing the access and making it appear as if the original link never expires. This is a common pattern for managing long-term access to S3 objects.

## Publicly Accessible Objects

If the S3 object itself is publicly accessible (e.g., via a bucket policy that grants public read access), then a pre-signed URL, even if generated, might not be strictly necessary for access, and the object would remain accessible independently of the URL's expiration.
Incorrectly Handling Temporary Credentials:
If you are using temporary credentials (e.g., from an IAM role assumed by a Lambda function or EC2 instance), the pre-signed URL's validity is tied to the expiration of those temporary credentials. If the temporary credentials have a very long session duration, the URL might also appear to be valid for an extended period.
To ensure pre-signed URLs expire as intended:
Verify Credential Type:
Confirm whether you are using IAM user credentials (AKIA...) or temporary STS credentials (ASIA...). The latter have shorter session durations and will limit the maximum pre-signed URL expiration.
Explicitly Set Expiration Time:
When generating the pre-signed URL, ensure you are explicitly setting the desired expiration time (e.g., ExpiresIn parameter in the AWS SDKs).
Review IAM Policies and Session Durations:
If using temporary credentials, check the maximum session duration configured for the IAM role.
Confirm Bucket and Object Permissions:
Ensure the S3 object is not publicly accessible, as this would negate the need for a pre-signed URL's security.
Avoid Proxying if Expiration is Desired:
If you are using a proxy or custom service to serve S3 content, ensure it's not inadvertently generating new, long-lived pre-signed URLs.
