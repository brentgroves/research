# **[setup venv](https://www.freecodecamp.org/news/how-to-setup-virtual-environments-in-python/)**

## references

- **[setup venv](https://www.freecodecamp.org/news/how-to-setup-virtual-environments-in-python/)**
- **[Creating virtual environments](https://docs.python.org/3/library/venv.html)**

# **[setup venv](https://www.freecodecamp.org/news/how-to-setup-virtual-environments-in-python/)**

## How to Install a Virtual Environment using Venv

Virtualenv is a tool to set up your Python environments. Since Python 3.3, a subset of it has been integrated into the standard library under the venv module. You can install venv to your host Python by running this command in your terminal:

pip install virtualenv
To use venv in your project, in your terminal, create a new project folder, cd to the project folder in your terminal, and run the following command:

```bash
# add env/ folder to gitignore
conda deactivate
pushd .
cd ~/src/repsys/volumes/python/tutorials/venv
# python3.8 -m venv env if multiple versions of python are installed using deadsnakes ppa
python3 -m venv env
source env/bin/activate
```

## How to Activate the Virtual Environment

Now that you have created the virtual environment, you will need to activate it before you can use it in your project. On a mac, to activate your virtual environment, run the code below:

```source env/bin/activate```
This will activate your virtual environment. Immediately, you will notice that your terminal path includes env, signifying an activated virtual environment.

## Is the Virtual Environment Working?

We have activated our virtual environment, now how do we confirm that our project is in fact isolated from our host Python? We can do a couple of things.

First we check the list of packages installed in our virtual environment by running the code below in the activated virtual environment. You will notice only two packages – pip and setuptools, which are the base packages that come default with a new virtual environment

```bash
pip list
Package    Version
---------- -------
pip        22.0.2
setuptools 59.6.0
```

Next you can run the same code above in a new terminal in which you haven't activated the virtual environment. You will notice a lot more libraries in your host Python that you may have installed in the past. These libraries are not part of your Python virtual environment until you install them.

## How to Install Libraries in a Virtual Environment

To install new libraries, you can easily just pip install the libraries. The virtual environment will make use of its own pip, so you don't need to use pip3.

After installing your required libraries, you can view all installed libraries by using pip list, or you can generate a text file listing all your project dependencies by running the code below:

```bash
pip freeze > requirements.txt
You can name this requirements.txt file whatever you want.
```

## Requirements File

Why is a requirements file important to your project? Consider that you package your project in a zip file (without the env folder) and you share with your developer friend.

To recreate your development environment, your friend will just need to follow the above steps to activate a new virtual environment.

Instead of having to install each dependency one by one, they could just run the code below to install all your dependencies within their own copy of the project:

```~ pip install -r requirements.txt```

Note that it is generally not advisable to share your env folder, and it should be easily replicated in any new environment.

Typically your env directory will be included in a .gitignore file (when using version control platforms like GitHub) to ensure that the environment file is not pushed to the project repository.

## How to Deactivate a Virtual Environment

To deactivate your virtual environment, simply run the following code in the terminal:

```~ deactivate```

## Conclusion

Python virtual environments give you the ability to isolate your Python development projects from your system installed Python and other Python environments. This gives you full control of your project and makes it easily reproducible.

When developing applications that would generally grow out of a simple .py script or a Jupyter notebook, it's a good idea to use a virtual environment – and now you know how to set up and start using one.

```bash
The command, if run with -h, will show the available options:

usage: venv [-h] [--system-site-packages] [--symlinks | --copies] [--clear]
            [--upgrade] [--without-pip] [--prompt PROMPT] [--upgrade-deps]
            ENV_DIR [ENV_DIR ...]

Creates virtual Python environments in one or more target directories.

positional arguments:
  ENV_DIR               A directory to create the environment in.

optional arguments:
  -h, --help            show this help message and exit
  --system-site-packages
                        Give the virtual environment access to the system
                        site-packages dir.
  --symlinks            Try to use symlinks rather than copies, when symlinks
                        are not the default for the platform.
  --copies              Try to use copies rather than symlinks, even when
                        symlinks are the default for the platform.
  --clear               Delete the contents of the environment directory if it
                        already exists, before environment creation.
  --upgrade             Upgrade the environment directory to use this version
                        of Python, assuming Python has been upgraded in-place.
  --without-pip         Skips installing or upgrading pip in the virtual
                        environment (pip is bootstrapped by default)
  --prompt PROMPT       Provides an alternative prompt prefix for this
                        environment.
  --upgrade-deps        Upgrade core dependencies (pip) to the
                        latest version in PyPI

Once an environment has been created, you may wish to activate it, e.g. by
sourcing an activate script in its bin directory.

```

Changed in version 3.12: setuptools is no longer a core venv dependency.

Changed in version 3.9: Add --upgrade-deps option to upgrade pip + setuptools to the latest on PyPI

Changed in version 3.4: Installs pip by default, added the --without-pip and --copies options

Changed in version 3.4: In earlier versions, if the target directory already existed, an error was raised, unless the --clear or --upgrade option was provided.

The created pyvenv.cfg file also includes the include-system-site-packages key, set to true if venv is run with the --system-site-packages option, false otherwise.

Unless the --without-pip option is given, ensurepip will be invoked to bootstrap pip into the virtual environment.

Multiple paths can be given to venv, in which case an identical virtual environment will be created, according to the given options, at each provided path.

## How venvs work

When a Python interpreter is running from a virtual environment, sys.prefix and sys.exec_prefix point to the directories of the virtual environment, whereas sys.base_prefix and sys.base_exec_prefix point to those of the base Python used to create the environment. It is sufficient to check sys.prefix != sys.base_prefix to determine if the current interpreter is running from a virtual environment.

A virtual environment may be “activated” using a script in its binary directory (bin on POSIX; Scripts on Windows). This will prepend that directory to your PATH, so that running python will invoke the environment’s Python interpreter and you can run installed scripts without having to use their full path. The invocation of the activation script is platform-specific (<venv> must be replaced by the path to the directory containing the virtual environment):

```bash
conda deactivate
pushd .
cd ~/src/volumes/python/tutorials/venv
# python -m venv /path/to/new/virtual/environment
python -m venv .
$ source <venv>/bin/activate
```

You don’t specifically need to activate a virtual environment, as you can just specify the full path to that environment’s Python interpreter when invoking Python. Furthermore, all scripts installed in the environment should be runnable without activating it.

In order to achieve this, scripts installed into virtual environments have a “shebang” line which points to the environment’s Python interpreter, i.e. #!/<path-to-venv>/bin/python. This means that the script will run with that interpreter regardless of the value of PATH. On Windows, “shebang” line processing is supported if you have the Python Launcher for Windows installed. Thus, double-clicking an installed script in a Windows Explorer window should run it with the correct interpreter without the environment needing to be activated or on the PATH.

When a virtual environment has been activated, the VIRTUAL_ENV environment variable is set to the path of the environment. Since explicitly activating a virtual environment is not required to use it, VIRTUAL_ENV cannot be relied upon to determine whether a virtual environment is being used.

Warning Because scripts installed in environments should not expect the environment to be activated, their shebang lines contain the absolute paths to their environment’s interpreters. Because of this, environments are inherently non-portable, in the general case. **You should always have a simple means of recreating an environment (for example, if you have a requirements file requirements.txt, you can invoke pip install -r requirements.txt using the environment’s pip to install all of the packages needed by the environment).** If for any reason you need to move the environment to a new location, you should recreate it at the desired location and delete the one at the old location. If you move an environment because you moved a parent directory of it, you should recreate the environment in its new location. Otherwise, software installed into the environment may not work as expected.
You can **deactivate a virtual environment by typing deactivate in your shell.** The exact mechanism is platform-specific and is an internal implementation detail (typically, a script or shell function will be used).
