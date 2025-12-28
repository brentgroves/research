# **[list comprehension]()**

List Comprehension:
This is a concise way to create lists based on an iterable.

List comprehensions in Python provide a concise way to create new lists from existing iterables (like lists, tuples, ranges, or strings) based on a specific expression and optional conditions. They offer a more readable and often more efficient alternative to traditional for loops for list construction.

```python
new_list = [expression for item in iterable]
```

Explanation:

- **expression:** This is the operation applied to each item to produce the elements of the new_list. It can be a variable, a function call, an arithmetic operation, etc.
item: This is a temporary variable that represents each element from the iterable during the iteration.
- **iterable:** This is the sequence (e.g., list, tuple, range) that you are iterating over.

Example without conditions:

```python
numbers = [1, 2, 3, 4, 5]
squares = [x * x for x in numbers]
print(squares)
# Output: [1, 4, 9, 16, 25]
```

Syntax with Conditional Filtering:

new_list = [expression for item in iterable if condition]

Explanation:
condition: An optional if clause that filters elements from the iterable. Only items for which the condition evaluates to True will be included in the new_list.
Example with conditions:

```python
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
even_squares = [x * x for x in numbers if x % 2 == 0]
print(even_squares)

# Output: [4, 16, 36, 64, 100]
```
