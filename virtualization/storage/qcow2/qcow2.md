# what is a qcow2 file

A qcow2 file is a virtual disk image format for the QEMU and KVM virtualization platforms, standing for "QEMU Copy-On-Write". It's a "thin-provisioned" format, meaning the file only uses disk space as data is written, rather than the full pre-allocated size. Key features include space efficiency, support for snapshots, compression, and encryption.

## How it works

- Copy-On-Write (COW):

The "Copy-On-Write" functionality allows for efficient snapshots and sharing of base images. When a change is made to the virtual disk, the data is written to a new location in the qcow2 file, keeping the original data intact.

- Thin Provisioning:
The image file starts small and only grows as actual data is stored within it, making it more space-efficient than a raw disk image.

- Clustering:
Qcow2 divides both the virtual disk and the physical storage into fixed-size units called clusters, which are used for all allocations and metadata.

## Key benefits

- Space efficiency:

Qcow2 files are generally more space-efficient than other formats because they only allocate space when it's needed.

- Snapshot support:

The copy-on-write mechanism makes it easy to create snapshots of virtual machine states, allowing you to revert to previous points in time.

- Compression:
The format supports zlib-based compression, which further reduces the size of the disk image file.

- Encryption:
Qcow2 files can be encrypted, providing a layer of security for data at rest.

- Flexibility:
It can use another backing file as a base, which is useful for creating multiple virtual machines from the same base image.

## Use cases

- QEMU/KVM virtualization:
It's the native format for virtual disk images within the QEMU and KVM hypervisors, making it a common choice in environments like Proxmox VE.

- Cloud images:

Qcow2 is frequently used to provide disk images for cloud-based virtual machines.

Running the build-incus sub-command creates an Incus image. If --type=split, it outputs two files. The metadata tarball will always be named incus.tar.xz. When creating a container image, the second file will be rootfs.squashfs. When creating a VM image, the second file will be disk.qcow2. If --type=unified, a unified tarball named <image.name>.tar.xz is created. See the image section for more on the image name.

If --compression is set, the tarballs will use the provided compression instead of xz.

Setting --vm will create a qcow2 image which is used for virtual machines. This requires some extra tools to be installed on your host - see How to install distrobuilder for instructions.

If --import-into-incus is set, the resulting image is imported into Incus. It basically runs lxc image import <image>. Per default, it doesn’t create an alias. This can be changed by calling it as --import-into-incus=<alias>.

After building the image, the rootfs will be destroyed.

The pack-incus sub-command can be used to create an image from an existing rootfs. The rootfs won’t be deleted afterwards.
