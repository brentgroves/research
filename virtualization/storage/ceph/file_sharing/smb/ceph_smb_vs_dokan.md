# **[](https://docs.ceph.com/en/reef/install/windows-install/)**

Installing Ceph on Windows
The Ceph client tools and libraries can be natively used on Windows. This avoids the need for additional layers such as iSCSI gateways or SMB shares, drastically improving the performance.

Prerequisites
Supported platforms
Note

Please see the OS recommendations regarding client package support.

Windows Server 2019 and Windows Server 2016 are supported. Previous Windows Server versions, including Windows client versions such as Windows 10, might work but haven’t been tested.

Windows Server 2016 does not provide Unix sockets, in which case some commands might be unavailable.

Secure boot
The WNBD driver hasn’t been signed by Microsoft, which means that Secure Boot must be disabled.

Dokany
In order to mount Ceph filesystems, ceph-dokan requires Dokany to be installed. You may fetch the installer as well as the source code from the Dokany GitHub repository: <https://github.com/dokan-dev/dokany/releases>

Make sure to install Dokany 2.0.5 or later.

Unlike WNBD, Dokany isn’t included in the Ceph MSI installer.

MSI installer
Using the MSI installer is the recommended way of installing Ceph on Windows. It can be downloaded from here: <https://cloudbase.it/ceph-for-windows/>

As mentioned earlier, the Ceph installer does not include Dokany, which has to be installed separately.

A server reboot is required after uninstalling the driver, otherwise subsequent install attempts may fail.

The following project allows building the MSI installer: <https://github.com/cloudbase/ceph-windows-installer>. It can either use prebuilt Ceph and WNBD binaries or compile them from scratch.

Manual installation
The following document describes the build process and manual installation: <https://github.com/ceph/ceph/blob/master/README.windows.rst>

Configuration
Please check the Windows configuration sample to get started.

You’ll also need a keyring file. The General CephFS Prerequisites page provides a simple example, showing how a new CephX user can be created and how its secret key can be retrieved.

For more details on CephX user management, see the Client Authentication and User Management.

## AI

Ceph SMB is a feature for providing network access to CephFS using the Samba server, while Ceph Dokan is a native Windows client that uses the Dokan library to mount CephFS directly on Windows machines. Ceph SMB allows Windows clients to access CephFS via a familiar SMB/CIFS network protocol, whereas Ceph Dokan provides a direct, FUSE-like interface to CephFS on the Windows host itself, requiring no external Samba server

Ceph SMB
Purpose:
To allow traditional Windows clients to access files on CephFS using the standard SMB/CIFS protocol.
How it works:
A new Ceph Manager (MGR) module called "SMB Manager" deploys and manages Samba services within the Ceph cluster, providing SMB access to CephFS.
Management:
Managed through imperative commands (e.g., ceph smb cluster create) or declarative methods (using YAML/JSON resources), similar to the NFS manager module.
Benefits:
Seamless integration with existing Windows environments and Active Directory, allowing for native SMB file sharing.
Limitations:
Supports SMB2 and SMB3 protocols, not SMB1/CIFS. Domain membership requires proper DNS configuration.
Ceph Dokan
Purpose:
To act as a native Windows client for CephFS, mounting the filesystem directly on a Windows machine.
How it works:
Uses the Dokan (Disk Application Kernel) library, which implements a FUSE-like interface on Windows, enabling the direct mounting of CephFS.
Management:
Installed as a Windows client and used for direct mounting of CephFS, not a server-side Ceph component.
Benefits:
Provides direct access to CephFS from Windows without relying on external servers or network protocols.
Limitations:
Does not provide a service command for surviving host reboots, requiring NSSM for automatic startup after a reboot. Windows ACLs are not fully supported, and it cannot handle mandatory file locks, which Windows heavily relies on.
