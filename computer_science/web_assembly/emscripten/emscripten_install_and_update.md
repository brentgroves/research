# **[Installation instructions using the emsdk (recommended)](https://emscripten.org/docs/getting_started/downloads.html)**

First, check the **[Platform-specific notes](https://emscripten.org/docs/getting_started/downloads.html#platform-notes-installation-instructions-sdk)** below and install any prerequisites.

The core Emscripten SDK (emsdk) driver is a Python script. You can get it for the first time with:

```bash
# Get the emsdk repo
cd ~/src
git clone https://github.com/emscripten-core/emsdk.git

# Enter that directory

cd emsdk
```

You can also get the emsdk without git, by selecting “Clone or download => Download ZIP” on the emsdk GitHub page.

Run the following emsdk commands to get the latest tools from GitHub and set them as active:

```bash
# Fetch the latest version of the emsdk (not needed the first time you clone)

git pull

# Download and install the latest SDK tools

./emsdk install latest

# Make the "latest" SDK "active" for the current user. (writes .emscripten file)

./emsdk activate latest

# Activate PATH and other environment variables in the current terminal
# if you have added this to the exports.zsh file then you should not have to source this file unless you want multiple versions of emsdk.
# Set up Emscripten environment variables
# export EMSDK = /home/brent/src/emsdk
# export EMSDK_NODE = /home/brent/src/emsdk/node/22.16.0_64bit/bin/node
# export PATH="$HOME/src/emsdk:$PATH"
# export PATH="$HOME/src/emsdk/upstream/emscripten:$PATH"

source ./emsdk_env.sh
```

source creates the EMSDK and EMSDK_NODE variables so I just added them to the zsh exports.zsh file/

## Linux Prereqs

Emsdk does not install any tools to the system, or otherwise interact with Linux package managers. All file changes are done inside the emsdk/ directory.

Python is not provided by emsdk. The user is expected to install this beforehand with the system package manager:

## Don't do this use uv instead

```bash
# Install Python

sudo apt-get install python3
```

## Install CMake (optional, only needed for tests and building Binaryen or LLVM)

```bash
sudo apt-get install cmake
```

Note

If you want to use your system’s Node.js instead of the emsdk’s, it may be node instead of nodejs, and you can adjust the NODE_JS attribute of your .emscripten file to point to it.

Git is not installed automatically. Git is only needed if you want to use tools from a development branch.

## Install git

This should already be installed and configured

`sudo apt-get install git`

## Updating the SDK

Tip

You only need to install the SDK once! After that you can update to the latest SDK at any time using Emscripten SDK (emsdk).

Type the following in a command prompt

```bash
# Fetch the latest registry of available tools

./emsdk update

# Download and install the latest SDK tools

./emsdk install latest

# Set up the compiler configuration to point to the "latest" SDK

./emsdk activate latest

# Activate PATH and other environment variables in the current terminal

source ./emsdk_env.sh
```

The package manager can do many other maintenance tasks ranging from fetching specific old versions of the SDK through to using the versions of the tools on GitHub (or even your own fork). Check out all the possibilities in the “How to” guides.
