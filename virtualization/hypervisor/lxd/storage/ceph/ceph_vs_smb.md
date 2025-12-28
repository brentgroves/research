Nutanix AHV utilizes paravirtualized devices, specifically virtio-scsi for storage and virtio-net for networking, to enhance VM performance.

lxd hypervisor uses pools which are the bytes, and volumes. It doesn't use storage container like nutanix

usually the host shares a volume with the VM or containers. what happens when you share the same volume with 2 vms?

You don't add the same host block device or remote filesystem volume to multiple VM/containers.

But since you want to examine/change the volume data in Ubuntu and then use it in Windows this may be just what you want.

You could also share the folder from Windows and mount it in Ubuntu.

To mount a Windows share on Ubuntu, you'll need to install the cifs-utils package, create a mount point (a directory to access the share), and then use the mount command with appropriate options, including the Windows server's IP address, share name, username, and password. You can also configure persistent mounting by editing the /etc/fstab file.

I do this.  It's just like mounting a share from any other Windows machine.

This is an SMB share. Windows file shares allow users to access folders and files on other computers over a network using the Server Message Block (SMB) protocol. To share a folder, you must first make it a network share, set permissions for who can access it, and then connect to it from other computers on the network.

Although if you mount an SMB share you will need to supply your credentials and may still not be able to see the content you were restricted from seeing.
