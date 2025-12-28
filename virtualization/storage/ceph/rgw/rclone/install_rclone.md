# **[](https://rclone.org/install/)**
<https://www.nakivo.com/blog/mount-amazon-s3-as-a-drive-how-to-guide/>

##

## update

```bash
# https://rclone.org/commands/rclone_selfupdate/
rclone selfupdate

cat ~/.config/rclone/rclone.conf
[mybucket]
type = s3
provider = Ceph
access_key_id = foo
secret_access_key = bar
endpoint = http://microcloud
acl = public-read-write
```

## Install

Rclone is a Go program and comes as a single binary file.

## Quickstart

- Download the relevant binary.
- Extract the rclone executable, rclone.exe on Windows, from the archive.
- Run rclone config to setup. See rclone config docs for more details.
- Optionally configure automatic execution.

See below for some expanded Linux / macOS / Windows instructions.

See the usage docs for how to use rclone, or run rclone -h.

Already installed rclone can be easily updated to the latest version using the rclone selfupdate command.

See the release signing docs for how to verify signatures on the release.

## Script installation

To install rclone on Linux/macOS/BSD systems, run:

```bash
sudo -v ; curl https://rclone.org/install.sh | sudo bash
...
rclone v1.70.3 has successfully installed.
Now run "rclone config" for setup. Check https://rclone.org/docs/ for more details.
```

For beta installation, run:

sudo -v ; curl <https://rclone.org/install.sh> | sudo bash -s beta
Note that this script checks the version of rclone installed first and won't re-download if not needed.

## Linux installation

Precompiled binary
Fetch and unpack

```bash
curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip
unzip rclone-current-linux-amd64.zip
cd rclone-*-linux-amd64
```

Copy binary file

```bash
sudo cp rclone /usr/bin/
sudo chown root:root /usr/bin/rclone
sudo chmod 755 /usr/bin/rclone
```

Install manpage

```bash
sudo mkdir -p /usr/local/share/man/man1
sudo cp rclone.1 /usr/local/share/man/man1/
sudo mandb
```

Run rclone config to setup. See rclone config docs for more details.

rclone config

## windows

if on server vlan you can install winsfp from msi instead.

<https://www.nakivo.com/blog/mount-amazon-s3-as-a-drive-how-to-guide/>

Install Chocolately, which is a Windows package manager that can be used to install applications from online repositories:
Set-ExecutionPolicy Bypass -Scope Process -Force; `

  iex ((New-Object System.Net.WebClient).DownloadString('<https://chocolatey.org/install.ps1>'))

WinFSP (Windows File System Proxy) is the Windows analog of the Linux FUSE and it is fast, stable and allows you to create user mode file systems.
Install WinFSP from Chocolatey repositories:

choco install winfsp -y
