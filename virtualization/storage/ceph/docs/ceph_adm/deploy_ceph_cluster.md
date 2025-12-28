# **[Using cephadm to Deploy a New Ceph Cluster](https://docs.ceph.com/en/reef/cephadm/install/#cephadm-deploying-new-cluster)**

cephadm was introduced in Ceph release v15.2.0 (Octopus) and does not support older versions of Ceph.

## Using cephadm to Deploy a New Ceph Cluster

Cephadm creates a new Ceph cluster by bootstrapping a single host, expanding the cluster to encompass any additional hosts, and then deploying the needed services.

Requirements
Python 3

Systemd

Podman or Docker for running containers

Time synchronization (such as Chrony or the legacy ntpd)

LVM2 for provisioning storage devices

LVM2, or Logical Volume Manager 2, is a set of tools that provide logical volume management capabilities for the Linux kernel. It allows administrators to manage disk storage space more flexibly than traditional partitioning by abstracting the physical storage into logical volumes. This allows for dynamic resizing, merging, and splitting of storage, as well as features like snapshots and mirroring

Any modern Linux distribution should be sufficient. Dependencies are installed automatically by the bootstrap process below.

See Docker Live Restore for an optional feature that allows restarting Docker Engine without restarting all running containers.

Live restore
By default, when the Docker daemon terminates, it shuts down running containers. You can configure the daemon so that containers remain running if the daemon becomes unavailable. This functionality is called live restore. The live restore option helps reduce container downtime due to daemon crashes, planned outages, or upgrades.

See the section Compatibility With Podman Versions for a table of Ceph versions that are compatible with Podman. Not every version of Podman is compatible with Ceph.

## Install cephadm

There are two ways to install cephadm:

a curl-based installation method

distribution-specific installation methods

Important

These methods of installing cephadm are mutually exclusive. Choose either the distribution-specific method or the curl-based method. Do not attempt to use both these methods on one system.

Note

Recent versions of cephadm are distributed as an executable compiled from source code. Unlike for earlier versions of Ceph it is no longer sufficient to copy a single script from Ceph’s git tree and run it. If you wish to run cephadm using a development version you should create your own build of cephadm. See Compiling cephadm for details on how to create your own standalone cephadm executable.

## distribution-specific installations

Some Linux distributions may already include up-to-date Ceph packages. In that case, you can install cephadm directly. For example:

In Ubuntu:

`apt install -y cephadm`

## curl-based installation

First, determine what version of Ceph you wish to install. You can use the releases page to find the latest active releases. For example, we might find that 18.2.1 is the latest active release.

Use curl to fetch a build of cephadm for that release.

CEPH_RELEASE=18.2.0 # replace this with the active release
curl --silent --remote-name --location <https://download.ceph.com/rpm-${CEPH_RELEASE}/el9/noarch/cephadm>
Ensure the cephadm file is executable:

`chmod +x cephadm`

This file can be run directly from the current directory:

`./cephadm <arguments...>`

If you encounter any issues with running cephadm due to errors including the message bad interpreter, then you may not have Python or the correct version of Python installed. The cephadm tool requires Python 3.6 or later. You can manually run cephadm with a particular version of Python by prefixing the command with your installed Python version. For example:

python3.8 ./cephadm <arguments...>
Although the standalone cephadm is sufficient to bootstrap a cluster, it is best to have the cephadm command installed on the host. To install the packages that provide the cephadm command, run the following commands:

## update cephadm

The cephadm binary can be used to bootstrap a cluster and for a variety of other management and debugging tasks. The Ceph team strongly recommends using an actively supported version of cephadm. Additionally, although the standalone cephadm is sufficient to get a cluster started, it is convenient to have the cephadm command installed on the host. Older or LTS distros may also have cephadm packages that are out-of-date and running the commands below can help install a more recent version from the Ceph project’s repositories.

To install the packages provided by the Ceph project that provide the cephadm command, run the following commands:

```bash
./cephadm add-repo --release reef
./cephadm install
```

Confirm that cephadm is now in your PATH by running which or command -v:

`which cephadm`

A successful which cephadm command will return this:

`/usr/sbin/cephadm`

## Bootstrap a new cluster

What to know before you bootstrap
The first step in creating a new Ceph cluster is running the cephadm bootstrap command on the Ceph cluster’s first host. The act of running the cephadm bootstrap command on the Ceph cluster’s first host creates the Ceph cluster’s first Monitor daemon. You must pass the IP address of the Ceph cluster’s first host to the ceph bootstrap command, so you’ll need to know the IP address of that host.

Important

ssh must be installed and running in order for the bootstrapping procedure to succeed.

Note

If there are multiple networks and interfaces, be sure to choose one that will be accessible by any host accessing the Ceph cluster.

## Running the bootstrap command

Run the ceph bootstrap command:

```bash
cephadm bootstrap --mon-ip *<mon-ip>*
```

This command will:

- Create a Monitor and a Manager daemon for the new cluster on the local host.

Generate a new SSH key for the Ceph cluster and add it to the root user’s /root/.ssh/authorized_keys file.

Write a copy of the public key to /etc/ceph/ceph.pub.

