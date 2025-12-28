# **[Optimize Your Workflow in Python with pipx](https://betterstack.com/community/guides/scaling-python/pipx-python/)**

**[Research List](../../../research_list.md)**\
**[Detailed Status](../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../README.md)**

pipx helps you install Python applications in isolated environments. Unlike regular pip, pipx puts each tool in its own container but still makes it available everywhere on your system.

This means you can use all your favorite Python tools without them interfering with each other or messing up your main Python setup.

This article will show you how to use pipx, what makes it better than regular installation methods, and how to keep your Python tools organized and conflict-free.

## Prerequisites

Before you start with pipx, you need Python 3.8 or higher on your computer. If you don't have Python yet, install it first before trying to use pipx.

## Why use pipx?

If you've worked with Python tools before, you've probably hit some annoying problems. Installing tools globally can mess up your Python installation. Putting tools in virtual environments means you have to activate them constantly. And system package managers often have outdated versions.

## pipx fixes these problems by

- Making tools available everywhere on your system after a single installation
- Keeping each tool completely separate from others, so they can't conflict
- Letting you update each tool individually without breaking others
- Removing tools cleanly when you don't need them anymore

This works incredibly well for tools like code formatters, linters, and test runners that you want to use across different projects.

Think of pipx as npm for JavaScript or cargo for Rust, but it solves Python's unique dependency problems with extra isolation.

## Installing pipx

Getting pipx running on your system takes just two quick steps.

First, check that you have Python installed:

`python3 --version`
You should see something like:

`Python 3.13.2`
Install pipx using Homebrew on macOS, or with apt on Linux. For other systems and detailed instructions, check the official documentation.

`brew install pipx`
Check that pipx was successfully installed by running:

```bash
pipx --version
1.7.1
```

Now you're ready to start using pipx!

## Getting started with pipx

With pipx installed, you can manage Python tools without messing up your system. Unlike pip, which installs packages globally (risking conflicts) or in project folders (limiting access), pipx gives you the best of both worlds.

Let's create a dedicated directory from which to work. This will help keep your experiments organized:

`mkdir pipx-demo && cd pipx-demo`

Now that you're in the demo directory, let's install HTTPie, a user-friendly command-line HTTP client:

```bash
pipx install httpie
  installed package httpie 3.2.4, installed using Python 3.13.2
  These apps are now globally available
    - http
    - httpie
    - https
  These manual pages are now globally available
    - man1/http.1
    - man1/httpie.1
    - man1/https.1
done! ✨ 🌟 ✨
```

Behind the scenes, pipx just did something clever: it created a special isolated container just for HTTPie, installed the app and all its dependencies there, then made the commands available everywhere on your system. You can now use HTTPie from any folder without activating anything.

Check that it worked by moving out of the demo directory:

```bash
cd ..
http --version
3.2.4
# That confirms it’s working system-wide!
# Head back to your demo folder:
cd pipx-demo
```

The real magic happens when you install multiple tools that might not get along. Try adding youtube-dl:

`pipx install youtube-dl`

Even if these apps need different versions of the same libraries, they'll work perfectly because each runs in its own private space.

To see all your pipx tools, run:

```bash
pipx list
# venvs are in /Users/stanley/.local/pipx/venvs
# apps are exposed on your $PATH at /Users/stanley/.local/bin
# manual pages are exposed at /Users/stanley/.local/share/man
   package httpie 3.2.4, installed using Python 3.13.2
    - http
    - httpie
    - https
    - man1/http.1
    - man1/httpie.1
    - man1/https.1
   package youtube-dl 2021.12.17, installed using Python 3.13.2
    - youtube-dl
    - man1/youtube-dl.1
```

This shows that pipx keeps everything organized - each app has its own environment in .local/pipx/venvs, while their commands are available through .local/bin.

You get the convenience of global commands with the safety of isolation - no more dependency nightmares.

## Managing applications with pipx

As you collect more Python tools, you'll need to keep them updated and organized. pipx makes this easy with simple commands to handle your apps throughout their lifetime.

