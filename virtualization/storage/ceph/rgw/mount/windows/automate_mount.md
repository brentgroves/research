# **[](https://www.nakivo.com/blog/mount-amazon-s3-as-a-drive-how-to-guide/)**

How to automate mounting an S3 bucket on Windows boot
It is convenient when the bucket is mounted as a network drive automatically on Windows boot. Let’s find out how to configure the automatic mounting of the S3 bucket in Windows.

1. Create the rclone_start.cmd file in the C:\bin\ directory.
Add the string to the rclone-S3.cmd file:
`C:\bin\rclone.exe mount mybucket:mybucket/ S: --links --vfs-cache-mode full`

## 2. Save the CMD file

You can run this CMD file instead of typing the command to mount the S3 bucket manually.

## create service from cmd file using nssm

## **[nssm](https://nssm.cc/)

## install

add c:\bin to path
copy nssm.exe to c:\bin

<!-- run as admin -->
```bash
nssm install rclone_start.cmd

nssm install dokan_start.cmd
```
