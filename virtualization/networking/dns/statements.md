# **[Statements](https://bind9.readthedocs.io/en/v9.20.7/reference.html#statements)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Tasks](../../../../../a_status/current_tasks.md)**\
**[Back to Detailed Status](../../../../../a_status/detailed_status.md)**\

**[Back to Main](../../../../../README.md)**

BIND 9 supports many hundreds of statements; finding the right statement to control a specific behavior or solve a particular problem can be a daunting task. To simplify the task for users, all statements have been assigned one or more tags. Tags are designed to group together statements that have broadly similar functionality; thus, for example, all statements that control the handling of queries or of zone transfers are respectively tagged under query and transfer.

DNSSEC Tag Statements are those that relate to or control DNSSEC.

Logging Tag Statements relate to or control logging, and typically only appear in a logging block.

Query Tag Statements relate to or control queries.

Security Tag Statements relate to or control security features.

Server Tag Statements relate to or control server behavior, and typically only appear in a server block.

Transfer Tag Statements relate to or control zone transfers.

View Tag Statements relate to or control view selection criteria, and typically only appear in a view block.

Zone Tag Statements relate to or control zone behavior, and typically only appear in a zone block.

Deprecated Tag Statements are those that are now deprecated, but are included here for historical reference.

The following table lists all statements permissible in named.conf, with their associated tags; the next section groups the statements by tag. Please note that these sections are a work in progress.
