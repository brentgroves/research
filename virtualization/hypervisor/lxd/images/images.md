# **[](https://mysignins.microsoft.com/security-info)**

Local and remote images
▶
Watch on YouTube
LXD uses an image-based workflow. Each instance is based on an image, which contains a basic operating system (for example, a Linux distribution) and some LXD-related information.

Images are available from remote image stores (see **[Remote image servers](https://documentation.ubuntu.com/lxd/stable-5.21/reference/remote_image_servers/#remote-image-servers)** for an overview), but you can also create your own images, either based on an existing instances or a rootfs image.

You can copy images from remote servers to your local image store, or copy local images to remote servers. You can also use a local image to create a remote instance.

Each image is identified by a fingerprint (SHA256). To make it easier to manage images, LXD allows defining one or more aliases for each image.

## all images

## desktop

lxc launch images:ubuntu/noble/desktop v1 --vm

## **[lxd images](https://images.lxd.canonical.com/)**

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
