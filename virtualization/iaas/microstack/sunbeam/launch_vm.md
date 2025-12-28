# **[Launch a VM (Virtual Machine)](https://www.turbogeek.co.uk/virtual-machine-vm-hypervisor-host-with-sunbeam-on-openstack-ubuntu-debian/)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Tasks](../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../README.md)**

To launch a virtual machine (VM) with Sunbeam, you’ll use the openstack command-line tool. Here’s how you can do it:

Source the OpenRC file: This will load the necessary environment variables for OpenStack interaction.

```Bash
source demo-openrc

openstack image list
+--------------------------------------+--------+--------+
| ID                                   | Name   | Status |
+--------------------------------------+--------+--------+
| 0612a4f2-f3a0-4cab-945d-658bb65026eb | ubuntu | active |
+--------------------------------------+--------+--------+
+--------------------------------------+------+--------
openstack image show ubuntu
brent@research01:~$ openstack image show ubuntu
+------------------+-------------------------------------------------------------------------------------------------------------------------------------+
| Field            | Value                                                                                                                               |
+------------------+-------------------------------------------------------------------------------------------------------------------------------------+
| checksum         | de55990c985b25704c1daf8a55aed45b                                                                                                    |
| container_format | bare                                                                                                                                |
| created_at       | 2025-06-11T19:40:38Z                                                                                                                |
| disk_format      | qcow2                                                                                                                               |
| file             | /v2/images/0612a4f2-f3a0-4cab-945d-658bb65026eb/file                                                                                |
| id               | 0612a4f2-f3a0-4cab-945d-658bb65026eb                                                                                                |
| min_disk         | 0                                                                                                                                   |
| min_ram          | 0                                                                                                                                   |
| name             | ubuntu                                                                                                                              |
| owner            | 017e63a26d604d9ab1978173ee61de5b                                                                                                    |
| properties       | architecture='x86_64', hw_firmware_type='uefi', hypervisor_type='qemu', os_hash_algo='sha512', os_hash_value='0e32aeb72d4f730b10e1b |
|                  | 6a29ed8d171412dfacd5796093f1aebc7d10fa23a5c4f344867832147d4faeb8663d72628ea1aa55dbdb4baffdcfc63f87bc40f9ce2', os_hidden='False',    |
|                  | stores='filestore'                                                                                                                  |
| protected        | False                                                                                                                               |
| schema           | /v2/schemas/image                                                                                                                   |
| size             | 613725184                                                                                                                           |
| status           | active                                                                                                                              |
| tags             |                                                                                                                                     |
| updated_at       | 2025-06-11T19:41:17Z                                                                                                                |
| virtual_size     | 3758096384                                                                                                                          |
| visibility       | public                                                                                                                              |
+------------------+-------------------------------------------------------------------------------------------------------------------------------------+
brent@research01:~$ 

openstack flavor list
```

Create a Keypair (optional): This allows you to securely access your VM later.

```Bash
source demo-openrc

openstack keypair create mykey > mykey.pem 
chmod 600 mykey.pem 
openstack server ssh command: openstack server ssh --login cloud-user --identity ~/.ssh/<keypair>.pem --private <instance>. 

openstack server ssh --login cloud-user --identity ~/.ssh/<keypair>.pem --private <instance>. 
```

Launch the VM:

```Bash
openstack network list
+--------------------------------------+------------------+--------------------------------------+
| ID                                   | Name             | Subnets                              |
+--------------------------------------+------------------+--------------------------------------+
| 2c292b89-238e-4331-a068-348f817d0c7f | external-network | ab87de2b-55c0-4a7e-a3d9-e98341936f01 |
| cec0a529-1065-4943-8bb2-eead33b22527 | demo-network     | 419c9545-6292-4c9a-a8d2-cb43a984fafa |
+--------------------------------------+------------------+--------------------------------------+

# openstack server create --flavor m1.small --image ubuntu-22.04 \ --network private --key-name mykey myvm 

# openstack server create --flavor m1.tiny --image ubuntu \ --network demo-network --key-name mykey myvm 

openstack server create --flavor m1.tiny --image ubuntu --key-name mykey myvm 

+--------------------------------------+------------------------------------------------+
| Field                                | Value                                          |
+--------------------------------------+------------------------------------------------+
| OS-DCF:diskConfig                    | MANUAL                                         |
| OS-EXT-AZ:availability_zone          |                                                |
| OS-EXT-STS:power_state               | NOSTATE                                        |
| OS-EXT-STS:task_state                | scheduling                                     |
| OS-EXT-STS:vm_state                  | building                                       |
| OS-SRV-USG:launched_at               | None                                           |
| OS-SRV-USG:terminated_at             | None                                           |
| accessIPv4                           |                                                |
| accessIPv6                           |                                                |
| addresses                            |                                                |
| adminPass                            | Xsp48yJZRQwp                                   |
| config_drive                         |                                                |
| created                              | 2025-06-12T17:39:11Z                           |
| flavor                               | m1.tiny (0ff82c08-343e-49a6-b07d-abdeea35ad33) |
| hostId                               |                                                |
| id                                   | fa3f7bec-70b9-46fa-9742-581b79bdbebc           |
| image                                | ubuntu (0612a4f2-f3a0-4cab-945d-658bb65026eb)  |
| key_name                             | mykey                                          |
| name                                 | myvm                                           |
| os-extended-volumes:volumes_attached | []                                             |
| progress                             | 0                                              |
| project_id                           | a6fac509ed3148e38222d19bd0d38ab0               |
| properties                           |                                                |
| security_groups                      | name='default'                                 |
| status                               | BUILD                                          |
| updated                              | 2025-06-12T17:39:12Z                           |
| user_id                              | 61caac148b2e4f66bc23f9d0af424742               |
+--------------------------------------+------------------------------------------------+

```

