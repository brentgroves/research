# **[Depth First Search or DFS for a Graph](https://www.geeksforgeeks.org/dsa/depth-first-search-or-dfs-for-a-graph/)**

Last Updated : 25 Oct, 2025
Given a graph, traverse the graph using Depth First Search and find the order in which nodes are visited.

Depth First Search (DFS) is a graph traversal method that starts from a source vertex and explores each path completely before backtracking and exploring other paths. To avoid revisiting nodes in graphs with cycles, a visited array is used to track visited vertices.

Note: There can be multiple DFS traversals of a graph according to the order in which we pick adjacent vertices. Here we pick vertices as per the insertion order.
