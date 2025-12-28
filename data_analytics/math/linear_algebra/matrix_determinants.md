# **[matrix determinant](https://www.mathsisfun.com/algebra/matrix-determinant.html)**

## Determinant of a Matrix

The determinant is a special number that can be calculated from a matrix.

The matrix has to be square (same number of rows and columns) like this one:

3,8
4,6

A Matrix
(This one has 2 Rows and 2 Columns)

Let us calculate the determinant of that matrix:

3×6 − 8×4
= 18 − 32
= −14

Easy, hey? Here is another example:

Example:
B = 1,2
    3,4

The symbol for determinant is two vertical lines either side like this:

|B| = 1×4 − 2×3
= 4 − 6
= −2

(Note: it is the same symbol as absolute value.)

What is it for?
The determinant helps us find the **[inverse of a matrix](https://www.mathsisfun.com/algebra/matrix-inverse-minors-cofactors-adjugate.html)**, tells us things about the matrix that are useful in **[systems of linear equations](https://www.mathsisfun.com/algebra/systems-linear-equations.html)**, calculus and more.

Calculating the Determinant
First of all the matrix must be square (i.e. have the same number of rows as columns). Then it is just arithmetic.

For a 2×2 Matrix
For a 2×2 matrix (2 rows and 2 columns):

A =
a
b
c
d
The determinant is:

|A| = ad − bc
"The determinant of A equals a times d minus b times c"

It is easy to remember when you think of a cross:

Blue is positive (+ad),
Red is negative (−bc)
  a by d, b by c

Example: find the determinant of
C = 4,6
    3,8
Answer:

|C| = 4×8 − 6×3
  = 32 − 18
  = 14

## For a 3×3 Matrix

For a 3×3 matrix (3 rows and 3 columns):

A =
a,b,c
d,e,f
g,h,i

The determinant is:

|A| = a(ei − fh) − b(di − fg) + c(dh − eg)
"The determinant of A equals ... etc"

It may look complicated, but there is a pattern:

![i1](https://www.mathsisfun.com/algebra/images/matrix-3x3-det.svg)

To work out the determinant of a 3×3 matrix:

Multiply a by the determinant of the 2×2 matrix that is not in a's row or column.
Likewise for b, and for c
Sum them up, but remember the minus in front of the b
As a formula (remember the vertical bars || mean "determinant of"):

A Matrix
"The determinant of A equals a times the determinant of ... etc"

Example:
D =
6
1
1
4
−2
5
2
8
7
|D| = 6×(−2×7 − 5×8) − 1×(4×7 − 5×2) + 1×(4×8 − (−2×2))
  = 6×(−54) − 1×(18) + 1×(36)
  = −306
