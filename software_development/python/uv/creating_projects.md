# **[Creating Projects](https://docs.astral.sh/uv/concepts/projects/init/)**

**[Research List](../../../research_list.md)**\
**[Detailed Status](../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../README.md)**

uv supports creating a project with uv init.

When creating projects, uv supports two basic templates: applications and libraries. By default, uv will create a project for an application. The --lib flag can be used to create a project for a library instead.

## Target directory

uv will create a project in the working directory, or, in a target directory by providing a name, e.g., uv init foo. If there's already a project in the target directory, i.e., if there's a pyproject.toml, uv will exit with an error.

## Applications

Application projects are suitable for web servers, scripts, and command-line interfaces.

Applications are the default target for uv init, but can also be specified with the --app flag.

`uv init example-app`

The project includes a pyproject.toml, a sample file (main.py), a readme, and a Python version pin file (.python-version).

```bash
tree example-app
```

Prior to v0.6.0, uv created a file named hello.py instead of main.py.

The pyproject.toml includes basic metadata. It does not include a build system, it is not a package and will not be installed into the environment:

```bash
pyproject.toml

[project]
name = "example-app"
version = "0.1.0"
description = "Add your description here"
readme = "README.md"
requires-python = ">=3.11"
dependencies = []
```

The sample file defines a main function with some standard boilerplate:

```python
# main.py

def main():
    print("Hello from example-app!")


if __name__ == "__main__":
    main()
```

Python files can be executed with uv run:

```bash
cd example-app
uv run main.py
Creating virtual environment at: .venv
Hello from veths-and-namespaces-md!

cat uv.lock
version = 1
revision = 1
requires-python = ">=3.12"

[[package]]
name = "veths-and-namespaces-md"
version = "0.1.0"
source = { virtual = "." }
```

## Packaged applications

Many use-cases require a **[package](https://docs.astral.sh/uv/concepts/projects/config/#project-packaging)**. For example, if you are creating a command-line interface that will be published to PyPI or if you want to define tests in a dedicated directory.

The --package flag can be used to create a packaged application:

```bash
uv init --package example-pkg
```

A build system is defined, so the project will be installed into the environment:

pyproject.toml

[project]
name = "example-pkg"
version = "0.1.0"
description = "Add your description here"
readme = "README.md"
requires-python = ">=3.11"
dependencies = []

[project.scripts]
example-pkg = "example_pkg:main"

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"
Tip

The --build-backend option can be used to request an alternative build system.
