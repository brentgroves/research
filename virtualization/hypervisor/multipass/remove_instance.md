# **[remove instance](https://multipass.run/docs/remove-an-instance)**

## Stop the instance

```multipass stop microk8s-vm```

## How to remove an instance

To mark an instance as deleted, run:

```multipass delete microk8s-vm```

Now, if you list the instances, you will see that it is actually just marked for deletion (or to put it in other words, moved to the recycle bin):

```bash
multipass list
Name                    State             IPv4             Image
microk8s-vm             Deleted           --               Ubuntu 24.04 LTS
test1                   Running           10.127.233.173   Ubuntu 24.04 LTS
                                          10.1.0.128
test2                   Running           10.127.233.24    Ubuntu 24.04 LTS
                                          10.13.31.201
```

You can move all instances to the recycle bin at once using the --all option:

```multipass delete --all```

Instances that have been marked as deleted can later be recovered:

```bash
$ multipass recover keen-yak
$ multipass list
Name                    State             IPv4             Release
keen-yak                STOPPED           --               Ubuntu 18.04 LTS
```

If you want to get rid of all instances in the ‘recycle bin’ for good, you must purge them:

```bash
$ multipass delete keen-yak
$ multipass purge
$ multipass list
No instances found.
```

The purge command does not take an argument. It will permanently remove all instances marked as deleted.

In order to permanently remove only one instance in a single command, you can use:

```multipass delete --purge keen-yak```
