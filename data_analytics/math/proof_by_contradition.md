# AI Overview

Proof by contradiction is a method of proving a statement true by assuming the opposite of the statement is true and showing that this assumption leads to a logical contradiction. If the assumption of the statement being false results in a contradiction (a statement that is impossible), then the original statement must be true.

## Steps for proof by contradiction

1. Assume the opposite: Start by assuming the statement you want to prove is false.
2. Derive consequences: Use logical steps to show what logically follows from this assumption.
3. Reach a contradiction: Show that these consequences lead to a contradiction. A contradiction is a statement that is logically impossible, such as \(2+2=5\), or the same number being both even and odd.  
4. Conclude the original statement is true: Because the initial assumption (that the statement is false) leads to an impossible result, the assumption must be false. Therefore, the original statement must be true.

Example: Proving \(\sqrt{2}\) is irrational

Statement to prove: \(\sqrt{2}\) is irrational.  

- Step 1: Assume the opposite: Assume \(\sqrt{2}\) is rational. This means we can write it as a fraction \(\frac{p}{q}\), where \(p\) and \(q\) are integers with no common factors other than 1.
- Step 2: Derive consequences: If \(\sqrt{2}=\frac{p}{q}\), then \(2=\frac{p^{2}}{q^{2}}\), which means \(2q^{2}=p^{2}\).  Since \(2q^{2}=p^{2}\), \(p^{2}\) must be an even number. If \(p^{2}\) is even, then \(p\) must also be even.  If \(p\) is even, we can write \(p=2k\) for some integer \(k\).  Substitute \(p=2k\) into the equation: \(2q^{2}=(2k)^{2}\), which simplifies to \(2q^{2}=4k^{2}\), and then \(q^{2}=2k^{2}\).  

- Step 3: Reach a contradiction:
  - Since \(q^{2}=2k^{2}\), \(q^{2}\) must be an even number, which means \(q\) must also be even.  
  - This leads to a contradiction: we assumed \(p\) and \(q\) had no common factors, but we just proved both are even, meaning they have a common factor of 2.  
- Step 4: Conclude the original statement is true:
  - The assumption that \(\sqrt{2}\) is rational led to a contradiction. Therefore, the assumption must be false, and the original statement is true: \(\sqrt{2}\) is irrational.
