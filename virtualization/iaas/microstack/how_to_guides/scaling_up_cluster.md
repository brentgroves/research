# **[Scaling up the cluster](https://canonical.com/microstack/docs/scaling-up)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Tasks](../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../README.md)**

Scaling up the cluster refers to the addition of cluster members.

## Create a registration token

A registration token is needed before adding a new member. Do this by accessing an existing cluster member and running the cluster add command against the FQDN of the new node:

```bash
sunbeam cluster add --name <new_machine_fqdn>
```

Clustering does not support base hostnames. A node is only known by their FQDN.

Keep the token in a safe place. It will be used in a future step.

## Provision the new machine

Several steps are needed to provision the new machine.

## Install the openstack snap

You will need to install the openstack snap on the new machine in order to perform various commands:

```bash
sudo snap install openstack --channel <channel>
```

The snap channel must be common across all cluster members.

## Install cloud software

Install cloud software on the new machine with the following command:

```bash
sunbeam prepare-node-script | bash -x
```

## Join the machine to the cluster

On the new machine, join it to the cluster by using the cluster join command. Refer to the registration token obtained earlier:

```bash
sunbeam cluster join [--role <role> [--role <role>...]] --token <registration_token>
```

Multiple roles can be selected per node. Available role values are ‘control’, ‘compute’, and ‘storage’. If unstated, the role defaults to a combination of ‘control’ and ‘compute’.

## Resize the cluster

After having joined the node, the cluster needs to be resized with the cluster resize command. This command can be invoked on an existing node or the new
node:

```bash
sunbeam cluster resize
```

If multiple nodes are to be added, you can join all nodes first and resize the cluster once. This can save a significant amount of processing time.
