# **[](https://fourtheorem.com/the-illustrated-guide-to-s3-pre-signed-urls/)

A presigned URL is a temporary, time-limited URL that grants access to a resource (like an object in an S3 bucket) without requiring the user to have direct credentials for that resource. It essentially allows you to share access to private data for a limited time.

Uploading and downloading files are very common features for most web and mobile applications.

But, implementing reliable and scalable upload and download workflows isn’t necessarily easy. You need to take care of storage, and permissions and maintain long-running connections between clients and your server.

If you are using a serverless architecture with API Gateway and Lambda,  implementing upload and download functionalities gets even more complicated because you are constrained by strict payload size limits (Lambda request/response payloads are both limited to 6 MB) and time limits (API Gateway will timeout after 29 seconds).

So, how can we implement upload and download functionality in an easy yet reliable way on AWS?

The simple answer is to use S3 and leverage S3 pre-signed URLs. In this article, we will discuss in great detail what pre-signed URLs are, how to use them, and some best practices to keep in mind.

Use cases
Before getting into the nitty-gritty details of S3 pre-signed URLs, let’s discuss some potential use cases:

You have a signup in a mobile application where people can take a photo for their avatar. To support this use case you would need to implement an endpoint that allows the mobile app to upload the picture.
You are building an App store platform. On this site, users who have purchased a license for a given software can download the installer binary. In this case, installers can reach multiple hundreds of megabytes. If we are talking about games, we can easily get to binaries in the order of gigabytes in size. In this scenario, you’ll need to allow app developers to upload large binaries and users to download them.
You are implementing a cloud-based document management platform. Users can upload their files and keep them stored in the cloud. They should also be able to download their file whenever they want to access them. You need to manage the upload and download of documents and access control to make sure that users can only access their own files.
You are implementing the backend for a marketing campaign. You are creating a landing page with an incentive: users who fill up a subscription form or a newsletter will receive a confirmation email with a link to download a whitepaper. You need to make sure the download link is somewhat secure and that it will expire after some time.
You are creating an inter-system communication workflow where different components need to exchange large files. You prefer to use asynchronous event-based communication, but you don’t put a large payload in the message. Instead, you provide a URL to an attachment that the receiving system will need to download.
It should be quite clear at this point that, all these use cases, while relatively common, will require some significant engineering effort to be implemented correctly. Most of the complexity lies in the storage layer, so let’s see how pre-signed URLs can make our life easier.

Enter S3 pre-signed URLs
S3 (Amazon Simple Storage Service), is an object storage service that offers great scalability, data availability, and a bunch of other cool but lesser-known features. Among these features, we have pre-signed URLs.

S3 is an ideal service when you need to store and serve files for all sorts of applications. Pre-signed URLs make it easy to allow various clients to upload and download files in a simple yet controlled manner.

By default, all the objects in an S3 bucket are private. You need to have proper credentials and use the AWS CLI or the AWS SDK to programmatically add new objects to a bucket or retrieve the content of an object from a given bucket. Of course, there needs to be a policy that allows your credentials to perform these actions on the given S3 bucket.

This approach works quite well for applications that need to interact with S3 on a regular basis. You can easily define IAM policies to give fine-grained permission to the application so that it can read and write objects in S3 in a controlled way.

But when it comes to giving temporary access to a user or a third-party service, having to rely on credentials or the SDK can be highly impractical and, in some cases, even unfeasible.

Let’s think again about the newsletter example. We want to send a link through an email that gives limited access to an object to a receiver. We cannot expect a random person receiving the email to have valid credentials to access an object in our S3 bucket. We need instead to create a “specially crafted” URL that gives the receiver temporary access to that resource.

This is exactly what S3 pre-signed URLs are: specially crafted S3 URLs with embedded credentials and time-limited availability.

Your app can generate pre-signed URLs every time you want to allow an arbitrary party to perform an upload or a download of an S3 object by simply using the HTTP protocol and without having to know anything about S3 or the AWS authentication protocols.

## Upload example

Let’s look at an illustration to understand at a high level how S3 pre-signed URLs can be used for uploading objects in a bucket.

STEP 1: A user communicates to the server that they intend to upload a file.

