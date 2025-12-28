# **[venv — Creation of virtual environments](https://docs.python.org/3/library/venv.html)**

**[Ubuntu 22.04 Desktop](../../ubuntu22-04/desktop-install.md)**\
**[Ubuntu 22.04 Server](../../ubuntu22-04/server-install.md)**\
**[Back to Main](../../../README.md)**

**The reason I'm using the python virtual environment** instead of conda is because conda is changing the OpenSSL environment which I have configured for our PKI and Plex ODBC connections.

The venv module supports creating lightweight “virtual environments”, each with their own independent set of Python packages installed in their **[site](https://docs.python.org/3/library/site.html#module-site)** directories. A virtual environment is created on top of an existing Python installation, known as the virtual environment’s “base” Python, and may optionally be isolated from the packages in the base environment, so only those explicitly installed in the virtual environment are available.

When used from within a virtual environment, common installation tools such as pip will install Python packages into a virtual environment without needing to be told to do so explicitly.

A virtual environment is (amongst other things):

- Used to contain a specific Python interpreter and software libraries and binaries which are needed to support a project (library or application). These are by default isolated from software in other virtual environments and Python interpreters and libraries installed in the operating system.
- Contained in a directory, conventionally named .venv or venv in the project directory, or under a container directory for lots of virtual environments, such as ~/.virtualenvs.
- Not checked into source control systems such as Git.
- Considered as disposable – it should be simple to delete and recreate it from scratch. You don’t place any project code in the environment.
- Not considered as movable or copyable – you just recreate the same environment in the target location.

See **[PEP 405](https://peps.python.org/pep-0405/)** for more background on Python virtual environments.

See also **[Python Packaging User Guide: Creating and using virtual environments](https://packaging.python.org/guides/installing-using-pip-and-virtual-environments/#create-and-use-virtual-environments)**

Availability: not Android, not iOS, not WASI.

This module is not supported on mobile platforms or WebAssembly platforms.

## Creating virtual environments

Virtual environments are created by executing the venv module:

`python -m venv /path/to/new/virtual/environment`

This creates the target directory (including parent directories as needed) and places a pyvenv.cfg file in it with a home key pointing to the Python installation from which the command was run. It also creates a bin (or Scripts on Windows) subdirectory containing a copy or symlink of the Python executable (as appropriate for the platform or arguments used at environment creation time). It also creates a lib/pythonX.Y/site-packages subdirectory (on Windows, this is Libsite-packages). If an existing directory is specified, it will be re-used.

## Use different Python version with virtualenv

NOTE: For Python 3.3+, see The Aelfinn's answer below.

Use the --python (or short -p) option when creating a virtualenv instance to specify the Python executable you want to use, e.g.:

virtualenv --python="/usr/bin/python2.6" "/path/to/new/virtualenv/"
