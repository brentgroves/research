# **[Python uv](https://www.datacamp.com/tutorial/python-uv)**

**[Research List](../../../../research_list.md)**\
**[Detailed Status](../../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../README.md)**

## Change default git branch

**[branch info](https://graphite.dev/guides/git-branch-not-showing-all-branches)**

To see local branch names, open your terminal and run `git branch`
To see all remote branch names, run `git branch -r`
To see all local and remote branches, run `git branch -a`

```bash
# what is it? https://stackoverflow.com/questions/71535128/what-exactly-is-the-default-git-branch
# git var GIT_DEFAULT_BRANCH
# it default to master but github uses main as default 
# switch default from master to main when working with github

git config --global init.defaultBranch main
```

## AI Overview: create github project using uv python

## **[Learn more](https://blog.devops.dev/ci-cd-with-github-actions-vs-jenkins-a-detailed-comparison-8c8ceded0205#:~:text=Continuous%20Integration%20(CI)%20is%20the%20practice%20of,repository%2C%20followed%20by%20automated%20builds%20and%20tests.)**

To create a new GitHub project using uv for Python package and project management, follow these steps:

Initialize a new uv project:

- Open your terminal and navigate to the directory where you want to create your project.
- Run the command uv init <project_name>. Replace <project_name> with your desired project name (e.g., my-uv-project).
- This command creates a new directory with the project name and initializes essential files, including .python-version, README.md, main.py, and pyproject.toml.

## Set a specific Python version (optional)

- If you need a specific Python version for your project, edit the .python-version file and specify the desired version (e.g., 3.11).
- Alternatively, you can specify the python version on project initialization with: uv init --python 3.10 <project_name>

## Add dependencies

- To add project dependencies, use the uv add command. For example, to add requests and pandas, run `uv add requests pandas`.
- uv automatically updates the pyproject.toml file with the added dependencies.

## Run your code

- Execute your Python script using uv run <script_name>.py (e.g., uv run main.py).
- uv automatically creates a virtual environment and installs the project dependencies before running the script.

## Create a GitHub repository

- Go to the GitHub website and create a new repository with the same name as your project.
- Do not initialize the repository with a README, license, or .gitignore file, as uv has already created these.

## Change default git branch from master to main

To see local branch names, open your terminal and run `git branch`
To see all remote branch names, run `git branch -r`
To see all local and remote branches, run `git branch -a`

```bash
# what is it? https://stackoverflow.com/questions/71535128/what-exactly-is-the-default-git-branch
# git var GIT_DEFAULT_BRANCH
# it default to master but github uses main as default 
# switch default from master to main when working with github

git config --global init.defaultBranch main
```

## Push your project to GitHub

- In your terminal, navigate to your project directory.
- Run git init to initialize a local Git repository (if it's not already initialized by uv).
- Add the remote repository URL: git remote add origin <repository_url>. Replace <repository_url> with the URL of your GitHub repository.

```bash
# ssh
git remote add origin git@github.com:brentgroves/veths_and_namespaces.git
# https
git remote add origin https://github.com:brentgroves/veths_and_namespaces.git
# change it
git remote set-url origin https://github.com:brentgroves/veths_and_namespaces.git
git remote -v
# running git branch lists no branches but zsh shows local branch is main
git add -A
git commit -m "updated source code"
git push origin main
# running git branch -a showw both local main and origin main branches now
git branch -a
main
remotes/origin/main
```

- Commit your changes: `git add .` followed by `git commit -m "Initial commit"`.
- Push your project to GitHub: `git push origin main`.

## Set up GitHub Actions for CI/CD (optional)

- To automate testing and deployment, create a .github/workflows directory in your project.
- Add a YAML file (e.g., ci.yml) to define your workflow.
- Use the astral-sh/setup-uv action to set up uv in your workflow.
- You can use uv run to run tests, linters, and other checks in your workflow.

```yaml
# Example GitHub Actions workflow
name: CI

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: astral-sh/setup-uv@v1
      - name: Install dependencies
        run: uv sync
      - name: Run tests
        run: uv run pytest
```
