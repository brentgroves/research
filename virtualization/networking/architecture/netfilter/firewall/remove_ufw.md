# **[Ensure ufw is uninstalled or disabled with nftables](https://www.tenable.com/audits/items/CIS_Debian_Linux_11_v1.0.0_L1_Workstation.audit:f7a714afa0867e8cac5dfa6033af8607)**


**[Back to Research List](../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../README.md)**

## references

- **[Introduction to Netfilter](https://blogs.oracle.com/linux/post/introduction-to-netfilter)**

## Information
Uncomplicated Firewall (UFW) is a program for managing a netfilter firewall designed to be easy to use.

Rationale:

Running both the nftables service and ufw may lead to conflict and unexpected results.

## Solution

Run one of the following commands to either remove ufw or disable ufw
Run the following command to remove ufw:

```bash
# apt purge ufw
```

Run the following command to disable ufw:

```bash
# ufw disable
```