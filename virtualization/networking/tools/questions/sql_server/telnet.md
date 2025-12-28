# **[Introduction to TELNET](https://www.geeksforgeeks.org/introduction-to-telnet/)**

TELNET stands for Teletype Network. It is a client/server application protocol that provides access to virtual terminals of remote systems on local area networks or the Internet. The local computer uses a telnet client program and the remote computers use a telnet server program. In this article, we will discuss every point about TELNET.

## **What is Telnet?**

TELNET is a type of protocol that enables one computer to connect to the local computer. It is used as a standard **[TCP/IP protocol](https://www.geeksforgeeks.org/tcp-ip-in-computer-networking/)** for virtual terminal service which is provided by **[ISO](https://www.geeksforgeeks.org/iso-full-form/)**. The computer which starts the connection is known as the local computer. The computer which is being connected to i.e. which accepts the connection known as the remote computer. During telnet operation, whatever is being performed on the remote computer will be displayed by the local computer. Telnet operates on a client/server principle.

## History of TELNET

The Telnet protocol originated in the late 1960s, it was created to provide remote terminal access and control over mainframes and minicomputers. Initially, it was designed to be a simple and secure method of connecting to a remote system. This protocol allowed users to access remote computers using a terminal or command-line interface. Over time, Telnet’s use has diminished due to security concerns, and alternatives like SSH are now preferred for secure remote management

## Logging in TELNET

The logging process can be further categorized into two parts:

- Local Login
- Remote Login

1. Local Login
    Whenever a user logs into its local system, it is known as local login.

    ![ll](https://media.geeksforgeeks.org/wp-content/uploads/20230319111951/Local-Login---Telnet.png)

    The Procedure of Local Login:

    - Keystrokes are accepted by the terminal driver when the user types at the terminal.
    - Terminal Driver passes these characters to OS.
    - Now, OS validates the combination of characters and opens the required application.

2. Remote Login

    Remote Login is a process in which users can log in to a remote site i.e. computer and use services that are available on the remote computer. With the help of remote login, a user is able to understand the result of transferring the result of processing from the remote computer to the local computer.

    ![rl](https://media.geeksforgeeks.org/wp-content/uploads/20230314171443/Remote-login.png)

    The Procedure of Remote Login
    - When the user types something on the local computer, the local operating system accepts the character.
    - The local computer does not interpret the characters, it will send them to the TELNET client.
    - TELNET client transforms these characters to a universal character set called Network Virtual Terminal (NVT) characters and it will pass them to the local TCP/IP protocol Stack.
    - Commands or text which are in the form of NVT, travel through the Internet and it will arrive at the TCP/IP stack at the remote computer.
    - Characters are then delivered to the operating system and later on passed to the TELNET server.
    - Then TELNET server changes those characters to characters that can be understandable by a remote computer.
    - The remote operating system receives characters from a pseudo-terminal driver, which is a piece of software that pretends that characters are coming from a terminal.
    - The operating system then passes the character to the appropriate application program.

## Network Virtual Terminal(NVT)

NVT (Network Virtual Terminal) is a virtual terminal in TELNET that has a fundamental structure that is shared by many different types of real terminals. NVT (Network Virtual Terminal) was created to make communication viable between different types of terminals with different operating systems.

![nvt](https://media.geeksforgeeks.org/wp-content/uploads/20230314171626/nvt-telnet.png)

## How TELNET Works?

### Client-Server Interaction

The Telnet client initiates the connection by sending requests to the Telnet server.
Once the connection is established, the client can send commands to the server.
The server processes these commands and responds accordingly.

### Character Flow

- When the user types on the local computer, the local operating system accepts the characters.
- The Telnet client transforms these characters into a universal character set called Network Virtual Terminal (NVT) characters.
- These NVT characters travel through the Internet to the remote computer via the local TCP/IP protocol stack.
- The remote Telnet server converts these characters into a format understandable by the remote computer.
- The remote operating system receives the characters from a pseudo-terminal driver and passes them to the appropriate application program3.

### TELNET Commands

Commands of Telnet are identified by a prefix character, Interpret As Command (IAC) with code 255. IAC is followed by command and option codes. The basic format of the command is as shown in the following figure :

![tc](https://media.geeksforgeeks.org/wp-content/uploads/20200810202530/format-300x64.png)

### **[How to use telnet to test connectivity to TCP ports](https://netbeez.net/blog/telnet-to-test-connectivity-to-tcp/)**

Telnet is a network command that enables its users to access the command prompt of a remote computer or network device. Network and system administrators use this application to configure and administer network devices such as servers, routers, switches, etc.

### Using telnet: syntax

The telnet command is accessible via a computer’s command line interface. For most users there’s no need for installing telnet as this command is preloaded in many operating systems. The telnet command syntax is the following:

```bash
telnet hostname_or_IP_address [ non_standard_port_used ]

telnet PD-AVI-SQL01 1433
```

By default, a telnet server listens on port TCP 23 for incoming connections from clients. For this reason, only the host parameter is mandatory. The port number is optional for remote computers that use the default port. However, if you want to test connectivity to a remote service using port 20011 on host test.netbeez.net, you’ll have to type:

`telnet netbeez.net 20011`

### Telnet limits and use cases

The telnet network protocol is based on the Transmission Control Protocol (TCP), which is connection-oriented. The telnet protocol doesn’t encrypt traffic. As a result, the information exchanged between a client and server is unencrypted. For this reason, in the last years, the Secure Shell command (SSH) replaced telnet for connecting to remote systems. In fact, SSH uses the Secure Socket Layer (SSL) protocol.

Although telnet is rarely used for remote administration purposes, the telnet client is still widely used to verify connectivity to remote services that are based on TCP. In a client-server model architecture, you can use a telnet client to make sure that no firewalls in between are blocking incoming connections to the server.

![fw](https://netbeez.net/wp-content/uploads/2018/06/Screen-Shot-2018-06-13-at-1.29.42-PM-1024x486.png)

As we’ll see in the next paragraphs, there are three possible outcomes when using telnet:

- There are no firewalls blocking the connection from the client to the server.
- There are firewalls explicitly rejecting the connection from the client to the server.
- There are firewalls silently dropping connections from the client to the server.

### Successful telnet

If the service is running with no firewalls in-between blocking incoming connections, the telnet command will return the following prompt:

![ts](https://netbeez.net/wp-content/uploads/2018/06/Screen-Shot-2018-06-13-at-1.32.59-PM-e1677150338190.png)

As you can see, the telnet command line interface returns the resolved IP address associated to the provided hostname, and give notice of the escape character ‘SHIFT ]’ that can be used to terminate the connection and resume the telnet prompt.

### Refused telnet connection

Let’s see what happens when a firewall in between is rejecting connections:

![cf](https://netbeez.net/wp-content/uploads/2018/06/Screen-Shot-2018-06-13-at-1.36.01-PM-e1677150329684.png)

In this case, the prompt telnet is returning the message “Connection refused” to communicate to the user that a firewall is blocking connections to the specified TCP port on the remote host.

### Unsuccessful telnet connection

When troubleshooting client connectivity issues to a TCP service, another possible scenario is the following:

![utc](https://netbeez.net/wp-content/uploads/2018/06/Screen-Shot-2018-06-13-at-1.38.35-PM-e1677150317499.png)

In this other scenario, the telnet prompt is not returning any message. This case is more difficult to troubleshoot because it could be either that:

1) a network or host firewall is dropping incoming connections
2) the remote host is down or the telnet server is not running
3) network connectivity between the client and server is unavailable for some reason.

In this case, you can troubleshoot to see if you find more information. In some case, you can test with a TCP traceroute where the connection fails. You can also get in touch with the administrator of the remote host to ask if they allow telnet connections.

Before concluding this post, I would like to explain two important concepts related to firewalls …

### Difference between host firewalls and network firewalls

A host firewall runs on a computer, or server, to block or allow incoming connections to specific local services. The goal of such firewall is to protect the host itself where the firewall is running. Most modern operating systems, like Windows, Mac, or Linux, have available such a service.

A network firewall is a dedicated device that is installed on a specific network segment to protect one or more private networks that reside behind it. Network firewalls are sophisticated appliances that can inspect a large amount of throughput data adding little delay.

### Difference between reject and drop in firewall configurations

Firewalls can block connections via two methods: reject or drop. When a connection is rejected, the firewall tells the source that the destination host is not allowing incoming connections to specific port(s).

The second method is to silently drop the packets, acting as if the host is unreachable. As I described earlier, since this method is more difficult to troubleshoot, it’s more appropriate to slow down hostile users that are scanning a network in the hopes of finding vulnerabilities to exploit. For this reason, it’s a good idea to configure internal firewalls with reject rules and external ones, while facing public networks with drop rules.

## Conclusion

Telnet is a network protocol that once used to connect to a remote computer or device. Its lack of encryption caused SSH to replace telnet for accessing . However, there are several other use cases for which telnet is still a much needed tool. For instance, users can determine if a remote TCP port is reachable, unreachable, or blocked by firewalls.

A network performance monitoring tool like NetBeez is capable of automating telnet tests thanks to its continuous testing capabilities. If you are a network administrator that needs to periodically verify TCP/IP ports availability, but also monitor network performance and uptime, request a demo or a free trial to see how NetBeez works. NetBeez is capable of automating telnet checks and do much more.
