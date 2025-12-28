# **[Using Masquerading with Iptables for Network Address Translation (NAT)](https://www.geeksforgeeks.org/using-masquerading-with-iptables-for-network-address-translation-nat/)**

**[Research List](../../../../../../research_list.md)**\
**[Detailed Status](../../../../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../../../../a_status/current_tasks.md)**\

**[Main](../../../../../../../README.md)**

This article talks about using Network Address Translation (NAT) with Masquerading using Iptables in a simple way. NAT with Masquerading helps Linux administrators efficiently share one public IP address among multiple devices on a local network. Iptables is a powerful tool in Linux for configuring packet filter rules. The article explains the concept of masquerading, which involves enabling IP forwarding and creating masquerading rules with iptables.

## What is Network Address Translation (NAT)?

Network Address Translation (NAT) is a handy technique in Linux that allows multiple devices to share a single public IP address for internet connectivity. In this guide, we'll use the powerful tool 'iptables' to set up NAT with Masquerading, making it easy for Linux administrators to share internet access among devices on a local network.

Using Masquerading with iptables for Network Address Translation (NAT)
so, here we listed all the steps how we can perform this task Using Masquerading with iptables for Network Address Translation (NAT)

Step 1 : Open Terminal

To begin, make sure to enable IP forwarding on Linux. Open the /etc/sysctl.conf file using a text editor like nano or vi.

`sudo nano /etc/sysctl.conf`

## Step 2: Apply Changes

After modifying the sysctl.conf file, you need to apply the changes using sudo sysctl -p. This command reloads the sysctl settings, making sure that the changes to enable IP forwarding take effect.

`sudo sysctl -p`

## Step 3: Add Masquerading Rule to POSTROUTING Chain -

In this step, a rule is added to the POSTROUTING chain of the NAT table. This rule utilizes the MASQUERADE target to dynamically modify the source IP address of outgoing packets. This modification ensures that multiple devices in the local network appear to have the same public IP address when communicating over the internet.

`sudo iptables -t nat -A POSTROUTING -j MASQUERADE`

## Step 4: Specify Masquerading for a Specific Interface

`sudo iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o eth1 -j MASQUERADE`

The POSTROUTING rule is further customized in this step by specifying a particular interface (eth1) and a source IP address range (192.168.1.0/24). This rule ensures that only traffic from the specified source IP address range going out through the specified interface undergoes masquerading.

This rule helps in network address translation (NAT) by altering the source address of the outgoing packets to match the IP address of the eth1 interface.

## Step 5: Specify Source IP Address

This step allows customization of the source IP address used in masquerading. By using the --to-source option followed by a specific IP address (203.0.113.1 in this example), you can modify the source IP address of outgoing packets to match the specified address.

`$ sudo iptables -t nat -A POSTROUTING -o eth0 --to-source 203.0.113.1 -j MASQUERADE`

## Step 6: Exclude Destination Address Range

Excluding a range of destination IP addresses from masquerading is useful in situations where you want to maintain direct communication with specific IP addresses without the masquerading process. This step involves setting up a rule in the PREROUTING chain to identify packets with excluded destination addresses and mark them.

`$ sudo iptables -t nat -A PREROUTING -d 203.0.113.0/24 -j MARK --set-mark 1`

## Step 7: Exclude IP Address Range

Continuing from the previous step, this step completes the exclusion process. A rule in the POSTROUTING chain skips packets with the marked destination addresses, ensuring that masquerading is not applied to them. This allows for a more tailored approach to address requirements.

`$ sudo iptables -t nat -A POSTROUTING -o eth0 -m mark ! --mark 1 -j MASQUERADE`

-t nat: Specifies the table as NAT.
-A POSTROUTING: Appends the rule to the POSTROUTING chain.
-o eth0: Specifies the output interface as eth0.
-m mark ! --mark 1: Matches packets that do not have the mark value 1.
-j MASQUERADE: Specifies the target action as masquerade.
