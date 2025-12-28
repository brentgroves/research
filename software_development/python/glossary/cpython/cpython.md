# **[CPython](https://www.simplilearn.com/tutorials/python-tutorial/understand-the-workings-of-cpython)**

**[Research List](../../../research_list.md)**\
**[Detailed Status](../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../README.md)**

CPython is the standard Python software implementation or the default Python interpreter. The main purpose of CPython is to execute the programming language Python. CPython has great compatibility with various Python packages and modules. In this tutorial, you will get a detailed look at CPython.

## History of CPython

The first version of CPython was released in 1994 by the Python developer community. The project was originally sponsored by Google and was headed by full-time Google employees Thomas Wouters, Jeffrey Yasskin, and Collin Winter; however, most project contributors were not Google employees. It is directly downloaded from python.org and written in the programming language C.  

Python
Python is a high-level general-purpose programming language.

Implementation
Implementation is all about what the interpreter ends up doing.

Machine Code
High-level languages use compilers to translate the source code into executable machine code. Further, the machine code directly gets executed by the CPU. Each machine code instruction performs a unique task, and every processor or processor family has its own machine code instruction set.

Bytecode
Bytecode is a binary representation executed by a virtual machine and not by the CPU directly. Here, a virtual machine converts binary instruction into a specific machine instruction. Java is one example.

Machine Code is much faster than Bytecode, but Bytecode is portable and secure compared to machine code.

Source Code of CPython
The CPython source distribution comes with various tools, libraries, and components.

To compile CPython from the source code, you need a C compiler, and some build tools according to your OS.

In Windows, to download a copy of the CPython source code, you can use git to pull the latest version to a working copy locally:

```bash
git clone https://github.com/python/cpython
cd cpython
git checkout v3.8.0b4
```

## Why Is CPython Written in C and Not Python?

CPython is written in C, following a source-to-source compiler model. There are two types of compiler models:

Self-hosted compilers are compilers written in the same language they go on compiling, such as the Go compiler.
Source-to-source compilers are first written in another language that already possesses a compiler.
If you are developing a new language, you must write their compilers in a more established language. You have a very good example when it comes to the Go language. The first Go compiler was based on the C programming language. As and when Go could be compiled, the compiler was rewritten in Go.

## Is Python an Interpreted or Compiled Language?

Before concluding, it’s best to understand both concepts.

Compilation
The compilation is a way that translates the source code into machine-readable code. It takes the whole code file as input.

In compilation, the code is once translated into machine code and can be run many times. It will not execute the machine-readable code it produced.

![c](https://www.simplilearn.com/ice9/free_resources_article_thumb/CPython_1.png)

## Interpretation

Interpretation is the process that takes a single line of code at a time and executes it. The interpreter executes the instruction specified in the source file and parallelly the program gets executed.
![i](https://www.simplilearn.com/ice9/free_resources_article_thumb/CPython_2.png)

You must have heard that Python is an Interpreted language. In reality, it is both a compiled and an interpreted language.

![bc](https://www.simplilearn.com/ice9/free_resources_article_thumb/CPython_3.png)

Working of CPython
CPython produces Bytecode which is Python-specific and then executes it.

![c](https://www.simplilearn.com/ice9/free_resources_article_thumb/CPython_4.png)

The Compiler receives the source code.
It then keeps a check on the syntax in the source code.
If the Compiler runs into an error, it halts the translation process and shows an error message (Syntax error).
And if the instruction is well-formatted, then it translates the Python source code into a special low-level intermediary language called Bytecode.
This Bytecode is stored in .pyc files in a hidden directory and cached for execution and only understood by CPython.
Bytecode is then sent to the Python Virtual Machine (PVM). Python Virtual Machine runs the python code in the bytecode format and is part of the Python system.
PVM takes the bytecode instructions, inputs, and library modules.
PVM executes the instructions and in case any error occurs, it displays an error message (Runtime error). Else it results in the output.

Conclusion
With this, you have learned about CPython and saw how it works. CPython is one of the many Python runtimes other than PyPy, Cython, and Jython.

## Why shouldn't I use PyPy over CPython if PyPy is 6.3 times faster?

Asked 11 years, 6 months ago
Modified 2 months ago
Viewed 235k times
823

I've been hearing a lot about the PyPy project. They claim it is 6.3 times faster than the CPython interpreter on their site.

Whenever we talk about dynamic languages like Python, speed is one of the top issues. To solve this, they say PyPy is 6.3 times faster.

The second issue is parallelism, the infamous Global Interpreter Lock (GIL). For this, PyPy says it can give GIL-less Python.

If PyPy can solve these great challenges, what are its weaknesses that are preventing wider adoption? That is to say, what's preventing someone like me, a typical Python developer, from switching to PyPy right now?

PyPy, as others have been quick to mention, has tenuous support for C extensions. It has support, but typically at slower-than-Python speeds and it's iffy at best. Hence a lot of modules simply require CPython. Check the list of supported packages, but look at the date that list was updated, because it's not not kept in lockstep with actual support, so it's still possible that packages that marked unsupported on that list are actually supported.
Python support typically lags a few versions behind, so if you absolutely need the latest features, you may need to wait a while before PyPy supports them.
PyPy sometimes isn't actually faster for "scripts", which a lot of people use Python for. These are the short-running programs that do something simple and small. Because PyPy is a JIT compiler its main advantages come from long run times and simple types (such as numbers). PyPy's pre-JIT speeds can be bad compared to CPython.
Inertia. Moving to PyPy often requires retooling, which for some people and organizations is simply too much work.
