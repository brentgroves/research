# iptables notes


**[Back to Research List](../../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../../README.md)**

## **[command syntax](https://www.linode.com/docs/guides/what-is-iptables/)**

## Using iptables

Building iptables commands

Here are some common command options:

| Option                                  | Functionality                                                                                                                                             |
|-----------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| -t or --table                           | Specifies the packet matching table. Default table is set to filter if no table is specified.                                                             |
| -I or --insert chain [rule-number] rule | Inserts one or more rule(s) to the in the selected chain as the given rule number. Indexing begins with 1.                                                |
| -A or --append chain rule-specification | Appends one or more rule(s) to the list of rules to the end of the selected chain.                                                                        |
| -L or --list [chain]                    | Lists all the rules in the selected chain. If no chain is specified all chains are listed.                                                                |
| -D or --delete chain rule-specification | Deletes one or more rule(s) in the selected chain.                                                                                                        |
| -D or --delete chain rule-number        | Deletes the specified rule in the selected chain. Indexing begins with 1.                                                                                 |
| -p or --protocol [!]                    | The protocol to check (TCP, UDP, icmp, or all). Using the ! argument before the protocol inverts the test.                                                |
| -s or --source [!]                      | The source specification. This can be either a network, hostname, or IP address. Using the ! argument before the source inverts the sense of the address. |
| --destination-port or --dport           | The destination port range.                                                                                                                               |
| -j or --jump target                     | This is the target of the rule and specifies what to do in the case of a match.                                                                           |
| -m or --match match                     | Specifies an extension module that tests for a specific property.                                                                                         |
| -p or --policy chain target             | Sets the policy for the chain to the target.                                                                                                              |
| F or --flush [chain]                    | Flushes the selected chain. If no chain is specified, all chains are flushed. Flushing is akin to deleting all rules one by one.                          |