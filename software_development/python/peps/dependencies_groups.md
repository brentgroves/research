# **[PEP 735 – Dependency Groups in pyproject.toml](https://packaging.python.org/en/latest/specifications/dependency-groups/)**

**[Research List](../../../research_list.md)**\
**[Detailed Status](../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../README.md)**

## Dependency Groups

This specification defines Dependency Groups, a mechanism for storing package requirements in pyproject.toml files such that they are not included in project metadata when it is built.

Dependency Groups are suitable for internal development use-cases like linting and testing, as well as for projects which are not built for distribution, like collections of related scripts.

Fundamentally, Dependency Groups should be thought of as being a standardized subset of the capabilities of requirements.txt files (which are pip-specific).

## Specification

Examples
This is a simple table which shows a test group:

```toml
[dependency-groups]
test = ["pytest>7", "coverage"]
and a similar table which defines test and coverage groups:

[dependency-groups]
coverage = ["coverage[toml]"]
test = ["pytest>7", {include-group = "coverage"}]
```

## The [dependency-groups] Table

Dependency Groups are defined as a table in pyproject.toml named dependency-groups. The dependency-groups table contains an arbitrary number of user-defined keys, each of which has, as its value, a list of requirements.

[dependency-groups] keys, sometimes also called “group names”, must be **[valid non-normalized names](https://packaging.python.org/en/latest/specifications/name-normalization/#name-format)**. Tools which handle Dependency Groups MUST **[normalize](https://packaging.python.org/en/latest/specifications/name-normalization/#name-normalization)** these names before comparisons.

## Name format

A valid name consists only of ASCII letters and numbers, period, underscore and hyphen. It must start and end with a letter or number. This means that valid project names are limited to those which match the following regex (run with re.IGNORECASE):

`^([A-Z0-9]|[A-Z0-9][A-Z0-9._-]*[A-Z0-9])$`

## Name normalization

The name should be lowercased with all runs of the characters ., -, or _ replaced with a single - character. This can be implemented in Python with the re module:

```python
import re

def normalize(name):
    return re.sub(r"[-_.]+", "-", name).lower()
```

Tools SHOULD prefer to present the original, non-normalized name to users, and if duplicate names are detected after normalization, tools SHOULD emit an error.

Requirement lists, the values in [dependency-groups], may contain strings, tables (dict in Python), or a mix of strings and tables. Strings must be valid **[dependency specifiers](https://packaging.python.org/en/latest/specifications/dependency-specifiers/#dependency-specifiers)**, and tables must be valid Dependency Group Includes.

## Dependency specifiers

This document describes the dependency specifiers format as originally specified in PEP 508.

The job of a dependency is to enable tools like pip [1] to find the right package to install. Sometimes this is very loose - just specifying a name, and sometimes very specific - referring to a specific file to install. Sometimes dependencies are only relevant in one platform, or only some versions are acceptable, so the language permits describing all these cases.

The language defined is a compact line based format which is already in widespread use in pip requirements files, though we do not specify the command line option handling that those files permit. There is one caveat - the URL reference form, specified in **[Versioning specifier specification](https://packaging.python.org/en/latest/specifications/version-specifiers/#version-specifiers)** is not actually implemented in pip, but we use that format rather than pip’s current native format.

## Specification

Examples
All features of the language shown with a name based lookup:

`requests [security,tests] >= 2.8.1, == 2.8.* ; python_version < "2.7"`

A minimal URL based lookup:

`pip @ https://github.com/pypa/pip/archive/1.3.1.zip#sha1=da9234ee9982d4bbb3c72346a6de940a148ea686`

## Concepts

A dependency specification always specifies a distribution name. It may include extras, which expand the dependencies of the named distribution to enable optional features. The version installed can be controlled using version limits, or giving the URL to a specific artifact to install. Finally the dependency can be made conditional using environment markers.

Grammar
We first cover the grammar briefly and then drill into the semantics of each section later.

A distribution specification is written in ASCII text. We use a parsley [2] grammar to provide a precise grammar. It is expected that the specification will be embedded into a larger system which offers framing such as comments, multiple line support via continuations, or other such features.

The full grammar including annotations to build a useful parse tree is included at the end of this document.

Versions may be specified according to the rules of the Version specifier specification. (Note: URI is defined in std-66):

version_cmp   = wsp*'<' | '<=' | '!=' | '==' | '>=' | '>' | '~=' | '==='
version       = wsp* ( letterOrDigit | '-' | '_' | '.' | '*' | '+' | '!' )+
version_one   = version_cmp version wsp*
version_many  = version_one (',' version_one)*(',' wsp*)?
versionspec   = ( '(' version_many ')' ) | version_many
urlspec       = '@' wsp* <URI_reference>
