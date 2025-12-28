<https://rclone.org/commands/rclone_mount/>

When the program ends while in foreground mode, either via Ctrl+C or receiving a SIGINT or SIGTERM signal, the mount should be automatically stopped.

When running in background mode the user will have to stop the mount manually:

# Linux

fusermount -u /path/to/local/mount

# ... or on some systems

fusermount3 -u /path/to/local/mount

# OS X or Linux when using nfsmount

umount /path/to/local/mount
The umount operation can fail, for example when the mountpoint is busy. When that happens, it is the user's responsibility to stop the mount manually.

The size of the mounted file system will be set according to information retrieved from the remote, the same as returned by the rclone about command. Remotes with unlimited storage may report the used size only, then an additional 1 PiB of free space is assumed. If the remote does not support the about feature at all, then 1 PiB is set as both the total and the free size.
