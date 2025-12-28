# **[Planar Graphs](https://math.libretexts.org/Courses/Saint_Mary's_College_Notre_Dame_IN/SMC%3A_MATH_339_-_Discrete_Mathematics_(Rohatgi)/Text/5%3A_Graph_Theory/5.3%3A_Planar_Graphs)**

When a connected graph can be drawn without any edges crossing, it is called planar. When a planar graph is drawn in this way, it divides the plane into regions called faces.

- Draw, if possible, two different planar graphs with the same number of vertices, edges, and faces.
- Draw, if possible, two different planar graphs with the same number of vertices and edges, but a different number of faces.

When is it possible to draw a graph so that none of the edges cross? If this is possible, we say the graph is planar (since you can draw it on the plane).

Notice that the definition of planar includes the phrase “it is possible to.” This means that even if a graph does not look like it is planar, it still might be. Perhaps you can redraw it in a way in which no edges cross. For example, this is a planar graph:

![i1](https://math.libretexts.org/@api/deki/files/12850/image-101.svg?revision=1&size=bestfit&width=177&height=119)

That is because we can redraw it like this:

![i2](https://math.libretexts.org/@api/deki/files/12851/image-102.svg?revision=1&size=bestfit&width=200&height=160)

The graphs are the same, so if one is planar, the other must be too. However, the original drawing of the graph was not a planar representation of the graph.

When a planar graph is drawn without edges crossing, the edges and vertices of the graph divide the plane into regions. We will call each region a face. The graph above has 3 faces (yes, we do include the “outside” region as a face). The number of faces does not change no matter how you draw the graph (as long as you do so without the edges crossing), so it makes sense to ascribe the number of faces as a property of the planar graph.

WARNING: you can only count faces when the graph is drawn in a planar way. For example, consider these two representations of the same graph:

![i3](https://math.libretexts.org/@api/deki/files/12852/image-104.svg?revision=1&size=bestfit&width=132&height=132)

If you try to count faces using the graph on the left, you might say there are 5 faces (including the outside). But drawing the graph with a planar representation shows that in fact there are only 4 faces.

There is a connection between the number of vertices (
), the number of edges (
) and the number of faces (
) in any connected planar graph. This relationship is called Euler's formula.

A connected graph is a graph in which a path exists between every pair of vertices. In other words, you can travel from any vertex to any other vertex by traversing the edges. If a graph has at least one pair of vertices that cannot be reached from each other, the graph is considered disconnected and consists of multiple connected components.

Definition: Euler's Formula for Planar Graphs

For any (connected) planar graph with
 vertices,
 edges and
 faces, we have

<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg xmlns="http://www.w3.org/2000/svg" width="13.08ex" height="2.059ex" viewBox="0 -705 5781.4 910" xmlns:xlink="http://www.w3.org/1999/xlink" aria-hidden="true" style="vertical-align: -0.464ex;"><defs><style>svg a{fill:blue;stroke:blue}[data-mml-node="merror"]>g{fill:red;stroke:red}[data-mml-node="merror"]>rect[data-background]{fill:yellow;stroke:none}[data-frame],[data-line]{stroke-width:70px;fill:none}.mjx-dashed{stroke-dasharray:140}.mjx-dotted{stroke-linecap:round;stroke-dasharray:0,140}use[data-c]{stroke-width:3px}</style><path id="MJX-181-NCM-I-1D463" d="M369 391C369 383 378 370 394 350C410 330 418 307 418 281C418 252 404 203 375 134C354 86 306 18 247 18C201 18 178 45 178 100C178 139 197 208 235 307C243 328 247 345 247 357C247 407 213 442 163 442C119 442 84 417 59 367C39 326 29 300 29 287C29 278 34 273 45 273C58 273 60 279 64 293C87 373 119 413 160 413C173 413 180 404 180 385C180 369 175 347 164 318C127 219 108 152 108 115C108 64 125 29 159 10C186-4 214-11 243-11C332-11 394 85 420 162C452 256 468 325 468 369C468 418 452 442 421 442C396 442 369 416 369 391Z"/><path id="MJX-181-NCM-N-2212" d="M698 270L80 270C64 270 56 263 56 250C56 237 64 230 80 230L698 230C714 230 722 237 722 250C722 262 710 270 698 270Z"/><path id="MJX-181-NCM-I-1D452" d="M124 129C124 153 129 186 139 227L188 227C253 227 303 235 339 250C372 264 394 284 405 309C412 326 415 342 415 355C415 410 363 442 307 442C268 442 229 432 190 412C113 372 46 281 46 171C46 69 105-11 204-11C257-11 304 2 345 27C379 48 404 69 420 90C427 99 430 106 430 109C430 120 425 126 414 126C409 126 404 122 398 114C365 70 324 42 277 30C246 22 223 18 206 18C149 18 124 72 124 129M375 355C375 289 311 256 182 256L147 256C166 322 194 366 232 387C262 404 287 413 307 413C343 413 375 391 375 355Z"/><path id="MJX-181-NCM-N-2B" d="M698 274L413 274L413 559C413 575 405 583 389 583C373 583 365 575 365 559L365 274L80 274C64 274 56 266 56 250C56 234 64 226 80 226L365 226L365-59C365-75 373-83 389-83C405-83 413-75 413-59L413 226L698 226C714 226 722 234 722 250C722 263 711 274 698 274Z"/><path id="MJX-181-NCM-I-1D453" d="M552 633C552 677 509 705 462 705C400 705 357 665 334 586C329 568 318 517 302 433L237 433C215 433 204 432 204 411C204 400 214 395 235 395L295 395L222 8C211-49 201-91 192-119C180-156 163-175 141-175C126-175 114-171 103-164C135-159 151-140 151-108C151-82 138-69 111-69C77-69 53-99 53-133C53-177 94-205 141-205C166-205 189-195 208-174C240-141 265-94 283-31C294 8 304 46 311 84L369 395L451 395C474 395 484 396 484 419C484 428 474 433 454 433L377 433C383 474 411 625 420 644C430 665 444 675 462 675C477 675 490 671 501 664C470 657 454 639 454 608C454 582 467 569 494 569C528 569 552 599 552 633Z"/><path id="MJX-181-NCM-N-3D" d="M698 367L80 367C64 367 56 359 56 344C56 329 64 321 80 321L698 321C714 321 722 329 722 344C722 356 711 367 698 367M698 179L80 179C64 179 56 171 56 156C56 141 64 133 80 133L698 133C714 133 722 141 722 156C722 169 711 179 698 179Z"/><path id="MJX-181-NCM-N-32" d="M237 666C186 666 143 648 106 612C69 576 50 534 50 483C50 449 75 424 106 424C136 424 161 450 161 480C161 513 137 536 105 536C102 536 100 536 98 535C117 584 161 627 224 627C306 627 352 556 352 470C352 403 318 331 250 255L62 43C49 28 50 29 50 0L421 0L450 180L417 180C409 129 402 100 396 91C391 86 361 84 306 84L139 84L236 179C304 243 390 312 419 365C439 400 449 435 449 470C449 588 357 666 237 666Z"/></defs><g stroke="black" fill="black" stroke-width="0" transform="scale(1,-1)"><g data-mml-node="math" class=""><g data-mml-node="mrow"><g data-mml-node="mrow"><g data-mml-node="mi"><use data-c="1D463" xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="#MJX-181-NCM-I-1D463"/></g><g data-mml-node="mo" transform="translate(707.2,0)"><use data-c="2212" xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="#MJX-181-NCM-N-2212"/></g><g data-mml-node="mi" transform="translate(1707.4,0)"><use data-c="1D452" xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="#MJX-181-NCM-I-1D452"/></g></g><g data-mml-node="mo" transform="translate(2395.7,0)"><use data-c="2B" xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="#MJX-181-NCM-N-2B"/></g><g data-mml-node="mi" transform="translate(3395.9,0)"><use data-c="1D453" xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="#MJX-181-NCM-I-1D453"/></g></g><g data-mml-node="mo" transform="translate(4225.7,0)"><use data-c="3D" xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="#MJX-181-NCM-N-3D"/></g><g data-mml-node="mn" transform="translate(5281.4,0)"><use data-c="32" xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="#MJX-181-NCM-N-32"/></g></g></g></svg>

Why is Euler's formula true? One way to convince yourself of its validity is to draw a planar graph step by step. Start with the graph

![i1](https://math.libretexts.org/@api/deki/files/12854/image-105.svg?revision=1&size=bestfit&width=81&height=77)

Any connected graph (besides just a single isolated vertex) must contain this subgraph. Now build up to your graph by adding edges and vertices. Each step will consist of either adding a new vertex connected by a new edge to part of your graph (so creating a new “spike”) or by connecting two vertices already in the graph with a new edge (completing a circuit).

![i3](https://math.libretexts.org/@api/deki/files/12855/image-106.svg?revision=1&size=bestfit&width=187&height=127)

What do these “moves” do? When adding the spike, the number of edges increases by 1, the number of vertices increases by one, and the number of faces remains the same. But this means that $v-e+f=2$ does not change. Completing a circuit adds one edge, adds one face, and keeps the number of vertices the same. So again, $v-e+f=2$ does not change.

Since we can build any graph using a combination of these two moves, and doing so never changes the quantity $v-e+f=2$, that quantity will be the same for all graphs. But notice that our starting graph has $v=2$,$e=2$, and $f=1$, so $v-e+2=2$. This argument is essentially a **proof by induction**. A good exercise would be to rewrite it as a formal induction proof.

## Process of Proof by Induction

There are two types of induction: regular and strong. The steps start the same but vary at the end. Here are the steps. In mathematics, we start with a statement of our assumptions and intent:

Let $p(n), \forall n \geq n_0, \, n, \, n_0 \in \mathbb{Z_+}$ be a statement. We would show that p(n) is true for all possible values of n.

1. Show that p(n) is true for the smallest possible value of n: In our case $p(n_0)$

    Start with the graph
    ![i1](https://math.libretexts.org/@api/deki/files/12854/image-105.svg?revision=1&size=bestfit&width=81&height=77)

    Let p(n) be p(v,e) is: $v-e+f=2$

    Any connected graph (besides just a single isolated vertex) must contain this subgraph.

    So we can say this is our starting graph which has the smallest possible values for $v$ and $n$. Here our starting graph has $v=2$\, $e=1$, and $f=1$, so $v-e+f=2$.

2. **For Regular Induction:** Assume that the statement is true for some $p(v,e)$. Then show that the statement is true for the next possible $p(v,e)$ planar graph.

    Each step will consist of either adding a new vertex connected by a new edge to part of your graph (so creating a new “spike”) or by connecting two vertices already in the graph with a new edge (completing a circuit).

    ![i3](https://math.libretexts.org/@api/deki/files/12855/image-106.svg?revision=1&size=bestfit&width=187&height=127)

    - When adding the spike, the number of edges increases by 1, the number of vertices increases by one, and the number of faces remains the same. But this means that $v-e+f=2$ does not change.
    - Completing a circuit adds one edge, adds one face, and keeps the number of vertices the same. So again, $v-e+f=2$ does not change.

    Since we can build any graph using a combination of these two moves, and doing so never changes the quantity $v-e+f=2$, that quantity will be the same for all graphs. But notice that our starting graph has $v=2$,$e=1$, and $f=1$, so $v-e+f=2$.

## Non-planar Graphs

  <!DOCTYPE html>
  <html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
  </head>
  <body>
<table>
  <caption>
    Non-planar graphs
  </caption>
  <thead>
    <tr>
      <th>Investigate</th>
    </tr>
  </thead>

  <tbody>
    <tr>
<td>
For the complete graphs $k_n$  we would like to be able to say something about the number of vertices, edges, and (if the graph is planar) faces. Let's first consider $k_3$

1. How many vertices does $k_3$  have? How many edges?
2. If $k_3$ is planar, how many faces should it have?

Repeat parts (1) and (2) for $k_4,\,k_5,and\,k_{23}$.

What about complete bipartite graphs? How many vertices, edges, and faces (if it were planar) does $v_{7,4}$ have? For which values of $m$ and $n$ are $K_n$ and $K_{m,n}$ planar?

</td>
</tr>
</tbody>
</table>

  </body>
  </html>

Not all graphs are planar. If there are too many edges and too few vertices, then some of the edges will need to intersect. The first time this happens is in

![i1](https://math.libretexts.org/@api/deki/files/12930/image-108.svg?revision=1&size=bestfit&width=135&height=128)

If you try to redraw this without edges crossing, you quickly get into trouble. There seems to be one edge too many. In fact, we can prove that no matter how you draw it, $k_5$ will always have edges crossing.

## Theorem 5.3.1

$k_5$ is not planar

Proof
The proof is by contradiction. So assume that $K_5$ is planar. Then the graph must satisfy Euler's formula for planar graphs.
$K_5$ has 5 vertices and 10 edges, so we get

$$5-10+f=2$$

which says that if the graph is drawn without any edges crossing, there would be $7$ faces.

Now consider how many edges surround each face. Each face must be surrounded by at least 3 edges. Let $B$ be the total number of boundaries around all the faces in the graph. Thus we have that $B \ge 3f$. But also $B=2e$, **since each edge is used as a boundary exactly twice**. Putting this together we get

$$3f<=2e$$

But this is impossible, since we have already determined that $f=7$ and $e=10$ and $21 \not \le 20$. This is a contradiction so in fact $K_5$ is not planar.

## AI in a planar graph is each edge used a boundary exactly twice

Yes, in a planar graph with a valid embedding, each edge is part of the boundary of exactly two faces (or regions). An edge is traversed once for the boundary of each of the two faces it borders. This is sometimes referred to as the "sum of face degrees" being equal to twice the number of edges (\(2e\)).

- Why edges are counted twice: Imagine walking along the boundary of a face. To get from one face to the next, you must cross an edge. When you return to a face, you have traversed that edge a second time, but in the opposite direction.

![i2](https://math.libretexts.org/@api/deki/files/12851/image-102.svg?revision=1&size=bestfit&width=200&height=160)

- The 2e relationship: The sum of the lengths (number of edges) of all face boundaries is exactly twice the total number of edges in the graph. This is because each edge is shared by two faces, so it's counted once for each of them.
- Exception (special cases): Some edge cases, like "cut edges" that connect only one face (like a spike), are sometimes handled differently depending on the context. However, for the standard "handshaking theorem" for faces in a planar graph, each edge is counted twice.
