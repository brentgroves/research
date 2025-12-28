# **[Module](https://packaging.python.org/en/latest/glossary/#term-Module)**
The basic unit of code reusability in Python, existing in one of two types: **[Pure Module](https://packaging.python.org/en/latest/glossary/#term-Pure-Module)**, or **[Extension Module](https://packaging.python.org/en/latest/glossary/#term-Extension-Module)**.


## **[Pure Module](https://packaging.python.org/en/latest/glossary/#term-Pure-Module)**

A **[Module](https://packaging.python.org/en/latest/glossary/#term-Module)** written in Python and contained in a single .py file (and possibly associated .pyc and/or .pyo files).

## **[Extension Module](https://packaging.python.org/en/latest/glossary/#term-Extension-Module)**

A Module written in the low-level language of the Python implementation: C/C++ for Python, Java for Jython. Typically contained in a single dynamically loadable pre-compiled file, e.g. a shared object (.so) file for Python extensions on Unix, a DLL (given the .pyd extension) for Python extensions on Windows, or a Java class file for Jython extensions.