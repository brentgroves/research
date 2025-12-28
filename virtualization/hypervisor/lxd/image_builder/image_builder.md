# **[lxd image-builder](https://canonical-lxd-imagebuilder.readthedocs-hosted.com/en/latest/tutorials/use/?_gl=1*1u260or*_ga*MTY2Njg1MzMxNS4xNzQ3NTE3NDk3*_ga_892F83CXG5*czE3NTcwMTI2NTIkbzM1JGcxJHQxNzU3MDEyODkxJGo1OSRsMCRoMA..)**

Use lxd-imagebuilder to create images
This guide shows you how to create an image for LXD or LXC.

Before you start, you must install lxd-imagebuilder. See **[How to install lxd-imagebuilder](https://canonical-lxd-imagebuilder.readthedocs-hosted.com/en/latest/howto/install/)** and simplestream-maintainer for instructions.

## Create an image

To create an image, first create a directory where you will be placing the images, and enter that directory.

```bash
mkdir -p $HOME/Images/ubuntu/
cd $HOME/Images/ubuntu/
```

Then, copy one of the example YAML configuration files for images into this directory.

Note

The YAML configuration file contains an image template that gives instructions to LXD imagebuilder.

LXD imagebuilder provides examples of YAML files for various distributions in the **[examples directory](https://github.com/canonical/lxd-imagebuilder/tree/main/doc/examples)**. **[scheme.yaml](https://github.com/canonical/lxd-imagebuilder/blob/main/doc/examples/scheme.yaml)** is a standard template that includes all available options.

Official LXD templates for various distributions are available in the **[lxd-ci repository](https://github.com/canonical/lxd-ci/tree/main/images)**.

In this example, we are creating an Ubuntu image.

```bash
cp $HOME/go/src/github.com/canonical/lxd-imagebuilder/doc/examples/ubuntu.yaml ubuntu.yaml
```

## Edit the template file

Optionally, you can do some edits to the YAML configuration file. You can define the following keys:

| Section  | Description                                                                            | Documentation      |
|----------|----------------------------------------------------------------------------------------|--------------------|
| image    | Defines distribution, architecture, release etc.                                       | Image              |
| source   | Defines main package source, keys etc.                                                 | Source             |
| targets  | Defines configuration for specific targets (e.g. LXD, instances etc.)                  | Targets            |
| files    | Defines generators to modify files                                                     | Generators         |
| packages | Defines packages for install or removal; adds repositories                             | Package management |
| actions  | Defines scripts to be run after specific steps during image building                   | Actions            |
| mappings | Maps different terms for architectures for specific distributions (e.g. x86_64: amd64) | Mappings           |

Tip

When building a VM image, you should either build an image with cloud-init support (provides automatic size growth) or set a higher size in the template, because the standard size is relatively small (10 GiB). Alternatively, you can also grow it manually.

## Build and launch the image

The steps for building and launching the image depend on whether you want to use it with LXD or with LXC.

## Create an image for LXD

To build an image for LXD, run lxd-imagebuilder. We are using the build-lxd option to create an image for LXD.

- To create a container image:

```bash
sudo $HOME/go/bin/lxd-imagebuilder build-lxd ubuntu.yaml
```

- To create a VM image:

```bash
sudo $HOME/go/bin/lxd-imagebuilder build-lxd ubuntu.yaml --vm
```

See **[LXD image](https://canonical-lxd-imagebuilder.readthedocs-hosted.com/en/latest/howto/build/#howto-build-lxd)** for more information about the build-lxd command.

If the command is successful, you will get an output similar to the following (for a container image). The lxd.tar.xz file is the description of the container image. The rootfs.squasfs file is the root file system (rootfs) of the container image. The set of these two files is the container image.

```bash
$ ls -l
total 100960
-rw-r--r-- 1 root   root         676 Oct  3 16:15 lxd.tar.xz
-rw-r--r-- 1 root   root   103370752 Oct  3 16:15 rootfs.squashfs
-rw-r--r-- 1 ubuntu ubuntu      7449 Oct  3 16:03 ubuntu.yaml
$
```

Add the image to LXD
To add the image to an LXD installation, use the lxc image import command as follows.

```bash
$ lxc image import lxd.tar.xz rootfs.squashfs --alias mycontainerimage
Image imported with fingerprint: 009349195858651a0f883de804e64eb82e0ac8c0bc51880
```

See **[How to copy and import images](https://documentation.ubuntu.com/lxd/latest/howto/images_copy/#images-copy)** for detailed information.

Let’s look at the image in LXD. The ubuntu.yaml had a setting to create an Ubuntu 20.04 (focal) image. The size is 98.58MB.

```bash
$ lxc image list mycontainerimage
+------------------+--------------+--------+--------------+--------+---------+-----------------------------+
|      ALIAS       | FINGERPRINT  | PUBLIC | DESCRIPTION  |  ARCH  |  SIZE   |         UPLOAD DATE         |
+------------------+--------------+--------+--------------+--------+---------+-----------------------------+
| mycontainerimage | 009349195858 | no     | Ubuntu focal | x86_64 | 98.58MB | Oct 3, 2020 at 5:10pm (UTC) |
+------------------+--------------+--------+--------------+--------+---------+-----------------------------+
```

Launch an LXD container from the container image
To launch a container from the freshly created image, use lxc launch as follows. Note that you do not specify a repository for the image (like ubuntu: or images:) because the image is located locally.

```bash
$ lxc launch mycontainerimage c1
Creating c1
Starting c1
```
