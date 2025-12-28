# **[list images](https://www.cyberciti.biz/faq/how-to-list-vm-images-in-lxd-linux-containers/)**

## How to list VM images in LXD (Linux Containers)

Author: Vivek Gite Last updated: July 24, 2025 4 comments
Iam using LXD (“Linux Container”) a container “hypervisor” on Ubuntu Linux serer. How do I list all available VM images for installation in the LXD image store? Is it possible to list lxd images using lxc command line?

lxd is a system-wide daemon and lxd is a command line client to talk with the lxd daemon. So, you need to use the lxc command to list images in the LXD store. This page shows how to list VM images in LXD using the lxc.

How to list VM images in LXD
The syntax is:
`lxc image list images:`

You can use the grep command or more command as follows:

```bash
lxc image list images: | more
lxc image list images: | grep -i 'debian'
lxc image list images: | grep -i 'opensuse'
```

You can apply filter as follows to just show alpine Linux vm images:

```bash
lxc image list images: 'alpine'
lxc image list images: 'opensuse'
```

You can now create a VM as follows:

```bash
lxc launch images:alpine/3.17/amd64 alpine-www
lxc launch images:centos/7/amd64 cenots-db
lxc launch images:opensuse/15.4/amd64 opensuse-15-4
lxc list
```

How do I get a list of Linux distros?
Run the following combination of grep command/egrep command, awk command and sed command:

```bash
lxc image list images: |\
awk -F'|' '{ print $2}' |\
sed '/^[[:space:]]*$/d' |\
awk -F'/' '{ print $1"/"$2 }' | sort | uniq | grep -E -v 'more|ALIAS'
```

How to list images by architecture
Try passing the architecture={NAME} to lxc command:
lxc image list images: architecture=x86_64

## aarch64 (ARM)

```bash
lxc image list images: architecture=aarch64
lxc image list images: centos architecture=aarch64
```

Listing image type by container or virtual-machine
Run:
`lxc image list images: type=container`

OR
`lxc image list images: type=virtual-machine`

Here is how to see all VM images:
`lxc image list images: rocky type=virtual-machine`

## Getting help on image option

Type the following man command or help command:
`lxc image --help`

```bash
lxc image list --vm type=virtual-machine
lxc config showhttps://cloud-images.ubuntu.com/locator/
lxc config show v1
architecture: x86_64
config:
  image.architecture: amd64
  image.description: ubuntu 24.04 LTS amd64 (release) (20250805)
  image.label: release
  image.os: ubuntu
  image.release: noble
  image.serial: "20250805"
  image.type: disk1.img
  image.version: "24.04"
  volatile.base_image: 01cbaaaa4d04ae2433dc4402ab61a4d9638637888d4759397e4fb036aa98f85b
  volatile.cloud-init.instance-id: 6d5d7d69-dd4e-4c8f-9cbd-31ecc79f1bae
  volatile.eth0.host_name: tapa488186c
  volatile.eth0.hwaddr: 00:16:3e:cb:cb:fd
  volatile.last_state.power: RUNNING
  volatile.uuid: 2ac30e39-13bf-4a4c-8bfa-5f2a6d50f21d
  volatile.uuid.generation: 2ac30e39-13bf-4a4c-8bfa-5f2a6d50f21d
  volatile.vsock_id: "545730999"
devices: {}
ephemeral: false
profiles:
- default
stateful: false
description: ""

lxc image info <image_fingerprint_or_alias>

lxc image info aeed887e1eb5
Fingerprint: aeed887e1eb5d7df9f0ff4e2d80a3231f40c0abb8ef9ec4e547b94c2be0c88ab
Size: 1140.47MiB
Architecture: x86_64
Type: virtual-machine
Public: no
Timestamps:
    Created: 2025/07/24 00:02 UTC
    Uploaded: 2025/07/24 22:34 UTC
    Expires: never
    Last used: 2025/07/24 22:34 UTC
Properties:
    os: Ubuntu
    release: noble
    requirements.cgroup: v2
    serial: 20250724_0002
    type: disk-kvm.img
    variant: desktop
    architecture: amd64
    description: Ubuntu noble amd64 (20250724_0002)
Aliases:
Cached: no
Auto update: disabled
Source:
    Server: https://images.lxd.canonical.com
    Protocol: simplestreams
    Alias: ubuntu/noble/desktop
Profiles:
    - default
```
