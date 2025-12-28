# **[](https://documentation.ubuntu.com/lxd/latest/howto/instances_configure/)**

How to configure instances
You can configure instances by setting Instance properties, Instance options, or by adding and configuring Devices.

See the following sections for instructions.

Note

To store and reuse different instance configurations, use profiles.

Configure instance options
You can specify instance options when you create an instance. Alternatively, you can update the instance options after the instance is created.

Use the lxc config set command to update instance options. Specify the instance name and the key and value of the instance option:

`lxc config set <instance_name> <option_key>=<option_value> <option_key>=<option_value> ...`

To set the memory limit to 8 GiB, enter the following command:

`lxc config set my-container limits.memory=8GiB`

Some of the instance options are updated immediately while the instance is running. Others are updated only when the instance is restarted.

See the “Live update” information in the Instance options reference for information about which options are applied immediately while the instance is running.

To update instance properties after the instance is created, use the lxc config set command with the --property flag. Specify the instance name and the key and value of the instance property:

`lxc config set <instance_name> <property_key>=<property_value> <property_key>=<property_value> ... --property`

Using the same flag, you can also unset a property just like you would unset a configuration option:

`lxc config unset <instance_name> <property_key> --property`

You can also retrieve a specific property value with:

`lxc config get <instance_name> <property_key> --property`

## Configure devices

Generally, devices can be added or removed for a container while it is running. VMs support hotplugging for some device types, but not all.

See Devices for a list of available device types and their options.

Every device entry is identified by a name unique to the instance.

Devices from profiles are applied to the instance in the order in which the profiles are assigned to the instance. Devices defined directly in the instance configuration are applied last. At each stage, if a device with the same name already exists from an earlier stage, the whole device entry is overridden by the latest definition.

Device names are limited to a maximum of 64 characters.

To add and configure an instance device for your instance, use the lxc config device add command.

Specify the instance name, a device name, the device type and maybe device options (depending on the device type):

`lxc config device add <instance_name> <device_name> <device_type> <device_option_key>=<device_option_value> <device_option_key>=<device_option_value> ...`

For example, to add the storage at /share/c1 on the host system to your instance at path /opt, enter the following command:

```bash
lxc config device add my-container disk-storage-device disk source=/share/c1 path=/opt
```

To configure instance device options for a device that you have added earlier, use the lxc config device set command:

lxc config device set <instance_name> <device_name> <device_option_key>=<device_option_value> <device_option_key>=<device_option_value> ...
