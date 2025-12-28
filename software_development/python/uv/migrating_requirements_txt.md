# **[Migrate](https://pydevtools.com/handbook/how-to/migrate-requirements.txt/)**

How to migrate from requirements.txt to pyproject.toml with uv
Start by installing uv if you haven’t already.

Steps 
Create a pyproject.toml in your existing project:

$ uv init --bare

This creates a minimal pyproject.toml without sample code.

Import your existing requirements into the project:

$ uv add -r requirements.txt

This command:

Reads dependencies from requirements.txt
Adds them to pyproject.toml
Creates/updates the lockfile
Installs dependencies in the project environment
If you have separate requirements-dev.txt:

$ uv add --dev -r requirements-dev.txt

Check that all dependencies were imported correctly:

$ uv pip freeze

Compare this output with your original requirements files.

Once verified, remove the old requirements files:

$ rm requirements.txt requirements-dev.txt

With pyproject.toml, manage dependencies using:

# Add new runtime dependency
$ uv add requests

# Add development dependency
$ uv add --dev pytest

# Remove dependency
$ uv remove re