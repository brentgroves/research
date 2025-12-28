# **[SUSE Enterprise Storage Driver for Windows](https://www.suse.com/betaprogram/suse-enterprise-storage-windows-driver-beta/)**

## Ceph in a Windows World

We are bringing a new block driver (WNBD) and Ceph CLI tools to Microsoft Windows Server 2016 and 2019 platforms. These tools provide native connectivity to SUSE Enterprise Storage clusters version 6 and 7. This native I/O model may increase performance, and eliminate the complexities and single points of failure commonly associated with the iSCSI and Samba gateway configurations. Ceph is a highly-resilient software-defined-storage offering, which has only been available to Microsoft Windows environments through the use of iSCSI or CIFS gateways. This gateway architecture introduces a single point of contact and limits fault-tolerance and bandwidth, in comparison to the native I/O paths of Ceph with RADOS. In order to bring the benefits of native Ceph to Microsoft Windows environments, SUSE partnered with Cloudbase Solutions to port Ceph to the Microsoft Windows platform. This work is nearing completion, and provides the following functionality:

- RADOS Block Device (RBD)
- CephFS

This second beta of the SUSE Enterprise Storage Driver for Windows changes the device model from a strictly Network Block Device model, to an IOCTL based model which offers the following features:

- Significantly increased performance
- Improved stability
- Extensibility through upper and lower level APIs

These improvements include a new libwnbd.dll, and changes to some command line tools. The most significant is a renaming of 'rbd-nbd.exe' to 'rbd-wnbd.exe'. Corresponding registry entries have also been renamed to include 'wnbd'.

Please check out our **[Ceph Windows Guide](https://susedoc.github.io/doc-ses/master/single-html/ses-windows/)** documentation, to learn how to install and beta test it! And download our Ceph CLI tools and driver from here.

**[beta program](https://www.suse.com/betaprogram/#windows)**
