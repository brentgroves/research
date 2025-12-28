# **[Install Python](https://docs.astral.sh/uv/guides/install-python/)**

**[Ubuntu 22.04 Desktop](../../../ubuntu22-04/desktop-install.md)**\
**[Ubuntu 22.04 Server](../../../ubuntu22-04/server-install.md)**\
**[Back to Main](../../../../README.md)**

Getting started
To install the latest Python version:

```bash
uv python install
```

Python does not publish official distributable binaries. As such, uv uses distributions from the Astral python-build-standalone project. See the **[Python distributions](https://docs.astral.sh/uv/concepts/python-versions/#managed-python-distributions)** documentation for more details.

Once Python is installed, it will be used by uv commands automatically.

## Important

When Python is installed by uv, it will not be available globally (i.e. via the python command). Support for this feature is in preview. See Installing Python executables for details.

You can still use uv run or create and activate a virtual environment to use python directly.

Installing a specific version
To install a specific Python version:

uv python install 3.12
To install multiple Python versions:

uv python install 3.11 3.12
To install an alternative Python implementation, e.g., PyPy:

uv python install pypy@3.10
See the python install documentation for more details.

## Using existing Python versions

uv will use existing Python installations if present on your system. There is no configuration necessary for this behavior: uv will use the system Python if it satisfies the requirements of the command invocation. See the Python discovery documentation for details.

To force uv to use the system Python, provide the --no-managed-python flag. See the Python version preference documentation for more details.

## Viewing Python installations

To view available and installed Python versions:

`uv python list`
