# **[https://github.com/pyenv/pyenv](linux/k_p/python/python-virtual_environment.md)**

**[Ubuntu 22.04 Desktop](../../ubuntu22-04/desktop-install.md)**\
**[Ubuntu 22.04 Server](../../ubuntu22-04/server-install.md)**\
**[Back to Main](../../../README.md)**

Note: Suggest 'uv' instead.  Had problems with pyenv in ubuntu 24.04.

Simple Python Version Management: pyenv
Join the chat at <https://gitter.im/yyuu/pyenv>

pyenv lets you easily switch between multiple versions of Python. It's simple, unobtrusive, and follows the UNIX tradition of single-purpose tools that do one thing well.

This project was forked from rbenv and ruby-build, and modified for Python.

What pyenv does...
Lets you change the global Python version on a per-user basis.
Provides support for per-project Python versions.
Allows you to override the Python version with an environment variable.
Searches for commands from multiple versions of Python at a time. This may be helpful to test across Python versions with tox.
In contrast with pythonbrew and pythonz, pyenv does not...
Depend on Python itself. pyenv was made from pure shell scripts. There is no bootstrap problem of Python.
Need to be loaded into your shell. Instead, pyenv's shim approach works by adding a directory to your PATH.
Manage virtualenv. Of course, you can create virtualenv yourself, or pyenv-virtualenv to automate the process.

## **[How to Install Pyenv on Ubuntu 24.04](https://dev.to/emdadul38/how-to-install-pyenv-on-ubuntu-2404-5807)**

Due to the slowness of repositories or even lack thereof being updated with specific versions of Python, I’ve decided to move some of my environments over to Pyenv to allow me to dynamically install and configure Python specifically for my environment. As it turns out this will also allow VS Code to allow me to choose the version of Python that I’d like to use when testing. So, here’s a quick guide to installing Pyenv on Ubuntu 24.04

Update and install dependencies
we need to ensure our package cache is updated, and then install the dependencies to download, and build python from pyenv.

`sudo apt-get update && sudo apt-get install make build-essential`

Install Pyenv using pyenv-installer

`curl -fsSL https://pyenv.run | bash`

## Configure user profile to use pyenv

Ensure the following is in your ~/.bash_profile (if exists), ~/.profile (for login shells), ~/.bashrc (for interactive shells), or ~/.zshrc

Note: This is already in .zshrc_pyenv script.

```bash
# Load pyenv automatically by appending
# the following to 
# ~/.bash_profile if it exists, otherwise ~/.profile (for login shells)
# and ~/.bashrc (for interactive shells) :

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
```

## Optionally enable pyenv-virtualenv

eval "$(pyenv virtualenv-init -)"

## Install python using pyenv

```bash
pyenv install 3.12.9
pyenv install 3.13.2 # failed 
```

## Install not for 24.04

1. Automatic installer (Recommended)

```bash
curl -fsSL https://pyenv.run | bash
which pyenv 
/home/brent/.pyenv/bin/pyenv
sudo su
curl -fsSL https://pyenv.run | bash
WARNING: seems you still have not added 'pyenv' to the load path.

# Load pyenv automatically by appending
# the following to 
# ~/.bash_profile if it exists, otherwise ~/.profile (for login shells)
# and ~/.bashrc (for interactive shells) :

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

# Restart your shell for the changes to take effect.

# Load pyenv-virtualenv automatically by adding
# the following to ~/.bashrc:

eval "$(pyenv virtualenv-init -)"

which pyenv 

```

For more details visit our other project: <https://github.com/pyenv/pyenv-installer>

## B. Set up your shell environment for Pyenv

The below setup should work for the vast majority of users for common use cases. See Advanced configuration for details and more configuration options.

Note: this is in the .zshrc-pyenv dotfile script

```bash
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
  echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
  echo 'eval "$(pyenv init - zsh)"' >> ~/.zshrc
```  

## C. Restart your shell

for the PATH changes to take effect.

`exec "$SHELL"`

## D. Install Python build dependencies

Install **[Python build dependencies](https://github.com/pyenv/pyenv/wiki#suggested-build-environment)** before attempting to install a new Python version.

You can now begin using Pyenv.

## Suggested build environment

pyenv will try its best to download and compile the wanted Python version, but sometimes compilation fails because of unmet system dependencies, or compilation succeeds but the new Python version exhibits weird failures at runtime. The following instructions are our recommendations for a sane build environment.

## Ubuntu/Debian/Mint

```bash
sudo apt update; sudo apt install build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl git \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

The following packages have unmet dependencies:
 libncursesw5-dev : Depends: libtinfo6 (= 6.2-0ubuntu2.1) but 6.4+20240113-1ubuntu2 is to be installed
                    Depends: libncurses-dev (= 6.2-0ubuntu2.1) but 6.4+20240113-1ubuntu2 is to be installed
E: Unable to correct problems, you have held broken packages.
```

The Python's documentation reports a different set of dependencies in the documentation and in the script used in the GitHub Actions

If you are going build PyPy from source or install other Python flavors that require CLang, also install llvm.
