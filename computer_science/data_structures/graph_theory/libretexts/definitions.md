# **[](https://math.libretexts.org/Courses/Saint_Mary's_College_Notre_Dame_IN/SMC%3A_MATH_339_-_Discrete_Mathematics_(Rohatgi)/Text/5%3A_Graph_Theory/5.2%3A_Definitions)**

Graph: A collection of vertices, some of which are connected by edges. More precisely, a pair of sets
 and
 where
 is a set of vertices and
 is a set of 2-element subsets of
Adjacent: Two vertices are adjacent if they are connected by an edge. Two edges are adjacent if they share a vertex.
Bipartite graph: A graph for which it is possible to divide the vertices into two disjoint sets such that there are no edges between any two vertices in the same set.
Complete bipartite graph: A bipartite graph for which every vertex in the first set is adjacent to every vertex in the second set.
Complete graph: A graph in which every pair of vertices is adjacent.
Connected: A graph is connected if there is a path from any vertex to any other vertex.
Chromatic number: The minimum number of colors required in a proper vertex coloring of the graph.
Cycle: A path (see below) that starts and stops at the same vertex, but contains no other repeated vertices.
Degree of a vertex: The number of edges incident to a vertex.
Euler path: A walk which uses each edge exactly once.
Euler circuit: An Euler path which starts and stops at the same vertex.
Multigraph: A multigraph is just like a graph but can contain multiple edges between two vertices as well as single edge loops (that is an edge from a vertex to itself).
Planar: A graph which can be drawn (in the plane) without any edges crossing.
Subgraph: We say that
 is a subgraph of
 if every vertex and edge of
 is also a vertex or edge of
 We say
 is an induced subgraph of
 if every vertex of
 is a vertex of
 and each pair of vertices in
 are adjacent in
 if and only if they are adjacent in
Tree: A (connected) graph with no cycles. (A non-connected graph with no cycles is called a forest.) The vertices in a tree with degree 1 are called leaves.
Vertex coloring: An assignment of colors to each of the vertices of a graph. A vertex coloring is proper if adjacent vertices are always colored differently.
Walk: A sequence of vertices such that consecutive vertices (in the sequence) are adjacent (in the graph). A walk in which no vertex is repeated is called simple
