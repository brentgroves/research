# **[](https://www.nakivo.com/blog/mount-amazon-s3-as-a-drive-how-to-guide/)**

**[](https://upcloud.com/resources/tutorials/mount-object-storage-cloud-server-s3fs-fuse/)**

**[Great mount s3fs youtube](https://www.youtube.com/watch?v=0xS1lBgHDX8)** explains k8s usage

**[ceph series](https://www.youtube.com/watch?v=Uvbp3mtOltw&list=PLP2v7zU48xOJf5FMYrQepGkEwKHD7m7QA)**

<https://s3fs.readthedocs.io/en/latest/>

s3fs mount s3 bucket
s3fs mount ceph s3 bucket
<https://www.nakivo.com/blog/mount-amazon-s3-as-a-drive-how-to-guide/>

## **[How to Mount an S3 Bucket as a filesystem in Linux](https://www.nakivo.com/blog/mount-amazon-s3-as-a-drive-how-to-guide/)**

In Amazon S3, data is stored in “buckets”, the basic unit of data storage. You can configure permissions for users to access the buckets via the AWS web interface. If you want access to AWS S3 to be available without a web browser, you can allow users to use the interface of an operating system such as Linux, Windows, or macOS.

Access to Amazon S3 cloud storage from the command line can be handy in several scenarios. This is particularly useful with operating systems that don’t have a graphical user interface (GUI), in particular VMs running in a public cloud, and for automating tasks such as copying files or creating cloud data backups.

Read on to learn how to mount Amazon S3 bucket as a filesystem on a Linux machine and as a drive to a local directory on Windows and macOS machines to be able to use AWS S3 without a web browser.

AWS provides an API to work with Amazon S3 buckets using third-party applications. You can even write your own application that can interact with S3 buckets by using the Amazon API. You can create an application that uses the same path for uploading files to Amazon S3 cloud storage and provide the same path on each computer by mounting the S3 bucket to the same directory with S3FS. In this tutorial, we use S3FS to mount an Amazon S3 bucket as a disk drive to a Linux directory.

**[S3FS](https://github.com/s3fs-fuse/)** is a special solution based on FUSE (file system in user space), developed to mount S3 buckets to directories of Linux operating systems, similarly to the way you mount CIFS or NFS share as a network drive. S3FS is a free and open-source solution.

After mounting Amazon S3 cloud storage with S3FS to your Linux machine, you can use cp, mv, rm, and other commands in the Linux console to operate with files as you do when working with mounted local or network drives.

Let’s mount an Amazon S3 bucket to a Linux directory with Ubuntu 18.04 LTS as an example. A fresh installation of Ubuntu is used in this walkthrough. You can use the same principle for newer versions.

Update the repository tree:
`sudo apt-get update`

If any existing FUSE is installed on your Linux system, remove that FUSE before configuring the environment and installing fuse-f3fs to avoid conflicts. As we’re using a fresh installation of Ubuntu, we don’t run the sudo apt-get remove fuse command to remove FUSE.

Install s3fs from online software repositories:
`sudo apt-get install s3fs`

You need to generate the access key ID and secret access key in the AWS web interface for your account (IAM user). The IAM user must have S3 full access. You can use this link:
<https://console.aws.amazon.com/iam/home?#/security_credentials>

NOTE: It is recommended that you mount Amazon S3 buckets as a regular user with restricted permissions and use users with administrative permissions only for generating keys.

These keys are needed for AWS API access. You must have administrative permissions to generate the AWS access key ID and AWS secret access key. If you don’t have enough permissions, ask your system administrator to generate the AWS keys for you. The administrator can generate the AWS keys for a user account in the Users section of the AWS console in the Security credentials tab by clicking the Create access key button.

## get keys

cat ~/.s3cfg

```ini
[default]
access_key = foo
secret_key = bar
host_base = micro11
host_bucket = micro11/%(bucket)
check_ssl_certificate = False
check_ssl_hostname = False
use_https = False
```

```bash
sudo s3fs {bucketname} {/mountpoint/dir/} -o passwd_file=/etc/passwd-s3fs -o allow_other -o url=https://{private-network-endpoint}

sudo s3fs {bucketname} {/mountpoint/dir/} -o passwd_file=/etc/passwd-s3fs -o allow_other -o url=https://{private-network-endpoint}

```

## Go back to the Ubuntu console to create a configuration file for storing the AWS access key and secret access key needed to mount an S3 bucket with S3FS. The command to do this is

echo ACCESS_KEY:SECRET_ACCESS_KEY > PATH_TO_FILE

Change ACCESS_KEY to your AWS access key and SECRET_ACCESS_KEY to your secret access key.

In this example, we will store the configuration file with the AWS keys in the home directory of our user. Make sure that you store the file with the keys in a safe place that is not accessible to unauthorized persons.

```bash
# echo AKIA4SK3HPQ9FLWO8AMB:esrhLH4m1Da+3fJoU5xet1/ivsZ+Pay73BcSnzP > ~/.passwd-s3fs
echo foo:bar > ~/.passwd-s3fs

```

Set correct permissions for the passwd-s3fs file where the access keys are stored:
`chmod 600 ~/.passwd-s3fs`

Create the directory (mount point) that will be used as a mount point for your S3 bucket. In this example, we create the Amazon cloud drive S3 directory in the home user’s directory.
`mkdir ~/s3-bucket`

You can also use an existing empty directory.

Let’s mount the bucket. Use the following command to set the bucket name, the path to the directory used as the mount point, and the file that contains the AWS access key and secret access key.

```bash
# s3fs bucket-name /path/to/mountpoint -o passwd_file=/path/passwd-s3fs

s3fs mybucket ~/s3-bucket -o passwd_file=~/.passwd-s3fs

```

```bash
# sudo s3fs {bucketname} {/mountpoint/dir/} -o passwd_file=/etc/passwd-s3fs -o allow_other -o url=https://{private-network-endpoint}

# sudo s3fs my-bucket /mnt/my-object-storage -o passwd_file=/etc/passwd-s3fs -o allow_other -o url=https://my-object-storage-internal.sg-sin1.upcloudobjects.com

sudo mkdir /mnt/my-object-storage
sudo mkdir /mnt/mybucket

sudo s3fs mybucket /mnt/my-object-storage -o passwd_file=/home/brent/.passwd-s3fs -o allow_other -o url=https://10.188.50.201

```

```bash
# echo ACCESS_KEY_ID:SECRET_ACCESS_KEY > ${HOME}/.passwd-s3fs

# s3fs mybucket /path/to/mountpoint -o passwd_file=${HOME}/.passwd-s3fs -o dbglevel=info -f -o curldbg
s3fs mybucket /path/to/mountpoint -o passwd_file=${HOME}/.passwd-s3fs -o url=<https://url.to.s3/> -o use_path_request_style

s3fs mybucket /mnt/mybucket -o passwd_file=/home/brent/.passwd-s3fs -o url=https://micro11/ -o use_path_request_style -o dbglevel=info

s3fs <bucket-name> /mnt/ceph-s3 -o url=http://<ceph-rgw-ip>:<port> -o access_key=<your-access-key> -o secret_key=<your-secret-key>

s3fs mybucket /mnt/ceph-s3 -o url=http://10.188.50.201 -o access_key=foo -o secret_key=bar
fuse: unknown option `access_key=foo'

s3fs mybucket /mnt/ceph-s3 -o url=http://10.188.50.201 -o passwd_file=/home/brent/.passwd-s3fs

s3fs my-new-bucket-1 /mnt/s3 -o sigv2 -o use_path_request_style -o passwd_file=/root/.s3.pass -o url=http://shd-storage-3.bilibili.co -d

s3fs my-new-bucket-1 /mnt/s3 -o sigv2 -o use_path_request_style -o passwd_file=/root/.s3.pass -o url=http://shd-storage-3.bilibili.co -d

s3fs on /mnt/s3 type fuse.s3fs (rw,nosuid,nodev,relatime,user_id=0,group_id=0)
Filesystem     Type       Size  Used Avail Use% Mounted on
s3fs           fuse.s3fs  256T     0  256T   0% /mnt/s3

sudo umount /mnt/s3root

s3fs mybucket /mnt/ceph-s3 -o sigv2 -o use_path_request_style -o passwd_file=/home/brent/.passwd-s3fs -o url=http://micro11 -d

sudo umount /mnt/ceph-s3
```

<https://canlogger.csselectronics.com/canedge-getting-started/ce1/transfer-data/server-tools/mount-s3-linux/>
