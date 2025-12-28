<https://www.youtube.com/watch?v=At1i4vBUsSw>

Goal: out perform iSCSI gateway

Ceph RADOS, RBD and CephFS have been ported on Microsoft Windows, a community effort led by SUSE and Cloudbase Solutions. The goal consisted in porting librados and librdb on Windows Server, providing a kernel driver for exposing RBD devices natively as Windows volumes, support for Hyper-V VMs and last but not least, even CephFS.

During this session we will talk about the architectural differences between Windows and Linux from a storage standpoint and how we retained the same CLI so that long time Ceph users will feel at home regardless of the underlying operating system.

Performance is a key aspect of this porting, with Ceph on Windows significantly outperforming the iSCSI gateway, previously the main option for accessing RBD images from Windows nodes. There will be no lack of live demos, including automating the installation of the Windows binaries, setting up and managing a Ceph cluster across Windows and Linux nodes, spinning up Hyper-V VMs from RBD, and CephFS.

Speakers:
Alessandro Pilotti

Thank you to the Sponsors of the OpenInfra Summit Berlin 2022!

Connect with us:
OpenInfra Twitter:   / openinfradev  
OpenInfra LinkedIn:   / open-infrastructure-foundation  
OpenInfra Facebook:   / openinfradev  
OpenInfra Foundation Website: <https://openinfra.dev/>

# OpenInfra #OpenInfraSummit #OpenStack #OpenSource
