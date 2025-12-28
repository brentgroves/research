# **[egress requirements](https://discourse.ubuntu.com/t/manage-a-proxied-environment/43946)**

This page shows how to configure proxy settings for MicroStack. This is required for an environment that has network egress traffic restrictions placed upon it. These restrictions are typically implemented via a corporate proxy server that is separate from the MicroStack deployment.

The proxy server itself must permit access to certain external (internet) resources in order for MicroStack to deploy (and operate) correctly. These resources are listed on the **[Proxy ACL access reference page](https://discourse.ubuntu.com/t/43948)**.

## **[Proxy ACL access reference page](https://discourse.ubuntu.com/t/43948)**

For a network that is constrained by a proxy server, efforts will be needed to ensure that MicroStack works as intended. See the Manage a proxied environment page for guidance.

The proxy server itself must have ACL rules that permit all MicroStack nodes to access the resources listed below.

| Resource                             | Description                |
|--------------------------------------|----------------------------|
| streams.canonical.com 3              | Juju agent packages        |
| archive.ubuntu.com 2                 | Ubuntu archive packages    |
| security.ubuntu.com                  | Ubuntu security packages   |
| cloud-images.ubuntu.com 2            | Cloud images               |
| api.charmhub.io                      | Juju charms                |
| docker.io 3                          | Container images           |
| production.cloudflare.docker.com     | Container images           |
| quay.io                              | Container images           |
| ghcr.io                              | Container images           |
| pkg-containers.githubusercontent.com | Container images           |
| registry.k8s.io                      | Container images           |
| pkg.dev                              | Container images           |
| amazonaws.com                        | Container images           |
| registry.jujucharms.com              | Container images           |
| api.snapcraft.io 1                   | Snaps                      |
| snapcraftcontent.com 1               | Snaps                      |
| builds.coreos.fedoraproject.org 1    | VM Image for Fedora CoreOS |
| download.cirros-cloud.net 1          | VM Image for CirrOS        |
| maas.io                              | MAAS images [1]            |
| contracts.canonical.com              | Ubuntu Pro                 |
| images.lxd.canonical.com             | LXD Container images [2]   |
