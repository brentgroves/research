# **[Overview: What is pipx?](https://pipx.pypa.io/stable/)**

**[Research List](../../../research_list.md)**\
**[Detailed Status](../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../README.md)**

pipx is a tool to help you install and run end-user applications written in Python. It's roughly similar to macOS's brew, JavaScript's npx, and Linux's apt.

It's closely related to pip. In fact, it uses pip, but is focused on installing and managing Python packages that can be run from the command line directly as applications.

## How is it Different from pip?

pip is a general-purpose package installer for both libraries and apps with no environment isolation. pipx is made specifically for application installation, as it adds isolation yet still makes the apps available in your shell: pipx creates an isolated environment for each application and its associated packages.

pipx does not ship with pip, but installing it is often an important part of bootstrapping your system.

## Where Does pipx Install Apps From?

By default, pipx uses the same package index as pip, PyPI. pipx can also install from all other sources pip can, such as a local directory, wheel, git url, etc.

Python and PyPI allow developers to distribute code with "console script entry points". These entry points let users call into Python code from the command line, effectively acting like standalone applications.

pipx is a tool to install and run any of these thousands of application-containing packages in a safe, convenient, and reliable way. In a way, it turns Python Package Index (PyPI) into a big app store for Python applications. Not all Python packages have entry points, but many do.

If you would like to make your package compatible with pipx, all you need to do is add a **[console scripts](https://python-packaging.readthedocs.io/en/latest/command-line-scripts.html#the-console-scripts-entry-point)** entry point. If you're a poetry user, use these **[instructions](https://python-poetry.org/docs/pyproject/#scripts)**. Or, if you're using hatch, try this.

## Features

pipx enables you to

- Expose CLI entrypoints of packages ("apps") installed to isolated environments with the install command. This guarantees no dependency conflicts and clean uninstalls!
- Easily list, upgrade, and uninstall packages that were installed with pipx
- Run the latest version of a Python application in a temporary environment with the run command

Best of all, pipx runs with regular user permissions, never calling sudo pip install (you aren't doing that, are you? 😄).

## Walkthrough: Installing a Package and its Applications With pipx

You can globally install an application by running

`pipx install PACKAGE`

This automatically creates a virtual environment, installs the package, and adds the package's associated applications (entry points) to a location on your PATH. For example, pipx install pycowsay makes the pycowsay command available globally, but sandboxes the pycowsay package in its own virtual environment. pipx never needs to run as sudo to do this.

Example:

```python
>> pipx install pycowsay
  installed package pycowsay 2.0.3, Python 3.10.3
  These apps are now globally available
    - pycowsay
done! ✨ 🌟 ✨

>> pipx list
venvs are in /home/user/.local/share/pipx/venvs
apps are exposed on your $PATH at /home/user/.local/bin
   package pycowsay 2.0.3, Python 3.10.3
    - pycowsay

# Now you can run pycowsay from anywhere
>>
>> pycowsay mooo
  ____

< mooo >
  ====

         \
          \
            ^__^
            (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

## Installing from Source Control

You can also install from a git repository. Here, black is used as an example.

```bash
pipx install git+<https://github.com/psf/black.git>
pipx install git+<https://github.com/psf/black.git@branch>  # branch of your choice
pipx install git+<https://github.com/psf/black.git@ce14fa8b497bae2b50ec48b3bd7022573a59cdb1>  # git hash
pipx install <https://github.com/psf/black/archive/18.9b0.zip>  # install a release
The pip syntax with egg must be used when installing extras:

pipx install "git+<https://github.com/psf/black.git#egg=black[jupyter>]"
```

## Inject a package

If an application installed by pipx requires additional packages, you can add them with pipx inject. For example, if you have ipython installed and want to add the matplotlib package to it, you would use:

```bash
pipx inject ipython matplotlib
```

You can inject multiple packages by specifying them all on the command line, or by listing them in a text file, with one package per line, or a combination. For example:

```bash
pipx inject ipython matplotlib pandas

# or

pipx inject ipython -r useful-packages.txt
```

## Walkthrough: Running an Application in a Temporary Virtual Environment

This is an alternative to pipx install.

pipx run downloads and runs the above mentioned Python "apps" in a one-time, temporary environment, leaving your system untouched afterwards.

This can be handy when you need to run the latest version of an app, but don't necessarily want it installed on your computer.

You may want to do this when you are initializing a new project and want to set up the right directory structure, when you want to view the help text of an application, or if you simply want to run an app in a one-off case and leave your system untouched afterwards.

For example, the blog post How to set up a **[perfect Python project uses pipx](https://sourcery.ai/blog/python-best-practices/)** run to kickstart a new project with **[cookiecutter](https://github.com/cookiecutter/cookiecutter)**, a tool that creates projects from project templates.

A nice side benefit is that you don't have to remember to upgrade the app since pipx run will automatically run a recent version for you.

Okay, let's see what this looks like in practice!

`pipx run APP [ARGS...]`

This will install the package in an isolated, temporary directory and invoke the app. Give it a try:

```bash
> pipx run pycowsay moo

  ---
< moo >
  ---
   \   ^__^
    \  (oo)\_______
       (__)\       )\/\
           ||----w |
           ||     ||
```

Notice that you don't need to execute any install commands to run the app.

Any arguments after the application name will be passed directly to the application:

```bash
> pipx run pycowsay these arguments are all passed to pycowsay!

  -------------------------------------------

< these arguments are all passed to pycowsay! >
  -------------------------------------------

   \   ^**^
    \  (oo)\_**____
       (__)\       )\/\
           ||----w |
           ||     ||
