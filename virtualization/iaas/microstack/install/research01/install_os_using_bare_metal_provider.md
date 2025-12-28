# **[Install Canonical OpenStack using the manual bare metal provider](https://canonical-openstack.readthedocs-hosted.com/en/latest/how-to/install/install-canonical-openstack-using-the-manual-bare-metal-provider/)**

## references

- **[ubuntu with 2 hard drives](https://www.linuxjournal.com/content/installing-ubuntu-two-hard-drives)**
- **[canonical openstack](https://canonical.com/openstack)**

This how-to guide provides all necessary information to install Canonical OpenStack with Sunbeam using the manual bare metal provider.

Make sure you get familiar with the following sections before proceeding with any instructions listed below:

- **[Architecture](https://canonical-openstack.readthedocs-hosted.com/en/latest/explanation/architecture/)**
- **[Design considerations](https://canonical-openstack.readthedocs-hosted.com/en/latest/explanation/design-considerations/)**
- **[Enterprise requirements](https://canonical-openstack.readthedocs-hosted.com/en/latest/reference/enterprise-requirements/)**
- **[Example physical configuration](https://canonical-openstack.readthedocs-hosted.com/en/latest/reference/example-physical-configuration/)**

This how-to guide is intended to serve operators willing to deploy a production-grade cloud. If you’re looking for some simple learning materials instead, please refer to the Tutorials section of this documentation.

## Requirements

You will need:

- two dedicated physical networks with an unlimited access to the Internet
- one dedicated physical machine with:
  - hardware specifications matching minimum hardware specifications for the Cloud node as documented under the **[Enterprise requirements](https://canonical-openstack.readthedocs-hosted.com/en/latest/reference/enterprise-requirements/)** section
  - fresh Ubuntu Server 24.04 LTS installed

If you can’t provide an unlimited access to the Internet, see the **[Manage a proxied environment](https://canonical-openstack.readthedocs-hosted.com/en/latest/how-to/misc/manage-a-proxied-environment/)** section.

Additional machines can be added later. See the **[Scaling the cluster out](https://canonical-openstack.readthedocs-hosted.com/en/latest/how-to/operations/scaling-the-cluster-out/)** how-to guide.

## Install Canonical OpenStack

When using the manual bare metal provider, Canonical OpenStack installation process is relatively simple and takes around 30 minutes to complete, depending on your Internet connection speed.

Warning

Canonical Juju does not yet support controller HA modeling capabilities when deployed on top Kubernetes. This means that Canonical OpenStack clouds deployed using the manual bare metal provider do not provide HA for all types of governance functions by default. To bypass this limitation Canonical recommends using an external highly available Juju controller. External controller has to be registered before running the sunbeam cluster bootstrap command.

## Install the snap

First, install the openstack snap:

```bash
sudo snap install openstack
```