Check VM Status:

```Bash
openstack server list 
+--------------------------------------+------+--------+----------------------------+--------+---------+
| ID                                   | Name | Status | Networks                   | Image  | Flavor  |
+--------------------------------------+------+--------+----------------------------+--------+---------+
| fa3f7bec-70b9-46fa-9742-581b79bdbebc | myvm | ACTIVE | demo-network=192.168.0.126 | ubuntu | m1.tiny |
+--------------------------------------+------+--------+----------------------------+--------+---------+
```

Look for your VM in the list. Its status should change from “BUILD” to “ACTIVE.”
Get VM IP Address:

```Bash
openstack server show test
+-------------------------------------+------------------------------------------------------------------------------------------------------------------+
| Field                               | Value                                                                                                            |
+-------------------------------------+------------------------------------------------------------------------------------------------------------------+
| OS-DCF:diskConfig                   | MANUAL                                                                                                           |
| OS-EXT-AZ:availability_zone         | nova                                                                                                             |
| OS-EXT-SRV-ATTR:host                | None                                                                                                             |
| OS-EXT-SRV-ATTR:hostname            | test                                                                                                             |
| OS-EXT-SRV-ATTR:hypervisor_hostname | None                                                                                                             |
| OS-EXT-SRV-ATTR:instance_name       | None                                                                                                             |
| OS-EXT-SRV-ATTR:kernel_id           | None                                                                                                             |
| OS-EXT-SRV-ATTR:launch_index        | None                                                                                                             |
| OS-EXT-SRV-ATTR:ramdisk_id          | None                                                                                                             |
| OS-EXT-SRV-ATTR:reservation_id      | None                                                                                                             |
| OS-EXT-SRV-ATTR:root_device_name    | None                                                                                                             |
| OS-EXT-SRV-ATTR:user_data           | None                                                                                                             |
| OS-EXT-STS:power_state              | Running                                                                                                          |
| OS-EXT-STS:task_state               | None                                                                                                             |
| OS-EXT-STS:vm_state                 | active                                                                                                           |
| OS-SRV-USG:launched_at              | 2025-06-11T19:48:02.000000                                                                                       |
| OS-SRV-USG:terminated_at            | None                                                                                                             |
| accessIPv4                          |                                                                                                                  |
| accessIPv6                          |                                                                                                                  |
| addresses                           | demo-network=172.16.2.39, 192.168.0.166                                                                          |
| config_drive                        |                                                                                                                  |
| created                             | 2025-06-11T19:47:09Z                                                                                             |
| description                         | None                                                                                                             |
| flavor                              | description=, disk='4', ephemeral='0', , id='m1.tiny', is_disabled=, is_public='True', location=,                |
|                                     | name='m1.tiny', original_name='m1.tiny', ram='512', rxtx_factor=, swap='0', vcpus='1'                            |
| hostId                              | 6be06fdbd7ace8a224a1587d4ca026ff98263b8333a944346c471cc6                                                         |
| host_status                         | None                                                                                                             |
| id                                  | 70842ca8-5296-499e-88cd-dd7f3ee1899e                                                                             |
| image                               | ubuntu (0612a4f2-f3a0-4cab-945d-658bb65026eb)                                                                    |
| key_name                            | sunbeam                                                                                                          |
| locked                              | False                                                                                                            |
| locked_reason                       | None                                                                                                             |
| name                                | test                                                                                                             |
| progress                            | 0                                                                                                                |
| project_id                          | a6fac509ed3148e38222d19bd0d38ab0                                                                                 |
| properties                          |                                                                                                                  |
| security_groups                     | name='default'                                                                                                   |
| server_groups                       | []                                                                                                               |
| status                              | ACTIVE                                                                                                           |
| tags                                |                                                                                                                  |
| trusted_image_certificates          | None                                                                                                             |
| updated                             | 2025-06-11T19:48:03Z                                                                                             |
| user_id                             | 61caac148b2e4f66bc23f9d0af424742                                                                                 |
| volumes_attached                    |                                                                                                                  |
+-------------------------------------+------------------------------------------------------------------------------------------------------------------+

# openstack server show myvm | grep -i addresses
openstack server show test | grep -i addresses
```
