# **[Mount CephFS on Windows](https://docs.ceph.com/en/latest/cephfs/ceph-dokan/#mount-cephfs-on-windows)**

## references

- **[](https://docs.ceph.com/en/latest/cephadm/services/smb/#smb-service)**
- **[](https://www.samba.org/samba/docs/current/man-html/vfs_ceph.8.html)**

## AI: how to mount cephfs on windows

To mount a CephFS share on a Windows machine, you need to use the ceph-dokan utility, which requires the Dokany library to be installed. First, install Dokany and then use ceph-dokan with the appropriate configuration and authentication details to mount the CephFS share.
Here's a step-by-step guide:

1. Install Dokany:
.
Download and install the latest version of Dokany from the Dokany GitHub repository. Ensure you install version 2.0.5 or later.
2. Install Ceph on Windows:
.
Download and run the Ceph MSI installer from Cloudbase Solutions. This installer includes ceph-dokan.exe. The installer does not include Dokany, so it must be installed separately.
3. Prepare Ceph Configuration and Keyring:
.
You will need a Ceph configuration file (ceph.conf) and a CephX user keyring with permissions to access the Ceph Metadata Server (MDS). You can generate a minimal ceph.conf using the following commands:
Code

   mkdir -p -m 755 /etc/ceph
   ssh user@mon-host "sudo ceph config generate-minimal-conf" | sudo tee /etc/ceph/ceph.conf

Replace user with your username and mon-host with the monitor's hostname or IP address.
You can copy the keyring from the Ceph MON host or create a new one for the client.
Mount the CephFS share:
Open a PowerShell window as an administrator.
Navigate to the ceph-dokan.exe directory (usually C:\Program Files\Ceph\bin).
Construct the mount command. You'll need the following information:
Config file path (e.g., C:\ProgramData\ceph\ceph.conf)
Keyring file path (e.g., C:\ProgramData\ceph\keyring.txt)
Client name (e.g., client.admin)
CephFS path (e.g., /)
Local mount point (e.g., C:\CephFS)
The command will look similar to this:
Code

.\ceph-dokan.exe -l C:\CephFS -n client.admin --keyring C:\ProgramData\ceph\keyring.txt -x /

This command mounts the root of the CephFS ( / ) to the local directory C:\CephFS. You can specify a different path within CephFS to mount.
Automate Mounting on Boot (Optional):
Download and install NSSM (Non-Sucking Service Manager).
Place nssm.exe in C:\Windows\System32.
Open PowerShell as an administrator and run nssm install cephmount.
In the NSSM GUI, set the following:
Application Path: C:\Program Files\Ceph\bin\ceph-dokan.exe
Startup directory: C:\Program Files\Ceph\bin
Arguments: -l x (or your desired mount point)
In the Task Scheduler, create a new task with a trigger set to "At system startup" and an action to nssm start cephmount.

Important Notes:
Windows ACLs are ignored when mounting CephFS, and mandatory file locks are not supported.
ceph-dokan does not currently offer a service command, so NSSM is needed to automate mounting on boot.
You can use the -n option to specify the Ceph client name and the -x option to specify the CephFS path to mount.
If your Ceph configuration file is in the default location ( %ProgramData%\ceph\ceph.conf ), you can omit the -c argument.

## **[Mount CephFS on Windows](https://docs.ceph.com/en/latest/cephfs/ceph-dokan/#mount-cephfs-on-windows)**

The Samba software suite is a collection of programs that implements the Server Message Block (commonly abbreviated as SMB) protocol for UNIX systems and provides Active Directory services. The first version of the SMB protocol is sometimes also referred to as the Common Internet File System (CIFS). For a more thorough description, see <http://www.ubiqx.org/cifs/>. Samba also implements the NetBIOS protocol in nmbd.

ceph-dokan can be used for mounting CephFS filesystems on Windows. It leverages Dokany, a Windows driver that allows implementing filesystems in userspace, pretty much like FUSE.

Please see the installation guide to get started.

Note

Please see the OS recommendations regarding client package support.

Usage
Mounting filesystems
In order to mount a ceph filesystem, the following command can be used:

ceph-dokan.exe -c c:\ceph.conf -l x

This will mount the default ceph filesystem using the drive letter x. If ceph.conf is placed at the default location, which is %ProgramData%\ceph\ceph.conf, then this argument becomes optional.

The -l argument also allows using an empty folder as a mount point instead of a drive letter.

The uid and gid used for mounting the filesystem default to 0 and may be changed using the following ceph.conf options:

[client]

# client_permissions = true

client_mount_uid = 1000
client_mount_gid = 1000
If you have more than one FS on your Ceph cluster, use the option --client_fs to mount the non-default FS:

mkdir -Force C:\mnt\mycephfs2
ceph-dokan.exe --mountpoint C:\mnt\mycephfs2 --client_fs mycephfs2
CephFS subdirectories can be mounted using the --root-path parameter:

ceph-dokan -l y --root-path /a
If the -o --removable flags are set, the mounts will show up in the Get-Volume results:

PS C:\> Get-Volume -FriendlyName "Ceph*" | `
        Select-Object -Property @("DriveLetter", "Filesystem", "FilesystemLabel")

DriveLetter Filesystem FilesystemLabel
----------- ---------- ---------------
          Z Ceph       Ceph
          W Ceph       Ceph - new_fs
Please use ceph-dokan --help for a full list of arguments.

Credentials
The --id option passes the name of the CephX user whose keyring we intend to use for mounting CephFS. The following commands are equivalent:

ceph-dokan --id foo -l x
ceph-dokan --name client.foo -l x
Unmounting filesystems
The mount can be removed by either issuing ctrl-c or using the unmap command, like so:

ceph-dokan.exe unmap -l x
Note that when unmapping Ceph filesystems, the exact same mount point argument must be used as when the mapping was created.

Limitations
Be aware that Windows ACLs are ignored. Posix ACLs are supported but cannot be modified using the current CLI. In the future, we may add some command actions to change file ownership or permissions.

Another thing to note is that CephFS doesn’t support mandatory file locks, which Windows relies heavily upon. At present Ceph lets Dokan handle file locks, which are only enforced locally.

Unlike rbd-wnbd, ceph-dokan doesn’t currently provide a service command. In order for the cephfs mount to survive host reboots, consider using NSSM.
