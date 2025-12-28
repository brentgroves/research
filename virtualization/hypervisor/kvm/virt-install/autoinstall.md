# **[How to use Autoinstall from Ubuntu 20.04 with virt-install command?](https://askubuntu.com/questions/1319896/how-to-use-autoinstall-from-ubuntu-20-04-with-virt-install-command)**

## **[50-cloud-init](https://ubuntuforums.org/showthread.php?t=2492108)**

## references

**[auto-install](https://askubuntu.com/questions/1319896/how-to-use-autoinstall-from-ubuntu-20-04-with-virt-install-command)**

## question

5

I use Ubuntu 20.04 desktop as host to run different Linux VMs using KVM. The VMs are created in scripts using virt-install. This works well with CentOS VMs etc. Now I would like to install Ubuntu 20.04 VM using Autoinstall option. I have generated the Autoinstall file and use it now. Here is my current command:

```bash
virt-install --name ubuntu1 --vcpus 2 --memory 2048 --disk device=cdrom,path=./seed.iso --cdrom ~/images/ubuntu-20.04.2-live-server-amd64.iso --disk pool=default,size=10,bus=virtio --network network=br0 --os-variant ubuntu20.04
```