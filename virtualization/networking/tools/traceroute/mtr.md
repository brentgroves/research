# **[](https://www.baeldung.com/linux/mtr-command)**

1. Overview
In this tutorial, we’ll take a look at the mtr command in Linux. The name is a shorthand for My Traceroute, also known as Matt’s Traceroute.

mtr is a networking tool that combines ping and traceroute to diagnose a network. Instead of using both tools separately, we could use only mtr. The purpose of mtr is to analyze the network traffic hop-to-hop using ICMP packets.

## General Usage

Let’s start with a simple example by executing the mtr command for the baeldung.com domain:

```bash
$ mtr -t baeldung.com
                        My traceroute [v0.94]
myhome (192.168.0.7)                          2022-06-08T01:41:48+0700
Keys:   Help   Display mode   Restart statistics   Order of fields   quit
                                     Packets           Pings
Host                                Loss% Snt Last Avg  Best Wrst StDev

1. _gateway                         0.0%  21  4.8  4.7  3.3  12.0 1.9
2. 11.68.93.1                       0.0%  21  12.9 14.5 11.9 22.2 2.7
3. bex-0005-pele.fast.net.id        0.0%  21  19.4 17.6 14.3 27.3 3.5
4. bex-0005-pele.fast.net.id        0.0%  21  21.9 18.2 13.6 33.7 5.0
5. fm-dyn-www-73-22-333.fast.net.id 0.0%  21  16.9 19.1 15.6 35.4 4.9
6. fm-dyn-www-136-22-333.fast.net.i 0.0%  20  24.1 20.5 16.0 41.9 5.8
7. 172.66.40.248                    0.0%  20  16.2 17.4 14.6 22.8 2.3

# virtual router

                                                                      My traceroute  [v0.95]
isdev (10.187.40.24) -> 10.188.50.200 (10.188.50.200)                                                                                    2025-08-18T15:40:51-0400
Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                                                                                                                         Packets               Pings
 Host                                                                                                                  Loss%   Snt   Last   Avg  Best  Wrst StDev
 1. _gateway                                                                                                            0.0%     9    1.0   1.0   0.9   1.2   0.1
 2. 10.188.249.1                                                                                                        0.0%     9    1.2   1.5   1.1   1.8   0.3
 3. 10.188.50.200                                                                                                       0.0%     8    1.1   1.1   0.8   1.6   0.3


# what is _gateway
ping _gateway     
PING _gateway (10.187.40.254) 56(84) bytes of data.
64 bytes from _gateway (10.187.40.254): icmp_seq=1 ttl=255 time=0.809 ms
64 bytes from _gateway (10.187.40.254): icmp_seq=2 ttl=255 time=0.738 ms
64 bytes from _gateway (10.187.40.254): icmp_seq=3 ttl=255 time=0.804 ms
^C

```

The -t option indicates we want to see the output in the curses-based terminal. If we hadn’t used this option, we’d receive output in GUI mode, if possible. The numbers change depending on the network activity. To quit this curses-based terminal, we could press q (quit).

A "curses-based terminal" refers to a text-based interface created using the curses library or its successor, ncurses. These libraries provide a framework for building interactive applications with features like windows, menus, and forms, all within a terminal environment.

There are seven nodes in the output above. The last one has the IP address of the Baeldung server, 172.66.40.248, while the first one is the router. In this case, the lines containing fast.net.id, are ISP nodes.

4. Connectivity Problems
We could experiment with a problematic connection to get some intuition for mtr. Let’s add the line below to /etc/hosts:

0.0.0.0 baeldung.com
Copy
This is to make baeldung.com not accessible from our computer.

Let’s run mtr, same as before:

$ mtr -t baeldung.com
                        My traceroute [v0.94]
myhome (127.0.0.1)                           2022-06-09T03:03:11+0700
Keys:   Help    Display mode    Restart statistics    Order of fields     quit
                                   Packets              Pings
Host                              Loss%  Snt  Last  Avg  Best  Wrst  StDev

1. (waiting for reply)
Copy
This time, we got a different result: waiting for reply. This means we’re not getting anything back.

Next, we can try turning off our Internet connection and run the same command again. This time, the result is also different:

mtr: Failed to resolve host: baeldung.com: Name or service not known
Copy
We can guess where the problems lie based on the different results.

5. Output Columns
To utilize mtr fully, it’s best to understand its output, which can be quite verbose. The values are spread into many columns, but they are not fixed. Let’s take our earlier output as an example:

$ mtr -t baeldung.com
                        My traceroute [v0.94]
myhome (192.168.0.7)                          2022-06-08T01:41:48+0700
Keys:   Help   Display mode   Restart statistics   Order of fields   quit
                                     Packets           Pings
Host                                Loss% Snt Last Avg  Best Wrst StDev

1. _gateway                         0.0%  21  4.8  4.7  3.3  12.0 1.9
2. 11.68.93.1                       0.0%  21  12.9 14.5 11.9 22.2 2.7
3. bex-0005-pele.fast.net.id        0.0%  21  19.4 17.6 14.3 27.3 3.5
4. bex-0005-pele.fast.net.id        0.0%  21  21.9 18.2 13.6 33.7 5.0
5. fm-dyn-www-73-22-333.fast.net.id 0.0%  21  16.9 19.1 15.6 35.4 4.9
6. fm-dyn-www-136-22-333.fast.net.i 0.0%  20  24.1 20.5 16.0 41.9 5.8
7. 172.66.40.248                    0.0%  20  16.2 17.4 14.6 22.8 2.3
Copy
