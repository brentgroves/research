# **[Python Virtual Environments](https://docs.python.org/3/library/venv.html)**

Changed in version 3.5: The use of venv is now recommended for creating virtual environments.

Deprecated since version 3.6: pyvenv was the recommended tool for creating virtual environments for Python 3.3 and 3.4, and is deprecated in Python 3.6.

## venv — Creation of virtual environments

The venv module supports creating lightweight “virtual environments”, each with their own independent set of Python packages installed in their site directories. A virtual environment is created on top of an existing Python installation, known as the virtual environment’s “base” Python, and may optionally be isolated from the packages in the base environment, so only those explicitly installed in the virtual environment are available.

When used from within a virtual environment, common installation tools such as pip will install Python packages into a virtual environment without needing to be told to do so explicitly.

A virtual environment is (amongst other things):

- Used to contain a specific Python interpreter and software libraries and binaries which are needed to support a project (library or application). These are by default isolated from software in other virtual environments and Python interpreters and libraries installed in the operating system.
- Contained in a directory, conventionally either named venv or .venv in the project directory, or under a container directory for lots of virtual environments, such as ~/.virtualenvs.
- Not checked into source control systems such as Git.
- Considered as disposable – it should be simple to delete and recreate it from scratch. You don’t place any project code in the environment
- Not considered as movable or copyable – you just recreate the same environment in the target location.

