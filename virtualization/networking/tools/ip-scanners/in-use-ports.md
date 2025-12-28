# **[How to check if port is in use in](https://www.cyberciti.biz/faq/unix-linux-check-if-port-is-in-use-command/)**

To check the listening ports and applications on Linux:

Open a terminal application i.e. shell prompt.
Run any one of the following command on Linux to see open ports:

```bash
sudo lsof -i -P -n | grep LISTEN
sudo netstat -tulpn | grep LISTEN
sudo ss -tulpn | grep LISTEN
sudo lsof -i:22 ## see a specific port such as 22 ##
sudo nmap -sTU -O IP-address-Here
```

For the latest version of Linux use the ss command. For example, ss -tulw
Let us see commands and its output in details.

## Viewing the Internet network services list

The /etc/services is a text file mapping between human-friendly textual names for internet services and their underlying assigned port numbers and protocol types. Use the cat command or more command/less command to view it:
less /etc/services
**OR**
more /etc/services

## remote in-use ports

To check in-use ports on a remote Linux system using the command line, you can use the "nmap" command, which is a powerful network scanning tool that allows you to scan for open ports on a remote host; to check specific ports, simply add the port number after the target IP address.
Basic syntax:
Code

```bash
nmap [target_ip_address] -p [port_number] 
```

pd-avi-sql01

## **[HOWTO: check the connectivity to a Microsoft SQL Server database for Ivanti Workspace Control datastore connection](https://forums.ivanti.com/s/article/HOWTO-check-the-connectivity-to-a-Microsoft-SQL-Server-database?language=en_US)**

### How To - Answer

There are two different ways to verify Microsoft SQL server database connectivity: Telnet and ODBC.

## 1. Telnet

Start a command prompt on the client and check if it is possible to setup a Telnet connection to the Microsoft SQL Server with the command:

```bash
telnet [sql server name] 1433
```

1) a network or host firewall is dropping incoming connections
2) the sql service is not running

If this is successful, a Telnet prompt will be started. If not, a connection error will occur.

If the port number of the Microsoft SQL-listener is changed, change 1433 to the different port number.

## 2. ODBC

Create an ODBC entry on the client to the Microsoft SQL Server.

Control Panel > Administrative Tools > Data sources (ODBC)

Client configuration: TCP/IP
Port Number: 1433 (default)

Test configuration, this must be OK!
