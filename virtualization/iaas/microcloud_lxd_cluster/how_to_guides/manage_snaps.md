# **[manage snaps](https://documentation.ubuntu.com/microcloud/stable/microcloud/how-to/snaps/#howto-snap)**

MicroCloud is distributed as a snap. The benefit of packaging MicroCloud as a snap is that it makes it possible to include the required dependencies, and that it allows MicroCloud to be installed on many different Linux distributions. The snap ensures that MicroCloud runs in a consistent environment.

Because MicroCloud uses a set of other snaps, you must make sure to have suitable versions of these snaps installed on all machines of your MicroCloud cluster. The installed snap versions must be compatible with one another, and for each of the snaps, the same version must be installed on all machines.

Choose the right channel and track
Snaps come with different channels that define which release of a snap is installed and tracked for updates. See Channels and tracks in the snap documentation for detailed information.

MicroCloud currently provides the legacy 1 and the latest 2 track.

Tip

In general, you should use the default channels for all snaps required to run MicroCloud.

See **[How to get support](https://documentation.ubuntu.com/microcloud/stable/microcloud/how-to/support/#howto-support)** for a list of supported channels that are orchestrated to work together.

We recommend using the following channels for the snaps required to run MicroCloud:

For MicroCloud: 2/(stable|candidate|edge)

For LXD: 5.21/(stable|candidate|edge)

For MicroCeph: squid/(stable|candidate|edge)

For MicroOVN: 24.03/(stable|candidate|edge)

Note

The LTS version of MicroCloud is available in the 2 track. It’s recommended to use the <track>/stable channels for production deployments.