![i1](https://lh5.googleusercontent.com/6qBnC8obpEX97aovqyaBV5aad5I4PkjDYJbhGhZy3yQIqowZds6d1bgOZXVzbEbJxsirXkND4JGy4AO35uGrNgbAG7OEaq7QdQjP-m4EN0LerxBboWyBuAEzCVB-DXMBk0SUoZpHDal-LdbXL7hyl73HS5EeOgm-nxeD_YxQgLmchIESZ-yNiPnOGD55eQ)

STEP 2: The server recognizes the user and assesses that the user is authorized to perform the upload. Then the server uses its own credentials to generate an S3 pre-signed URL for uploading an object with a predetermined name into a given S3 bucket.

![i2](https://lh5.googleusercontent.com/H1yf10FIlLEX3aTxBBsCg1v_PD8qG4Jg0Or8O4YZWPGYXTUB5sMy0SxUHNPB6g0sMsZF5fycdkYt3oksiPzyq2WzvSehXAQ3pHqh1EyA8m2VG8ehTNeVmXCq-VYepK6scdXG0Ti8jZVkkPiISg4crZq2B0iZ6rh1vJXhRrtbrm9VkW7XSwi7HOdkzjunXw)

STEP 3: The user receives the pre-signed URL from the server.

![i3](https://lh6.googleusercontent.com/atDCmvj9K6IHdlYIDeB6LeMi5YlrLrfN7dvIywVK4CqWPDK5uBDiqLuzu9om-owgV-J8Vt2YN-9SJXWkSm75dRyLj3ZMVPfxYKjORVtCL1oN3qjWEue4FuMMroX-Ak84fyxb913dHtZPmO2uyfbJt1thk8Gm3cD3d6rXpALlGZKDUD969stkjub2gqj_DQ)

STEP 4: The user makes an HTTP request (PUT or POST) to the received pre-signed URL attaching the file to be uploaded as request payload. Once the request is completed the uploaded file will be available in S3.

## Download Example

Let’s see another example that illustrates how pre-signed URLs can instead be used to authorize the download of a given object in S3.

STEP 1: The user requests the server the file myexpenses.csv.

![i4](https://fourtheorem.com/wp-content/uploads/2023/01/s3-download-example-1024x454.jpg)

STEP 2: The server recognizes the user and somehow verifies that they can have access to myexpenses.csv. Then the server uses its own credentials to generate an S3 pre-signed URL to get myexpenses.csv.

![i5](https://lh3.googleusercontent.com/YIR5gMA60BW1KlkXpaym4QWboS3ESW-od3TJEGHaEyn1Sjj5_dErRGz0rLQ2zxYhrTHXpBzVOKDUI3XbcJf9mrhlu4UvL-fCeZK6WOOhQsBFefE7eUE-et7m2jhMKszycdqp1dm6qsQQ_Rq5dVZ1qErWbajVZr6gpAK7WZpwE91gn_BxtHP8iL_YjJLYWw)

STEP 3: The user receives the pre-signed URL from the server.

![i6](https://lh6.googleusercontent.com/bJQlDzqycqIlooYJ96naDElUAUy6GB88bCFouhMWCh4tOucNp1uqKIEP-YD1nHzbt4uF0Iwlj3k61-qLW73kAIHui4_CJxEFKBlel-qC_zfabwjYb7WmvhbAdYkljM--tMWI7BvBkrV0A2jd_OaignXVBifsVbgtPLswyK9WkS0wpFI0fIOhhx5b75ZTuQ)

STEP 4: The user makes an HTTP request (GET) to the received pre-signed URL to download the file directly from S3.

Security Considerations
From these illustrations, it’s important to appreciate that the server never talks directly to S3. It can generate the pre-signed URLs autonomously by using its own set of AWS credentials (for example the server could be an EC2 instance with an IAM instance profile). In other words, the server does not need to talk with S3 (or other AWS services) to be able to generate a pre-signed URL.

In general, everyone with valid AWS credentials (Role, User, or Security Token) can generate a pre-signed URL by using the AWS Signature v4 protocol.

For this reason, the URL is validated by AWS at request time (i.e. when a user actually makes an HTTP call with that URL). AWS will consider this request as if it was performed by the entity that generate the pre-signed URL in the first place. So, in our example, if the server is not authorized to perform actions on the given bucket, the user will see a permission error when trying to use the generated URL.

![i6](https://lh5.googleusercontent.com/ehOSjZUtoRbxEx5eRUewcI91KqlJkWl_f-6VxSHXkxhc0F40exWBQn78GdtPZsNRIENxHzFpenQ6qM6fs6DLwsZ6Ocrir5NgIWpMMxBusFanDfdINugPcANTdXRgZW9upkaDgHBaw1vHEM9RgWrWCqrwTa8WHvSE6CYLPAP7SxSLPWGnn9vxguLyAHEjwg)

The error returned by the S3 API if no access is granted to the resource.
Different kinds of pre-signed URLs
Now that we understand how pre-signed URLs work and how can they be useful in real-life projects, let’s look a little bit more in detail at all the different kinds of pre-signed URLs that we can get from S3.
