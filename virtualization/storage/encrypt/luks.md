# **[How To Linux Hard Disk Encryption With LUKS](https://www.cyberciti.biz/security/howto-linux-hard-disk-encryption-with-luks-cryptsetup-command/)**

How To Linux Hard Disk Encryption With LUKS [ cryptsetup encrypt command ]
Author: Vivek Gite Last updated: July 20, 2024 54 comments
Dear nixCraft,
    I carry my Linux powered laptop just about everywhere. How do I protect my private data stored on partition or removable storage media against bare-metal attacks where anyone can get their hands on my laptop or usb pen drive while traveling?
–Sincerely,
Worried about my data.

## Linux Hard Disk Encryption

That’s actually a great question. Many enterprises, small businesses, and government users need to encrypt their laptops to protect confidential information such as customer details, files, contact information, and much more. Linux supports the following cryptographic techniques to protect a hard disk, directory, and partition. All data that is written on any one of the following techniques will automatically encrypted and decrypted on the fly.

## Linux encryption methods

There are two methods to encrypt your data:

## Filesystem stacked level encryption

- **[eCryptfs](https://launchpad.net/ecryptfs)** – It is a cryptographic stacked Linux filesystem. eCryptfs stores cryptographic metadata in the header of each file written, so that encrypted files can be copied between hosts; the file will be decrypted with the proper key in the Linux kernel keyring. This solution is widely used, as the basis for Ubuntu’s Encrypted Home Directory, natively within Google’s ChromeOS, and transparently embedded in several network attached storage (NAS) devices.
- **[EncFS](http://www.arg0.net/encfs)** - It provides an encrypted filesystem in user-space. It runs without any special permissions and uses the **[FUSE library](https://www.kernel.org/doc/html/next/filesystems/fuse.html)** and Linux kernel module to provide the filesystem interface. You can find links to source and binary releases below. EncFS is open source software, licensed under the GPL.

## Block device level encryption

- **[Loop-AES](https://sourceforge.net/projects/loop-aes/)** – Fast and transparent file system and swap encryption package for linux. No source code changes to linux kernel. Works with 3.x, 2.6, 2.4, 2.2 and 2.0 kernels.
- **[VeraCrypt](https://www.veracrypt.fr/)** – It is free open-source disk encryption software for Windows 7/Vista/XP, Mac OS X and Linux based on TrueCrypt codebase.
- **[dm-crypt+LUKS](https://gitlab.com/cryptsetup/cryptsetup)** – dm-crypt is a transparent disk encryption subsystem in Linux kernel v2.6+ and later and DragonFly BSD. It can encrypt whole disks, removable media, partitions, software RAID volumes, logical volumes, and files.

In this tutorial, I will explain how to encrypt your partitions using Linux Unified Key Setup-on-disk-format (LUKS) on your Linux based computer or laptop.

## Step 1: Install cryptsetup utility on Linux

You need to install the following package. It contains cryptsetup, a utility for setting up encrypted filesystems using Device Mapper and the dm-crypt target. Debian / Ubuntu Linux user type the following apt-get command or apt command:

`apt install cryptsetup`

## Step 2: Configure LUKS partition

WARNING! The following command will remove all data on the partition that you are encrypting. You WILL lose all your information! So make sure you backup your data to an external source such as NAS or hard disk before typing any one of the following command. The nixCraft or author is not responsible for data loss.
Open the terminal to **[list all Linux partitions/disks](https://www.cyberciti.biz/faq/linux-list-disk-partitions-command/)** and then use the cryptsetup command:

`fdisk -l`

The syntax is:
cryptsetup luksFormat --type luks1 /dev/DEVICE
cryptsetup luksFormat --type luks2 /dev/DEVICE

In this example, I’m going to encrypt /dev/xvdc. Type the following command:
`cryptsetup -y -v luksFormat /dev/xvdc`

Sample outputs:

```bash
WARNING
========

This will overwrite data on /dev/xvdc irrevocably.

Are you sure? (Type uppercase yes): YES
Enter LUKS passphrase:
Verify passphrase:
Command successful.
```

For example, set up cryptsetup on /dev/sdc with luks2 format, run:
`cryptsetup -y -v --type luks2 luksFormat /dev/sdc`

This command initializes the volume, and sets an initial key or passphrase. Please note that the passphrase is not recoverable so do not forget it.Type the following command create a mapping for the /dev/xvdc:

```bash
cryptsetup luksOpen /dev/xvdc backup2

Sample outputs:

Enter passphrase for /dev/xvdc:
```

You can see a mapping name /dev/mapper/backup2 after successful verification of the supplied key material which was created with luksFormat command extension:

```bash
ls -l /dev/mapper/backup2
# Sample outputs:

lrwxrwxrwx 1 root root 7 Oct 19 19:37 /dev/mapper/backup2 -> ../dm-0
```

You can use the following command to see the status for the mapping:

```bash
cryptsetup -v status backup2

/dev/mapper/backup2 is active.
  type:    LUKS1
  cipher:  aes-cbc-essiv:sha256
  keysize: 256 bits
  device:  /dev/xvdc
  offset:  4096 sectors
  size:    419426304 sectors
  mode:    read/write
Command successful.
```

You can dump LUKS headers using the following command:

```bash
cryptsetup luksDump /dev/xvdc
# Sample outputs:

LUKS header information for /dev/xvdc
 
Version:        1
Cipher name:    aes
Cipher mode:    xts-plain64
Hash spec:      sha256
Payload offset: 4096
MK bits:        256
MK digest:      21 07 68 54 77 96 11 34 f2 ec 17 e9 85 8a 12 c3 1f 3e cf 5f 
MK salt:        8c a6 3d 8c e9 de 16 fb 07 fd 8e d3 72 d7 db 94 
                7e e0 75 f9 e0 23 24 df 50 26 fb 92 f8 b5 dd 70 
MK iterations:  222000
UUID:           4dd563a9-5bff-4fea-b51d-b4124f7185d1
 
Key Slot 0: ENABLED
 Iterations:          2245613
 Salt:                05 a8 b4 a2 54 f7 c6 ee 52 db 60 b6 12 7f 2f 53 
                        3f 5d 2d 62 fb 5a b1 c3 52 da d5 5f 7b 2d 38 32 
 Key material offset: 8
 AF stripes:             4000
Key Slot 1: DISABLED
Key Slot 2: DISABLED
Key Slot 3: DISABLED
Key Slot 4: DISABLED
Key Slot 5: DISABLED
Key Slot 6: DISABLED
Key Slot 7: DISABLED
```

You can also pass the **[status=progress option to the dd command](https://www.cyberciti.biz/faq/linux-unix-dd-command-show-progress-while-coping/)**:

```bash
dd if=/dev/zero of=/dev/mapper/backup2 status=progress

# Sample outputs:

2133934592 bytes (2.1 GB, 2.0 GiB) copied, 142 s, 15.0 MB/s
```

Next, create a filesystem i.e. format filesystem, enter:

```bash
mkfs.ext4 /dev/mapper/backup2

# Sample outputs:

mke2fs 1.42.13 (17-May-2015)
Creating filesystem with 52428288 4k blocks and 13107200 inodes
Filesystem UUID: 1c71b0f4-f95d-46d6-93e0-cbd19cb95edb
Superblock backups stored on blocks:
 32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
 4096000, 7962624, 11239424, 20480000, 23887872

Allocating group tables: done
Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done
```

To mount the new filesystem at /backup2, enter:

```bash
mkdir /backup2
mount /dev/mapper/backup2 /backup2
df -H
cd /backup2
ls -l
```

A sample session for /dev/sdc

![i1](https://www.cyberciti.biz/media/new/cms/2012/10/Linux-Hard-Disk-Encryption-Demo.png)
