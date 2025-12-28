# **[Python Packaging User Guide](https://packaging.python.org/guides/installing-using-pip-and-virtual-environments/#create-and-use-virtual-environments)**: Creating and using virtual environments

## Create a new virtual environment

venv (for Python 3) allows you to manage separate package installations for different projects. It creates a “virtual” isolated Python installation. When you switch projects, you can create a new virtual environment which is isolated from other virtual environments. You benefit from the virtual environment since packages can be installed confidently and will not interfere with another project’s environment.

It is recommended to use a virtual environment when working with third party packages.

To create a virtual environment, go to your project’s directory and run the following command. This will create a new virtual environment in a local folder named .venv:

`python3 -m venv .venv`

The second argument is the location to create the virtual environment. Generally, you can just create this in your project and call it .venv.

venv will create a virtual Python installation in the .venv folder.

Note: You should exclude your virtual environment directory from your version control system using .gitignore or similar.

## Activate a virtual environment

Before you can start installing or using packages in your virtual environment you’ll need to activate it. Activating a virtual environment will put the virtual environment-specific python and pip executables into your shell’s PATH.

`source .venv/bin/activate`

To confirm the virtual environment is activated, check the location of your Python interpreter:

`which python`

While the virtual environment is active, the above command will output a filepath that includes the .venv directory, by ending with the following:

`.venv/bin/python`

While a virtual environment is activated, pip will install packages into that specific environment. This enables you to import and use packages in your Python application.

## Deactivate a virtual environment

If you want to switch projects or leave your virtual environment, deactivate the environment:

`deactivate`

Note: Closing your shell will deactivate the virtual environment. If you open a new shell window and want to use the virtual environment, reactivate it.

## Reactivate a virtual environment
If you want to reactivate an existing virtual environment, follow the same instructions about activating a virtual environment. There’s no need to create a new virtual environment.

## Prepare pip

pip is the reference Python package manager. It’s used to install and update packages into a virtual environment.

The Python installers for macOS include pip. On Linux, you may have to install an additional package such as python3-pip. You can make sure that pip is up-to-date by running:

```bash
python3 -m pip install --upgrade pip
python3 -m pip --version
```

Afterwards, you should have the latest version of pip installed in your user site:

`pip 23.3.1 from .../.venv/lib/python3.9/site-packages (python 3.9)`

## Install packages using pip

When your virtual environment is activated, you can install packages. Use the pip install command to install packages.

## Install a package

For example,let’s install the Requests library from the Python Package Index (PyPI):

`python3 -m pip install requests`

Pip should download requests and all of its dependencies and install them:

```bash
Collecting requests
  Using cached requests-2.18.4-py2.py3-none-any.whl
Collecting chardet<3.1.0,>=3.0.2 (from requests)
  Using cached chardet-3.0.4-py2.py3-none-any.whl
Collecting urllib3<1.23,>=1.21.1 (from requests)
  Using cached urllib3-1.22-py2.py3-none-any.whl
Collecting certifi>=2017.4.17 (from requests)
  Using cached certifi-2017.7.27.1-py2.py3-none-any.whl
Collecting idna<2.7,>=2.5 (from requests)
  Using cached idna-2.6-py2.py3-none-any.whl
Installing collected packages: chardet, urllib3, certifi, idna, requests
Successfully installed certifi-2017.7.27.1 chardet-3.0.4 idna-2.6 requests-2.18.4 urllib3-1.22
```

## Install a specific package version

pip allows you to specify which version of a package to install using version specifiers. For example, to install a specific version of requests:

`python3 -m pip install 'requests==2.18.4'`

To install the latest 2.x release of requests:

`python3 -m pip install 'requests>=2.0.0,<3.0.0'`

To install pre-release versions of packages, use the --pre flag:

`python3 -m pip install --pre requests`

## Install extras

Some packages have optional **[extras](https://setuptools.readthedocs.io/en/latest/userguide/dependency_management.html#optional-dependencies)**. You can tell pip to install these by specifying the extra in brackets:


`python3 -m pip install 'requests[security]'`

## Install a package from source

pip can install a package directly from its source code. For example, to install the source code in the google-auth directory:

```bash
cd google-auth
python3 -m pip install .
```

Additionally, pip can install packages from source in **[development mode](https://setuptools.pypa.io/en/latest/userguide/development_mode.html)**, meaning that changes to the source directory will immediately affect the installed package without needing to re-install:


`python3 -m pip install --editable .`

## Install from version control systems

pip can install packages directly from their version control system. For example, you can install directly from a git repository:

`google-auth @ git+https://github.com/GoogleCloudPlatform/google-auth-library-python.git`
For more information on supported version control systems and syntax, see pip’s documentation on **[VCS Support](https://pip.pypa.io/en/latest/topics/vcs-support/#vcs-support)**.

## Install from local archives

If you have a local copy of a Distribution Package’s archive (a zip, wheel, or tar file) you can install it directly with pip:

`python3 -m pip install requests-2.18.4.tar.gz`

If you have a directory containing archives of multiple packages, you can tell pip to look for packages there and not to use the **[Python Package Index (PyPI)](https://packaging.python.org/en/latest/glossary/#term-Python-Package-Index-PyPI)** at all:

### Python Package Index (PyPI)
**[PyPI](https://pypi.org/)** is the default **[Package Index](https://packaging.python.org/en/latest/glossary/#term-Package-Index)** for the Python community. It is open to all Python developers to consume and distribute their distributions.

### Package Index

A repository of distributions with a web interface to automate **[package](https://packaging.python.org/en/latest/glossary/#term-Distribution-Package)** discovery and consumption.

### Distribution Package

A versioned archive file that contains Python **[packages](https://packaging.python.org/en/latest/glossary/#term-Import-Package)**, **[modules](https://packaging.python.org/en/latest/glossary/#term-Module)**, and other resource files that are used to distribute a Release. The archive file is what an end-user will download from the internet and install.

A distribution package is more commonly referred to with the single words “package” or “distribution”, but this guide may use the expanded term when more clarity is needed to prevent confusion with an Import Package (which is also commonly called a “package”) or another kind of distribution (e.g. a Linux distribution or the Python language distribution), which are often referred to with the single term “distribution”. See **[Distribution package vs. import package](https://packaging.python.org/en/latest/discussions/distribution-package-vs-import-package/#distribution-package-vs-import-package)** for a breakdown of the differences.

