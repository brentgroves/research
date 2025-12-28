START /min C:\rclone\rclone.exe mount mybucket:mybucket/ S: --links --vfs-cache-mode full

rclone.exe config
No remotes found, make a new one?
n) New remote
s) Set configuration password
q) Quit config
n/s/q>n

name> mybucket

Option Storage.
Type of storage to configure.
Choose a number from below, or type in your own value.
 1 / 1Fichier
   \ (fichier)
 2 / Akamai NetStorage
   \ (netstorage)
 3 / Alias for an existing remote
   \ (alias)
 4 / Amazon S3 Compliant Storage Providers including AWS, Alibaba, ArvanCloud, Ceph, ChinaMobile, Cloudflare, DigitalOcean, Dreamhost, Exaba, FlashBlade, GCS, HuaweiOBS, IBMCOS, IDrive, IONOS, LyveCloud, Leviia, Liara, Linode, Magalu, Mega, Minio, Netease, Outscale, Petabox, RackCorp, Rclone, Scaleway, SeaweedFS, Selectel, StackPath, Storj, Synology, TencentCOS, Wasabi, Qiniu and others
   \ (s3)
 5 / Backblaze B2
   \ (b2)
 6 / Better checksums for other remotes
   \ (hasher)
 7 / Box
   \ (box)
 8 / Cache a remote
   \ (cache)
 9 / Citrix Sharefile
   \ (sharefile)
10 / Cloudinary
   \ (cloudinary)
11 / Combine several remotes into one
   \ (combine)
12 / Compress a remote
   \ (compress)
13 / DOI datasets
   \ (doi)
14 / Dropbox
   \ (dropbox)
15 / Encrypt/Decrypt a remote
   \ (crypt)
16 / Enterprise File Fabric
   \ (filefabric)
17 / FTP
   \ (ftp)
18 / FileLu Cloud Storage
   \ (filelu)
19 / Files.com
   \ (filescom)
20 / Gofile
   \ (gofile)
21 / Google Cloud Storage (this is not Google Drive)
   \ (google cloud storage)
22 / Google Drive
   \ (drive)
23 / Google Photos
   \ (google photos)
24 / HTTP
   \ (http)
25 / Hadoop distributed file system
   \ (hdfs)
26 / HiDrive
   \ (hidrive)
27 / ImageKit.io
   \ (imagekit)
28 / In memory object storage system.
   \ (memory)
29 / Internet Archive
   \ (internetarchive)
30 / Jottacloud
   \ (jottacloud)
31 / Koofr, Digi Storage and other Koofr-compatible storage providers
   \ (koofr)
32 / Linkbox
   \ (linkbox)
33 / Local Disk
   \ (local)
34 / Mail.ru Cloud
   \ (mailru)
35 / Mega
   \ (mega)
36 / Microsoft Azure Blob Storage
   \ (azureblob)
37 / Microsoft Azure Files
   \ (azurefiles)
38 / Microsoft OneDrive
   \ (onedrive)
39 / OpenDrive
   \ (opendrive)
40 / OpenStack Swift (Rackspace Cloud Files, Blomp Cloud Storage, Memset Memstore, OVH)
   \ (swift)
41 / Oracle Cloud Infrastructure Object Storage
   \ (oracleobjectstorage)
42 / Pcloud
   \ (pcloud)
43 / PikPak
   \ (pikpak)
44 / Pixeldrain Filesystem
   \ (pixeldrain)
45 / Proton Drive
   \ (protondrive)
46 / Put.io
   \ (putio)
47 / QingCloud Object Storage
   \ (qingstor)
48 / Quatrix by Maytech
   \ (quatrix)
49 / SMB / CIFS
   \ (smb)
50 / SSH/SFTP
   \ (sftp)
51 / Sia Decentralized Cloud
   \ (sia)
52 / Storj Decentralized Cloud Storage
   \ (storj)
53 / Sugarsync
   \ (sugarsync)
54 / Transparently chunk/split large files
   \ (chunker)
55 / Uloz.to
   \ (ulozto)
56 / Union merges the contents of several upstream fs
   \ (union)
57 / Uptobox
   \ (uptobox)
58 / WebDAV
Storage> 4

Option provider.
Choose your S3 provider.
Choose a number from below, or type in your own value.
Press Enter to leave empty.
1 / Amazon Web Services (AWS) S3
   \ (AWS)
 2 / Alibaba Cloud Object Storage System (OSS) formerly Aliyun
   \ (Alibaba)
 3 / Arvan Cloud Object Storage (AOS)
   \ (ArvanCloud)
 4 / Ceph Object Storage
   \ (Ceph)
 5 / China Mobile Ecloud Elastic Object Storage (EOS)
   \ (ChinaMobile)
 6 / Cloudflare R2 Storage
   \ (Cloudflare)
 7 / DigitalOcean Spaces
   \ (DigitalOcean)
 8 / Dreamhost DreamObjects
   \ (Dreamhost)
 9 / Exaba Object Storage
   \ (Exaba)
10 / Pure Storage FlashBlade Object Storage
   \ (FlashBlade)
11 / Google Cloud Storage
   \ (GCS)
12 / Huawei Object Storage Service
   \ (HuaweiOBS)
13 / IBM COS S3
   \ (IBMCOS)
14 / IDrive e2
   \ (IDrive)
15 / IONOS Cloud
   \ (IONOS)
16 / Seagate Lyve Cloud
   \ (LyveCloud)
