# **[Generate temporary links to files with AWS CLI and S3cmd](https://gcore.com/docs/storage/manage-object-storage/configure-aws-sli-s3cmd-and-aws-javascript-sdk/generate-temporary-links-to-files-with-aws-cli-and-s3cmd)**

## What is a presigned URL?

A presigned URL is a temporary link used to access a private file in the storage. Such links can be generated only by those who have access keys (Access key and Secret key) from the storage. As a rule, this is a storage owner.
This is how you work with the presigned URLs:

1. A storage owner sets the link expiry date and generates a presigned URL.
2. The owner sends the generated link to the users for whom he/she wants to make the file accessible.
3. The users receive a link as follows:

![i1](https://mintlify.s3.us-west-1.amazonaws.com/gcore/images/docs/storage/manage-s3-storage/generate-a-presigned-url/link-explanation-10.png)

## 4. After that, users will be able to view and download the file during the link lifespan that has been set by the owner

## 5. When the link expires, the access will be revoked. When clicking the link, users will see the “AccessDenied” error

![i2](https://mintlify.s3.us-west-1.amazonaws.com/gcore/images/docs/storage/manage-s3-storage/generate-a-presigned-url/example-temp-link-20.png)

A presigned URL doesn’t require user’s authentication. This means that everyone with a valid temporary link can access the file. For example, if you send such a link to a user who then forwards it to another person, that person will also be able to view and download files.
To protect the temporary link, you can restrict access by IP in the Access Policy settings. For the appropriate code, refer to the following article: **[Configure ACL and Policy for Object Storage](https://gcore.com/docs/storage/manage-object-storage/configure-aws-sli-s3cmd-and-aws-javascript-sdk/configure-access-control-on-s3-storage-with-aws-cli-and-s3cmd)**.

Generate a presigned URL
We have prepared a guide to generate a presigned URL for two storage management utilities: AWS CLI and S3cmd.
​

## Generate links in AWS CLI

1. Open a command-line tool and navigate to the AWS directory.
2. Paste the command below into AWS and replace the values with your own ones:

```bash
BUCKET_NAME=buckebasic
RGW_ENDPOINT=http://10.188.50.201

# aws --profile rgwuser-basic --endpoint-url  http://micro11 s3 mb s3://buckebasic --region default

aws --profile rgwuser-basic --endpoint-url ${RGW_ENDPOINT} s3api list-objects --bucket ${BUCKET_NAME}

aws --profile rgwuser-basic --endpoint-url http://10.188.50.201 s3 ls buckebasic

# aws presign s3://example-bucket/image.jpg --expires in 60480 --endpoint-url s-dt2.cloud.gcore.lu
aws --profile rgwuser-basic --endpoint-url ${RGW_ENDPOINT} s3 presign s3://buckebasic/testfile --expires-in 60
# it worked when I used the link right away but it also worked after expiration time from the same browser but with a different browser it failed as expected after expiration time.
# After I deleted the browser data for the last hour the origal browser also worked as expected.
http://10.188.50.201/buckebasic/testfile?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=JOHR9NY712UOTW6DYYMX%2F20250807%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250807T215154Z&X-Amz-Expires=60&X-Amz-SignedHeaders=host&X-Amz-Signature=4aa9f8dfc89e2929d865af22ad25e7fb0ecad419283061f0e59a3d9a5b6fba1f

curl -o testfile http://10.188.50.201/buckebasic/testfile?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=JOHR9NY712UOTW6DYYMX%2F20250807%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250807T215154Z&X-Amz-Expires=60&X-Amz-SignedHeaders=host&X-Amz-Signature=4aa9f8dfc89e2929d865af22ad25e7fb0ecad419283061f0e59a3d9a5b6fba1f

<?xml version="1.0" encoding="UTF-8"?><Error><Code>AccessDenied</Code><Message></Message><RequestId>tx00000aa774de3d35aaa4d-0068952242-14970-default</RequestId><HostId>14970-default-de

# https://fossa.com/resources/devops-tools/timestamp-converter/



aws --profile rgwuser-basic --endpoint-url ${RGW_ENDPOINT} s3 presign s3://buckebasic/testfile --expires-in 60
# I waited to after expiration time to use this link
http://10.188.50.201/buckebasic/testfile?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=JOHR9NY712UOTW6DYYMX%2F20250807%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250807T213726Z&X-Amz-Expires=60&X-Amz-SignedHeaders=host&X-Amz-Signature=259b81da5dd60bc6ad9d37ed5805884a637afe4d61d63243c268cb0a121e3550
<Error>
<Code>UnknownError</Code>
<Message/>
<RequestId>tx00000c715dc473c0d5e38-0068951e95-14970-default</RequestId>
<HostId>14970-default-default</HostId>
</Error>

aws --profile rgwuser-basic --endpoint-url ${RGW_ENDPOINT} s3 presign s3://buckebasic/testfile --expires-in 3600
http://10.188.50.201/buckebasic/testfile?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=JOHR9NY712UOTW6DYYMX%2F20250807%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250807T204329Z&X-Amz-Expires=3600&X-Amz-SignedHeaders=host&X-Amz-Signature=fe8ae4b9ab759324c8104a29a7137b266a7238431d7779a68649c9b30997eb2d

aws --profile user --endpoint-url ${RGW_ENDPOINT} s3 presign s3://mybucket/tb.xlsx --expires-in 3600
http://10.188.50.201/mybucket/tb.xlsx?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=foo%2F20250807%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250807T204706Z&X-Amz-Expires=3600&X-Amz-SignedHeaders=host&X-Amz-Signature=758e7858ab54495627f2d95c4f24eb815909695c9f67c9dab24f3a1fc41bd8e0
```

where:
example-bucket — the name of the bucket that hosts the file,
image.jpg — the file you want to share,
60480 — link lifespan in seconds, the maximum is 7 days,
s-dt2.cloud.gcore.lu — the hostname of your storage that can be found in the “Details” of the Object Storage in the Gcore Customer Portal.
3. Press “Enter”.
Done. The command will generate a link. Copy it and send it to the user you want to share access with.
​

## Generate links in S3cmd

1. Open a command-line tool and navigate to the S3cmd directory.
2. Paste the command below into S3cmd and replace the values with your own ones:

```bash
# s3cmd signurl s3://example-bucket/image.jpg 1657457538

s3cmd -c ~/.rgwuser.s3cfg ls s3://buckebasic
s3cmd -c ~/.s3cfg ls s3://mybucket

s3cmd -c ~/.rgwuser.s3cfg signurl s3://buckebasic/testfile
s3cmd -c ~/.s3cfg signurl s3://mybucket/cat.jpg

```

where:
example-bucket — the name of the bucket that hosts the file,
image.jpg — the file you want to share,
1657457538 — link expiry time in the Timestamp format, use the **[converter](https://epochconverter.com/)** to convert time formats.

You can also set the link expiry date by running the Echo command as an alternative to Timestamp. For example, you can set a lifespan of 7 days by entering the following string:

```bash
# bc (basic calculator) is a command-line utility in Linux and Unix-like operating systems that provides an arbitrary-precision calculator language. 

# 1 week
s3cmd signurl s3://example-bucket/image.jpg $(echo "`date +%s` + 3600 *24* 7" | bc)

# 3 minutes
s3cmd -c ~/.rgwuser.s3cfg signurl s3://buckebasic/testfile $(echo "`date +%s` + 60 *3" | bc)
http://10.188.50.201/buckebasic/testfile?AWSAccessKeyId=JOHR9NY712UOTW6DYYMX&Expires=1754602412&Signature=24MnIdna3Hd51bE2VDlQaOfnKIQ%3D

<Error>
<Code>AccessDenied</Code>
<Message/>
<RequestId>tx00000a41732bccdadd57d-0068951fbe-14970-default</RequestId>
<HostId>14970-default-default</HostId>
</Error>

s3cmd -c ~/.rgwuser.s3cfg signurl s3://buckebasic/testfile $(echo "`date +%s` + 60" | bc)
http://10.188.50.201/buckebasic/testfile?AWSAccessKeyId=JOHR9NY712UOTW6DYYMX&Expires=1754603359&Signature=paslp7DYiiIH0fqSf19Slpgcgzg%3D

s3cmd -c ~/.s3cfg signurl s3://mybucket/cat.jpg $(echo "`date +%s` + 60 *3" | bc)

```
