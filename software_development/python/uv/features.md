# **[features](https://docs.astral.sh/uv/getting-started/features/)**

**[Ubuntu 22.04 Desktop](../../../ubuntu22-04/desktop-install.md)**\
**[Ubuntu 22.04 Server](../../../ubuntu22-04/server-install.md)**\
**[Back to Main](../../../../README.md)**

Features
uv provides essential features for Python development — from installing Python and hacking on simple scripts to working on large projects that support multiple Python versions and platforms.

uv's interface can be broken down into sections, which are usable independently or together.

Python versions
Installing and managing Python itself.

```bash
uv python install: Install Python versions.
uv python install cpython-3.13.2-linux-x86_64-gnu
Installed Python 3.13.2 in 1.28s
 + cpython-3.13.2-linux-x86_64-gnu

uv python list: View available Python versions.
uv python find: Find an installed Python version.
uv python pin: Pin the current project to use a specific Python version.
uv python uninstall: Uninstall a Python version.
```
