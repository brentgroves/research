# **[lxc image info](<https://documentation.ubuntu.com/lxd/latest/reference/manpages/lxc/image/info/#lxc-image-info-md>)**

Show useful information about images

Synopsis
Description: Show useful information about images

```bash
lxc image info [<remote>:]<image> [flags]
Options
      --vm   Query virtual machine images
Options inherited from parent commands
      --debug          Show all debug messages
      --force-local    Force using the local unix socket
  -h, --help           Print help
      --project        Override the source project
  -q, --quiet          Don't show progress information
      --sub-commands   Use with help or --help to view sub-commands
  -v, --verbose        Show all information messages
      --version        Print version number
lxc image info ubuntu/noble/desktop 
lxc image list --vm type=virtual-machine

lxc image info aeed887e1eb5
Fingerprint: aeed887e1eb5d7df9f0ff4e2d80a3231f40c0abb8ef9ec4e547b94c2be0c88ab
Size: 1140.47MiB
Architecture: x86_64
Type: virtual-machine
Public: no
Timestamps:
    Created: 2025/07/24 00:02 UTC
    Uploaded: 2025/07/24 22:34 UTC
    Expires: never
    Last used: 2025/07/24 22:34 UTC
Properties:
    os: Ubuntu
    release: noble
    requirements.cgroup: v2
    serial: 20250724_0002
    type: disk-kvm.img
    variant: desktop
    architecture: amd64
    description: Ubuntu noble amd64 (20250724_0002)
Aliases:
Cached: no
Auto update: disabled
Source:
    Server: https://images.lxd.canonical.com
    Protocol: simplestreams
    Alias: ubuntu/noble/desktop
Profiles:
    - default
```
