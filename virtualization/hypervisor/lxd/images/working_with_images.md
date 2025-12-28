# **[Working With LXD Linux Virtual Machine Images](https://www.youtube.com/watch?v=vSTzmcG2nro)**

In this video, we learn about managing LXD virtual machine images. When you install LXD, you automatically gain access to a publicly accessible image server. There are up-to-date Linux operating system images for many popular Linux distributions, including Ubuntu, Linux Mint, Alpine, Debian, and many more! Using the lxc CLI tool, you can separately download (pre-cache) images from an image server onto your LXD host, without having to create a virtual machine. You can also use the lxc CLI to delete cached images from your LXD host, to free up disk space for other purposes.

There are two network protocols supported for pulling and publishing images: Simple Streams, and LXD. With LXD engine, you can configure a "remote" server to pull images from, and specify which protocol the server supports. Simple Streams is designed for image servers that contain publicly accessible images, whereas using the LXD protocol offers the ability to make images "private."

If you need to create an image of an existing LXD virtual machine, to deploy new VMs from, you can use the "lxc publish" command. This command will take a replica of your virtual machine, store is as an image, and you can then deploy a new VM from that image with "lxc launch."