Keeping tools updated is important for security and new features. Update a single app like this:

```bash
pipx upgrade httpie

httpie is already at latest version 3.2.4 (location: /Users/stanley/.local/pipx/venvs/httpie)
```

When you have many tools, updating them one by one gets tedious. Update everything at once with:

`pipx upgrade-all`

Sometimes an app starts acting strange after updates. When nothing else works, you can reinstall it cleanly:

```bash
pipx reinstall youtube-dl
uninstalled youtube-dl! ✨ 🌟 ✨
  installed package youtube-dl 2021.12.17, installed using Python 3.13.2
  These apps are now globally available
    - youtube-dl
  These manual pages are now globally available
    - man1/youtube-dl.1
done! ✨ 🌟 ✨
```

This completely removes youtube-dl and reinstalls it fresh, often fixing weird problems.

When you don't need a tool anymore, delete it:

```bash
pipx uninstall youtube-dl
uninstalled youtube-dl! ✨ 🌟 ✨
```

Unlike pip uninstall, which often leaves leftover packages, pipx removes the entire environment, giving you a truly clean uninstall.

One of pipx's coolest features lets you run tools without installing them permanently. This is perfect for tools you rarely need:

```bash
pipx run cowsay -t Hello
```

pipx creates a temporary environment, installs cowsay, runs it, then cleans everything up afterward. It's perfect for one-off tasks or trying tools without committing to installation.

With these commands, you can keep your Python tools fresh, organized, and conflict-free.

## Advanced pipx features

While the basic pipx commands handle most needs, the advanced features help you solve trickier problems. These extras give you more control over your Python tools.

One powerful feature lets you add plugins or extensions to tools you've already installed:

```bash
pipx inject httpie httpie-jwt-auth
  injected package httpie-jwt-auth into venv httpie
done! ✨ 🌟 ✨
```

This adds the JWT authentication plugin directly to HTTPie's environment without affecting anything else. You can add multiple plugins to customize tools exactly how you want them.

Sometimes you need cutting-edge versions of tools before they're officially released. pipx lets you install directly from GitHub:

```bash
pipx install git+<https://github.com/example/project.git>
```

This is great for testing new features or using your own forks of projects.

Some Python tools require specific Python versions to work correctly. With pipx, you can choose which Python interpreter to use when installing a tool.

For example, if you have Python 3.12 installed, you can run:

```bash
pipx install --python python3.12 black

  installed package black 25.1.0, installed using Python 3.12.6
  These apps are now globally available
    - black
    - blackd
done! ✨ 🌟 ✨
```

This is super helpful when a tool hasn't been updated for the latest Python yet.

If you're developing your own command-line tool, pipx has a special mode that automatically reflects your code changes:

`pipx install --editable ./my_cli_project`

This creates a special link to your source code so you can test changes instantly without reinstalling.

For troubleshooting, you might need to see what's inside an app's environment. pipx gives you a peek:

```bash
pipx runpip httpie list

Package            Version
------------------ ---------
certifi            2025.1.31
charset-normalizer 3.4.1
defusedxml         0.7.1
httpie             3.2.4
httpie-jwt-auth    0.4.0
idna               3.10
markdown-it-py     3.0.0
mdurl              0.1.2
multidict          6.3.2
pip                25.0.1
Pygments           2.19.1
PySocks            1.7.1
requests           2.32.3
requests-toolbelt  1.0.0
rich               14.0.0
setuptools         78.1.0
urllib3            2.3.0
```

These advanced features transform pipx from a simple installer into a powerful tool that handles even complex Python application needs.

Final thoughts
pipx changes how you manage Python command-line tools by giving you global access and perfect isolation. This solves long-standing problems in Python where tools would conflict with each other or mess up your system.

When you use pipx, you get cleaner installations, more reliable tools, and easier maintenance while avoiding the dependency headaches that Python developers have struggled with for years. To learn more about pipx and see what's new, check out the official documentation.

Thanks for reading!
