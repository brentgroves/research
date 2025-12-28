# **[Environments](https://docs.astral.sh/uv/pip/environments/)**

**[Research List](../../../research_list.md)**\
**[Detailed Status](../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../README.md)**

## Python environments

Each Python installation has an environment that is active when Python is used. Packages can be installed into an environment to make their modules available from your Python scripts. Generally, it is considered best practice not to modify a Python installation's environment. This is especially important for Python installations that come with the operating system which often manage the packages themselves. A virtual environment is a lightweight way to isolate packages from a Python installation's environment. Unlike pip, uv requires using a virtual environment by default.

## Creating a virtual environment

uv supports creating virtual environments, e.g., to create a virtual environment at .venv:

`uv venv`
A specific name or path can be specified, e.g., to create a virtual environment at my-name:

`uv venv my-name`

A Python version can be requested, e.g., to create a virtual environment with Python 3.11:

`uv venv --python 3.11`

Note this requires the requested Python version to be available on the system. However, if unavailable, uv will download Python for you. See the Python version documentation for more details.

## Using a virtual environment

When using the default virtual environment name, uv will automatically find and use the virtual environment during subsequent invocations.

`uv venv`

```bash
# Install a package in the new virtual environment
uv pip install ruff
```

The virtual environment can be "activated" to make its packages available:

`source .venv/bin/activate`

The default activation script on Unix is for POSIX compliant shells like sh, bash, or zsh. There are additional activation scripts for common alternative shells.

`source .venv/bin/activate.fish`

## Deactivating an environment

To exit a virtual environment, use the deactivate command:

`deactivate`

## Using arbitrary Python environments

Since uv has no dependency on Python, it can install into virtual environments other than its own. For example, setting VIRTUAL_ENV=/path/to/venv will cause uv to install into /path/to/venv, regardless of where uv is installed. Note that if VIRTUAL_ENV is set to a directory that is not a PEP 405 compliant virtual environment, it will be ignored.

## Python Enhancement Proposals Python

PEP 405 – Python Virtual Environments

uv can also install into arbitrary, even non-virtual environments, with the --python argument provided to uv pip sync or uv pip install. For example, uv `pip install --python /path/to/python` will install into the environment linked to the /path/to/python interpreter.

For convenience, uv pip install --system will install into the system Python environment. Using --system is roughly equivalent to uv pip install --python $(which python), but note that executables that are linked to virtual environments will be skipped. Although we generally recommend using virtual environments for dependency management, --system is appropriate in continuous integration and containerized environments.

The --system flag is also used to opt in to mutating system environments. For example, the --python argument can be used to request a Python version (e.g., --python 3.12), and uv will search for an interpreter that meets the request. If uv finds a system interpreter (e.g., /usr/lib/python3.12), then the --system flag is required to allow modification of this non-virtual Python environment. Without the --system flag, uv will ignore any interpreters that are not in virtual environments. Conversely, when the --system flag is provided, uv will ignore any interpreters that are in virtual environments.

Installing into system Python across platforms and distributions is notoriously difficult. uv supports the common cases, but will not work in all cases. For example, installing into system Python on Debian prior to Python 3.10 is unsupported due to the distribution's patching of distutils (but not sysconfig). While we always recommend the use of virtual environments, uv considers them to be required in these non-standard environments.

If uv is installed in a Python environment, e.g., with pip, it can still be used to modify other environments. However, when invoked with python -m uv, uv will default to using the parent interpreter's environment. Invoking uv via Python adds startup overhead and is not recommended for general usage.

uv itself does not depend on Python, but it does need to locate a Python environment to (1) install dependencies into the environment and (2) build source distributions.

## Discovery of Python environments

When running a command that mutates an environment such as uv pip sync or uv pip install, uv will search for a virtual environment in the following order:

An activated virtual environment based on the VIRTUAL_ENV environment variable.
An activated Conda environment based on the CONDA_PREFIX environment variable.
A virtual environment at .venv in the current directory, or in the nearest parent directory.
If no virtual environment is found, uv will prompt the user to create one in the current directory via uv venv.

If the --system flag is included, uv will skip virtual environments search for an installed Python version. Similarly, when running a command that does not mutate the environment such as uv pip compile, uv does not require a virtual environment — however, a Python interpreter is still required. See the documentation on **[Python discovery](https://docs.astral.sh/uv/concepts/python-versions/#discovery-of-python-versions)** for details on the discovery of installed Python versions.

## AI Overview

In the context of Python programming, a "Python environment" refers to the specific set of packages and libraries that a Python project uses, and it's often managed through virtual environments to isolate project dependencies.

What it is:
A Python environment consists of an interpreter (the core Python software), a library (typically the Python Standard Library), and a set of installed packages.
Why it's important:
Using virtual environments helps ensure that different projects don't conflict with each other's dependencies, which can lead to issues when different projects require different versions of the same package.
Virtual Environments:
A Python virtual environment (venv) is essentially a directory with a specific file structure that contains a Python interpreter and installed packages specific to that environment.
Benefits of using virtual environments:
Dependency Isolation: Each project can have its own set of packages and versions, preventing conflicts.
Reproducibility: You can easily recreate the same environment for a project on different machines, ensuring consistent results.
Organization: Virtual environments help organize your projects and make it easier to manage dependencies.
venv:
The venv module is a built-in tool in Python 3 for creating virtual environments, and it's the recommended approach for creating and managing them.
Other tools:
While venv is the standard, other tools like virtualenv and conda can also be used for creating and managing Python environments.
Setting up a virtual environment:
Install Python: Make sure you have Python installed on your system.
Create a virtual environment: Use the python -m venv <environment_name> command to create a virtual environment.
Activate the environment: Use the source <environment_name>/bin/activate (Linux/macOS) or <environment_name>\Scripts\activate (Windows) command to activate the environment.
Install packages: Use pip install <package_name> to install packages into the environment.
Deactivate the environment: Use the deactivate command to exit the environment.
