# **[](https://math.libretexts.org/Courses/Mount_Royal_University/Mathematical_Reasoning/3%3A_Number_Patterns/3.1%3A_Proof_by_Induction)**

Inductive reasoning is the process of drawing conclusions after examining particular observations. This reasoning is very useful when studying number patterns. In many situations, inductive reasoning strongly suggests that the statement is valid, however, we have no way to present whether the statement is true or false, for example, Goldbach conjecture. But, in this class, we will deal with problems that are more accessible and we can often apply mathematical induction to prove our guess based on particular observations. For example, when we predict a $n^{th}$
 term for a given sequence of numbers, mathematics induction is useful to prove the statement, as it involves positive integers.

Process of Proof by Induction
There are two types of induction: regular and strong. The steps start the same but vary at the end. Here are the steps. In mathematics, we start with a statement of our assumptions and intent:

Let $p(n), \forall n \geq n_0, \, n, \, n_0 \in \mathbb{Z_+}$
 be a statement. We would show that p(n) is true for all possible values of n.

Show that p(n) is true for the smallest possible value of n: In our case $p(n_0)$

For Regular Induction: Assume that the statement is true for  
 for some integer  $n = k,$
. Show that the statement is true for n = k + 1.
OR

OR

For Strong Induction: Assume that the statement p(r) is true for all integers r, where $n_0 ≤ r ≤ k$
 for some  
. Show that p(k+1) is true.

If these steps are completed and the statement holds, we are saying that, by mathematical induction, we can conclude that the statement is true for all values of  
$n \geq n_0.$

Prove $ 2^{n} > n + 4$ for $n \geq 3, n \in \mathbb{N}$.

Solution

Let $n=3$. Then 2^{3}>3+4 is true since clearly $8>7$. Thus the statement is true for $n=3$.

Assume that $2^{n}>n+4$  is true for some $n=k$.

We will show that $2^{k+1}>(k+1)+4$.

Consider $2^{k+1}=2*2^{k}>2*(k+4)=2k+8$.

Since  $2k>k+1$ and $8>4$ , we have $2k+8>(k+1)+4$.

Thus the statement is true for all $n=k$.

By induction, $2{n}>n+4$ for all $n>3$ and $n\in\mathbb{Z}$.
