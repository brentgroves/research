# **[Multiple python versionsex](https://discuss.python.org/t/managing-multiple-python-version-without-any-tool/48620/2)**

If you simply install multiple versions of Python , they will generally stay out of each others’ ways. On my Linux system, I can type python3 to get the default Python, or python3.5 or python3.8 or python3.13 to ask for a specific version. If you invoke a specific Python when creating a virtual environment, that will become the default Python within that environment, too, making it easy to manage your apps’ venvs. (As an example of that: I have some Python apps which are hosted on Heroku, and so my local venv is always synchronized with the Python version running on production.)

So, how simple is it? You just install multiple and they stay out of each others’ way

## **[Python versions](https://devguide.python.org/versions/)**

As of 07/29/2024

| Branch | Schedule |   Status   | First release | End of life |    Release manager    |
|:------:|:--------:|:----------:|:-------------:|:-----------:|:---------------------:|
| main   | PEP 745  | feature    | 2025-10-01    | 2030-10     | Hugo van Kemenade     |
| 3.13   | PEP 719  | prerelease | 2024-10-01    | 2029-10     | Thomas Wouters        |
| 3.12   | PEP 693  | bugfix     | 2023-10-02    | 2028-10     | Thomas Wouters        |
| 3.11   | PEP 664  | security   | 2022-10-24    | 2027-10     | Pablo Galindo Salgado |
| 3.10   | PEP 619  | security   | 2021-10-04    | 2026-10     | Pablo Galindo Salgado |
| 3.9    | PEP 596  | security   | 2020-10-05    | 2025-10     | Łukasz Langa          |
| 3.8    | PEP 569  | security   | 2019-10-14    | 2024-10     | Łukasz Langa          |

## how to install multiple python versions

```bash
Felix Krull runs a PPA offering basically any version of Python (seriously, there is 2.3.7 build for vivid...) for many Ubuntu releases at https://launchpad.net/~deadsnakes/+archive/ubuntu/ppa.

Do the usual:

sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install python3.11
It will not overwrite your existing python3.4 which is still symlinked as python3.

Instead, to run python3.5, run the command python3.5 (or python3.X for any other version of python).

DON'T change the symlink! There are apparently many system functions that don't work properly with python3.5.

```
