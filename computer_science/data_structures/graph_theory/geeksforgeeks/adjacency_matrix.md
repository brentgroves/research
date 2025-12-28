# **[Adjacency Matrix Representation](https://www.geeksforgeeks.org/dsa/adjacency-matrix/)**

Adjacency Matrix Representation
Last Updated : 19 Mar, 2025
Adjacency Matrix is a square matrix used to represent a finite graph. The elements of the matrix indicate whether pairs of vertices are adjacent or not in the graph. An adjacency matrix is a simple and straightforward way to represent graphs and is particularly useful for dense graphs.

## What is Adjacency Matrix?

Adjacency Matrix is a square matrix used to represent a finite graph by storing the relationships between the nodes in their respective cells. For a graph with V vertices, the adjacency matrix A is an V X V matrix or 2D array.

1. Adjacency Matrix for Undirected and Unweighted graph:
Consider an Undirected and Unweighted graph G with 4 vertices and 3 edges. For the graph G, the adjacency matrix would look like:

![i](https://media.geeksforgeeks.org/wp-content/uploads/20240424142649/Adjacency-Matrix-for-Undirected-and-Unweighted-graph.webp)

Here's how to interpret the matrix:

A[i][j] ​= 1, there is an edge between vertex i and vertex j.
A[i][j] ​= 0, there is NO edge between vertex i and vertex j.

Below is a program to create an adjacency matrix for an unweighted and undirected graph:

```python
def add_edge(mat, i, j):
  
    # Add an edge between two vertices
    mat[i][j] = 1  # Graph is 
    mat[j][i] = 1  # Undirected

def display_matrix(mat):
  
    # Display the adjacency matrix
    for row in mat:
        print(" ".join(map(str, row)))  

# Main function to run the program
if __name__ == "__main__":
    V = 4  # Number of vertices
    mat = [[0] * V for _ in range(V)]  

    # Add edges to the graph
    add_edge(mat, 0, 1)
    add_edge(mat, 0, 2)
    add_edge(mat, 1, 2)
    add_edge(mat, 2, 3)

    # Optionally, initialize matrix directly
    """
    mat = [
        [0, 1, 0, 0],
        [1, 0, 1, 0],
        [0, 1, 0, 1],
        [0, 0, 1, 0]
    ]
    """

    # Display adjacency matrix
    print("Adjacency Matrix:")
    display_matrix(mat)
```

## 2. Adjacency Matrix for Undirected and Weighted graph

Consider an Undirected and Weighted graph G with 5 vertices and 5 edges. For the graph G, the adjacency matrix would look like:

![i](<https://media.geeksforgeeks.org/wp-content/uploads/20240424142706/Adjacency-Matrix-for-Undirected-and-Weighted-graph.webp>

Here's how to interpret the matrix:

- `A[i][j]` ​= INF, then there is no edge between vertex i and j
- `A[i][j]` ​= w, then there is an edge between vertex i and j having weight = w.
)

## 3. Adjacency Matrix for Directed and Unweighted graph

Consider an Directed and Unweighted graph G with 4 vertices and 4 edges. For the graph G, the adjacency matrix would look like:

![i](https://media.geeksforgeeks.org/wp-content/uploads/20240424142803/Adjacency-Matrix-for-Directed-and-Unweighted-graph.webp)

Here's how to interpret the matrix:

- `A[i][j]` ​= 1, there is an edge from vertex i to vertex j
- `A[i][j]` ​= 0, No edge from vertex i to j.

## 4. Adjacency Matrix for Directed and Weighted graph

Consider an Directed and Weighted graph G with 5 vertices and 6 edges. For the graph G, the adjacency matrix would look like:

![i](https://media.geeksforgeeks.org/wp-content/uploads/20240424142833/Adjacency-Matrix-for-Directed-and-Weighted-graph.webp)

Here's how to interpret the matrix:

- `A[i][j]` ​= INF, then there is no edge from vertex i to j
- `A[i][j]` ​= w, then there is an edge from vertex i having weight w

## Properties of Adjacency Matrix

- Diagonal Entries: The diagonal entries A[i][j] are usually set to 0 (in case of unweighted) and INF in case of weighted, assuming the graph has no self-loops.
- Undirected Graphs: For undirected graphs, the adjacency matrix is symmetric. This means A[i][j] ​= A[j][i]​ for all i and j.

## Applications of Adjacency Matrix

- Graph Representation: The adjacency matrix is one of the most common ways to represent a graph computationally.
Connectivity: By examining the entries of the adjacency matrix, one can determine whether the graph is connected or not. If the graph is undirected, it is connected if and only if the corresponding adjacency matrix is irreducible (i.e., there is a path between every pair of vertices). In directed graphs, connectivity can be analyzed using concepts like strongly connected components.
- Degree of Vertices: The degree of a vertex in a graph is the number of edges incident to it. In an undirected graph, the degree of a vertex can be calculated by summing the entries in the corresponding row (or column) of the adjacency matrix. In a directed graph, the in-degree and out-degree of a vertex can be similarly determined.

## Advantages of Adjacency Matrix

- Simple: Simple and Easy to implement.
- Space Efficient for Dense Graphs: Space efficient when the graph is dense as it requires V * V space to represent the entire graph.
- Faster access to Edges: Adjacency Matrix allows constant look up to check whether there exists an edge between a pair of vertices.

## Disadvantages of Adjacency Matrix

- Space inefficient for Sparse Graphs: Takes up O(V*V) space even if the graph is sparse.
- Costly Insertions and Deletions: Adding or deleting a vertex can be costly as it requires resizing the matrix.
- Slow Traversals: Graph traversals like DFS, BFS takes O(V* V) time to visit all the vertices whereas Adjacency List takes only O(V + E).
