# **[New Branch](https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging)**

## Default branch

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

## Basic Branching and Merging

Let’s go through a simple example of branching and merging with a workflow that you might use in the real world. You’ll follow these steps:

1. Do some work on a website.
2. Create a branch for a new user story you’re working on.
3. Do some work in that branch.

At this stage, you’ll receive a call that another issue is critical and you need a hotfix. You’ll do the following:

1. Switch to your production branch.
2. Create a branch to add the hotfix.
3. After it’s tested, merge the hotfix branch, and push to production.
4. Switch back to your original user story and continue working.

 To create a new branch and switch to it at the same time, you can run the git checkout command with the -b switch:

## Before Beginning

Make sure the main branch just the way you want it and all changes have been committed.

```bash
# git diff, git diff HEAD HEAD~1 and git diff --staged
cd ~/src/go/tutorials/unit_tests/test_tips/go_interfaces/mock_interfaces

# List branches
git branch
# git checkout -b feature1
git checkout -b init_commit 
Switched to a new branch 'add_test'

# https://graphite.dev/guides/how-to-use-git-push-origin
git push --set-upstream origin init_commit
remote: Create a pull request for 'polymorphism' on GitHub by visiting:
remote:      https://github.com/brentgroves/vin_main/pull/new/polymorphism
To github.com:brentgroves/go_test_tips.git
 * [new branch]      mock_things -> mock_things
Branch 'mock_things' set up to track remote branch 'mock_things' from 'origin'.
```
