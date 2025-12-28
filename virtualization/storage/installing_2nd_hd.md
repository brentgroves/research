# **[installing 2nd hard drive](https://help.ubuntu.com/community/InstallingANewHardDrive)**

## Introduction

While it's not every day that you need to add a new hard drive to your computer, the task does not have to be complicated. Use this guide to help you install a new hard drive with an existing Ubuntu system, and partition it for use. Before beginning, you need to consider for what you will be using the hard drive.

- Will the drive be used only with Ubuntu?
- Will the drive need to be accessible from both Ubuntu and Windows?
- How do you want to divide the free space? As a single partition, or as several?
- Do you want any of the partitions to be larger than 2 TB?
- This guide goes over procedures for a single partition drive install only. Multiple partition drive installations are not very hard, and you may very well figure it out by using this guide; however, make sure you add an entry in /etc/fstab for each partition, not just the drive.

A Note about File Systems:

Drives that are going to be used only under Ubuntu should be formatted using the ext3/ext4 file system (depending on which version of Ubuntu you use and whether you need Linux backwards compatibility). For sharing between Ubuntu and Windows, FAT32 is often the recommended file system, although NTFS works quite well too. If you are new to file systems and partitioning, please do some preliminary research on the two before you attempt this procedure.

## Determine Drive Information

We assume that the hard drive is physically installed and detected by the BIOS.

To determine the path that your system has assigned to the new hard drive, open a terminal and run:

```bash
sudo lshw -C disk
```

This should produce output similar to this sample:

```bash
  *-disk
       description: ATA Disk
       product: IC25N040ATCS04-0
       vendor: Hitachi
       physical id: 0
       bus info: ide@0.0
       logical name: /dev/sdb
       version: CA4OA71A
       serial: CSH405DCLSHK6B
       size: 37GB
       capacity: 37GB
```

micro11

```bash
sudo lshw -C disk
[sudo] password for brent: 
  *-disk                    
       description: SCSI Disk
       product: PERC H710
       vendor: DELL
       physical id: 2.0.0
       bus info: scsi@0:2.0.0
       logical name: /dev/sda
       version: 3.13
       serial: 00c6a18f259ca23e2f00cda9db60f681
       size: 1862GiB (1999GB)
       capabilities: gpt-1.00 partitioned partitioned:gpt
       configuration: ansiversion=5 guid=58ee31f9-3982-47c2-921d-e69c740c8d4e logicalsectorsize=512 sectorsize=512
  *-disk
       description: SCSI Disk
       product: Internal Dual SD
       vendor: Dell
       physical id: 0.0.0
       bus info: scsi@7:0.0.0
       logical name: /dev/sdb
       version: 1.:
       serial: 0123456789AB
       size: 1946MiB (2040MB)
       capabilities: partitioned partitioned:dos
       configuration: ansiversion=5 logicalsectorsize=512 sectorsize=512 signature=d70045f0
  *-cdrom
       description: DVD reader
       product: DVD-ROM DU70N
       vendor: HL-DT-ST
       physical id: 0.0.0
       bus info: scsi@5:0.0.0
       logical name: /dev/cdrom
       logical name: /dev/sr0
       version: D300
       capabilities: removable audio dvd
       configuration: ansiversion=5 status=nodisc

```

micro12

```bash
sudo lshw -C disk
  *-disk                    
       description: SCSI Disk
       product: PERC H710
       vendor: DELL
       physical id: 2.0.0
       bus info: scsi@0:2.0.0
       logical name: /dev/sda
       version: 3.13
       serial: 00e40633741d55732d00cca9db60f681
       size: 1862GiB (1999GB)
       capabilities: gpt-1.00 partitioned partitioned:gpt
       configuration: ansiversion=5 guid=0e02c66a-1560-43c7-a161-a96097590323 logicalsectorsize=512 sectorsize=512
  *-disk
       description: SCSI Disk
       product: Internal Dual SD
       vendor: Dell
       physical id: 0.0.0
       bus info: scsi@7:0.0.0
       logical name: /dev/sdb
       version: 1.:
       serial: 0123456789AB
       size: 1946MiB (2040MB)
       capabilities: partitioned partitioned:dos
       configuration: ansiversion=5 logicalsectorsize=512 sectorsize=512 signature=75e8b820
  *-cdrom
       description: DVD reader
       product: DVD-ROM DU70N
       vendor: HL-DT-ST
       physical id: 0.0.0
       bus info: scsi@5:0.0.0
       logical name: /dev/cdrom
       logical name: /dev/sr0
       version: D300
       capabilities: removable audio dvd
       configuration: ansiversion=5 status=nodisc
```

micro13

```bash
sudo lshw -C disk
[sudo] password for brent: 
  *-disk                    
       description: SCSI Disk
       product: PERC H710
       vendor: DELL
       physical id: 2.0.0
       bus info: scsi@0:2.0.0
       logical name: /dev/sda
       version: 3.13
       serial: 00d00ffe6bdb0d732d0001aadb60f681
       size: 1862GiB (1999GB)
       capabilities: gpt-1.00 partitioned partitioned:gpt
       configuration: ansiversion=5 guid=4cffc696-e610-4366-b2d5-97913a0d2cdc logicalsectorsize=512 sectorsize=512
  *-disk
       description: SCSI Disk
       product: Internal Dual SD
       vendor: Dell
       physical id: 0.0.0
       bus info: scsi@7:0.0.0
       logical name: /dev/sdb
       version: 1.:
       serial: 0123456789AB
       size: 1946MiB (2040MB)
       configuration: ansiversion=5 logicalsectorsize=512 sectorsize=512 signature=efd4cafd
  *-cdrom
       description: DVD reader
       product: DVD-ROM DU70N
       vendor: HL-DT-ST
       physical id: 0.0.0
       bus info: scsi@5:0.0.0
       logical name: /dev/cdrom
       logical name: /dev/sr0
       version: D300
       capabilities: removable audio dvd
       configuration: ansiversion=5 status=nodisc
```
