# **[TroubleShooting branch issues](https://graphite.dev/guides/git-branch-not-showing-all-branches)**

## Troubleshooting configuration issues

When working with Git, non-standard configurations can sometimes lead to issues with branch visibility or behavior. These problems often arise from local settings that deviate from typical configurations, affecting how branches and remotes are handled.

The command `git config --list` is used to display all the settings in your Git configuration that can affect your local repository's operations. This command compiles settings from various scopes (system, global, and local), providing a comprehensive view of how Git is configured on your machine.

1. Execute the command: Running `git config --list` in your terminal will list all the Git configuration settings currently active. This output includes all custom configurations applied at different levels, such as user-specific settings (global) or repository-specific settings (local).

2. Inspect relevant settings: Specifically, look for entries that start with branch. and remote.. These entries control the behavior of your branches and the settings for your remote repositories, respectively. For instance, branch.<branchname>.remote and branch.<branchname>.merge are important for understanding which remote branch is tracked by your local branches and how they merge.

```bash
git config --list
user.name=brentgroves
user.email=brent.groves@gmail.com
pull.rebase=false
init.defaultbranch=main
core.repositoryformatversion=0
core.filemode=true
core.bare=false
core.logallrefupdates=true
```

When you run `git config --list`, you might see output like this:

```bash
remote.origin.url=<https://github.com/username/repo.git>
remote.origin.fetch=+refs/heads/*:refs/remotes/origin/*
branch.main.remote=origin
branch.main.merge=refs/heads/main
```
