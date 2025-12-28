# **[]()**

Deleting a partition in Linux can be accomplished using command-line tools like fdisk or parted, or graphical tools like GParted.

## Using fdisk (Command Line)

- **Identify the disk:** Use lsblk or sudo fdisk -l to list all disks and partitions and - identify the correct disk (e.g., /dev/sdb) and the partition number you wish to delete.
- ***Unmount the partition (if mounted):** If the partition is currently mounted, unmount it using `sudo umount /dev/sdbX` (replace X with the partition number).

```bash
lsblk
sda      8:0    0 238.5G  0 disk 
├─sda1   8:1    0    50M  0 part 
├─sda2   8:2    0 237.9G  0 part 
└─sda3   8:3    0   498M  0 part 
sdb      8:16   0 465.8G  0 disk 
├─sdb1   8:17   0     1G  0 part /boot/efi
└─sdb2   8:18   0 464.7G  0 part /
# or
sudo parted -l
Model: ATA SAMSUNG MZ7PD256 (scsi)
Disk /dev/sda: 256GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags: 

Number  Start   End     Size    Type     File system  Flags
 1      1049kB  53.5MB  52.4MB  primary  ntfs         boot
 2      53.5MB  256GB   255GB   primary  ntfs
 3      256GB   256GB   522MB   primary  ntfs         msftres


Model: ATA Samsung SSD 860 (scsi)
Disk /dev/sdb: 500GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: 

Number  Start   End     Size    File system  Name  Flags
 1      1049kB  1128MB  1127MB  fat32              boot, esp
 2      1128MB  500GB   499GB   ext4
#  or
sudo lshw -C disk
 *-disk:0
       description: ATA Disk
       product: SAMSUNG MZ7PD256
       physical id: 0
       bus info: scsi@0:0.0.0
       logical name: /dev/sda
       version: 6H6Q
       serial: S1N8NSAG909469
       size: 238GiB (256GB)
       capabilities: partitioned partitioned:dos
       configuration: ansiversion=5 logicalsectorsize=512 sectorsize=512 signature=77979942
 *-disk:1
       description: ATA Disk
       product: Samsung SSD 860
       physical id: 0.0.0
       bus info: scsi@3:0.0.0
       logical name: /dev/sdb
       version: 2B6Q
       serial: S3Z1NB0M267130H
       size: 465GiB (500GB)
       capabilities: gpt-1.00 partitioned partitioned:gpt
       configuration: ansiversion=5 guid=84cd21fa-9b01-422a-a516-cb845a0b14b5 logicalsectorsize=512 sectorsize=512     


```

- **Start fdisk:** Open the fdisk utility for the target disk:

```bash
sudo fdisk /dev/sda
```

- **Delete the partition:**
Type d and press Enter.
Enter the partition number you want to delete and press Enter.

- **Write changes and exit:**
Type w and press Enter to write the changes to the partition table and exit fdisk.