17 / Leviia Object Storage
   \ (Leviia)
18 / Liara Object Storage
   \ (Liara)
19 / Linode Object Storage
   \ (Linode)
20 / Magalu Object Storage
   \ (Magalu)
21 / MEGA S4 Object Storage
   \ (Mega)
22 / Minio Object Storage
   \ (Minio)
23 / Netease Object Storage (NOS)
   \ (Netease)
24 / OUTSCALE Object Storage (OOS)
   \ (Outscale)
25 / Petabox Object Storage
   \ (Petabox)
26 / RackCorp Object Storage
   \ (RackCorp)
27 / Rclone S3 Server
   \ (Rclone)
28 / Scaleway Object Storage
   \ (Scaleway)
29 / SeaweedFS S3
   \ (SeaweedFS)
30 / Selectel Object Storage
   \ (Selectel)
31 / StackPath Object Storage
   \ (StackPath)
32 / Storj (S3 Compatible Gateway)
   \ (Storj)
33 / Synology C2 Object Storage
   \ (Synology)
34 / Tencent Cloud Object Storage (COS)
   \ (TencentCOS)
35 / Wasabi Object Storage
   \ (Wasabi)
36 / Qiniu Object Storage (Kodo)
   \ (Qiniu)
37 / Any other S3 compatible provider
   \ (Other)
provider> 4
Option env_auth.
Get AWS credentials from runtime (environment variables or EC2/ECS meta data if no env vars).
Only applies if access_key_id and secret_access_key is blank.
Choose a number from below, or type in your own boolean value (true or false).
Press Enter for the default (false).
 1 / Enter AWS credentials in the next step.
   \ (false)
 2 / Get AWS credentials from the environment (env vars or IAM).
   \ (true)
env_auth>1

Option access_key_id.
AWS Access Key ID.
Leave blank for anonymous access or runtime credentials.
Enter a value. Press Enter to leave empty.
access_key_id> foo

Option secret_access_key.
AWS Secret Access Key (password).
Leave blank for anonymous access or runtime credentials.
Enter a value. Press Enter to leave empty.
secret_access_key> bar

Option region.
Region to connect to.
Leave blank if you are using an S3 clone and you don't have a region.
Choose a number from below, or type in your own value.
Press Enter to leave empty.
   / Use this if unsure.
 1 | Will use v4 signatures and an empty region.
   \ ()
   / Use this only if v4 signatures don't work.
 2 | E.g. pre Jewel/v10 CEPH.
   \ (other-v2-signature)
region>
Option endpoint.
Endpoint for S3 API.
Required when using an S3 clone.
Enter a value. Press Enter to leave empty.
<http://microcloud>

Option location_constraint.
Location constraint - must be set to match the Region.
Leave blank if not sure. Used when creating buckets only.
Enter a value. Press Enter to leave empty.
location_constraint>
Option acl.
Canned ACL used when creating buckets and storing or copying objects.
This ACL is used for creating objects and if bucket_acl isn't set, for creating buckets too.
For more info visit <https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl>
Note that this ACL is applied when server-side copying objects as S3
doesn't copy the ACL from the source but rather writes a fresh one.
If the acl is an empty string then no X-Amz-Acl: header is added and
the default (private) will be used.
Choose a number from below, or type in your own value.
Press Enter to leave empty.
   / Owner gets FULL_CONTROL.
 1 | No one else has access rights (default).
   \ (private)
   / Owner gets FULL_CONTROL.
 2 | The AllUsers group gets READ access.
   \ (public-read)
   / Owner gets FULL_CONTROL.
 3 | The AllUsers group gets READ and WRITE access.
   | Granting this on a bucket is generally not recommended.
   \ (public-read-write)
   / Owner gets FULL_CONTROL.
 4 | The AuthenticatedUsers group gets READ access.
   \ (authenticated-read)
   / Object owner gets FULL_CONTROL.
 5 | Bucket owner gets READ access.
   | If you specify this canned ACL when creating a bucket, Amazon S3 ignores it.
   \ (bucket-owner-read)
   / Both the object owner and the bucket owner get FULL_CONTROL over the object.
 6 | If you specify this canned ACL when creating a bucket, Amazon S3 ignores it.
   \ (bucket-owner-full-control)
acl> 3

Option server_side_encryption.
The server-side encryption algorithm used when storing this object in S3.
Choose a number from below, or type in your own value.
Press Enter to leave empty.
 1 / None
   \ ()
 2 / AES256
   \ (AES256)
 3 / aws:kms
   \ (aws:kms)
server_side_encryption>
Option sse_kms_key_id.
If using KMS ID you must provide the ARN of Key.
Choose a number from below, or type in your own value.
Press Enter to leave empty.
 1 / None
   \ ()
 2 / arn:aws:kms:*
   \ (arn:aws:kms:us-east-1:*)
sse_kms_key_id>
Edit advanced config?
y) Yes
n) No (default)
y/n>
Configuration complete.
Options:

- type: s3
- provider: Ceph
- access_key_id: foo
- secret_access_key: bar
- endpoint: <http://microcloud>
- acl: public-read-write
Keep this "mybucket" remote?
y) Yes this is OK (default)
e) Edit this remote
d) Delete this remote
y/e/d>

Current remotes:

Name                 Type
====                 ====
mybucket             s3

e) Edit existing remote
n) New remote
d) Delete remote
r) Rename remote
c) Copy remote
s) Set configuration password
q) Quit config
e/n/d/r/c/s/q>

```
