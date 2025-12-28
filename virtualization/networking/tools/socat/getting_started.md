# **[Getting started with socat, a multipurpose relay tool for Linux](https://www.redhat.com/en/blog/getting-started-socat)**

**[Back to Research List](../../research_list.md)**\
**[Back to Current Tasks](../../../a_status/current_tasks.md)**\
**[Back to Main](../../../README.md)**

The **[socat](https://linux.die.net/man/1/socat)** utility is a relay for bidirectional data transfers between two independent data channels.

There are many different types of channels socat can connect, including:

- Files
- Pipes
- Devices (serial line, pseudo-terminal, etc)
- Sockets (UNIX, IP4, IP6 - raw, UDP, TCP)
- SSL sockets
- Proxy CONNECT connections
- File descriptors (stdin, etc)
- The GNU line editor (readline)
- Programs
- Combinations of two of these

This tool is regarded as the advanced version of **[netcat](https://linux.die.net/man/1/nc)**. They do similar things, but socat has more additional functionality, such as permitting multiple clients to listen on a port, or reusing connections.

## Why do we need socat?

There are many ways to use socate effectively. Here are a few examples:

- TCP port forwarder (one-shot or daemon)
- External socksifier
- Tool to attack weak firewalls (security and audit)
- Shell interface to Unix sockets
- IP6 relay
- Redirect TCP-oriented programs to a serial line
- Logically connect serial lines on different computers
- Establish a relatively secure environment (su and chroot) for running client or server shell scripts with network connections

[ Download now: **[A system administrator's guide to automation](https://www.redhat.com/en/engage/system-administrator-guide-s-202107300146?intcmp=701f20000012ngPAAQ)**. ]

## How do we use socat?

The syntax for socat is fairly simple:

`socat [options] <address> <address>`

You must provide the source and destination addresses for it to work. The syntax for these addresses is:

`protocol:ip:port`

## Examples of using socat

Let's get started with some basic examples of using socat for various connections.

1. Connect to TCP port 80 on the local or remote system:

`socat - TCP4:www.example.com:80`

In this case, socat transfers data between STDIO (-) and a TCP4 connection to port 80 on a host named <www.example.com>.

2. Use socat as a TCP port forwarder:

For a single connection, enter:

`socat TCP4-LISTEN:81 TCP4:192.168.1.10:80`

For multiple connections, use the fork option as used in the examples below:

`socat TCP4-LISTEN:81,fork,reuseaddr TCP4:TCP4:192.168.1.10:80`

This example listens on port 81, accepts connections, and forwards the connections to port 80 on the remote host.

`socat TCP-LISTEN:3307,reuseaddr,fork UNIX-CONNECT:/var/lib/mysql/mysql.sock`

The above example listens on port 3307, accepts connections, and forwards the connections to a Unix socket on the remote host.

[ Learn how to manage your Linux environment for success. ]

## 3. Implement a simple network-based message collector

`socat -u TCP4-LISTEN:3334,reuseaddr,fork OPEN:/tmp/test.log,creat,append`

In this example, when a client connects to port 3334, a new child process is generated. All data sent by the clients is appended to the file /tmp/test.log. If the file does not exist, socat creates it. The option reuseaddr allows an immediate restart of the server process.

## 4. Send a broadcast to the local network

`socat - UDP4-DATAGRAM:224.255.0.1:6666,bind=:6666,ip-add-membership=224.255.0.1:eth0`

In this case, socat transfers data from stdin to the specified multicast address using UDP over port 6666 for both the local and remote connections. The command also tells the interface eth0 to accept multicast packets for the given group.

## Practical uses for socat

Socat is a great tool for troubleshooting. It is also handy for easily making remote connections. Practically, I have used socat for remote MySQL connections. In the example below, I demonstrate how I use socat to connect my web application to a remote MySQL server by connecting over the local socket.

1. On my remote MySQL server, I enter:

`socat TCP-LISTEN:3307,reuseaddr,fork UNIX-CONNECT:/var/lib/mysql/mysql.sock &`

This command starts socat and configures it to listen by using port 3307.

## 2. On my webserver, I enter

`socat UNIX-LISTEN:/var/lib/mysql/mysql.sock,fork,reuseaddr,unlink-early,user=mysql,group=mysql,mode=777 TCP:192.168.100.5:3307 &`

The above command connects to the remote server 192.168.100.5 by using port 3307.

However, all communication will be done on the Unix socket /var/lib/mysql/mysql.sock, and this makes it appear to be a local server.

## Wrap up

socat is a sophisticated utility and indeed an excellent tool for every sysadmin to get things done and for troubleshooting. Follow this link to read more **[examples of using socat](http://www.dest-unreach.org/socat/doc/socat.html#EXAMPLES)**.
