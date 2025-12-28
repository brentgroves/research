# **[lvm2](https://medium.com/@The_Anshuman/what-is-lvm2-in-linux-3d28b479e250)**

LVM
Logical Volume Manager (LVM) is a versatile disk management and partitioning system designed for Linux.

It introduces a high-level abstraction layer over physical storage, allowing for dynamic and flexible control of storage volumes.

LVM is especially useful in scenarios where storage requirements may evolve, such as in server environments and virtualization.

LVM2
LVM2, or Logical Volume Manager 2, is a set of tools that provide logical volume management for the Linux kernel.

LVM2 facilitates the management of disk drives and their partitions by allowing administrators to create, resize, and move logical volumes dynamically.

![i1](https://miro.medium.com/v2/resize:fit:720/format:webp/0*rRo2iwPQLf5gXJPf.jpg)

Physical Volume (PV):
A physical volume represents a storage device or partition used by LVM.

Initialization of a physical volume can be done with the pvcreate command, for example: sudo pvcreate /dev/sdX.

Lets see PV commnds examples.

Creating a Physical Volume:To initialize a storage device or partition as a physical volume, use the pvcreate command.

![i2](https://miro.medium.com/v2/resize:fit:720/format:webp/1*J1-Qgo7AX3-nsb_6KdHu2g.png)

```bash
lsblk
NAME                      MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda                         8:0    0 278.9G  0 disk 
├─sda1                      8:1    0     1G  0 part /boot/efi
├─sda2                      8:2    0     2G  0 part /boot
└─sda3                      8:3    0 275.8G  0 part 
  └─ubuntu--vg-ubuntu--lv 252:0    0   270G  0 lvm  /
sdb                         8:16   0   1.8T  0 disk 
sdc                         8:32   0   1.8T  0 disk 
sdd                         8:48   0   1.9G  0 disk 
sr0                        11:0    1  1024M  0 rom  

df -hT
Filesystem                        Type      Size  Used Avail Use% Mounted on
tmpfs                             tmpfs      13G  2.1M   13G   1% /run
efivarfs                          efivarfs   64K   30K   30K  51% /sys/firmware/efi/efivars
/dev/mapper/ubuntu--vg-ubuntu--lv ext4      265G   11G  241G   5% /
tmpfs                             tmpfs      63G     0   63G   0% /dev/shm
tmpfs                             tmpfs     5.0M     0  5.0M   0% /run/lock
/dev/sda2                         ext4      2.0G  101M  1.7G   6% /boot
/dev/sda1                         vfat      1.1G  6.2M  1.1G   1% /boot/efi
tmpfs                             tmpfs      13G   12K   13G   1% /run/user/1000
```

Displaying Information about Physical Volumes:Use the pvdisplay command to view detailed information about one or more physical volumes.

![i3](https://miro.medium.com/v2/resize:fit:720/format:webp/1*vFaVfDbnvVxsrydtJz3HJQ.png)

```bash
sudo pvdisplay
[sudo] password for brent: 
  --- Physical volume ---
  PV Name               /dev/sda3
  VG Name               ubuntu-vg
  PV Size               275.82 GiB / not usable 3.00 MiB
  Allocatable           yes 
  PE Size               4.00 MiB
  Total PE              70610
  Free PE               1490
  Allocated PE          69120
  PV UUID               MJ1r7T-v9lM-m22G-4HBp-OnRO-WoC0-1ZopjH
```

Removing a Physical Volume:If you need to remove a physical volume, you can use the pvremove command.

![i3](https://miro.medium.com/v2/resize:fit:720/format:webp/1*nnX6ImEHoTOcu77WCpSTeg.png)

Volume Group (VG):
A volume group is a collection of physical volumes.

The creation of a volume group is accomplished using the vgcreate command. For instance: sudo vgcreate myvg /dev/sdX1 /dev/sdX2.

Lets see VG commnds examples.

Creating a Volume Group:To create a new volume group, use the vgcreate command.

![i4](https://miro.medium.com/v2/resize:fit:720/format:webp/1*cRIkuTmeRFsTdsGjzg1Bog.png)

Displaying Information about Volume Groups: Use the vgdisplay command to view detailed information about volume groups.

![i5](https://miro.medium.com/v2/resize:fit:720/format:webp/1*px2zqei20vaxB26MRiJrjQ.png)

```bash
sudo vgdisplay
  --- Volume group ---
  VG Name               ubuntu-vg
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  2
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               275.82 GiB
  PE Size               4.00 MiB
  Total PE              70610
  Alloc PE / Size       69120 / 270.00 GiB
  Free  PE / Size       1490 / 5.82 GiB
  VG UUID               21yCmD-Ui3r-yfWj-NtUx-3Nsa-044l-gRenVb
```

Adding Physical Volumes to a Volume Group: To add additional physical volumes to an existing volume group, use the vgextend command.

![i6](https://miro.medium.com/v2/resize:fit:720/format:webp/1*FWUmaOXbmfZptvRdr668oA.png)

Reducing a Volume Group by Removing Physical Volumes: If you want to reduce a volume group by removing a physical volume, use the vgreduce command.

![i7](https://miro.medium.com/v2/resize:fit:720/format:webp/1*Bhj8RdAGRgmpZvg5Twav8Q.png)

Renaming a Volume Group: To rename a volume group, you can use the vgrename command.

![i8](https://miro.medium.com/v2/resize:fit:720/format:webp/1*lIqlm4dMhTusLc6e2jWR4A.png)

Activating a Volume Group: If a volume group is not active, you can activate it using the vgchange command.

![i9](https://miro.medium.com/v2/resize:fit:720/format:webp/1*D1p8HM8GX10u2n8eW2D-IQ.png)

Deactivating a Volume Group: To deactivate a volume group, use the vgchange command.

![i10](https://miro.medium.com/v2/resize:fit:720/format:webp/1*I5R-F2LasSZ-RMdg1e83Qg.png)

Removing a Volume Group: To remove a volume group, use the vgremove command.

![i11](https://miro.medium.com/v2/resize:fit:720/format:webp/1*xvR89vtHtJb0qNOEM0avzQ.png)

Logical Volume (LV):
A logical volume is a virtual partition within a volume group.

Logical volumes can be created with the lvcreate command. An example would be: sudo lvcreate -L 10G -n mylv myvg.

Lets see LV commnds examples.

Creating a Logical Volume: Use the lvcreate command to create a logical volume within a volume group.

![i12](https://miro.medium.com/v2/resize:fit:720/format:webp/1*2g6tr8Sh4JZKThqYclbOHw.png)

Displaying Information about Logical Volumes: The lvdisplay command provides detailed information about logical volumes.

![i13](https://miro.medium.com/v2/resize:fit:720/format:webp/1*CfiqOTmSHVZEyBZbbMRbrQ.png)

```bash
sudo lvdisplay
  --- Logical volume ---
  LV Path                /dev/ubuntu-vg/ubuntu-lv
  LV Name                ubuntu-lv
  VG Name                ubuntu-vg
  LV UUID                2OLNka-NPkz-ckX8-UwTh-pDN9-M7A3-vtt0vB
  LV Write Access        read/write
  LV Creation host, time ubuntu-server, 2025-06-25 20:58:51 +0000
  LV Status              available
  # open                 1
  LV Size                270.00 GiB
  Current LE             69120
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:0
```

Resizing a Logical Volume: Extend the size of a logical volume using the lvextend command.

![i14](https://miro.medium.com/v2/resize:fit:720/format:webp/1*Zf9BYE2nEHrcl21ZGvzswA.png)

Reducing the Size of a Logical Volume: To reduce the size of a logical volume, use the lvreduce command.

![i15](https://miro.medium.com/v2/resize:fit:720/format:webp/1*RQ7IIuLWWc8rrAmZUABRZQ.png)

Removing a Logical Volume: To remove a logical volume, use the lvremove command.

![i16](https://miro.medium.com/v2/resize:fit:720/format:webp/1*s7Uk0o5vx1NqFZt1KlpQvg.png)
