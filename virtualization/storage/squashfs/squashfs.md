# SquashFS

SquashFS is a compressed, read-only, Linux-native filesystem that saves disk space by compressing files and directories individually. It's widely used in live Linux distributions (like Ubuntu or Fedora), embedded systems, and for archiving large amounts of data due to its high compression ratio and fast data access times. Tools like mksquashfs create SquashFS images, and unsquashfs extracts them, while union filesystems, such as OverlayFS, allow for a read-write layer on top of the read-only SquashFS.

This **[video](https://www.youtube.com/watch?v=Rt6U2gG0ggw&t=1)** explains what SquashFS is and its benefits:
