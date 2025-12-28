# how to add iptables postrouting rule if docker is running

**[Back to Research List](../../../../../../research_list.md)**\
**[Back to Current Tasks](../../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../../README.md)**

## reference

- **[docker iptable issue](https://github.com/moby/moby/issues/44816)**

AI Overview
To add a POSTROUTING rule in iptables while Docker is running, you need to be mindful of how Docker manages iptables and insert your rules in the appropriate chain. Here's how you can approach it:

Understanding Docker's Interaction with Iptables
Docker Manipulates Iptables: Docker manages iptables rules for networking features like port publishing and NAT. This includes adding MASQUERADE rules in the nat table's POSTROUTING chain.
Docker's Chains: Docker creates custom chains like DOCKER and DOCKER-USER. The DOCKER-USER chain is processed before most of Docker's automatically generated rules. This makes it a good place for custom rules.
Inserting Rules: Use the -I flag to insert rules at the beginning of the chain rather than appending with -A. This ensures rules are processed before Docker's potentially overriding rules.

## Steps to Add a POSTROUTING Rule

- Identify the Target Chain: For a POSTROUTING rule, work within the nat table, inserting the rule into the POSTROUTING chain.
- Construct the iptables Command: Adapt this command structure to your needs:

```bash
sudo iptables -t nat -I POSTROUTING 1 -s <source_network/mask> -j SNAT --to-source <your_external_ip> -m comment --comment "Your unique rule comment"
-t nat: Specifies the nat table.
-I POSTROUTING 1: Inserts the rule as the first rule (position 1) in the POSTROUTING chain.
-s <source_network/mask>: Specifies the source network the rule applies to (e.g., your Docker container network range).
-j SNAT --to-source <your_external_ip>: Uses the SNAT target to change the source IP address to your external IP address.
-m comment --comment "Your unique rule comment": Adds a comment to the rule for easier identification and management.
Execute the Command: Run the command on your host machine to add the rule. 
ljk
```

## iptables list docker rules

AI Overview
To list the iptables rules that Docker creates, you can use the following commands:

1. List all iptables rules:
Code

sudo iptables -L -v
This command will display all rules in all chains.
2. List rules for a specific chain:
Docker primarily uses the FORWARD chain and creates its own chains like DOCKER and DOCKER-USER. To view rules in a specific chain, use:
Code

sudo iptables -L FORWARD -v
sudo iptables -L DOCKER -v
sudo iptables -L DOCKER-USER -v
3. List NAT rules:
Docker uses the nat table for port forwarding. To view these rules:
Code

sudo iptables -t nat -L -v
4. List rules with line numbers:
To see the rules with line numbers, which can be useful for deleting or modifying specific rules, use:
Code

sudo iptables -L -v --line-numbers
or
Code

sudo iptables -t nat -L -v --line-numbers
Key Docker Chains:
DOCKER:
This chain contains the main rules created by Docker for container networking. It should not be manually modified.
DOCKER-USER:
This chain is intended for users to add their own custom rules that will be loaded before Docker's rules.
FORWARD:
Docker adds rules to the FORWARD chain to allow traffic between containers and the outside world.
Important Notes:
Docker manages its own iptables rules, and it's generally not recommended to modify the DOCKER chain directly. If you need to add custom rules, use the DOCKER-USER chain to avoid conflicts with Docker's configuration.
Docker uses the nat table for port forwarding, so make sure to check that table if you're having issues with port access.
The -v flag provides verbose output, showing more details about each rule.
The -L flag lists the rules in a chain or all chains.
The --line-numbers flag shows the rules with line numbers.
The -t <table-name> flag specifies the table to list rules from (e.g., nat, filter).
