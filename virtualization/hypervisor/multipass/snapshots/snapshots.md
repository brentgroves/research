# **[Snapshot](https://canonical.com/multipass/docs/snapshot)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

## reference

- **[snapshot](https://discourse.ubuntu.com/t/multipass-snapshot-command/39755)**

A snapshot is an conceptual image of an instance at some point in time, that can be used to restore the instance to what it was at that instant.

To achieve this, a snapshot records all mutable properties of an instance, that is, all the properties that can change through interaction with Multipass. These include disk contents and size, number of CPUs, amount of memory, and mounts. On the other hand, aliases are not considered part of the instance and are not recorded.