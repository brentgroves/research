## fix suspended vm

## AI Overview

Learn more
To fix a suspended VM on Multipass, you can try starting it back up or, in some cases, deleting the suspended state or the VM itself. If the VM gets stuck in a suspended state, you can attempt to reset DHCP leases or even delete the VM and recreate it.
Here's a more detailed breakdown of the troubleshooting steps:

1. Try Starting the VM:
If the VM is in a suspended state, try starting it with the multipass start command.

```bash
multipass list
Name                    State             IPv4             Image
k8sn2                   Stopped           --               Ubuntu 24.04 LTS
k8sn211                 Suspended         --               Ubuntu 24.04 LTS
multipass start k8sn211

sudo ip link set dev mpqemubr0 up
sudo ip link set dev eth2 up

```

## 2. 9. Troubleshooting Multipass Logs

Check the Multipass logs for any errors or clues that might help you identify the cause of the problem.
The logs can be found in /var/log/multipassd.log.

## 2. Resetting DHCP Leases

If the VM is still stuck, you can try resetting DHCP leases. This can sometimes resolve issues related to networking and booting.

## 3. Deleting the Suspended State

In some cases, the suspension snapshot may be corrupted. You can try deleting it using the qemu-img snapshot command, followed by restarting the Multipass daemon.
For example: sudo /Library/Application Support/com.canonical.multipass/bin/qemu-img snapshot -d suspend "/var/root/Library/Application Support/multipassd/qemu/vault/instances/ubuntu-lts/ubuntu-22.04-server-cloudimg-arm64.img".
