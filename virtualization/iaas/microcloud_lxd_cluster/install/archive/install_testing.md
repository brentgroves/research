# **[How to install MicroClouds](https://documentation.ubuntu.com/microcloud/stable/microcloud/how-to/install/)**

- Pre-deployment requirements
- Physical or virtual machines can be used
- Minimum cluster size:
- 1 member
- Memory:
- Minimum 8 GiB RAM per cluster member
- Storage:
- If high availability is required, use distributed storage with:
- a minimum of 3 cluster members
- a minimum of 3 separate disks located across 3 different members
Otherwise, local storage is sufficient

For detailed information, see: **[Requirements](https://documentation.ubuntu.com/microcloud/stable/microcloud/reference/#reference-requirements)**.

Installation
▶
**[Watch on YouTube](https://www.youtube.com/watch?v=M0y0hQ16YuE)**
To install MicroCloud, install all required Snaps on all machines that you want to include in your cluster.

To do so, enter the following commands on all machines:

```bash
sudo snap install lxd --channel=5.21/stable --cohort="+"
sudo snap install microceph --channel=squid/stable --cohort="+"
sudo snap install microovn --channel=24.03/stable --cohort="+"
sudo snap install microcloud --channel=2/stable --cohort="+"
```

Make sure to install the same version of the snaps on all machines. See How to manage the snaps for more information.

If you don’t want to use MicroCloud’s full functionality, you can install only some of the snaps. However, this is not recommended.

After installing the snaps make sure to hold any automatic updates to keep the used snap versions across MicroCloud in sync. See **[Hold updates](https://documentation.ubuntu.com/microcloud/stable/microcloud/how-to/snaps/#howto-snap-hold-updates)** for more information.

## Hold updates

You can hold snap updates for a specific time or forever, for all snaps or for specific snaps.

Which strategy to choose depends on your use case. If you want to fully control updates to your MicroCloud setup, you should put a hold on all related snaps until you decide to update them.

Enter the following command to indefinitely hold all updates to the snaps needed for MicroCloud:

```bash
sudo snap refresh --hold lxd microceph microovn microcloud
```

See Hold refreshes in the snap documentation for detailed information about holding snap updates.
