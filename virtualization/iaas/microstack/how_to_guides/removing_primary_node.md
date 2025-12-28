# **[Removing the primary node](https://canonical.com/microstack/docs/removing-primary)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Tasks](../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../README.md)**

Removing the primary node refers to the removal of the initial (bootstrap) node.

Warning: Removing the primary node will destroy the entire MicroStack deployment.

If the deployment consists of multiple nodes then remove all non-primary nodes before removing the primary node. See page Scaling down the cluster for instructions on doing that.

## Remove components from the node

Software components need to removed from the node. Perform all the below steps on the primary node.

Remove the Juju model:

```bash
juju destroy-model --destroy-storage --no-prompt --force --no-wait openstack
```

Remove the Juju controller:

```bash
juju destroy-controller --no-prompt --destroy-storage  --force --no-wait sunbeam-controller
```

Remove the Juju agent:

```bash
sudo /sbin/remove-juju-services
```

Remove the juju snap:

```bash
sudo snap remove --purge juju
```

Remove Juju configuration:

```bash
rm -rf ~/.local/share/juju
sudo rm -rf /var/lib/juju/dqlite
sudo rm -rf /var/lib/juju/system-identity
sudo rm -rf /var/lib/juju/bootstrap-params
```

Remove the openstack-hypervisor and openstack snaps:

```bash
sudo snap remove --purge openstack-hypervisor
sudo snap remove --purge openstack
```

Remove openstack snap configuration:

```bash
rm -rf ~/.local/share/openstack
```
