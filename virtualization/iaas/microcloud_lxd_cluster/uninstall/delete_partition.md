# delete partition

To delete a partition in Linux, you can use the fdisk command-line utility. First, identify the disk and partition you want to delete using fdisk -l. Then, use the fdisk /dev/sdX command (replace 'sdX' with the correct disk identifier) to enter the utility. Inside fdisk, use the d command to delete a partition, specifying the partition number when prompted. Finally, use the w command to write the changes to the disk and exit fdisk.
Detailed Steps:

1. Identify the disk and partition:
Use the command fdisk -l to list all available disks and their partitions.
Note the disk identifier (e.g., /dev/sda, /dev/sdb) and the partition number you wish to delete.

```bash
sudo -i
fdisk -l
...
Disk /dev/sdb: 1.82 TiB, 1999844147200 bytes, 3905945600 sectors
Disk model: PERC H710       
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: B7E5840F-44F7-1042-A5B6-679A36AC1DB4

Device          Start        End    Sectors  Size Type
/dev/sdb1        2048 3905927167 3905925120  1.8T Solaris /usr & Apple ZFS
/dev/sdb9  3905927168 3905943551      16384    8M Solaris reserved 1

```

## 2. Enter the fdisk utility

Open a terminal and use the command sudo fdisk /dev/sdX (replace 'sdX' with the correct disk identifier).
You will need administrator privileges (sudo) to modify the partition table.

```bash

cryptsetup luksClose /dev/mapper/luksosd-1
```

## 3. Delete the partition

Inside the fdisk utility, type d to delete a partition.
fdisk will prompt you to enter the partition number you want to delete. Enter the number and press Enter.

```bash
Welcome to fdisk (util-linux 2.39.3).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): d
Partition number (1,9, default 9): 

Partition 9 has been deleted.

Command (m for help): d
Selected partition 1
Partition 1 has been deleted.

Command (m for help): d
No partition is defined yet!
```

Repeat this process if you need to delete multiple partitions.

## 4. Save the changes

After deleting the desired partitions, type w to write the changes to the disk and exit fdisk.

```bash
Command (m for help): w

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

lsblk
NAME                      MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
loop0                       7:0    0  50.9M  1 loop /snap/snapd/24718
loop1                       7:1    0  73.9M  1 loop /snap/core22/2010
loop3                       7:3    0  66.8M  1 loop /snap/core24/1006
loop7                       7:7    0  49.3M  1 loop /snap/snapd/24792
sda                         8:0    0 278.9G  0 disk 
├─sda1                      8:1    0     1G  0 part /boot/efi
├─sda2                      8:2    0     2G  0 part /boot
└─sda3                      8:3    0 275.8G  0 part 
  └─ubuntu--vg-ubuntu--lv 252:0    0   270G  0 lvm  /
sdb                         8:16   0   1.8T  0 disk 
sdc                         8:32   0   1.8T  0 disk 
sdd                         8:48   0 465.3G  0 disk 
sde                         8:64   0   1.9G  0 disk 
sr0                        11:0    1  1024M  0 rom 
```
