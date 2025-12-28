# **[onedrive](https://rclone.org/onedrive/)**

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
   \ (webdav)
59 / Yandex Disk
   \ (yandex)
60 / Zoho
   \ (zoho)
61 / iCloud Drive
   \ (iclouddrive)
62 / premiumize.me
   \ (premiumizeme)
63 / seafile
   \ (seafile)
Storage> 38

Option client_id.
OAuth Client Id.
Leave blank normally.
Enter a value. Press Enter to leave empty.
client_id>

Option client_secret.
OAuth Client Secret.
Leave blank normally.
Enter a value. Press Enter to leave empty.
client_secret>

Option region.
Choose national cloud region for OneDrive.
Choose a number from below, or type in your own value of type string.
Press Enter for the default (global).
 1 / Microsoft Cloud Global
   \ (global)
 2 / Microsoft Cloud for US Government
   \ (us)
 3 / Microsoft Cloud Germany (deprecated - try global region first).
   \ (de)
 4 / Azure and Office 365 operated by Vnet Group in China
   \ (cn)
region>

Option tenant.
ID of the service principal's tenant. Also called its directory ID.
Set this if using

- Client Credential flow
Enter a value. Press Enter to leave empty.
tenant> linamar.com

Edit advanced config?
y) Yes
n) No (default)
y/n>

Use web browser to automatically authenticate rclone with remote?

- Say Y if the machine running rclone has a web browser you can use
- Say N if running rclone on a (remote) machine without web browser access
If not sure try Y. If Y failed, try N.

y) Yes (default)
n) No
y/n>

2025/08/21 15:21:48 NOTICE: Make sure your Redirect URL is set to "<http://localhost:53682/>" in your custom config.
2025/08/21 15:21:48 NOTICE: If your browser doesn't open automatically go to the following link: <http://127.0.0.1:53682/auth?state=7H5TdviHcEnmgW0lDeY4EQ>
2025/08/21 15:21:48 NOTICE: Log in and authorize rclone for access
2025/08/21 15:21:48 NOTICE: Waiting for code...

Organization banner logo
<bgroves@linamar.com>
Approval required
rclone
This app requires your admin's approval to:

Read user files

Have full access to user files

Read all files that user can access

Have full access to all files user can access

Read items in all site collections

Maintain access to data you have given it access to

View users' basic profile
Enter justification for requesting this app
Sign in with another account
Does this app look suspicious? Report it here