```

## Ambiguous arguments

Sometimes pipx can consume arguments provided for the application:

```bash
> pipx run pycowsay --py

usage: pipx run [-h] [--no-cache] [--pypackages] [--spec SPEC] [--verbose] [--python PYTHON]
                [--system-site-packages] [--index-url INDEX_URL] [--editable] [--pip-args PIP_ARGS]
                app ...
pipx run: error: ambiguous option: --py could match --pypackages, --python
```

To prevent this put double dash -- before APP. It will make pipx to forward the arguments to the right verbatim to the application:

```bash
> pipx run -- pycowsay --py

  ----

< --py >
  ----

   \   ^**^
    \  (oo)\_**____
       (__)\       )\/\
           ||----w |
           ||     ||
```

Re-running the same app is quick because pipx caches Virtual Environments on a per-app basis. The caches only last a few days, and when they expire, pipx will again use the latest version of the package. This way you can be sure you're always running a new version of the package without having to manually upgrade.

Package with multiple apps, or the app name doesn't match the package name
If the app name does not match the package name, you can use the --spec argument to specify the PACKAGE name, and provide the APP to run separately:

`pipx run --spec PACKAGE APP`

For example, the esptool package doesn't provide an executable with the same name:

```bash
>> pipx run esptool
'esptool' executable script not found in package 'esptool'.
Available executable scripts:
    esp_rfc2217_server.py - usage: 'pipx run --spec esptool esp_rfc2217_server.py [arguments?]'
    espefuse.py - usage: 'pipx run --spec esptool espefuse.py [arguments?]'
    espsecure.py - usage: 'pipx run --spec esptool espsecure.py [arguments?]'
    esptool.py - usage: 'pipx run --spec esptool esptool.py [arguments?]'
```

You can instead run the executables that this package provides by using --spec:

```bash
pipx run --spec esptool esp_rfc2217_server.py
pipx run --spec esptool espefuse.py
pipx run --spec esptool espsecure.py
pipx run --spec esptool esptool.py
```

Note that the .py extension is not something you append to the executable name. It is part of the executable name, as provided by the package. This can be anything. For example, when working with the **[pymodbus](https://github.com/pymodbus-dev/pymodbus)** package:

```bash
>> pipx run pymodbus[repl]
'pymodbus' executable script not found in package 'pymodbus'.
Available executable scripts:
    pymodbus.console - usage: 'pipx run --spec pymodbus pymodbus.console [arguments?]'
    pymodbus.server - usage: 'pipx run --spec pymodbus pymodbus.server [arguments?]'
    pymodbus.simulator - usage: 'pipx run --spec pymodbus pymodbus.simulator [arguments?]'

```

You can run the executables like this:

```bash
pipx run --spec pymodbus[repl] pymodbus.console
pipx run --spec pymodbus[repl] pymodbus.server
pipx run --spec pymodbus[repl] pymodbus.simulator
```

## Running a specific version of a package

The PACKAGE argument above is actually a requirement specifier. Therefore, you can also specify specific versions, version ranges, or extras. For example:

```bash
pipx run mpremote==1.20.0
pipx run --spec esptool==4.6.2 esptool.py
pipx run --spec 'esptool>=4.5' esptool.py
pipx run --spec 'esptool >= 4.5' esptool.py
```

Notice that some requirement specifiers have to be enclosed in quotes or escaped.

## Running from Source Control

You can also run from a git repository. Here, black is used as an example.

```bash
pipx run --spec git+<https://github.com/psf/black.git> black
pipx run --spec git+<https://github.com/psf/black.git@branch> black  # branch of your choice
pipx run --spec git+<https://github.com/psf/black.git@ce14fa8b497bae2b50ec48b3bd7022573a59cdb1> black  # git hash
pipx run --spec <https://github.com/psf/black/archive/18.9b0.zip> black # install a release
```

## Running from URL

You can run .py files directly, too.

```bash
pipx run https://gist.githubusercontent.com/cs01/fa721a17a326e551ede048c5088f9e0f/raw/6bdfbb6e9c1132b1c38fdd2f195d4a24c540c324/pipx-demo.py
```

pipx is working!

Summary
That's it! Those are the most important commands pipx offers. To see all of pipx's documentation, run pipx --help or see the docs.

Testimonials
"Thanks for improving the workflow that pipsi has covered in the past. Nicely done!"
—Jannis Leidel, PSF fellow, former pip and Django core developer, and founder of the Python Packaging Authority (PyPA)
"My setup pieces together pyenv, poetry, and pipx. [...] For the things I need, it’s perfect."
—Jacob Kaplan-Moss, co-creator of Django in blog post My Python Development Environment, 2020 Edition
"I'm a big fan of pipx. I think pipx is super cool."
—Michael Kennedy, co-host of PythonBytes podcast in episode 139
Credits
pipx was inspired by pipsi and npx. It was created by Chad Smith and has had lots of help from contributors. The logo was created by @IrishMorales.

pipx is maintained by a team of volunteers (in alphabetical order)