Write a minimal configuration file to /etc/ceph/ceph.conf. This file is needed to communicate with Ceph daemons.

Write a copy of the client.admin administrative (privileged!) secret key to /etc/ceph/ceph.client.admin.keyring.

Add the _admin label to the bootstrap host. By default, any host with this label will (also) get a copy of /etc/ceph/ceph.conf and /etc/ceph/ceph.client.admin.keyring.

## Further information about cephadm bootstrap

The default bootstrap process will work for most users. But if you’d like immediately to know more about cephadm bootstrap, read the list below.

Also, you can run cephadm bootstrap -h to see all of cephadm’s available options.

By default, Ceph daemons send their log output to stdout/stderr, which is picked up by the container runtime (docker or podman) and (on most systems) sent to journald. If you want Ceph to write traditional log files to /var/log/ceph/$fsid, use the --log-to-file option during bootstrap.

Larger Ceph clusters perform best when (external to the Ceph cluster) public network traffic is separated from (internal to the Ceph cluster) cluster traffic. The internal cluster traffic handles replication, recovery, and heartbeats between OSD daemons. You can define the cluster network by supplying the --cluster-network option to the bootstrap subcommand. This parameter must be a subnet in CIDR notation (for example 10.90.90.0/24 or fe80::/64).

cephadm bootstrap writes to /etc/ceph files needed to access the new cluster. This central location makes it possible for Ceph packages installed on the host (e.g., packages that give access to the cephadm command line interface) to find these files.

Daemon containers deployed with cephadm, however, do not need /etc/ceph at all. Use the --output-dir *<directory>* option to put them in a different directory (for example, .). This may help avoid conflicts with an existing Ceph configuration (cephadm or otherwise) on the same host.

You can pass any initial Ceph configuration options to the new cluster by putting them in a standard ini-style configuration file and using the --config *<config-file>* option. For example:

```bash
cat <<EOF > initial-ceph.conf
[global]
osd crush chooseleaf type = 0
EOF

./cephadm bootstrap --config initial-ceph.conf ...
```

The --ssh-user *<user>* option makes it possible to designate which SSH user cephadm will use to connect to hosts. The associated SSH key will be added to /home/*<user>*/.ssh/authorized_keys. The user that you designate with this option must have passwordless sudo access.

If you are using a container image from a registry that requires login, you may add the argument:

--registry-json <path to json file>

example contents of JSON file with login info:

`{"url":"REGISTRY_URL", "username":"REGISTRY_USERNAME", "password":"REGISTRY_PASSWORD"}`

Cephadm will attempt to log in to this registry so it can pull your container and then store the login info in its config database. Other hosts added to the cluster will then also be able to make use of the authenticated container registry.

See **[Different deployment scenarios](https://docs.ceph.com/en/reef/cephadm/install/#cephadm-deployment-scenarios)** for additional examples for using cephadm bootstrap.

## Enable Ceph CLI

Cephadm does not require any Ceph packages to be installed on the host. However, we recommend enabling easy access to the ceph command. There are several ways to do this:

- The cephadm shell command launches a bash shell in a container with all of the Ceph packages installed. By default, if configuration and keyring files are found in /etc/ceph on the host, they are passed into the container environment so that the shell is fully functional. Note that when executed on a MON host, cephadm shell will infer the config from the MON container instead of using the default configuration. If --mount <path> is given, then the host <path> (file or directory) will appear under /mnt inside the container:

```bash
cephadm shell
```

To execute ceph commands, you can also run commands like this:

`cephadm shell -- ceph -s`

You can install the ceph-common package, which contains all of the ceph commands, including ceph, rbd, mount.ceph (for mounting CephFS file systems), etc.:

```bash
cephadm add-repo --release reef
cephadm install ceph-common
```

Confirm that the ceph command is accessible with:

`ceph -v`

Confirm that the ceph command can connect to the cluster and also its status with:

`ceph status`

## Adding Hosts

Add all hosts to the cluster by following the instructions in **[Adding Hosts](https://docs.ceph.com/en/reef/cephadm/host-management/#cephadm-adding-hosts)**.

By default, a ceph.conf file and a copy of the client.admin keyring are maintained in /etc/ceph on all hosts that have the _admin label. This label is initially applied only to the bootstrap host. We recommend that one or more other hosts be given the_admin label so that the Ceph CLI (for example, via cephadm shell) is easily accessible on multiple hosts. To add the _admin label to additional host(s), run a command of the following form:

`ceph orch host label add *<host>* _admin`

## Adding additional MONs

A typical Ceph cluster has three or five Monitor daemons spread across different hosts. We recommend deploying five Monitors if there are five or more nodes in your cluster. Most clusters do not benefit from seven or more Monitors.

Please follow **[Deploying additional monitors](https://docs.ceph.com/en/reef/cephadm/services/mon/#deploy-additional-monitors)** to deploy additional MONs.

## Adding Storage

To add storage to the cluster, you can tell Ceph to consume any available and unused device(s):

`ceph orch apply osd --all-available-devices`

See **[Deploy OSDs](https://docs.ceph.com/en/reef/cephadm/services/osd/#cephadm-deploy-osds)** for more detailed instructions.
