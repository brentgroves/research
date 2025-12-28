# **[How to install distrobuilder](https://linuxcontainers.org/distrobuilder/docs/latest/howto/install/)**

## Installing from package

distrobuilder is available from the Snap Store.

```bash
sudo snap install distrobuilder --classic
# for windows registry support
sudo apt install libwin-hivex-perl genisoimage
```

## Runtime dependencies for building VM images

If you intend to build Incus VM images (via distrobuilder build-incus --vm), your system will need certain tools installed:

Debian-based:

```bash
sudo apt update
sudo apt install -y btrfs-progs dosfstools qemu-kvm
```
