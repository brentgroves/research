# spanning tree

A "spanning tree" can refer to a subgraph in graph theory that connects all vertices without cycles, or a network protocol called the Spanning Tree Protocol (STP) which prevents network loops by disabling redundant paths on switches. In graph theory, a spanning tree includes every vertex of the original graph. In networking, STP ensures a single active path between devices by blocking redundant links, preventing broadcast storms and MAC table instability caused by loops.  

This video explains the concept of a spanning tree in graph theory:

**[stt](https://www.youtube.com/watch?v=fO-R1vwgsmw&t=47)**

## Spanning Tree in Graph Theory

- **Definition:** A spanning tree is a subgraph of a larger graph that includes all the vertices of the original graph but contains no cycles.
- **Properties:** A spanning tree of a graph with \(n\) vertices will have exactly \(n-1\) edges
- **Applications:** This mathematical concept is used in various applications, including network design and optimization problems.

## Spanning Tree Protocol (STP) in Networking

- **Purpose:** STP is a network protocol that prevents Layer 2 switching loops in a local area network (LAN).
- **How it Works:**
- It creates a tree-like network topology where redundant paths are blocked.
- One switch is elected as the "root bridge," which is the root of the spanning tree.
- Non-root switches use Bridge Protocol Data Units (BPDUs) to discover the network topology and determine the best path to the root.
- For each network segment, a single "designated port" is chosen to forward traffic, while other ports in the loop are placed in a "blocking" state.

- **Benefits:** By preventing loops, STP ensures network stability, prevents broadcast storms, and avoids MAC address instability.
- **Evolution:** Different versions exist, such as Rapid Spanning Tree Protocol (RSTP), which provides faster convergence than the original STP.
