# **[RTT](https://www.geeksforgeeks.org/what-is-rttround-trip-time/)**

**[Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Research List](../../../../research/research_list.md)**\
**[Back Main](../../../../../README.md)**

## What is RTT(Round Trip Time)?

Last Updated : 13 Apr, 2023
RTT (Round Trip Time) also called round-trip delay is a crucial tool in determining the health of a network. It is the time between a request for data and the display of that data. It is the duration measured in milliseconds.

RTT can be analyzed and determined by pinging a certain address. It refers to the time taken by a network request to reach a destination and to revert back to the original source. In this scenario, the source is the computer and the destination is a system that captures the arriving signal and reverts it back.

![](https://media.geeksforgeeks.org/wp-content/uploads/20230406114042/RTT.png)

## What Are Common Factors that Affect RTT?

There are certain factors that can bring huge changes in the value of RTT. These are enlisted below:

- **Distance:** It is the length in which a signal travels for a request to reach the server and for a response to reach the browser,
- **Transmission medium:** The medium which is used to route a signal, which helps in faster transfer of request is transmitted.
- **Network hops:** It is the time that servers take to process a signal, on increasing the number of hops, RTT will also increase.
- **Traffic levels:** Round Trip Time generally increases when a network is having huge traffic which results in that, for low traffic RTT will also be less.
- **Server response time:** It is the time taken by a server to respond to a request which basically depends on the capacity of handling requests and also sometimes on the nature of the request.

## Applications of RTT

Round Trip Time refers to a wide variety of transmissions such as **[wireless Internet transmissions](https://www.geeksforgeeks.org/types-transmission-media/)** and satellite transmissions. In Internet transmissions, RTT may be identified by using the ping command. In satellite transmissions, RTT can be calculated by making use of the Jacobson/Karels algorithm.
