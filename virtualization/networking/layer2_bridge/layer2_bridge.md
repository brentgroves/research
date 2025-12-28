# **[](https://www.youtube.com/watch?v=CmxsgTq3FXE&t=150)**

A layer 2 bridge connects multiple network segments within the same Layer 2 broadcast domain, allowing devices on different segments to communicate as if they were on the same physical network by filtering and forwarding traffic based on MAC addresses. Modern implementations use specialized hardware called multi-port switches, which learn MAC addresses to intelligently forward data frames only to the port where the destination device resides, reducing unnecessary traffic and collisions.  

## How a Layer 2 Bridge Works

- **MAC Address Learning:** The bridge monitors network traffic and learns the MAC addresses of devices on each connected network segment.

- **MAC Address Table:** It builds a MAC address table to map each MAC address to a specific network segment (or port).

- **Frame Forwarding:** When the bridge receives a data frame, it checks the destination MAC address:
