# **[](https://documentation.ubuntu.com/lxd/stable-5.21/backup/)**

How to back up a LXD server
▶
Watch on YouTube
In a production setup, you should always back up the contents of your LXD server.

The LXD server contains a variety of different entities, and when choosing your backup strategy, you must decide which of these entities you want to back up and how frequently you want to save them.

What to back up
The various contents of your LXD server are located on your file system and, in addition, recorded in the LXD database. Therefore, only backing up the database or only backing up the files on disk does not give you a full functional backup.

Your LXD server contains the following entities:

Instances (database records and file systems)

Images (database records, image files, and file systems)

Networks (database records and state files)

Profiles (database records)

Storage volumes (database records and file systems)

Consider which of these you need to back up. For example, if you don’t use custom images, you don’t need to back up your images since they are available on the image server. If you use only the default profile, or only the standard lxdbr0 network bridge, you might not need to worry about backing them up, because they can easily be re-created.

Full backup
To create a full backup of all contents of your LXD server, back up the /var/snap/lxd/common/lxd (for snap users) or /var/lib/lxd (otherwise) directory.

This directory contains your local storage, the LXD database, and your configuration. It does not contain separate storage devices, however. That means that whether the directory also contains the data of your instances depends on the storage drivers that you use.

Important

If your LXD server uses any external storage (for example, LVM volume groups, ZFS zpools, or any other resource that isn’t directly self-contained to LXD), you must back this up separately.

See How to back up custom storage volumes for instructions.

To back up your data, create a tarball of /var/snap/lxd/common/lxd (for snap users) or /var/lib/lxd (otherwise). If you are not using the snap package and your source system has a /etc/subuid and /etc/subgid file, you should also back up these files. Restoring them avoids needless shifting of instance file systems.

To restore your data, complete the following steps:

Stop LXD on your server (for example, with sudo snap stop lxd).

Delete the directory (/var/snap/lxd/common/lxd for snap users or /var/lib/lxd otherwise).

Restore the directory from the backup.

Delete and restore any external storage devices.

If you are not using the snap, restore the /etc/subuid and /etc/subgid files.

Restart LXD (for example, with sudo snap start lxd or by restarting your machine).

Export a snapshot
If you are using the LXD snap, you can also create a full backup by exporting a snapshot of the snap:

Create a snapshot:

sudo snap save lxd
Note down the ID of the snapshot (shown in the Set column).

Export the snapshot to a file:

sudo snap export-snapshot <ID> <output_file>
See Snapshots in the Snapcraft documentation for details.

Partial backup
If you decide to only back up specific entities, you have different options for how to do this. You should consider doing some of these partial backups even if you are doing full backups in addition. It can be easier and safer to, for example, restore a single instance or reconfigure a profile than to restore the full LXD server.

Back up instances and volumes
Instances and storage volumes are backed up in a very similar way (because when backing up an instance, you basically back up its instance volume, see Storage volume types).

See How to back up instances and How to back up custom storage volumes for detailed information. The following sections give a brief summary of the options you have for backing up instances and volumes.

Secondary backup LXD server
LXD supports copying and moving instances and storage volumes between two hosts. See How to migrate LXD instances between servers and How to move or copy storage volumes for instructions.

So if you have a spare server, you can regularly copy your instances and storage volumes to that secondary server to back them up. Use the --refresh flag to update the copies (see Optimized volume transfer for the benefits).

If needed, you can either switch over to the secondary server or copy your instances or storage volumes back from it.

If you use the secondary server as a pure storage server, it doesn’t need to be as powerful as your main LXD server.
