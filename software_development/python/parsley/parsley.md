# **[Parsley Tutorial Part I: Basics and Syntax](https://parsley.readthedocs.io/en/latest/tutorial.html)**

**[Research List](../../../research_list.md)**\
**[Detailed Status](../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../README.md)**

## From Regular Expressions To Grammars

Parsley is a pattern matching and parsing tool for Python programmers.

Most Python programmers are familiar with regular expressions, as provided by Python’s re module. To use it, you provide a string that describes the pattern you want to match, and your input.

For example:

```python
>>> import re
>>> x = re.compile("a(b|c)d+e")
>>> x.match("abddde")
<_sre.SRE_Match object at 0x7f587af54af8>
```

You can do exactly the same sort of thing in Parsley:

```python
>>> import parsley
>>> x = parsley.makeGrammar("foo = 'a' ('b' | 'c') 'd'+ 'e'", {})
>>> x("abdde").foo()
'e'
```

From this small example, a couple differences between regular expressions and Parsley grammars can be seen:

## Parsley Grammars Have Named Rules

A Parsley grammar can have many rules, and each has a name. The example above has a single rule named foo. Rules can call each other; calling rules in Parsley works like calling functions in Python. Here is another way to write the grammar above:

```parsley
foo = 'a' baz 'd'+ 'e'
baz = 'b' | 'c'
```
