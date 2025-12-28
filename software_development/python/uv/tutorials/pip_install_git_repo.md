# **[Pip Install a Git Repository](https://dev.to/fronkan/pip-install-a-git-repository-111b#:~:text=You%20can%20use%20pip%20to,%2Fpallets%2Fflask.git%20.&text=Notice%20how%20pip%20has%20stored%20the%20specific%20commit%20hash%20used%20when%20installing.)**

**[Research List](../../../../research_list.md)**\
**[Detailed Status](../../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../README.md)**

## AI Overview: install flask from source github rep

You can use pip to install directly from a git repository. To install flask the shortest version of the command is

```bash
pip install git+https://github.com/pallets/flask.git
# Install a tag
uv pip install "git+https://github.com/astral-sh/ruff@v0.2.0"
uv pip install "git+https://github.com/pallets/flask@3.1.0"

```. Notice how pip has stored the specific commit hash used when installing

```text
Flask @ git+https://github.com/pallets/flask.git@bdf7083cfdeef0e0bdd0bf6d4c23b26c92b52d95
```

If you would like to install the latest version of flask, you would probably use pip install flask. While this gives you the latest released version, it doesn't contain the latest commit to the repository. At least not most of the time. Sooo, what if I want the latest commit? Maybe some new bugfix or feature has been added which I need for my project. Let's look at how you can get the latest commit made to flask or any other open-source package.

You could clone the repository and install it using pip locally:

```bash
git clone https://github.com/pallets/flask.git
pip install ./flask
```

However, this method creates a dependency on local files, and creating a requirements.txt you could share is impossible. Using pip freeze it would look like this for flask:

```txt
Flask @ file:///C:/Users/Fronkan/my_project/flask
```

Fear not, there is a better way of doing this! You can use pip to install directly from a git repository. To install flask the shortest version of the command is `pip install git+https://github.com/pallets/flask.git`.

This will install whatever is on the default branch of the project. Freezing this gives us:

```text
Flask @ git+https://github.com/pallets/flask.git@bdf7083cfdeef0e0bdd0bf6d4c23b26c92b52d95
```

Notice how pip has stored the specific commit hash used when installing. This means you can share this with others and they will, for sure, get the same version as you!

As I said, that is the short version of the command. This corresponds to `pip install git+<https://github.com/pallets/flask.git@master>`, as master is the default branch of the flask repository. The reason I show you this is because we can change master to any other branch in the repository. Actually, we can use either a branch, commit hash, tag name, or git ref. This gives you a lot of control over what to install from the repository.

If you follow the pip documentation you would run the command as: pip install git+<https://github.com/pallets/flask.git@master#egg=flask>. The #egg=flask part tells pip which package it is installing before downloading and parsing the metadata and is used for the dependency logic. This seems to be the, by pip, recommended way of doing things.
