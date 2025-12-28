# **[How to run Docker inside LXD containers](https://ubuntu.com/tutorials/how-to-run-docker-inside-lxd-containers#1-overview)**

## Overview

LXD and Docker containers serve different purposes. LXD runs system containers that are VM-like and systems running on them are intended to be long-running and persistent. Docker containers, on the other hand, are usually stateless and ephemeral, and are a great options for distributing working solutions. You can use LXD to create your virtual systems running inside the containers, segment it as you like, and then easily use Docker to get the actual service running inside of the container.

This tutorial teaches you how to run Docker inside LXD containers, which you can then use the same way as you usually would running on any other system.

## What you’ll learn

How to create an LXD container with a Docker compatible file system

How to install Docker inside an LXD container

## What you’ll need

- Ubuntu Desktop 16.04 or above
- LXD snap installed and running
- Some basic command-line knowledge

## How to run Docker inside LXD containers

## 2. Create LXD Container

Let’s start by creating a new storage pool in LXD. For Docker to work optimally it needs a specific file system and features that enable the Docker layers to be stored and stacked using as little space as possible and as fast as possible.

⚠️ Docker will not run well with the default zfs file system

Btrfs is one of the storage pools Docker supports natively, so we should create a new btrfs storage pool and we will call it “docker”:

`lxc storage create docker btrfs`

Now we can create a new LXD instance and call it “demo”:

`lxc launch images:ubuntu/24.04 demo`

We can proceed and create a new storage volume on the “docker” storage pool created earlier:

lxc storage volume create docker demo

We will attach it to the “demo” container and call the device being added as “docker”. Source volume is “demo” we created earlier, and we want that volume to be used for /var/lib/docker:

lxc config device add demo docker disk pool=docker source=demo path=/var/lib/docker

We need to add additional configuration so that Docker works well inside the container.

First we should allow nested containers required for Docker. Then, there are two additional security options needed - to intercept and emulate system calls. This normally wouldn’t be allowed inside LXD default unprivileged containers, but Docker relies on it for its layers, so it is okay to enable it.

lxc config set demo security.nesting=true security.syscalls.intercept.mknod=true security.syscalls.intercept.setxattr=true

To apply these changes, we need to restart the instance:

lxc restart demo

## 3. Install Docker

To install Docker, we start by going inside the container:

lxc exec demo bash

Now we can follow the normal Docker installation instructions. Paste the following command:

```bash
sudo apt-get update

 sudo apt-get install \
 ca-certificates \
 curl \
 gnupg \
  lsb-release
```

Now we need to add Docker’s official GPG key:

```bash
curl -fsSL <https://download.docker.com/linux/ubuntu/gpg> | sudo gpg \
--dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

And now we can install the Docker repository:

```bash
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Finally, we can install Docker itself:

```bash
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
```

## How to run Docker inside LXD containers

## 4. Test your Docker container

Now we have Docker up and running. Let’s test it by running an Ubuntu Docker container:

docker run -it ubuntu bash

And we can run the following to check that the processes are running correctly:

`ps aux`

And that’s it! Now you have a working Ubuntu Docker container inside of an LXD container. You can use it, or you can spin up another Docker image and proceed to use it according to your needs.

## 5. Additional information

Vast majority of Docker images will run fine inside LXD containers. However, few might not run properly. The reason for this is that LXD runs all its container unprivileged by default, which limits some of the actions of the user. Docker, on the other hand, runs privileged containers, and some actions might expect more privileges than LXD gives them, causing potential failures. For example, if you’re running something inside a docker container that expects to run as root, it won’t be able to do actions as a real root user but rather only as root inside of the LXD container, which is more constrained.
