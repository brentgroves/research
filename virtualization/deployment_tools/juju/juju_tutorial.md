# **[juju](https://documentation.ubuntu.com/juju/3.6/tutorial/)**

## Get started with Juju

Imagine your business needs a chat service such as Mattermost backed up by a database such as PostgreSQL. In a traditional setup, this can be quite a challenge, but with Juju you’ll find yourself deploying, configuring, scaling, integrating, etc., applications in no time. Let’s get started!

## What you’ll need

A workstation that has sufficient resources to launch a virtual machine with 4 CPUs, 8 GB RAM, and 50 GB disk space.

## What you’ll do

- Set up an isolated test environment with Multipass and the charm-dev blueprint, which will provide all the necessary tools and configuration for the tutorial (a localhost machine cloud and Kubernetes cloud, Juju, etc.).

- Plan, deploy, and maintain a chat service based on Mattermost and backed by PostgreSQL on a local Kubernetes cloud with Juju.

## Set up an isolated test environment

On your machine, install Multipass and use it to set up an Ubuntu virtual machine (VM) called my-juju-vm from the charm-dev blueprint.

## See more: **[Set things up](https://documentation.ubuntu.com/juju/3.6/howto/manage-your-deployment/manage-your-deployment-environment/#set-things-up)**

Note: We recommend you follow the automatic path, with the Multipass VM from the charm-dev blueprint. If you however decide to take the manual path, please make sure to stay very close to the definition of the charm-dev blueprint .

## Plan

In this tutorial your goal is to set up a chat service on a cloud.

First, decide which cloud (i.e., anything that provides storage, compute, and networking) you want to use. Juju supports a long list of clouds; in this tutorial we will use a low-ops, minimal production Kubernetes called ‘MicroK8s’. In a terminal, open a shell into your VM and verify that you already have MicroK8s installed (microk8s version).

<https://documentation.ubuntu.com/juju/3.6/reference/cloud/list-of-supported-clouds/#list-of-supported-clouds>
