# AI: if i stop an lxd instance is data lost

AI Overview
No, stopping an LXD instance does not typically result in data loss.
Here's why:
Stopped vs. Deleted: Stopping an LXD instance is similar to shutting down a virtual machine or a physical server. The instance's operating system and applications are halted, but the data stored within the instance remains on the host's storage system.
Data Persistence: LXD manages storage volumes that are associated with instances. When an instance is stopped, these volumes persist, ensuring that your data is preserved until the instance is explicitly deleted.
However, there are important considerations:
Deletion: Deleting an LXD instance, on the other hand, will destroy the instance's associated storage volume and all the data contained within it.
Snapshots: While snapshots capture the state of an instance at a particular point in time, they are stored within the same storage pool as the original data. If the primary data is lost or deleted, the snapshots might also be affected.
LXD Database: The LXD database stores metadata about your instances, such as profiles, network definitions, and server configuration. If the database becomes corrupted or lost, you might lose this metadata, requiring you to re-create it. However, LXD does provide tools for recovering instances in case of database loss by scanning the storage pools for existing instances.
In summary: Stopping an LXD instance is a safe operation that preserves your data. It's only when you choose to delete the instance that its associated storage and data are removed. Regular backups are always recommended to protect against unforeseen data loss scenarios, such as hardware failures or accidental deletions.
