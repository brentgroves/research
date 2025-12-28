# **[Distribution package vs. import package](https://packaging.python.org/en/latest/discussions/distribution-package-vs-import-package/#distribution-package-vs-import-package)** 

## What’s a distribution package?

A distribution package is a piece of software that you can install. Most of the time, this is synonymous with “project”. When you type pip install pkg, or when you write dependencies = ["pkg"] in your pyproject.toml, pkg is the name of a distribution package. When you search or browse the PyPI, the most widely known centralized source for installing Python libraries and tools, what you see is a list of distribution packages. Alternatively, the term “distribution package” can be used to refer to a specific file that contains a certain version of a project.

Note that in the Linux world, a “distribution package”, most commonly abbreviated as “distro package” or just “package”, is something provided by the system package manager of the Linux distribution, which is a different meaning.

## What’s an import package?

An import package is a Python module. Thus, when you write import pkg or from pkg import func in your Python code, pkg is the name of an import package. More precisely, import packages are special Python modules that can contain submodules. For example, the numpy package contains modules like numpy.linalg and numpy.fft. Usually, an import package is a directory on the file system, containing modules as .py files and subpackages as subdirectories.

You can use an import package as soon as you have installed a distribution package that provides it.



