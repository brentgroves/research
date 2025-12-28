# **[Inline script metadata](https://packaging.python.org/en/latest/specifications/inline-script-metadata/)**

**[Research List](../../../../../research_list.md)**\
**[Detailed Status](../../../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../README.md)**

This specification defines a metadata format that can be embedded in single-file Python scripts to assist launchers, IDEs and other external tools which may need to interact with such scripts.

Specification
This specification defines a metadata comment block format (loosely inspired by reStructuredText Directives).

Any Python script may have top-level comment blocks that MUST start with the line # /// TYPE where TYPE determines how to process the content. That is: a single #, followed by a single space, followed by three forward slashes, followed by a single space, followed by the type of metadata. Block MUST end with the line # ///. That is: a single #, followed by a single space, followed by three forward slashes. The TYPE MUST only consist of ASCII letters, numbers and hyphens.

Every line between these two lines (# /// TYPE and # ///) MUST be a comment starting with #. If there are characters after the # then the first character MUST be a space. The embedded content is formed by taking away the first two characters of each line if the second character is a space, otherwise just the first character (which means the line consists of only a single #).

Precedence for an ending line # /// is given when the next line is not a valid embedded content line as described above. For example, the following is a single fully valid block:

```python
# /// some-toml
# embedded-csharp = """
# /// <summary>
# /// text
# ///
# /// </summary>
# public class MyClass { }
# """
# ///
```

A starting line MUST NOT be placed between another starting line and its ending line. In such cases tools MAY produce an error. Unclosed blocks MUST be ignored.

When there are multiple comment blocks of the same TYPE defined, tools MUST produce an error.

Tools reading embedded metadata MAY respect the standard Python encoding declaration. If they choose not to do so, they MUST process the file as UTF-8.

This is the canonical regular expression that MAY be used to parse the metadata:

`(?m)^# /// (?P<type>[a-zA-Z0-9-]+)$\s(?P<content>(^#(| .*)$\s)+)^# ///$`

In circumstances where there is a discrepancy between the text specification and the regular expression, the text specification takes precedence.

Tools MUST NOT read from metadata blocks with types that have not been standardized by this specification.

## script type

The first type of metadata block is named script, which contains script metadata (dependency data and tool configuration).

This document MAY include the top-level fields dependencies and requires-python, and MAY optionally include a [tool] table.

The [tool] table MAY be used by any tool, script runner or otherwise, to configure behavior. It has the same semantics as the [tool] table in pyproject.toml.

The top-level fields are:

- dependencies: A list of strings that specifies the runtime dependencies of the script. Each entry MUST be a valid dependency specifier.
- requires-python: A string that specifies the Python version(s) with which the script is compatible. The value of this field MUST be a valid version specifier.

Script runners MUST error if the specified dependencies cannot be provided. Script runners SHOULD error if no version of Python that satisfies the specified requires-python can be provided.

## Example

The following is an example of a script with embedded metadata:

```python
# /// script
# requires-python = ">=3.11"
# dependencies = [
# "requests<3"
# "rich"
# ]
# ///

import requests
from rich.pretty import pprint

resp = requests.get("<https://peps.python.org/api/peps.json>")
data = resp.json()
pprint([(k, v["title"]) for k, v in data.items()][:10])
```
