# **[uv install](https://docs.astral.sh/uv/getting-started/installation/#standalone-installer)**

**[Ubuntu 22.04 Desktop](../../../ubuntu22-04/desktop-install.md)**\
**[Ubuntu 22.04 Server](../../../ubuntu22-04/server-install.md)**\
**[Back to Main](../../../../README.md)**

## Uninstall

Uninstallation
If you need to remove uv from your system, follow these steps:

Clean up stored data (optional):

```bash
uv cache clean
rm -r "$(uv python dir)"
rm -r "$(uv tool dir)"
```

Tip

Before removing the binaries, you may want to remove any data that uv has stored.

Remove the uv and uvx binaries:

macOS and Linux
Windows

`rm ~/.local/bin/uv ~/.local/bin/uvx`

Note

Prior to 0.5.0, uv was installed into ~/.cargo/bin. The binaries can be removed from there to uninstall. Upgrading from an older version will not automatically remove the binaries from ~/.cargo/bin.

## Installation methods

I did not do this method.

```bash
Command 'uv' not found, but can be installed with:
sudo snap install astral-uv --classic
```

Install uv with our standalone installers or your package manager of choice.
This is what I did to install uv.

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
downloading uv 0.6.13 x86_64-unknown-linux-gnu
no checksums to verify
installing to /home/brent/.local/bin
  uv
  uvx
everything's installed!

To add $HOME/.local/bin to your PATH, either restart your shell or run:

    source $HOME/.local/bin/env (sh, bash, zsh)
    source $HOME/.local/bin/env.fish (fish)
```

## Upgrading uv

When uv is installed via the standalone installer, it can update itself on-demand:

```bash
uv self update
```

Updating uv will re-run the installer and can modify your shell profiles. To disable this behavior, set INSTALLER_NO_MODIFY_PATH=1.

To enable shell autocompletion for uv commands, run one of the following:

`echo 'eval "$(uv generate-shell-completion zsh)"' >> ~/.zshrc`

## First steps with uv

After installing uv, you can check that uv is available by running the uv command:

`uv`
