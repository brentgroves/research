# **[Multi-node install](https://canonical-microceph.readthedocs-hosted.com/en/latest/how-to/multi-node/)**

This tutorial will show how to install MicroCeph on three machines, thereby creating a multi-node cluster. For this tutorial, we will utilise physical block devices for storage.

## Ensure storage requirements

Three OSDs will be required to form a minimal Ceph cluster. This means that, on each of the three machines, one entire disk must be allocated for storage.

The disk subsystem can be inspected with the lsblk command. In this tutorial, the command’s output on each machine looks very similar to what’s shown below. Any output related to possible loopback devices has been suppressed for the purpose of clarity:
