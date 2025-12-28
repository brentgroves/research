# **[create windows image for the MicroCloud](https://www.youtube.com/watch?v=DVxzGm5jIEI)**

```bash
sudo snap install distrobuilder --classic
# for windows registry support
sudo apt install libwin-hivex-perl
sudo apt install wimtools genisoimage
sudo distrobuilder repack-windows Win11_24H2_English_x64.iso win11.incus.iso --windows-arch amd64
```

upload custom iso image

## learnings

XFS, or the eXtended File System, is a high-performance, journaling file system originally developed by Silicon Graphics (SGI) and later ported to Linux. It is known for its ability to handle extremely large files and datasets,

A file overlay is a layer of data or a separate file system that sits on top of an existing one, providing a unified view while allowing changes to be made to the top layer without altering the underlying content. This is achieved by combining a read-only lower layer with a writable upper layer, so modifications are recorded in the upper layer, or in memory, creating a persistent or temporary modification of otherwise immutable data.
