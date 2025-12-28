# **[Managing dependencies](https://docs.astral.sh/uv/concepts/projects/dependencies/)**

**[Research List](../../../research_list.md)**\
**[Detailed Status](../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../README.md)**

## Dependency fields

Dependencies of the project are defined in several fields:

- **[project.dependencies](https://docs.astral.sh/uv/concepts/projects/dependencies/#project-dependencies)**: Published dependencies.
- project.optional-dependencies: Published optional dependencies, or "extras".
- dependency-groups: Local dependencies for development.
- tool.uv.sources: Alternative sources for dependencies during development.

The project.dependencies and project.optional-dependencies fields can be used even if project isn't going to be published. dependency-groups are a recently standardized feature and may not be supported by all tools yet.

uv supports modifying the project's dependencies with uv add and uv remove, but dependency metadata can also be updated by editing the pyproject.toml directly.

## Adding dependencies

To add a dependency:

`uv add httpx`

An entry will be added in the project.dependencies field:

pyproject.toml

[project]
name = "example"
version = "0.1.0"
dependencies = ["httpx>=0.27.2"]

The --dev, --group, or --optional flags can be used to add a dependencies to an alternative field.

The dependency will include a constraint, e.g., >=0.27.2, for the most recent, compatible version of the package. An alternative constraint can be provided:

`uv add "httpx>=0.20"`

When adding a dependency from a source other than a package registry, uv will add an entry in the sources field. For example, when adding httpx from GitHub:

`uv add "httpx @ git+https://github.com/encode/httpx"`

The pyproject.toml will include a Git source entry:

pyproject.toml

[project]
name = "example"
version = "0.1.0"
dependencies = [
    "httpx",
]

[tool.uv.sources]
httpx = { git = "<https://github.com/encode/httpx>" }

If a dependency cannot be used, uv will display an error.:

```bash
uv add "httpx>9999"
```

Importing dependencies
Dependencies declared in a requirements.txt file can be added to the project with the -r option:

`uv add -r requirements.txt`

Removing dependencies
To remove a dependency:

`uv remove httpx`

The --dev, --group, or --optional flags can be used to remove a dependency from a specific table.

If a source is defined for the removed dependency, and there are no other references to the dependency, it will also be removed.

## Changing dependencies

To change an existing dependency, e.g., to use a different constraint for httpx:

`uv add "httpx>0.1.0"`

In this example, we are changing the constraints for the dependency in the pyproject.toml. The locked version of the dependency will only change if necessary to satisfy the new constraints. To force the package version to update to the latest within the constraints, use --upgrade-package <name>, e.g.:

`uv add "httpx>0.1.0" --upgrade-package httpx`

See the **[lockfile](https://docs.astral.sh/uv/concepts/projects/sync/#upgrading-locked-package-versions)** documentation for more details on upgrading packages.

Requesting a different dependency source will update the tool.uv.sources table, e.g., to use httpx from a local path during development:

`uv add "httpx @ ../httpx"`

Platform-specific dependencies
To ensure that a dependency is only installed on a specific platform or on specific Python versions, use environment markers.

For example, to install jax on Linux, but not on Windows or macOS:

`uv add "jax; sys_platform == 'linux'"`

The resulting pyproject.toml will then include the environment marker in the dependency definition:

pyproject.toml

[project]
name = "project"
version = "0.1.0"
requires-python = ">=3.11"
dependencies = ["jax; sys_platform == 'linux'"]

Similarly, to include numpy on Python 3.11 and later:

`uv add "numpy; python_version >= '3.11'"`

See Python's **[environment marker](https://peps.python.org/pep-0508/#environment-markers)** documentation for a complete enumeration of the available markers and operators.

Dependency sources can also be changed per-platform.

## Project dependencies

The project.dependencies table represents the dependencies that are used when uploading to PyPI or building a wheel. Individual dependencies are specified using dependency specifiers syntax, and the table follows the PEP 621 standard.

A wheel in Python is a distribution format for Python packages, designed to be a self-contained and readily installable archive. It's essentially a ZIP file with a .whl extension, containing all the necessary files for installation, including Python code, compiled extensions, and metadata. Wheels aim to provide faster and more reliable installations compared to source distributions (sdists).

project.dependencies defines the list of packages that are required for the project, along with the version constraints that should be used when installing them. Each entry includes a dependency name and version. An entry may include extras or environment markers for platform-specific packages. For example:

```bash
# pyproject.toml

[project]
name = "albatross"
version = "0.1.0"
dependencies = [
  # Any version in this range
  "tqdm >=4.66.2,<5",
  # Exactly this version of torch
  "torch ==2.2.2",
  # Install transformers with the torch extra
  "transformers[torch] >=4.39.3,<5",
  # Only install this package on older python versions
  # See "Environment Markers" for more information
  "importlib_metadata >=7.1.0,<8; python_version < '3.10'",
  "mollymawk ==0.1.0"
]
```

## Dependency sources

The tool.uv.sources table extends the standard dependency tables with alternative dependency sources, which are used during development.

Dependency sources add support for common patterns that are not supported by the project.dependencies standard, like editable installations and relative paths. For example, to install foo from a directory relative to the project root:

pyproject.toml

[project]
name = "example"
version = "0.1.0"
dependencies = ["foo"]

[tool.uv.sources]
foo = { path = "./packages/foo" }

The following dependency sources are supported by uv:

Index: A package resolved from a specific package index.
Git: A Git repository.
URL: A remote wheel or source distribution.
Path: A local wheel, source distribution, or project directory.
Workspace: A member of the current workspace.

Sources are only respected by uv. If another tool is used, only the definitions in the standard project tables will be used. If another tool is being used for development, any metadata provided in the source table will need to be re-specified in the other tool's format.

Index
To add Python package from a specific index, use the --index option:

uv add torch --index pytorch=<https://download.pytorch.org/whl/cpu>
uv will store the index in [[tool.uv.index]] and add a [tool.uv.sources] entry:

pyproject.toml

[project]
dependencies = ["torch"]

[tool.uv.sources]
torch = { index = "pytorch" }

[[tool.uv.index]]
name = "pytorch"
url = "<https://download.pytorch.org/whl/cpu>"

The above example will only work on x86-64 Linux, due to the specifics of the PyTorch index. See the **[PyTorch](https://docs.astral.sh/uv/guides/integration/pytorch/)** guide for more information about setting up PyTorch.

The **[PyTorch](https://pytorch.org/)** ecosystem is a popular choice for deep learning research and development. You can use uv to manage PyTorch projects and PyTorch dependencies across different Python versions and environments, even controlling for the choice of accelerator (e.g., CPU-only vs. CUDA).

Most machine learning workflows involve working with data, creating models, optimizing model parameters, and saving the trained models. This tutorial introduces you to a complete ML workflow implemented in PyTorch, with links to learn more about each of these concepts.

## Git

To add a Git dependency source, prefix a Git-compatible URL (i.e., that you would use with git clone) with git+.

For example:

`uv add git+https://github.com/encode/httpx`

pyproject.toml

[project]
dependencies = ["httpx"]

[tool.uv.sources]
httpx = { git = "<https://github.com/encode/httpx>" }

Specific Git references can be requested, e.g., a tag:

`uv add git+https://github.com/encode/httpx --tag 0.27.0`

pyproject.toml

[project]
dependencies = ["httpx"]

[tool.uv.sources]
httpx = { git = "<https://github.com/encode/httpx>", tag = "0.27.0" }

Or, a branch:

`uv add git+https://github.com/encode/httpx --branch main`
pyproject.toml

[project]
dependencies = ["httpx"]

[tool.uv.sources]
httpx = { git = "<https://github.com/encode/httpx>", branch = "main" }

Or, a revision (commit):

uv add git+<https://github.com/encode/httpx> --rev 326b9431c761e1ef1e00b9f760d1f654c8db48c6
pyproject.toml

[project]
dependencies = ["httpx"]

[tool.uv.sources]
httpx = { git = "<https://github.com/encode/httpx>", rev = "326b9431c761e1ef1e00b9f760d1f654c8db48c6" }
A subdirectory may be specified if the package isn't in the repository root:

uv add git+<https://github.com/langchain-ai/langchain#subdirectory=libs/langchain>
pyproject.toml

[project]
dependencies = ["langchain"]

[tool.uv.sources]
langchain = { git = "<https://github.com/langchain-ai/langchain>", subdirectory = "libs/langchain" }

## URL

To add a URL source, provide a https:// URL to either a wheel (ending in .whl) or a source distribution (typically ending in .tar.gz or .zip; see here for all supported formats).

For example:

uv add "<https://files.pythonhosted.org/packages/5c/2d/3da5bdf4408b8b2800061c339f240c1802f2e82d55e50bd39c5a881f47f0/httpx-0.27.0.tar.gz>"
Will result in a pyproject.toml with:

pyproject.toml

[project]
dependencies = ["httpx"]

[tool.uv.sources]
httpx = { url = "<https://files.pythonhosted.org/packages/5c/2d/3da5bdf4408b8b2800061c339f240c1802f2e82d55e50bd39c5a881f47f0/httpx-0.27.0.tar.gz>" }

URL dependencies can also be manually added or edited in the pyproject.toml with the { url = <url> } syntax. A subdirectory may be specified if the source distribution isn't in the archive root.

Path
To add a path source, provide the path of a wheel (ending in .whl), a source distribution (typically ending in .tar.gz or .zip; see here for all supported formats), or a directory containing a pyproject.toml.

For example:

uv add /example/foo-0.1.0-py3-none-any.whl
Will result in a pyproject.toml with:

pyproject.toml

[project]
dependencies = ["foo"]

[tool.uv.sources]
foo = { path = "/example/foo-0.1.0-py3-none-any.whl" }
The path may also be a relative path:

uv add ./foo-0.1.0-py3-none-any.whl
Or, a path to a project directory:

uv add ~/projects/bar/
Important

An editable installation is not used for path dependencies by default. An editable installation may be requested for project directories:

uv add --editable ../projects/bar/
Which will result in a pyproject.toml with:

pyproject.toml

[project]
dependencies = ["bar"]

[tool.uv.sources]
bar = { path = "../projects/bar", editable = true }
Similarly, if a project is marked as a non-package, but you'd like to install it in the environment as a package, set package = true on the source:

pyproject.toml

[project]
dependencies = ["bar"]

[tool.uv.sources]
bar = { path = "../projects/bar", package = true }
For multiple packages in the same repository, workspaces may be a better fit.
