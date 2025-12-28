# **[Project packaging](https://docs.astral.sh/uv/concepts/projects/config/#project-packaging)**

**[Research List](../../../research_list.md)**\
**[Detailed Status](../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../README.md)**

As discussed in build systems, a Python project must be built to be installed. This process is generally referred to as "packaging".

You probably need a package if you want to:

- Add commands to the project
- Distribute the project to others
- Use a src and test layout
- Write a library

You probably do not need a package if you are:

- Writing scripts
- Building a simple application
- Using a flat layout

While uv usually uses the declaration of a build system to determine if a project should be packaged, uv also allows overriding this behavior with the tool.uv.package setting.

Setting tool.uv.package = true will force a project to be built and installed into the project environment. If no build system is defined, uv will use the setuptools legacy backend.

Setting tool.uv.package = false will force a project package not to be built and installed into the project environment. uv will ignore a declared build system when interacting with the project; however, uv will still respect explicit attempts to build the project such as invoking uv build.

## Project environment path

The UV_PROJECT_ENVIRONMENT environment variable can be used to configure the project virtual environment path (.venv by default).

If a relative path is provided, it will be resolved relative to the workspace root. If an absolute path is provided, it will be used as-is, i.e., a child directory will not be created for the environment. If an environment is not present at the provided path, uv will create it.

This option can be used to write to the system Python environment, though it is not recommended. **[uv sync](https://docs.astral.sh/uv/reference/cli/#uv-sync)** will remove extraneous packages from the environment by default and, as such, may leave the system in a broken state.

To target the system environment, set UV_PROJECT_ENVIRONMENT to the prefix of the Python installation. For example, on Debian-based systems, this is usually /usr/local:

```bash
python -c "import sysconfig; print(sysconfig.get_config_var('prefix'))"
```

To target this environment, you'd export UV_PROJECT_ENVIRONMENT=/usr/local.

Important

If an absolute path is provided and the setting is used across multiple projects, the environment will be overwritten by invocations in each project. This setting is only recommended for use for a single project in CI or Docker images.

Note

By default, uv does not read the VIRTUAL_ENV environment variable during project operations. A warning will be displayed if VIRTUAL_ENV is set to a different path than the project's environment. The --active flag can be used to opt-in to respecting VIRTUAL_ENV. The --no-active flag can be used to silence the warning.

## Limited resolution environments

If your project supports a more limited set of platforms or Python versions, you can constrain the set of solved platforms via the environments setting, which accepts a list of PEP 508 environment markers. For example, to constrain the lockfile to macOS and Linux, and exclude Windows:

pyproject.toml

```toml
[tool.uv]
environments = [
    "sys_platform == 'darwin'",
    "sys_platform == 'linux'",
]
```

See the **[resolution documentation](https://docs.astral.sh/uv/concepts/resolution/#limited-resolution-environments)** for more.

## Required environments

If your project must support a specific platform or Python version, you can mark that platform as required via the required-environments setting. For example, to require that the project supports Intel macOS:

pyproject.toml

```toml
[tool.uv]
required-environments = [
    "sys_platform == 'darwin' and platform_machine == 'x86_64'",
]
```

The required-environments setting is only relevant for packages that do not publish a source distribution (like PyTorch), as such packages can only be installed on environments covered by the set of pre-built binary distributions (wheels) published by that package.

See the resolution documentation for more.

## Build isolation

By default, uv builds all packages in isolated virtual environments, as per PEP 517. Some packages are incompatible with build isolation, be it intentionally (e.g., due to the use of heavy build dependencies, mostly commonly PyTorch) or unintentionally (e.g., due to the use of legacy packaging setups).

To disable build isolation for a specific dependency, add it to the no-build-isolation-package list in your pyproject.toml:

pyproject.toml

```toml
[project]
name = "project"
version = "0.1.0"
description = "..."
readme = "README.md"
requires-python = ">=3.12"
dependencies = ["cchardet"]

[tool.uv]
no-build-isolation-package = ["cchardet"]
```

Installing packages without build isolation requires that the package's build dependencies are installed in the project environment prior to installing the package itself. This can be achieved by separating out the build dependencies and the packages that require them into distinct extras. For example:

pyproject.toml

```bash
[project]
name = "project"
version = "0.1.0"
description = "..."
readme = "README.md"
requires-python = ">=3.12"
dependencies = []

[project.optional-dependencies]
build = ["setuptools", "cython"]
compile = ["cchardet"]

[tool.uv]
no-build-isolation-package = ["cchardet"]
```

Given the above, a user would first sync the build dependencies:

`uv sync --extra build`

Followed by the compile dependencies:

`uv sync --extra compile`

Note that uv sync --extra compile would, by default, uninstall the cython and setuptools packages. To instead retain the build dependencies, include both extras in the second uv sync invocation:

```bash
uv sync --extra build
uv sync --extra build --extra compile
```

Some packages, like cchardet above, only require build dependencies for the installation phase of uv sync. Others, like flash-attn, require their build dependencies to be present even just to resolve the project's lockfile during the resolution phase.

In such cases, the build dependencies must be installed prior to running any uv lock or uv sync commands, using the lower lower-level uv pip API. For example, given:

```bash
# pyproject.toml

[project]
name = "project"
version = "0.1.0"
description = "..."
readme = "README.md"
requires-python = ">=3.12"
dependencies = ["flash-attn"]

[tool.uv]
no-build-isolation-package = ["flash-attn"]
```

You could run the following sequence of commands to sync flash-attn:

```bash
uv venv
uv pip install torch setuptools
error: Failed to fetch: `https://pypi.org/simple/flask/`
  Caused by: Request failed after 3 retries
  Caused by: error sending request for url (https://pypi.org/simple/flask/)
  Caused by: operation timed out
uv sync
```

Alternatively, you can provide the flash-attn metadata upfront via the dependency-metadata setting, thereby forgoing the need to build the package during the dependency resolution phase. For example, to provide the flash-attn metadata upfront, include the following in your pyproject.toml:

pyproject.toml

[[tool.uv.dependency-metadata]]
name = "flash-attn"
version = "2.6.3"
requires-dist = ["torch", "einops"]

```
