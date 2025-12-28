<https://discourse.ubuntu.com/t/deploy-charmed-ceph-on-lxd/56554>

This tutorial will guide you through the process of deploying a Ceph cluster on LXD with Juju. You will use Juju to pull the ceph-mon and ceph-osd charms from Charmhub and colocate them on three LXD machines. To do this, you will need to create a Juju controller on your local LXD cloud to manage your deployment.

You will then add a model to deploy your charms, and make the services deployed by these charms aware of each other using Juju integrations.

By the end of the tutorial, you will have deployed a standalone Ceph model on LXD with three nodes each containing a ceph-osd unit and ceph-mon unit, that are integrated with Juju, and you will be ready to customise your Charmed Ceph cluster even more and explore more use cases.
