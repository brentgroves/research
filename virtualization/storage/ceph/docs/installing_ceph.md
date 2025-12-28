# **[installing ceph](https://docs.ceph.com/en/reef/install/)**

**[Cephadm](https://docs.ceph.com/en/reef/cephadm/install/#cephadm-deploying-new-cluster)** is a tool that can be used to install and manage a Ceph cluster

cephadm supports only Octopus and newer releases.

cephadm is fully integrated with the orchestration API and fully supports the CLI and dashboard features that are used to manage cluster deployment.

cephadm requires container support (in the form of Podman or Docker) and Python 3.

**[Rook](https://rook.io/)** deploys and manages Ceph clusters running in Kubernetes, while also enabling management of storage resources and provisioning via Kubernetes APIs. We recommend Rook as the way to run Ceph in Kubernetes or to connect an existing Ceph storage cluster to Kubernetes.

Rook supports only Nautilus and newer releases of Ceph.

Rook is the preferred method for running Ceph on Kubernetes, or for connecting a Kubernetes cluster to an existing (external) Ceph cluster.

Rook supports the orchestrator API. Management features in the CLI and dashboard are fully supported.

ceph-salt installs Ceph using Salt and cephadm.

jaas.ai/ceph-mon installs Ceph using Juju.

github.com/openstack/puppet-ceph installs Ceph via Puppet.

OpenNebula HCI clusters deploys Ceph on various cloud platforms.

Ceph can also be installed manually.
