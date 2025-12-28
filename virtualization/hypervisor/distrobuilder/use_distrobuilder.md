# **[Use distrobuilder to create images](https://linuxcontainers.org/distrobuilder/docs/latest/tutorials/use/)**

This guide shows you how to create an image for Incus or LXC.

Before you start, you must install distrobuilder. See **[How to install distrobuilder](https://linuxcontainers.org/distrobuilder/docs/latest/howto/install/)** for instructions.

## Create an image

To create an image, first create a directory where you will be placing the images, and enter that directory.

```bash
mkdir -p $HOME/Images/ubuntu/
cd $HOME/Images/ubuntu/
```

Then, copy one of the example YAML configuration files for images into this directory.

Note

The YAML configuration file contains an image template that gives instructions to distrobuilder.

Distrobuilder provides examples of YAML files for various distributions in the **[examples directory](https://github.com/lxc/distrobuilder/tree/master/doc/examples)**. **[scheme.yaml](https://github.com/lxc/distrobuilder/blob/master/doc/examples/scheme.yaml)** is a standard template that includes all available options.

Official Incus templates for various distributions are available in the **[lxc-ci](https://github.com/lxc/lxc-ci/tree/master/images)** **[repository](https://github.com/lxc/lxc-ci/tree/master/images)**.

In this example, we are creating an Ubuntu image.

```bash
cp $HOME/go/src/github.com/lxc/distrobuilder/doc/examples/ubuntu.yaml ubuntu.yaml
```

## Edit the template file

Optionally, you can do some edits to the YAML configuration file. You can define the following keys:
