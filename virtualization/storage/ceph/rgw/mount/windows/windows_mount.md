# **[](https://www.nakivo.com/blog/mount-amazon-s3-as-a-drive-how-to-guide/)**

<https://blog.spikeseed.cloud/mount-s3-as-a-disk/>

## Mounting Amazon S3 Cloud Storage in Windows

You can try wins3fs, which is a solution equivalent to S3FS for mounting Amazon S3 cloud storage as a network disk in Windows. However, in this section, we are going to use rclone. Rclone is a command line tool that can be used to mount and synchronize cloud storage, such as Amazon S3 buckets, Google Cloud Storage, Google Drive, Microsoft OneDrive, DropBox, and so on.

Rclone is a free open-source tool that can be downloaded from the official website and from GitHub. You can download the needed version of rclone by using one of these links:

<https://rclone.org/downloads/>
<https://github.com/rclone/rclone/releases/tag/v1.51.0>
Let’s use the direct link from the official website:

<https://downloads.rclone.org/v1.51.0/rclone-v1.51.0-windows-amd64.zip>
You can use this workflow for newer versions of rclone after they are released. The following actions are performed in the command line interface and may be useful for users who use Windows without a GUI on servers or VMs.

Open Windows PowerShell as Administrator.
Create the directory to download and store rclone files:
mkdir c:\rclone

Go to the created directory:
cd c:\rclone

Download rclone by using the direct link mentioned above. Edit the version number in the link if you download another version.
Invoke-WebRequest -Uri "<https://downloads.rclone.org/v1.51.0/rclone-v1.51.0-windows-amd64.zip>" -OutFile "c:\rclone\rclone.zip"

Extract files from the downloaded archive:
Expand-Archive -path 'c:\rclone\rclone.zip' -destinationpath '.\'

Check the contents of the directory:
dir

```bash
cat C:\rclone\rclone.conf
cat ~/.config/rclone/rclone.conf
[mybucket]
type = s3
provider = Ceph
access_key_id = foo
secret_access_key = bar
endpoint = http://microcloud
acl = public-read-write
.\rclone mount mybucket:mybucket/ S: --links --vfs-cache-mode full
```
