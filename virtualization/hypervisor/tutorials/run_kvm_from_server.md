# **[How to run KVM from a server](https://linuxconfig.org/how-to-use-bridged-networking-with-libvirt-and-kvm)**

**[Back to Research List](../../../../../research/research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

![cn](https://linuxconfig.org/wp-content/uploads/2021/03/00-how_to_use_bridged_networking_with_libvirt_and_kvm.avif)

## reference

- **[create vlan](https://www.baeldung.com/linux/vlans-create)**
- **[virt-install tutorial](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/virtualization_deployment_and_administration_guide/sect-guest_virtual_machine_installation_overview-creating_guests_with_virt_install)**
- **[create guests with virt-install](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/6/html/virtualization_host_configuration_and_guest_installation_guide/sect-virtualization_host_configuration_and_guest_installation_guide-guest_installation-creating_guests_with_virt_install)**

AI Overview

To run a KVM virtual machine from a server, you need to access the server via SSH, use the "virsh" command to interact with the KVM hypervisor, and execute the "start" command on the desired virtual machine name; essentially, you'll need to be on the server where the KVM is installed and use the command: "sudo virsh start <VM_NAME>" to start the VM, where <VM_NAME> is the name you assigned to your virtual machine when creating it. 

## **[reddit](https://www.reddit.com/r/selfhosted/comments/1469dos/how_to_run_kvm_vms_inside_a_headless_linux_server/)** 

use

virt-install
to create vms

and use

virsh
to start and stop them.