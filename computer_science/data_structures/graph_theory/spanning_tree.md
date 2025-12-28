# **[](https://www.geeksforgeeks.org/dsa/spanning-tree/)**

In this article, we are going to cover one of the most commonly asked DSA topic which is the Spanning Tree with its definition, properties, and applications. Moreover, we will explore the Minimum Spanning Tree and various algorithms used to construct it. These algorithms have various pros and cons over each other depending on the use case of the problem.

## What is a Spanning Tree?

A spanning tree is a subset of Graph G, such that all the vertices are connected using minimum possible number of edges. Hence, a spanning tree does not have cycles and a graph may have more than one spanning tree.

![st](https://media.geeksforgeeks.org/wp-content/uploads/20231002184939/spanningtreedrawio.png)

## Properties of a Spanning Tree

- A Spanning tree does not exist for a disconnected graph.

A disconnected graph is a graph where there is at least one pair of vertices that cannot be connected by a path. This means the graph is composed of two or more separate parts, known as components, where no path exists between vertices in different components.  

- For a connected graph having N vertices then the number of edges in the spanning tree for that graph will be N-1.

- A Spanning tree does not have any cycle.
- We can construct a spanning tree for a complete graph by removing E-N+1 edges, where E is the number of Edges and N is the number of vertices.

A complete graph with n vertices has n(n-1)/2 edges. This is because each vertex is connected to every other vertex, resulting in n-1 edges for each of the n vertices, and dividing by 2 corrects for double-counting each edge.  

E = n(n-1)/2 # complete graph

what is: E - N + 1
2. n(n-1)/2 - n + 1
3. n(n-1)/2 - 2n/2 + 2/2
4. (n^2 - n - 2n + 2)/2
5. (n^2 - 3n - 2)/2

remove (n^2 - 3n - 2)/2 from a completed graphs n(n-1)/2 edge count.

use step 3 equation for calc

1. n(n-1)/2 - (n(n-1)/2 - 2n/2 + 2/2)
2. 2n/2 - 1
3. n-1

Cayley's Formula: It states that the number of spanning trees in a complete graph with N vertices is N
N
−
2
N
N−2
N
N
−
2
N
N−2

For example: N=4, then maximum number of spanning tree possible =
4
4
−
2
4
4−2
  = 16 (shown in the above image).

## Real World Applications of A Spanning Tree
