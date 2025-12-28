# AI Overview

<https://www.youtube.com/watch?v=ff8Ogk8NIPU>
<https://www.youtube.com/watch?v=we17KOJKySY>
<https://www.youtube.com/watch?v=MwxbX6PNiWA>

## windows

```bash
rclone mount mybucket:mybucket S: -v --links --vfs-cache-mode full
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

rclone mount mybucket:mybucket /home/brent/mybucket -vv --vfs-cache-mode full --daemon
```

- Replace remote_name with the name given to the remote during configuration.
- Replace path/to/files with the specific path within the remote that you wish to mount (optional).
- Replace /path/to/local/mount with the path to the empty directory created as the mount point.
- The --daemon flag runs the mount in the background, allowing the terminal to be used for other tasks.

**Access Mounted Files:** Once mounted, the files and directories on the remote storage can be accessed and manipulated through the local mount point as if they were local files.
