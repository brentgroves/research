# **[How to use cloud-init](https://documentation.ubuntu.com/lxd/en/latest/cloud-init/)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

## reference

- **[snapshot](https://discourse.ubuntu.com/t/multipass-snapshot-command/39755)**

**[cloud-init](https://cloud-init.io/)** is a tool for automatically initializing and customizing an instance of a Linux distribution.

By adding cloud-init configuration to your instance, you can instruct cloud-init to execute specific actions at the first start of an instance. Possible actions include, for example:

- Updating and installing packages
- Applying certain configurations
- Adding users
- Enabling services
- Running commands or scripts
- Automatically growing the file system of a VM to the size (quota) of the disk

See the **[Cloud-init documentation](https://cloudinit.readthedocs.io/en/latest/index.html#index)** for detailed information.

Note

The cloud-init actions are run only once on the first start of the instance. Rebooting the instance does not re-trigger the actions.

## cloud-init support in images

To use cloud-init, you must base your instance on an image that has cloud-init installed:

All images from the ubuntu and ubuntu-daily image servers have cloud-init support. However, images for Ubuntu releases prior to 20.04 LTS require special handling to integrate properly with cloud-init, so that lxc exec works correctly with virtual machines that use those images. Refer to VM cloud-init.

Images from the images remote have cloud-init-enabled variants, which are usually bigger in size than the default variant. The cloud variants use the /cloud suffix, for example, images:alpine/edge/cloud.


## Configuration options

LXD supports two different sets of configuration options for configuring cloud-init: cloud-init.* and user.*. Which of these sets you must use depends on the cloud-init support in the image that you use. As a rule of thumb, newer images support the cloud-init.* configuration options, while older images support user.*. However, there might be exceptions to that rule.

The following configuration options are supported:

- cloud-init.vendor-data or user.vendor-data (see **[Vendor-data](https://cloudinit.readthedocs.io/en/latest/explanation/vendordata.html#vendor-data)**)
- cloud-init.user-data or user.user-data (see **[User-data formats](https://cloudinit.readthedocs.io/en/latest/explanation/format.html#user-data-formats)**)
- cloud-init.network-config or user.network-config (see **[Network configuration](https://cloudinit.readthedocs.io/en/latest/reference/network-config.html#network-config)**)

For more information about the configuration options, see the **[cloud-init instance options](https://documentation.ubuntu.com/lxd/en/latest/reference/instance_options/#instance-options-cloud-init)**, and the documentation for the **[LXD data source](https://cloudinit.readthedocs.io/en/latest/reference/datasources/lxd.html#datasource-lxd)** in the cloud-init documentation.

Note

Ubuntu 20.04 and earlier have recent versions of the cloud-init package but support for the modern cloud-init.* configuration options is disabled in those series. As such, when using such old instances, remember to use the user.* configuration options instead.

## Vendor data and user data

Both vendor-data and user-data are used to provide cloud configuration data to cloud-init.

The main idea is that vendor-data is used for the general default configuration, while user-data is used for instance-specific configuration. This means that you should specify vendor-data in a profile and user-data in the instance configuration. LXD does not enforce this method, but allows using both vendor-data and user-data in profiles and in the instance configuration.

If both vendor-data and user-data are supplied for an instance, cloud-init merges the two configurations. However, if you use the same keys in both configurations, merging might not be possible. In this case, configure how cloud-init should merge the provided data. See **[Merging user-data sections for instructions](https://cloudinit.readthedocs.io/en/latest/reference/merging.html#merging-user-data)**.

## How to configure cloud-init

To configure cloud-init for an instance, add the corresponding configuration options to a **[profile](https://documentation.ubuntu.com/lxd/en/latest/profiles/#profiles)** that the instance uses or directly to the instance configuration.

When configuring cloud-init directly for an instance, keep in mind that cloud-init runs only on instance start. That means any changes to cloud-init configuration will only take effect after the next instance start. Some configuration options only take effect on the first boot of an instance. If cloud-init notices that an instance’s instance-id has changed, it behaves as if this was the instance’s first boot. For more information, see the cloud-init docs If you are using the CLI client, create the instance with lxc init instead of lxc launch, and then start it after completing the configuration.



