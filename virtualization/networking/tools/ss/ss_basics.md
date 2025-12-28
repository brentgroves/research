# **[How To Use Linux SS Command](https://phoenixnap.com/kb/ss-command)**

**[Back to Research List](../../../../../research_list.md)**\
**[Back to Current Tasks](../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../README.md)**

## reference

- **[ss](vhttps://www.cyberciti.biz/tips/linux-investigate-sockets-network-connections.html)**

![f](https://media.beehiiv.com/cdn-cgi/image/fit=scale-down,format=auto,onerror=redirect,quality=80/uploads/asset/file/9ba5ca1d-95a9-487c-833c-c91fb8cdfc49/ip-header-2021-1024x505.png)

The ss (socket statistics) tool is a CLI command used to show network statistics. The ss command is a simpler and faster version of the now obsolete netstat command. Together with the ip command, ss is essential for gathering network information and troubleshooting network issues.

## Prerequisites

- Access to a terminal or command line
- Installed iproute2 software package

## Linux ss Command Examples

The basic ss command usage is without any parameters:

`ss`

![i1](https://phoenixnap.com/kb/wp-content/uploads/2021/04/ss-command-example.png)

The columns show the following details:

- Netid – Type of socket. Common types are TCP, UDP, u_str (Unix stream), and u_seq (Unix sequence).
- State – State of the socket. Most commonly ESTAB (established), UNCONN (unconnected), LISTEN (listening).
- Recv-Q – Number of received packets in the queue.
- Send-Q – Number of sent packets in the queue.
- Local address:port – Address of local machine and port.
- Peer address:port – Address of remote machine and port.

For a more detailed output, add options to the ss command:

`ss <options>`

Or list the options individually:

`ss <option 1> <option 2> <option 3>`

Note: There are many **[Linux CLI tools for testing the network speed](https://phoenixnap.com/kb/linux-network-speed-test)** if the connection is slow.

## List All Connections

List all listening and non-listening connections with:

`ss -a`

```bash
sudo ss -tulpn | grep 25
netstat -tulpn | grep :25
```

## List Listening Sockets

To display only listening sockets, which are omitted by default, use:

```bash
ss -l
```

![i2](https://phoenixnap.com/kb/wp-content/uploads/2021/04/ss-l-command-example.png)

## List TCP Connections

To list TCP connections, add the -t option to the ss command:

```bash
ss -t
```

![i4](https://phoenixnap.com/kb/wp-content/uploads/2021/04/ss-t-command-example.png)

## List All TCP Connections

Combine the options -a and -t with the ss command to output a list of all the TCP connections:

```bash
ss -at
```

![i4](https://phoenixnap.com/kb/wp-content/uploads/2021/04/ss-at-command-example.png)

## List All Listening TCP Connections

Combine the options -l and -t with the ss command to list all listening TCP connections:

```bash
ss -lt
```

![i5](https://phoenixnap.com/kb/wp-content/uploads/2021/04/ss-lt-command-example.png)

## List Raw Sockets

To list raw sockets, use:

`ss -w`

## List Connections to a Specific IP Address

List connections to a specific destination IP address with:

`ss dst <address>`

For example:

```bash
ss dst 104.21.3.132
```

To show connections to a specific source address, use:

`ss src <addresss>`

For example:

`ss src 192.168.100.2`

![i5](https://phoenixnap.com/kb/wp-content/uploads/2021/04/ss-src-address-command-example.png)

## Check Process IDs

To show process IDs (PID), use:

`ss -p`

## List Summary Statistics

List the summary statistics for connections with:

```bash
ss -s
Total: 1208
TCP:   23 (estab 14, closed 0, orphaned 0, timewait 0)

Transport Total     IP        IPv6
RAW       1         0         1        
UDP       9         7         2        
TCP       23        18        5        
INET      33        25        8        
FRAG      0         0         0 
```
