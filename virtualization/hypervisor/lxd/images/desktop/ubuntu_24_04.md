# ubuntu 24.04 desktop

```bash
lxc launch images:ubuntu/noble/desktop v1 --vm
Fingerprints
ea6fa1ef943b (Virtual Machine)
Aliases
ubuntu/noble/desktop
ubuntu/24.04/desktop
Requirements
cgroup=v2
```

| Filename                        | Date (UTC)         | Size      |
|---------------------------------|--------------------|-----------|
| SHA256SUMS                      | 2025-07-23 (01:48) | 402 B     |
| disk.20250721_0002.qcow2.vcdiff | 2025-07-23 (00:02) | 529.78 MB |
| disk.qcow2                      | 2025-07-23 (00:02) | 1.20 GB   |
| image.yaml                      | 2025-07-23 (00:15) | 26.96 kB  |
| lxd.tar.xz                      | 2025-07-23 (00:02) | 1.21 kB   |
| serial                          | 2025-07-23 (00:15) | 14 B      |

## notes

The default username and password for a freshly created Ubuntu LXC container is ubuntu for both the username and password. However, cloud-init, a process that runs after the initial boot, is responsible for setting up the default user and may require you to set a new password after the first login, according to Raspberry Pi Forums.
Here's how you can access and potentially change the password:

1. Accessing the container:
Use the lxc exec <container_name> -- bash command to open a shell within the container.
2. Setting a password:
If the default password doesn't work, you can use the passwd ubuntu command within the container's shell to change the password.
3. Default user:
The default user is usually ubuntu, but you can check by using the command id in the container's shell.
4. Root access:
If you need root access, you can use sudo su or the lxc exec <container_name> -- sudo su command within the container's shell.
