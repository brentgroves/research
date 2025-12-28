# **[nmcli examples](https://www.geeksforgeeks.org/nmcli-command-in-linux-with-examples/)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Networking Menu](../networking_menu.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

## Manage Network Connections From the Linux Command Line with nmcli

Network connectivity is a critical aspect of modern computing, and Linux provides a robust command-line tool for managing network connections: nmcli. Network Manager Command-Line Interface (nmcli) is a powerful and versatile utility that allows users to control and configure network settings directly from the terminal. In this article, we will delve into the syntax, usage, and various capabilities of nmcli for efficient network management on Linux.

## What is nmcli

nmcli is a command-line tool which is used for controlling NetworkManager. nmcli command can also be used to display network device status, create, edit, activate/deactivate, and delete network connections.

Typical Uses:  

- **Scripts:** Instead of manually managing the network connections it utilize NetworkManager via nmcli.
- **Servers, headless machine and terminals:** Can be used to control NetworkManager with no GUI and control system-wide connections.

Syntax of nmcli
The nmcli command follows a specific syntax, enabling users to interact with Network Manager through the command line. The general syntax for nmcli is as follows:

```nmcli [OPTIONS] OBJECT { COMMAND | help }```

Here,

- OPTIONS: Additional options that modify the behavior of nmcli.
- OBJECT: Specifies the target of the operation (e.g., connection, device, etc.).
- COMMAND: Defines the action to be performed on the specified object.
Where the OBJECT can be any one of the following:  

nm: NetworkManager’s status.
connection/cn: NetworkManager’s connection.
d[evice]: devices managed by NetworkManager.

Pratical Implementation of nmcli Command in linux

1. How to View Connections using nmcli

```nmcli connection show```

This command lists all the available network connections on your system. It provides details such as the connection name, UUID, device, type, and status.

![](https://media.geeksforgeeks.org/wp-content/uploads/20240111170108/2024-01-11_17-00.png)

2. How to Check the Device Status using nmcli
To check the device status using nmcli command.

```bash
nmcli dev status
```

This command displays the current status of all network devices on your system. It shows whether each device is connected or disconnected, along with additional information like the device type and the connection type it is associated with.The output might vary with different machines.

3. How to Display Device Details using nmcli
Syntax:

nmcli device show <device_name>
Example:

```bash
ssh brent@repsys11
nmcli device show br-eno1

GENERAL.DEVICE:                         br-eno1
GENERAL.TYPE:                           bridge
GENERAL.HWADDR:                         46:3F:25:E1:B5:9C
GENERAL.MTU:                            1500
GENERAL.STATE:                          100 (connected)
GENERAL.CONNECTION:                     br-eno1
GENERAL.CON-PATH:                       /org/freedesktop/NetworkManager/ActiveConnection/6
IP4.ADDRESS[1]:                         10.1.2.139/22
IP4.GATEWAY:                            10.1.1.205
IP4.ROUTE[1]:                           dst = 10.1.0.0/22, nh = 0.0.0.0, mt = 425
IP4.ROUTE[2]:                           dst = 0.0.0.0/0, nh = 10.1.1.205, mt = 20425
IP4.DNS[1]:                             10.1.2.69
IP4.DNS[2]:                             10.1.2.70
IP4.DNS[3]:                             172.20.0.39
IP4.DOMAIN[1]:                          BUSCHE-CNC.COM
IP6.ADDRESS[1]:                         fe80::4eb4:eadc:ee5f:6055/64
IP6.GATEWAY:                            --
IP6.ROUTE[1]:                           dst = fe80::/64, nh = ::, mt = 1024


nmcli device show localbr
# this does not have dst 0.0.0.0/0 configured with gw like br-eno1 die
# also id does not have dns entries.
GENERAL.DEVICE:                         localbr
GENERAL.TYPE:                           bridge
GENERAL.HWADDR:                         96:BA:9B:E0:41:DA
GENERAL.MTU:                            1500
GENERAL.STATE:                          100 (connected)
GENERAL.CONNECTION:                     localbr
GENERAL.CON-PATH:                       /org/freedesktop/NetworkManager/ActiveConnection/23
IP4.ADDRESS[1]:                         10.1.0.126/22
IP4.GATEWAY:                            --
IP4.ROUTE[1]:                           dst = 10.1.0.0/22, nh = 0.0.0.0, mt = 426
IP6.GATEWAY:                            --

```

Replace “eno1” with the actual name of your network device. This command provides detailed information about the specified network device, including its IP address, MAC address, driver details, and more.

4. How to Add a New Ethernet Conncection using nmcli
To add a new connection, you can use the following command:

Syntax:

```nmcli connection add type <connection_type> ifname <interface_name> con-name <connection_name>```

Here,

- **connection_type:** Specifies the type of connection (e.g., ethernet, wifi).
- **interface_name:** The name of the network interface.
- **connection_name:** A user-defined name for the new connection.

Example:

```nmcli connection add type ethernet ifname eth1 con-name my_eth_connection```

This command creates a new Ethernet connection named “my_eth_connection” associated with the network interface “eth1”. Adjust the interface name and connection name as needed.

![](https://media.geeksforgeeks.org/wp-content/uploads/20240111171142/2024-01-11_17-11.png)

To verify we can use this command “nmcli connection show”

![](https://media.geeksforgeeks.org/wp-content/uploads/20240111171400/2024-01-11_17-13.png)

How to Adjust Connection Settings using nmcli
To modify connection settings, you can use the following command:

Syntax:

```nmcli connection modify <connection_name> <setting_name> <setting_value>```

Here,

- **connection_name:** The name of the connection to be modified.
- **setting_name:** The specific setting to be adjusted.
- **setting_value:** The new value for the setting.

Example:

```nmcli connection modify my_eth_connection ipv4.addresses "192.168.1.2/24" ipv4.gateway "192.168.1.1"```

This example modifies the IPv4 settings of the “my_eth_connection” connection, setting a static IP address of “192.168.1.2” with a subnet mask of “/24” and a gateway of “192.168.1.1”.

Options Available in nmcli Command in Linux

![](|    Options   |                                          Description                                         |
|:------------:|:--------------------------------------------------------------------------------------------:|
|  -t, –terse  |                         Terse output suitable for script processing.                         |
|  -p, –pretty |                          Prints organized and human-readable output.                         |
|   -m, –mode  |     Switches between tabular and multiline output. Defaults to tabular if not specified.     |
|  -f, –fields | Specifies fields to print as output. Use ‘all’ for all fields or ‘common’ for common fields. |
|  -e, –escape |                             Escapes column separators in values.                             |
| -v, –version |                                 Displays version information.                                |
|   -h, –help  |                               Prints help-related information.                               |)

1. -t, –terse option
This option is used to terse the output i.e. when we want the output to be very brief and in very few words. It is suitable for script processing.

Example:

```nmcli -t device list```

![](https://media.geeksforgeeks.org/wp-content/uploads/20190331014522/ooure48.jpg)

4. -f, –fields {fields1, fields2…. |all|common} option
This option is used to specify the fields to print as output. Where the field is the column that we want to print as output. all is used when we want all the value field to be displayed.

To print device list with field GENERAL.

![](https://media.geeksforgeeks.org/wp-content/uploads/20190331015313/ooure51.jpg)
