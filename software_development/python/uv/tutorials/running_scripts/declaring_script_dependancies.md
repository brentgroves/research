# **[Declaring script dependencies](https://docs.astral.sh/uv/guides/scripts/#declaring-script-dependencies)**

**[Research List](../../../../../research_list.md)**\
**[Detailed Status](../../../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../README.md)**

The inline metadata format allows the dependencies for a script to be declared in the script itself.

uv supports adding and updating inline script metadata for you. Use `uv add --script` to declare the dependencies for the script:

`uv add --script example.py 'requests<3' 'rich'`

This will add a script section at the top of the script declaring the dependencies using TOML:

example.py

```python
# /// script
# dependencies = [
# "requests<3"
# "rich"
# ]
# ///

import requests
from rich.pretty import pprint

resp = requests.get("https://peps.python.org/api/peps.json")
data = resp.json()
pprint([(k, v["title"]) for k, v in data.items()][:10])
```

uv will automatically create an environment with the dependencies necessary to run the script, e.g.:

`uv run example.py`

## Important

When using inline script metadata, even if uv run is used in a project, the project's dependencies will be ignored. The --no-project flag is not required.

uv also respects Python version requirements:

example.py

```python
# /// script
# requires-python = ">=3.12"
# dependencies = []
# ///
# Use some syntax added in Python 3.12

type Point = tuple[float, float]
print(Point)
```

Note

The dependencies field must be provided even if empty.

uv run will search for and use the required Python version. The Python version will download if it is not installed — see the documentation on Python versions for more details.

## Using a shebang to create an executable file

A shebang can be added to make a script executable without using uv run — this makes it easy to run scripts that are on your PATH or in the current folder.

For example, create a file called greet with the following contents

greet

```python
# !/usr/bin/env -S uv run --script
print("Hello, world!")
```
