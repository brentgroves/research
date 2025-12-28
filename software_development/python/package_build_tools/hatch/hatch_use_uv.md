# **[hatch](https://www.pyopensci.org/python-package-guide/tutorials/get-to-know-hatch.html)**

## **[Hatch or uv for a new project?](https://www.reddit.com/r/Python/comments/1gaz3tm/hatch_or_uv_for_a_new_project/?rdt=54530)**

Discussion
I'm starting a new project, and I can't decide if hatch is needed anymore. Hatch can install packages using uv for speed, so I used both before.

But uv allows monorepo, while hatch doesn't support it yet.

What are the differences between the two tools ? What would you choose for a new project?

## Answer 1

uv! it's not just a matter of speed. there's a whole team behind it, shipping fast, and it has a bunch of niceties that (last time that I checked hatch) weren't there - for example, running `uv add`. AFAIK, with hatch you still need to write the dependencies in pyproject.toml by hand.

EDIT; not to diminish Hatch's work. it's still a jewel. But, without specific requirements on your side, I think it's safe to recommend using uv for any personal project. Production might be another thing.

## Answer 2


I submitted a big report for uv and it was fixed within a few hours and a new version released within 2 days. I keep the changelog open in a tab and refresh it every few days to check out the new features. This is a new experience for Python package management, to say the least.

## Answer 3

I'm in a new job and looking to move my team's pip+requirements.txt into one of these tools with lock files, venv management, etc.

I've previously used poetry, but watching how different tools are adding support for the new PEP735 dependency groups - UV has gained a lot of points in my eyes

### reply


I would always recommend it in this case :) One thing where it might be a bit buggy is pinning packages to a third party index - it was released this week. for me personally it works, but there isn't a lot of documentation around so troubleshooting might be harder. Nevertheless, the community is amazing and super responsive.

there are some non-compatible behaviours: listed here https://docs.astral.sh/uv/pip/compatibility/ never been an issue for me though. YMMV.

however I think moving from "requirements.txt files written by hand" to a pyproject.toml + lockfile is a no brainer. One could also argue that if it ain't broke you should not fix it.

## Answer 4

I use UV on a couple small production projects and it is a god send compared to poetry, pdm, hatch, pipx, pip-tools, and many others.

## Get to Know Hatch
Our Python packaging tutorials use the tool Hatch. While there are many great packaging tools out there, we have selected Hatch because:

- It is an end-to-end tool that supports most of the steps required to create a quality Python package. Beginners will have fewer tools to learn if they use Hatch.
- It supports different build back-ends if you ever need to compile code in other languages.
- As a community, pyOpenSci has decided that Hatch is a user-friendly tool that supports many different scientific Python use cases.

In this tutorial, you will install and get to know Hatch a bit more before starting to use it.

You need two things to successfully complete this tutorial:
- You need Python installed.
- You need Hatch installed.

If you don’t already have Python installed on your computer, Hatch will do it for you when you install Hatch.

## Install Hatch

To begin, follow the operating-system-specific instructions below to install Hatch.