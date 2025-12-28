# **[Tap networking](https://docs.windriver.com/bundle/Wind_River_Linux_Open_Virtualization_Features_Guide_LTS_1/page/evf1537990866354.html)**

TAP networking is the recommended way to provide a virtual machine with access to the host and to external networks.

## About This Task

This procedure adds a TAP network backend to the basic launch workflow described in Launching a Virtual Machine.

The following host network elements interact with each other when using the TAP network backend:

A bridge to which network interfaces of different kinds can be attached
This example uses the default bridge virbr0.

## Host network interfaces such as eth0

When attached to the bridge, these interfaces provide access to host network resources for all virtual interfaces that are also attached.

## QEMU TAP network interfaces

These interfaces are created by the TAP network backend when the virtual machine is instantiated. You can think of these interfaces as the counterparts on the host to the virtual network devices inside the virtual machines. For all practical purposes TAP network interfaces behave like regular host network interfaces. When attached to the bridge they can exchange network packets with any other network interface, real or virtual.

## Before You Begin

You have deployed a host image to a hardware target system as described in Booting the Host System to Launch Guest Images.

## Procedure

On the host, create a QEMU configuration file to bring QEMU TAP network interfaces up.
Every instance of a TAP network backend creates a TAP network interface on the host. QEMU automatically invokes the /etc/qemu-ifup script before the virtual machine is instantiated. The script is expected to set up the newly created TAP interface in whatever mode is necessary to implement the desired network profile for the virtual machine.

The script is invoked by passing the name of the TAP interface as its sole parameter, typically tap0 for the first interface. In this example, the TAP interface is started in promiscuous mode so that it captures all traffic flowing through any network to which the interface is attached. The interface is then attached to the bridge virbr0.

Create the configuration file with the following content.

```bash
# cat /etc/qemu-ifup
#!/bin/sh
ifconfig $1 0.0.0.0 promisc up
brctl addif virbr0 $1
```

Make it executable.

```bash
# chmod +x /etc/qemu-ifup
```

The script must be executable, or otherwise launching the virtual machine will fail.

Optional: Configuring multiple TAP interfaces
When working with multiple TAP interfaces, as in the case of a virtual machine with multiple network devices, you will need to add some logic to the script to do what is appropriate for each interface. Alternatively you can specify the script to be used for each TAP network backend by adding it to the -netdev option of the qemu command. Here is an example:

-netdev tap,id=vm0,script=/etc/qemu-ifup

On the host, create a QEMU configuration file to bring QEMU TAP network interfaces down

```bash
# cat /etc/qemu-ifdown
#!/bin/sh
brctl delif virbr0 $1

# chmod +x /etc/qemu-ifdown
```

The script /etc/qemu-ifdown is invoked automatically by QEMU after the virtual machine is destroyed. It is expected to reverse the setup previously performed by the /etc/qemu-ifup script. In this example, the script removes the TAP interface from the bridge. The interface is turned down automatically by QEMU.

You can specify a different script to be used for each TAP network backend, for example:

-netdev tap,id=vm0,downscript=/etc/qemu-ifdown
Once the commands complete, the script is created and executable.

On the host, launch the virtual machine specifying the virtual device and network backend pair.

```bash
# taskset -c 2,3 /usr/bin/qemu-system-x86_64 \
-enable-kvm \
-m 512 \
-realtime mlock=on \
-smp 2 \
-name rt,process=rt-kvm \
-no-reboot \
-nographic \
-append "root=/dev/vda console=ttyS0,115200" \
-vcpu 0,affinity=0x4,prio=0 \
-vcpu 1,affinity=0x8,prio=80 \
-kernel /opt/windriver/bzImage-qemux86-64.bin \
-drive file=/opt/windriver/wrlinux-image-ovp-guest-qemux86-64.ext4,if=virtio \
-device e1000,netdev=vm0 \
-netdev tap,id=vm0,script=/etc/qemu-ifup,downscript=/etc/qemu-ifdown
```

The last two options specify the virtual device, an Intel e1000 Ethernet adapter, and a TAP network backend instance with vm0 as the ID. You can use other devices, such as the virtio network interface, as follows:

-device virtio-net-pci,netdev=vm0
The virtual network device is ready for configuration from within the virtual machine. The network backend is ready.

Log in to the virtual machine using the user name root and password root.
On the virtual machine, configure the network interface.

```bash
# cat /etc/systemd/network/20-wired.network
[Match]
Name=eth*

[Network]
Address=192.168.122.10/24
Gateway=192.168.122.1 

# systemctl restart systemd-networkd

# ip route
default via 192.168.122.1 dev eth0
192.168.122.0/24 dev eth0 src 192.168.122.10
```

Note that unlike the User Mode network backend, there are no DHCP or DNS services provided to the virtual machine by default. As it is, these services are only available from the host.

The virtual interface is now up and running and can be used by the applications in the user space of the virtual machine. A default gateway is available through which any other network can be reached provided the host allows this.

On the host, verify routing between the host and the virtual machine.

```bash
# ip route
default via 128.224.140.1 dev eth0 
128.224.140.0/23 dev eth0  proto kernel  scope link  src 128.224.140.198 
192.168.122.0/24 dev virbr0  proto kernel  scope link  src 192.168.122.1 
```

In this example, the host enables routing between the native host network 128.224.140.0/23 and the bridge at 192.168.122.0/24. This means that the host can ping the virtual machine and the virtual machine can ping the host. The virtual machine has also access to any external networks to which the host also has access.