See **[PEP 405](https://peps.python.org/pep-0405/)** for more background on Python virtual environments.

See also **[Python Packaging User Guide](https://packaging.python.org/guides/installing-using-pip-and-virtual-environments/#create-and-use-virtual-environments)**: Creating and using virtual environments
**[Availability](https://docs.python.org/3/library/intro.html#availability)**: not Emscripten, not WASI.

This module does not work or is not available on **[WebAssembly](https://webassembly.org/)** platforms wasm32-emscripten and wasm32-wasi. See WebAssembly platforms for more information.

## Creating virtual environments

Virtual environments are created by executing the venv module:

`python -m venv /path/to/new/virtual/environment`

This creates the target directory (including parent directories as needed) and places a pyvenv.cfg file in it with a home key pointing to the Python installation from which the command was run. It also creates a bin (or Scripts on Windows) subdirectory containing a copy or symlink of the Python executable (as appropriate for the platform or arguments used at environment creation time). It also creates a lib/pythonX.Y/site-packages subdirectory (on Windows, this is Libsite-packages). If an existing directory is specified, it will be re-used.

Changed in version 3.5: The use of venv is now recommended for creating virtual environments.

Deprecated since version 3.6, removed in version 3.8: pyvenv was the recommended tool for creating virtual environments for Python 3.3 and 3.4, and replaced in 3.5 by executing venv directly.

On Windows, invoke the venv command as follows:

python -m venv C:\path\to\new\virtual\environment
The command, if run with -h, will show the available options:

usage: venv [-h] [--system-site-packages] [--symlinks | --copies] [--clear]
            [--upgrade] [--without-pip] [--prompt PROMPT] [--upgrade-deps]
            [--without-scm-ignore-files]
            ENV_DIR [ENV_DIR ...]

Creates virtual Python environments in one or more target directories.

positional arguments:
  ENV_DIR               A directory to create the environment in.

options:
  -h, --help            show this help message and exit
  --system-site-packages
                        Give the virtual environment access to the system
                        site-packages dir.
  --symlinks            Try to use symlinks rather than copies, when
                        symlinks are not the default for the platform.
  --copies              Try to use copies rather than symlinks, even when
                        symlinks are the default for the platform.
  --clear               Delete the contents of the environment directory
                        if it already exists, before environment creation.
  --upgrade             Upgrade the environment directory to use this
                        version of Python, assuming Python has been
                        upgraded in-place.
  --without-pip         Skips installing or upgrading pip in the virtual
                        environment (pip is bootstrapped by default)
  --prompt PROMPT       Provides an alternative prompt prefix for this
                        environment.
  --upgrade-deps        Upgrade core dependencies (pip) to the latest
                        version in PyPI
  --without-scm-ignore-files
                        Skips adding SCM ignore files to the environment
                        directory (Git is supported by default).

Once an environment has been created, you may wish to activate it, e.g. by
sourcing an activate script in its bin directory.
Changed in version 3.4: Installs pip by default, added the --without-pip and --copies options.

Changed in version 3.4: In earlier versions, if the target directory already existed, an error was raised, unless the --clear or --upgrade option was provided.

Changed in version 3.9: Add --upgrade-deps option to upgrade pip + setuptools to the latest on PyPI.

Changed in version 3.12: setuptools is no longer a core venv dependency.

Changed in version 3.13: Added the --without-scm-ignore-files option.

Changed in version 3.13: venv now creates a .gitignore file for Git by default.

## How venvs work

When a Python interpreter is running from a virtual environment, sys.prefix and sys.exec_prefix point to the directories of the virtual environment, whereas sys.base_prefix and sys.base_exec_prefix point to those of the base Python used to create the environment. It is sufficient to check sys.prefix != sys.base_prefix to determine if the current interpreter is running from a virtual environment.

A virtual environment may be “activated” using a script in its binary directory (bin on POSIX; Scripts on Windows). This will prepend that directory to your PATH, so that running python will invoke the environment’s Python interpreter and you can run installed scripts without having to use their full path. The invocation of the activation script is platform-specific (<venv> must be replaced by the path to the directory containing the virtual environment):

| Platform | Shell      | Command to activate virtual environment |
|----------|------------|-----------------------------------------|
| POSIX    | bash/zsh   | $ source <venv>/bin/activate            |
|          | fish       | $ source <venv>/bin/activate.fish       |
|          | csh/tcsh   | $ source <venv>/bin/activate.csh        |
|          | pwsh       | $ <venv>/bin/Activate.ps1               |
| Windows  | cmd.exe    | C:\> <venv>\Scripts\activate.bat        |
|          | PowerShell | PS C:\> <venv>\Scripts\Activate.ps1     |

You don’t specifically need to activate a virtual environment, as you can just specify the full path to that environment’s Python interpreter when invoking Python. Furthermore, all scripts installed in the environment should be runnable without activating it.

In order to achieve this, scripts installed into virtual environments have a “shebang” line which points to the environment’s Python interpreter, #!/<path-to-venv>/bin/python. This means that the script will run with that interpreter regardless of the value of PATH. On Windows, “shebang” line processing is supported if you have the Python Launcher for Windows installed. Thus, double-clicking an installed script in a Windows Explorer window should run it with the correct interpreter without the environment needing to be activated or on the PATH.

When a virtual environment has been activated, the VIRTUAL_ENV environment variable is set to the path of the environment. Since explicitly activating a virtual environment is not required to use it, VIRTUAL_ENV cannot be relied upon to determine whether a virtual environment is being used.

Warning Because scripts installed in environments should not expect the environment to be activated, their shebang lines contain the absolute paths to their environment’s interpreters. Because of this, environments are inherently non-portable, in the general case. You should always have a simple means of recreating an environment (for example, if you have a requirements file requirements.txt, you can invoke pip install -r requirements.txt using the environment’s pip to install all of the packages needed by the environment). If for any reason you need to move the environment to a new location, you should recreate it at the desired location and delete the one at the old location. If you move an environment because you moved a parent directory of it, you should recreate the environment in its new location. Otherwise, software installed into the environment may not work as expected.

You can deactivate a virtual environment by typing deactivate in your shell. The exact mechanism is platform-specific and is an internal implementation detail (typically, a script or shell function will be used).

API
The high-level method described above makes use of a simple API which provides mechanisms for third-party virtual environment creators to customize environment creation according to their needs, the EnvBuilder class.

## Notes on availability

An “Availability: Unix” note means that this function is commonly found on Unix systems. It does not make any claims about its existence on a specific operating system.

If not separately noted, all functions that claim “Availability: Unix” are supported on macOS, which builds on a Unix core.

If an availability note contains both a minimum Kernel version and a minimum libc version, then both conditions must hold. For example a feature with note Availability: Linux >= 3.17 with glibc >= 2.27 requires both Linux 3.17 or newer and glibc 2.27 or newer.

## WebAssembly platforms

The WebAssembly platforms wasm32-emscripten (Emscripten) and wasm32-wasi (WASI) provide a subset of POSIX APIs. WebAssembly runtimes and browsers are sandboxed and have limited access to the host and external resources. Any Python standard library module that uses processes, threading, networking, signals, or other forms of inter-process communication (IPC), is either not available or may not work as on other Unix-like systems. File I/O, file system, and Unix permission-related functions are restricted, too. Emscripten does not permit blocking I/O. Other blocking operations like sleep() block the browser event loop.

The properties and behavior of Python on WebAssembly platforms depend on the Emscripten-SDK or WASI-SDK version, WASM runtimes (browser, NodeJS, wasmtime), and Python build time flags. WebAssembly, Emscripten, and WASI are evolving standards; some features like networking may be supported in the future.

For Python in the browser, users should consider Pyodide or PyScript. PyScript is built on top of Pyodide, which itself is built on top of CPython and Emscripten. Pyodide provides access to browsers’ JavaScript and DOM APIs as well as limited networking capabilities with JavaScript’s XMLHttpRequest and Fetch APIs.

Process-related APIs are not available or always fail with an error. That includes APIs that spawn new processes (fork(), execve()), wait for processes (waitpid()), send signals (kill()), or otherwise interact with processes. The subprocess is importable but does not work.

The socket module is available, but is limited and behaves differently from other platforms. On Emscripten, sockets are always non-blocking and require additional JavaScript code and helpers on the server to proxy TCP through WebSockets; see Emscripten Networking for more information. WASI snapshot preview 1 only permits sockets from an existing file descriptor.

Some functions are stubs that either don’t do anything and always return hardcoded values.

Functions related to file descriptors, file permissions, file ownership, and links are limited and don’t support some operations. For example, WASI does not permit symlinks with absolute file names.
