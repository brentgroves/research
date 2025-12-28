# **[Adjacency List Representation](https://www.geeksforgeeks.org/dsa/adjacency-list-meaning-definition-in-dsa/)**

Last Updated : 23 Jul, 2025
An adjacency list is a data structure used to represent a graph where each node in the graph stores a list of its neighboring vertices.

## 1. Adjacency List for Directed graph

Consider an Directed and Unweighted graph G with 3 vertices and 3 edges. For the graph G, the adjacency list would look like:

![i](https://media.geeksforgeeks.org/wp-content/uploads/20241022101636059213/graph-representation-of-directed-graph-to-adjacency-list-2.webp)

```python
# Function to add an edge between two vertices
def addEdge(adj, u, v):
    adj[u].append(v)


def displayAdjList(adj):
    for i in range(len(adj)):
        print(f"{i}: ", end="")
        for j in adj[i]:
            print(f"{j} ", end="")
        print()


def main():
  
    # Create a graph with 3 vertices and 3 edges
    V = 3
    adj = [[] for _ in range(V)]

    # Now add edges one by one
    addEdge(adj, 1, 0)
    addEdge(adj, 1, 2)
    addEdge(adj, 2, 0)

    print("Adjacency List Representation:")
    displayAdjList(adj)


if __name__ == "__main__":
    main()
```

## 2. Adjacency List for Undirected graph

Consider an Undirected and Unweighted graph G with 3 vertices and 3 edges. For the graph G, the adjacency list would look like:

![i](https://media.geeksforgeeks.org/wp-content/uploads/20241022101436341036/graph-representation-of-undirected-graph-to-adjacency-list-2.webp)

```python
# Function to add an edge between two vertices
def addEdge(adj, u, v):
    adj[u].append(v)
    adj[v].append(u)

def displayAdjList(adj):
    for i in range(len(adj)):
        print(f"{i}: ", end="")
        for j in adj[i]:
            print(f"{j} ", end="")
        print()


def main():
  
    # Create a graph with 3 vertices and 3 edges
    V = 3
    adj = [[] for _ in range(V)]

    # Now add edges one by one
    addEdge(adj, 1, 0)
    addEdge(adj, 1, 2)
    addEdge(adj, 2, 0)

    print("Adjacency List Representation:")
    displayAdjList(adj)


if __name__ == "__main__":
    main()
```

Output
Adjacency List Representation:
0: 1 2
1: 0 2
2: 1 0

## 3. Adjacency List for Directed and Weighted graph

Consider an Directed and Weighted graph G with 3 vertices and 3 edges. For the graph G, the adjacency list would look like:

![i](https://media.geeksforgeeks.org/wp-content/uploads/20241022101833342036/graph-representation-of-directed-weighted-graph-to-adjacency-list-3.webp)

```python
# Function to add an edge between two vertices
def addEdge(adj, u, v, w):
    adj[u].append((v, w))

def displayAdjList(adj):
    for i in range(len(adj)):
        print(f"{i}: ", end="")
        for j in adj[i]:
            print(f"{{{j[0]}, {j[1]}}} ", end="")
        print()

def main():
  
    # Create a graph with 3 vertices and 3 edges
    V = 3
    adj = [[] for _ in range(V)]

    # Now add edges one by one
    addEdge(adj, 1, 0, 4)
    addEdge(adj, 1, 2, 3)
    addEdge(adj, 2, 0, 1)

    print("Adjacency List Representation:")
    displayAdjList(adj)

if __name__ == "__main__":
    main()
```

Characteristics of the Adjacency List:

- An adjacency list representation uses a list of lists. We store all adjacent of every node together.
- The size of the list is determined by the number of vertices in the graph.
- All adjacent of a vertex are easily available. To find all adjacent, we need only O(n) time where is the number of adjacent vertices.

## Applications of the Adjacency List

- Graph algorithms: Many graph algorithms like Dijkstra's algorithm, Breadth First Search, and Depth First Search perform faster for adjacency lists to represent graphs.
- Adjacency List representation is the most commonly used representation of graph as it allows easy traversal of all edges.

## Advantages of using an Adjacency list

- An adjacency list is simple and easy to understand.
- Requires less space compared to adjacency matrix for sparse graphs.
- Easy to traverse through all edges of a graph.
Adding an vertex is easier compared to adjacency matrix representation.
- Most of the graph algorithms are implemented faster with this representation. For example, BFS and DFS implementations take OIV x V) time, but with Adjacency List representation, we get these in linear time. Similarly Prim's and Dijskstra's algorithms are implemented faster with Adjacency List representation.

## Disadvantages of using an Adjacency list

Checking if there is an edge between two vertices is costly as we have traverse the adjacency list.
Not suitable for dense graphs.

## What else can you read?

Adjacency Matrix meaning and definition in DSA
Add and Remove Edge in Adjacency List representation of a Graph
Convert Adjacency Matrix to Adjacency List representation of Graph
Convert Adjacency List to Adjacency Matrix representation of a Graph
Comparison between Adjacency List and Adjacency Matrix representation of Graph
