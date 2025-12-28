# **[TCP congestion control](https://www.geeksforgeeks.org/tcp-congestion-control/)**

**[Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Research List](../../../../research/research_list.md)**\
**[Back Main](../../../../../README.md)**

## TCP Congestion Control

Last Updated : 01 Jul, 2024\
TCP congestion control is a method used by the TCP protocol to manage data flow over a network and prevent congestion. TCP uses a congestion window and congestion policy that avoids congestion. Previously, we assumed that only the receiver could dictate the sender’s window size. We ignored another entity here, the network. If the network cannot deliver the data as fast as it is created by the sender, it must tell the sender to slow down. In other words, in addition to the receiver, the network is a second entity that determines the size of the sender’s window.

## Congestion Policy in TCP

- Slow Start Phase: Starts slow increment is exponential to the threshold.
- Congestion Avoidance Phase: After reaching the threshold increment is by 1.
- Congestion Detection Phase: The sender goes back to the Slow start phase or the Congestion avoidance phase.

## Slow Start Phase

**Exponential Increment:** In this phase after every **[RTT](https://www.geeksforgeeks.org/what-is-rttround-trip-time/)** the congestion window size increments exponentially.

Example: If the initial congestion window size is 1 segment, and the first segment is successfully acknowledged, the congestion window size becomes 2 segments. If the next transmission is also acknowledged, the congestion window size doubles to 4 segments. This exponential growth continues as long as all segments are successfully acknowledged.
