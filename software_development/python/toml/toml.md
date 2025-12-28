# **[TOML format](https://toml.io/en/)**

A config file format for humans.
TOML aims to be a minimal configuration file format that's easy to read due to obvious semantics. TOML is designed to map unambiguously to a hash table. TOML should be easy to parse into data structures in a wide variety of languages.

```toml
# This is a TOML comment

# This is a multiline
# TOML comment

str1 = "I'm a string."
str2 = "You can \"quote\" me."
str3 = "Name\tJos\u00E9\nLoc\tSF."

str1 = """
Roses are red
Violets are blue"""

str2 = """\
  The quick brown \
  fox jumps over \
  the lazy dog.\
  """
```
