# **[How to Install Ubuntu 22.04 Virtual Machine on KVM](https://www.wpdiaries.com/ubuntu-on-kvm/)**

**[Back to Research List](../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../README.md)**

## references

**[Ubuntu docs](https://manpages.ubuntu.com/manpages/trusty/man1/virt-install.1.html)**
**[virtual machine manager](https://ubuntu.com/server/docs/virtual-machine-manager)**
**[install kvm on headless server](https://www.cyberciti.biz/faq/how-to-install-kvm-on-ubuntu-20-04-lts-headless-server/)**

We suppose you already have KVM installed. If not, please see this article on **[installing KVM first](https://www.wpdiaries.com/kvm-on-ubuntu/)**.

## Download the Ubuntu 24.04 Image

```bash
sudo su
cd /var/lib/libvirt/images
wget https://releases.ubuntu.com/noble/ubuntu-24.04.2-live-server-amd64.iso
```

Please notice: You’ll need 2 options for the virt-install command below: kernel and initrd.

To find them: Mount the downloaded iso image to a directory:

```bash
mount /var/lib/libvirt/images/ubuntu-24.04.2-live-server-amd64.iso /mnt
```

and then check the contents of the directory /mnt.

- You’ll see the file casper/vmlinuz. You’ll need it in the kernel option of the command virt-install in section 2.
- And there’ll be a file casper/initrd. You’ll need it in the initrd option in section 2.

Write down the paths/names of these 2 files.

```bash
ls /mnt/casper/initrd 
/mnt/casper/initrd
ls /mnt/casper/initrd
/mnt/casper/initrd
```

Now you can unmount your mount point:

```bash
umount /mnt
```

## Create the Virtual Machine

Run in the terminal:

```bash
sudo su
ip link add name br0 type bridge
ip link set br0 up
ip -c -br link show

ip -c -br link show type bridge
br-2c4c88ba5dfd  DOWN           02:42:ff:bd:27:1c <NO-CARRIER,BROADCAST,MULTICAST,UP> 
docker0          DOWN           02:42:7f:e9:b2:91 <NO-CARRIER,BROADCAST,MULTICAST,UP> 
br0              DOWN           ba:ea:cb:63:00:4a <BROADCAST,MULTICAST> 
ip link set dev en01 master br0
ip link set dev vth1 up

nmap -sP 192.168.1.0/24
Starting Nmap 7.95 ( https://nmap.org ) at 2025-02-22 17:19 EST
Nmap scan report for router.home (192.168.1.1)
Host is up (0.00067s latency).
Nmap scan report for moto (192.168.1.60)
Host is up (0.00040s latency).
Nmap scan report for k8sgw1 (192.168.1.65)
Host is up (0.00042s latency).
Nmap scan report for 192.168.1.165
Host is up (0.064s latency).
Nmap scan report for 192.168.1.168
Host is up (0.032s latency).
Nmap scan report for 43onnRokuTV.home (192.168.1.173)
Host is up (0.0017s latency).
Nmap scan report for users-airport-extreme.home (192.168.1.205)
Host is up (0.0025s latency).
Nmap scan report for 32HisenseRokuTV.home (192.168.1.223)
Host is up (0.013s latency).
Nmap done: 256 IP addresses (8 hosts up) scanned in 2.65 seconds

https://computingforgeeks.com/install-kvm-virtualization-on-ubuntu-noble-numbat/
https://computingforgeeks.com/how-to-create-and-configure-bridge-networking-for-kvm-in-linux/

sudo virt-install \
--name ubuntu-jammy \
--vcpus 2 \
--ram 2048 \
--os-variant ubuntu22.04 \
--disk path=/var/lib/libvirt/images/ubuntu2204.qcow2,size=30 \
--location /var/lib/libvirt/images/ubuntu-22.04-live-server-amd64.iso,kernel=casper/vmlinuz,initrd=casper/initrd \
--console pty,target_type=serial \
--graphics none \
--extra-args 'console=ttyS0,115200n8' 

sudo virt-install \
--name ubuntu-jammy \
--vcpus 2 \
--ram 2048 \
--os-variant ubuntu22.04 \
--disk path=/var/lib/libvirt/images/ubuntu2404.qcow2,size=30 \
--location /var/lib/libvirt/images/ubuntu-24.04.2-live-server-amd64.iso,kernel=casper/vmlinuz,initrd=casper/initrd \
--console pty,target_type=serial \
--graphics none \
--extra-args 'console=ttyS0,115200n8' 

virt-install --name centos8-2 --memory 10240 --vcpus=2 --location=/tmp/rhel-server-7.6-x86_64-dvd.iso --network bridge=nm-bridge --graphics=none --extra-args console=ttyS0 -v
Using centos7.0 default --disk size=10


virt-install --name centos8-2 --memory 10240 --vcpus=2 --os-type=Linux --os-variant=centos7.0 --location=/tmp/rhel-server-7.6-x86_64-dvd.iso  --network network=default --graphics=vnc -v
Using centos7.0 default --disk size=10


./virt-install --debug --virt-type kvm --name ubuntu-noble --memory 4000 --disk size=100,path=/home/omajid/virt/noble.qcow2,format=qcow2 --graphics spice --location http://archive.ubuntu.com/ubuntu/dists/noble/main/installer-amd64/ --os-variant ubuntunoble --noautoconsole --wait

virt-install --name noble-template \
      --ram 16384 \
      --disk path=build/noble-seed.qcow2,format=qcow2,bus=virtio \
      --vcpus 2 \
      --os-variant ubuntu24.04 \
      --graphics none \
      --console pty,target_type=serial \
      --location /var/lib/libvirt/images/ubuntu-24.04.2-live-server-amd64.iso,kernel=casper/vmlinuz,initrd=casper/initrd \
      --network bridge=virbr0,model=virtio \
      --extra-args 'console=ttyS0,115200n8 serial'

virt-install --name noble-template \
      --ram 16384 \
       --disk size=20 \
      --vcpus 2 \
      --os-variant ubuntu24.04 \
      --graphics none \
      --console pty,target_type=serial \
      --location /var/lib/libvirt/images/ubuntu-24.04.2-live-server-amd64.iso,kernel=casper/vmlinuz,initrd=casper/initrd \
      --network bridge=virbr0,model=virtio \
      --extra-args 'console=ttyS0,115200n8 serial'
# did not find network
sudo virt-install --name vm61 \
--os-variant ubuntu24.04 \
--vcpus 1 \
--memory 2048 \
--location /var/lib/libvirt/images/ubuntu-24.04.2-live-server-amd64.iso,kernel=casper/vmlinuz,initrd=casper/initrd \
--network bridge=br0,model=virtio \
--disk size=20 \
--graphics none \
--extra-args='console=ttyS0,115200n8 --- console=ttyS0,115200n8' \
--debug


# use the default network
sudo virt-install --name vm66 \
--os-variant ubuntu24.04 \
--vcpus 1 \
--memory 2048 \
--location /var/lib/libvirt/images/ubuntu-24.04.2-live-server-amd64.iso,kernel=casper/vmlinuz,initrd=casper/initrd \
--network default,model=virtio \
--disk size=20 \
--graphics none \
--extra-args='console=ttyS0,115200n8 --- console=ttyS0,115200n8' \
--debug

use ip 192.168.1.66
```

Initrd stands for "initial RAM disk". It's a temporary file system that's loaded into memory during the boot process of a Linux system. The initrd is used to prepare for the real root file system to mount.

, where

```bash
--name – is the name of the virtual machine (VM).
(normally I name VMs after their static IP addresses. So the name vm61 will correspond to the IP 192.168.1.61)
--vcpus – number of vCPUs
--memory – RAM allocated to the VM
--location – path to the local .iso file (or a distro install URL). Also, we set kernel and initrd here (we got values for them in section 1).
--disk – hard disk allocated to the VM (20GB in our case).
--extra-args – extra arguments. In our case, we are setting the console configuration. But, for example, you can configure a static IP for the VM with this.
--debug – debugging information will be output during the installation. Remove this option if you do not need it.
--os-variant – is an operating system installed on the VM. For the full list of supported values, run:
virt-install --osinfo list
Or you could get more information like this ( but it would require installing an additional package libosinfo-bin):

apt install libosinfo-bin
osinfo-query os
```

**[source](https://www.golinuxcloud.com/virt-install-examples-kvm-virt-commands-linux/)**

For detailed help on virt-install run:

`man virt-install`

or you could see it **[online here](https://manpages.ubuntu.com/manpages/jammy/man1/virt-install.1.html)**.

For brief help run:

`virt-install -h`

Also, you could find this discussion on virt-install usage useful.

After you’ve started virt-install, it could be that the installer will not be able to configure the network automatically.

In my case: I was on the network 192.168.1.0/24. My router (=gateway) IP was 192.168.1.1. And I wanted my VM to have the static IP 192.168.1.61.

So when I was asked to configure the network, I entered those details manually:

![n](https://www.wpdiaries.com/wp-content/uploads/2022/11/ubuntu-22-04-network-configuration.png)

Also, I’ve chosen to install the OpenSSH server during the installation:

![ss](https://www.wpdiaries.com/wp-content/uploads/2022/11/ubuntu-22-04-install-openssh-server.png)

If you are installing the virtual machine on KVM which is, in turn, running on VirtualBox with nested virtualization, the installation process could take pretty long (it took more than 1 hour for me).

Later, you’ll be able to edit the virtual machine’s initial configuration parameters with

sudo virsh edit vm61
(replace vm61 with your virtual machine name)

If your virtual machine was shut down, you can start it with

virsh start vm61 --console
Right after the installation, the file /etc/netplan/00-installer-config.yaml on the my nested virtual machine (vm61) looked like this:
