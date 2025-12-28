# **[Installing Ceph on Windows](https://docs.ceph.com/en/reef/install/windows-install/)**

The Ceph client tools and libraries can be natively used on Windows. This avoids the need for additional layers such as iSCSI gateways or SMB shares, drastically improving the performance.

Windows Server 2019 and Windows Server 2016 are supported. Previous Windows Server versions, including Windows client versions such as Windows 10, might work but haven’t been tested.

Windows Server 2016 does not provide Unix sockets, in which case some commands might be unavailable.

## Ceph MS Windows Client

Ceph’s MS Windows native client support is “best effort”. There is no full-time maintainer. As of July 2025 there are no plans to remove this client but the future is uncertain.

## Secure boot

**[SUSU Enterprise Driver for Windows](https://www.suse.com/betaprogram/suse-enterprise-storage-windows-driver-beta/)**
The **[WNBD driver](https://github.com/cloudbase/wnbd)** hasn’t been **[signed CloudBase](https://docs.ceph.com/en/reef/install/windows-install)** but not by Microsoft, which means that Secure Boot must be disabled.

# **[](https://www.suse.com/betaprogram/suse-enterprise-storage-windows-driver-beta/)**

**[crashes](https://ask.cloudbase.it/question/3679/ceph-for-windows-driver-crashes/)**

## Dokany

In order to mount Ceph filesystems, ceph-dokan requires Dokany to be installed. You may fetch the installer as well as the source code from the Dokany GitHub repository: <https://github.com/dokan-dev/dokany/releases>

Make sure to install Dokany 2.0.5 or later.

Unlike WNBD, Dokany isn’t included in the Ceph MSI installer.

## MSI installer

Using the MSI installer is the recommended way of installing Ceph on Windows. It can be downloaded from here: <https://cloudbase.it/ceph-for-windows/>

As mentioned earlier, the Ceph installer does not include Dokany, which has to be installed separately.

A server reboot is required after uninstalling the driver, otherwise subsequent install attempts may fail.

The following project allows building the MSI installer: <https://github.com/cloudbase/ceph-windows-installer>. It can either use prebuilt Ceph and WNBD binaries or compile them from scratch.

## Manual installation

The following document describes the build process and manual installation: <https://github.com/ceph/ceph/blob/master/README.windows.rst>

Configuration
Please check the **[Windows configuration sample](https://docs.ceph.com/en/reef/install/windows-basic-config)** to get started.

You’ll also need a keyring file. The **[General CephFS Prerequisites](https://docs.ceph.com/en/reef/cephfs/mount-prerequisites)** page provides a simple example, showing how a new CephX user can be created and how its secret key can be retrieved.

For more details on CephX user management, see the **[Client Authentication](https://docs.ceph.com/en/reef/cephfs/client-auth)** and **[User Management](https://docs.ceph.com/en/reef/rados/operations/user-management/#user-management)**.

## Further reading

**[RBD Windows documentation](https://docs.ceph.com/en/reef/rbd/rbd-windows/)**

**[CephFS Windows documentation](https://docs.ceph.com/en/reef/cephfs/ceph-dokan)**

**[Windows troubleshooting](https://docs.ceph.com/en/reef/install/windows-troubleshooting)**
