# how big should i make the lxd local storage pool

The ideal size for an LXD storage pool depends on your specific needs and resources. By default, LXD sets up a loop-based storage pool with a sensible default size: 20% of the free disk space, with a minimum of 5 GiB and a maximum of 30 GiB. You can customize this when creating the pool or resize it later.
Factors to consider when determining the size:
Number of instances:
The number and size of instances (containers and virtual machines) you plan to run will directly impact the required storage space.
Instance types:
Different types of instances (e.g., development, production, databases) may have different storage requirements.
Storage usage patterns:
Consider how much data will be stored within the instances (e.g., persistent storage, application data, logs).
Growth expectations:
Account for potential future growth in instance count and storage needs.
Available disk space:
Ensure the pool size doesn't exceed the available disk space on your host machine.
Storage driver:
The chosen storage driver (e.g., btrfs, zfs, lvm) may have specific recommendations or limitations.
General recommendations:
Start with a reasonable default: If you're unsure, the default settings (20% of free space, with a minimum of 5 GiB and a maximum of 30 GiB) are a good starting point.
Monitor usage: Regularly monitor the storage pool's usage to identify potential over or under-provisioning.
Resize as needed: You can easily resize the pool later if your needs change.
Resizing the default storage pool:
If you're using the default loop-backed storage, you can resize it using the following command:
Code

lxc storage set default size=<new_size>
Replace <new_size> with the desired size (e.g., 100GiB). You can also use the LXD UI to resize the pool.
Example:
If you have 500GiB of free disk space and want to allocate 100GiB for your LXD storage pool, you can set it using:
Code

lxc storage set default size=100GiB
After setting the size, you can verify the changes using:
Code

lxc storage show default
Remember that you can only grow the pool (increase the size), not shrink it.
