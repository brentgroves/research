# AI Overview

```bash
rclone ls mybucket:mybucket
  2598092 .Trash-1000/files/TrialBalanceLinamar
  2598092 .Trash-1000/files/TrialBalanceLinamar.xlsx
  2092704 .Trash-1000/files/tb.xlsx
       71 .Trash-1000/info/TrialBalanceLinamar.trashinfo
       76 .Trash-1000/info/TrialBalanceLinamar.xlsx.trashinfo
       59 .Trash-1000/info/tb.xlsx.trashinfo
    12370 Workspace Migration Plan.xlsx
    21439 cat.jpg
       97 my-folder/.~lock.tb.xlsx#
        4 my-folder/my-file.txt
  2092704 my-folder/tb.xlsx
        4 mytest.txt.txt
        6 t1.txt
        3 t2.txt
        0 t3.txt
        4 t4.txt
        4 t5.txt
        5 t6.txt
        5 t7.txt
  2598092 tb2.xlsx
```
  
Rclone enables the mounting of various cloud storage systems and other remote locations as a local file system on Linux, utilizing FUSE (Filesystem in Userspace). This allows users to interact with remote files and directories as if they were stored locally.
Steps to Mount a Remote with Rclone on Linux:
Install Rclone: If Rclone is not already installed, it can be installed using the official installation script or by downloading and extracting the precompiled binary.
Code

```bash
sudo -v ; curl https://rclone.org/install.sh | sudo bash
```

Configure Rclone Remote: Before mounting, a remote must be configured using the rclone config command. This involves specifying the type of storage, authentication details, and other relevant settings for the remote.
Code

```bash
rclone config
```

## Create a Mount Point: Create an empty directory on your local file system that will serve as the mount point for the remote storage

```bash
mkdir ~/mycloudmount
```

## Mount the Remote: Use the rclone mount command to mount the configured remote to the created mount point

```bash
# rclone mount mybucket:mybucket S: --links --vfs-cache-mode full

# rclone mount mybucket:mybucket /home/brent/mybucket -vv --vfs-cache-mode full --daemon

rclone mount mybucket:mybucket /home/brent/mybucket -vv --vfs-cache-mode full 

rclone mount ceph-s3-bucket:my-bucket /mnt/ceph-mount --vfs-cache-mode full: This command mounts your Ceph S3 bucket as a local filesystem at /mnt/ceph-mount. 


# s3fs mybucket /home/brent/s3-bucket -o sigv2 -o use_path_request_style -o passwd_file=/home/brent/.passwd-s3fs -o url=http://microcloud -d
```

- Replace remote_name with the name given to the remote during configuration.
- Replace path/to/files with the specific path within the remote that you wish to mount (optional).
- Replace /path/to/local/mount with the path to the empty directory created as the mount point.
- The --daemon flag runs the mount in the background, allowing the terminal to be used for other tasks.

**Access Mounted Files:** Once mounted, the files and directories on the remote storage can be accessed and manipulated through the local mount point as if they were local files.

## windows

rclone mount mybucket:mybucket S: -v --links --vfs-cache-mode full
