# **[How to install Microcloud general + production](https://documentation.ubuntu.com/microcloud/latest/microcloud/how-to/install/#howto-install)**

## Pre-deployment requirements

The requirements in this section apply to all MicroCloud deployments.

A physical or virtual machine intended for use as a MicroCloud cluster member must meet the following prerequisites:

## Addition production requirements

- use physical machines only (no VMs)

Minimum cluster size:

3 members

For critical deployments, we recommend a minimum of 4 members

Memory:

Minimum 32 GiB RAM per cluster member

Software:

For production deployments subscribed to Ubuntu Pro, each cluster member must use a LTS version of Ubuntu

Networking:

For each cluster member, we recommend dual-port network cards with a minimum 10 GiB capacity, or higher if low latency is essential

Storage:

For each cluster member, we recommend at least 3 NVMe disks:

1 for OS

1 for local storage

1 for distributed storage
