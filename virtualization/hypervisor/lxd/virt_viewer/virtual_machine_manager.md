# **[](https://documentation.ubuntu.com/server/how-to/virtualisation/virtual-machine-manager/)**

Virtual Machine Manager
The Virtual Machine Manager, through the virt-manager package, provides a graphical user interface (GUI) for managing local and remote virtual machines. In addition to the virt-manager utility itself, the package also contains a collection of other helpful tools like virt-install, virt-clone and virt-viewer.

Install virt-manager
To install virt-manager, enter:

sudo apt install virt-manager
Since virt-manager requires a Graphical User Interface (GUI) environment we recommend installing it on a workstation or test machine instead of a production server. To connect to the local libvirt service, enter:

virt-manager
You can connect to the libvirt service running on another host by entering the following in a terminal prompt:

virt-manager -c qemu+ssh://virtnode1.mydomain.com/system
