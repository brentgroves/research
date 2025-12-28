# **[Delete an instance](https://docs.openstack.org/ocata/user-guide/cli-delete-an-instance.html)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Tasks](../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../README.md)**

When you no longer need an instance, you can delete it.

List all instances:

```bash
source demo-openrc

openstack server list
+-------------+----------------------+--------+------------+-------------+------------------+------------+
| ID          | Name                 | Status | Task State | Power State | Networks         | Image Name |
+-------------+----------------------+--------+------------+-------------+------------------+------------+
| 84c6e57d... | myCirrosServer       | ACTIVE | None       | Running     | private=10.0.0.3 | cirros     |
| 8a99547e... | myInstanceFromVolume | ACTIVE | None       | Running     | private=10.0.0.4 | ubuntu     |
| d7efd3e4... | newServer            | ERROR  | None       | NOSTATE     |                  | centos     |
+-------------+----------------------+--------+------------+-------------+------------------+------------+
```

Run the openstack server delete command to delete the instance. The following example shows deletion of the newServer instance, which is in ERROR state:

```bash
openstack server delete newServer
```

The command does not notify that your server was deleted.

To verify that the server was deleted, run the openstack server list command:

```bash
openstack server list

+-------------+----------------------+--------+------------+-------------+------------------+------------+
| ID          | Name                 | Status | Task State | Power State | Networks         | Image Name |
+-------------+----------------------+--------+------------+-------------+------------------+------------+
| 84c6e57d... | myCirrosServer       | ACTIVE | None       | Running     | private=10.0.0.3 | cirros     |
| 8a99547e... | myInstanceFromVolume | ACTIVE | None       | Running     | private=10.0.0.4 | ubuntu     |
+-------------+----------------------+--------+------------+-------------+------------------+------------+
```

The deleted instance does not appear in the list.
