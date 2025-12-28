# **[Project](https://packaging.python.org/en/latest/glossary/#term-Project)**

A library, framework, script, plugin, application, or collection of data or other resources, or some combination thereof that is intended to be packaged into a **[Distribution](https://packaging.python.org/en/latest/glossary/#term-Distribution-Package)**.

Since most projects create Distributions using either PEP 518 build-system, distutils or Setuptools, another practical way to define projects currently is something that contains a pyproject.toml, setup.py, or setup.cfg file at the root of the project source directory.

Python projects must have unique names, which are registered on PyPI. Each project will then contain one or more Releases, and each release may comprise one or more distributions.

Note that there is a strong convention to name a project after the name of the package that is imported to run that project. However, this doesn’t have to hold true. It’s possible to install a distribution from the project ‘foo’ and have it provide a package importable only as ‘bar’.

