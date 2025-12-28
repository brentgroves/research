# virt-viewer remote to lxd vm

To connect to an LXD virtual machine remotely using virt-viewer, you need to first ensure virt-viewer is installed on your client machine and then use the lxc console --type=VGA command with the --type=VGA flag. This will launch the virt-viewer application, connecting it to the VM's VGA console.
This **[video](https://www.youtube.com/watch?v=dfh_9aGQ9rE&t=1259)** shows how to start a VM in LXD and connect to it using virt-viewer:

Here's a more detailed breakdown:

1. Install virt-viewer:
.
On your client machine (where you want to view the VM), install virt-viewer. On Debian/Ubuntu systems, this can be done with sudo apt install virt-viewer. On other systems, use the appropriate package manager.
2. Start the VM with VGA console:
.
When starting the LXD VM, ensure you specify the console type as VGA. For example: lxc start <vm_name> --console=VGA or lxc console --type=VGA <vm_name>.
3. Connect with virt-viewer:
.
LXD will automatically detect the VGA console and launch virt-viewer to display it. If it doesn't automatically start, you might need to adjust LXD configuration or restart the LXD daemon.
4. Optional SSH tunneling:
.
For remote connections, especially over the internet, you might want to tunnel the connection over SSH for security and performance reasons. You can achieve this by connecting to the LXD host via SSH and then using the lxc console --type=VGA <vm_name> command.
This video demonstrates how to manage LXD VMs remotely using the LXC CLI, including switching remotes:

**[remote management](https://www.youtube.com/watch?v=05Fu3iGEQhI&t=919)**
