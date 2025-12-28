# **[mount 2nd hdd](https://www.reddit.com/r/Ubuntu/comments/1f6cpc2/mount_second_hard_drive/)**

set a proper label on the filesystem, and the auto-mount feature of the filemanagers will use that.

gparted can set labels on such things.

FSTAB currently contains this entry:

    /dev/disk/by-uuid/e23a401d-02c8-456a-97d0-5e2ee2b91f41 /mnt/e23a401d-02c8-456a-97d0-5e2ee2b91f41 auto nosuid,nodev,nofail,x-gvfs-show 0 0
So change it?

   sudo mkdir /mnt/Storage
In fstab

  /dev/disk/by-uuid/e23a401d-02c8-456a-97d0-5e2ee2b91f41 /mnt/Storage  auto nosuid,nodev,nofail,x-gvfs-show 0 0
Just to be clear - the mountpoint directory MUST exist before you do the mount. The file manager auto-mount feature does make the directory automatically, using fstab will NOT auto-make a missing directory.

Not sure how/what generated that fstab line, but the use of 'auto' as the filesystem type can cause some issues. I am guessing you used gnome disks to make that entry.

Knowing how linux mounts filesystems, is a good skill to have. Its a core concept thats used in other use cases as well.

Learn Linux, 101: Control mounting and unmounting of filesystems

<https://developer.ibm.com/learningpaths/lpic1-exam-101-topic-104/l-lpic1-104-3/>

Learn Linux, 101: Manage file permissions and ownership

<https://developer.ibm.com/learningpaths/lpic1-exam-101-topic-104/l-lpic1-104-5/>

Upvote
2

Downvote
