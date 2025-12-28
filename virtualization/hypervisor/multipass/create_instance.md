# **[create Multipass Instance](https://multipass.run/docs/create-an-instance)**

**[Back to Research List](../../research_list.md)**\
**[Back to Multipass Menu](./multipass_menu.md)**\
**[Back to Current Status](../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../README.md)**

## references

- **[instance](https://multipass.run/docs/instance)**
- See also **[how to manage instances](https://multipass.run/docs/how-to-guides#heading--manage-instances)**

## Create an instance with a specific image

To find out what images are available, run:

```bash
multipass find
Image                       Aliases           Version          Description
core                        core16            20200818         Ubuntu Core 16
core18                                        20211124         Ubuntu Core 18
core20                                        20230119         Ubuntu Core 20
core22                                        20230717         Ubuntu Core 22
20.04                       focal             20240612         Ubuntu 20.04 LTS
22.04                       jammy             20240626         Ubuntu 22.04 LTS
23.10                       mantic            20240619         Ubuntu 23.10
24.04                       noble,lts         20240622         Ubuntu 24.04 LTS
daily:24.10                 oracular,devel    20240622         Ubuntu 24.10
appliance:adguard-home                        20200812         Ubuntu AdGuard Home Appliance
appliance:mosquitto                           20200812         Ubuntu Mosquitto Appliance
appliance:nextcloud                           20200812         Ubuntu Nextcloud Appliance
appliance:openhab                             20200812         Ubuntu openHAB Home Appliance
appliance:plexmediaserver                     20200812         Ubuntu Plex Media Server Appliance

Blueprint                   Aliases           Version          Description
anbox-cloud-appliance                         latest           Anbox Cloud Appliance
charm-dev                                     latest           A development and testing environment for charmers
docker                                        0.4              A Docker environment with Portainer and related tools
jellyfin                                      latest           Jellyfin is a Free Software Media System that puts you in control of managing and streaming your media.
minikube                                      latest           minikube is local Kubernetes
ros-noetic                                    0.1              A development and testing environment for ROS Noetic.
ros2-humble                                   0.1              A development and testing environment for ROS 2 Humble.

```

The full multipass help launch output explains the available options:

```bash
$  multipass help launch
Usage: multipass launch [options] [[<remote:>]<image> | <url>]
Create and start a new instance.

Options:
  -h, --help                            Displays help on commandline options
  -v, --verbose                         Increase logging verbosity. Repeat the
                                        'v' in the short option for more detail.
                                        Maximum verbosity is obtained with 4 (or
                                        more) v's, i.e. -vvvv.
  -c, --cpus <cpus>                     Number of CPUs to allocate.
                                        Minimum: 1, default: 1.
  -d, --disk <disk>                     Disk space to allocate. Positive
                                        integers, in bytes, or decimals, with K,
                                        M, G suffix.
                                        Minimum: 512M, default: 5G.
  -m, --memory <memory>                 Amount of memory to allocate. Positive
                                        integers, in bytes, or decimals, with K,
                                        M, G suffix.
                                        Minimum: 128M, default: 1G.
  -n, --name <name>                     Name for the instance. If it is
                                        'primary' (the configured primary
                                        instance name), the user's home
                                        directory is mounted inside the newly
                                        launched instance, in 'Home'.
                                        Valid names must consist of letters,
                                        numbers, or hyphens, must start with a
                                        letter, and must end with an
                                        alphanumeric character.
  --cloud-init <file> | <url>           Path or URL to a user-data cloud-init
                                        configuration, or '-' for stdin
  --network <spec>                      Add a network interface to the
                                        instance, where <spec> is in the
                                        "key=value,key=value" format, with the
                                        following keys available:
                                         name: the network to connect to
                                        (required), use the networks command for
                                        a list of possible values, or use
                                        'bridged' to use the interface
                                        configured via `multipass set
                                        local.bridged-network`.
                                         mode: auto|manual (default: auto)
                                         mac: hardware address (default:
                                        random).
                                        You can also use a shortcut of "<name>"
                                        to mean "name=<name>".
  --bridged                             Adds one `--network bridged` network.
  --mount <local-path>:<instance-path>  Mount a local directory inside the
                                        instance. If <instance-path> is omitted,
                                        the mount point will be the same as the
                                        absolute path of <local-path>
  --timeout <timeout>                   Maximum time, in seconds, to wait for
                                        the command to complete. Note that some
                                        background operations may continue
                                        beyond that. By default, instance
                                        startup and initialization is limited to
                                        5 minutes each.

Arguments:
  image                                 Optional image to launch. If omitted,
                                        then the default Ubuntu LTS will be
                                        used.
                                        <remote> can be either ‘release’ or
                                        ‘daily‘. If <remote> is omitted,
                                        ‘release’ will be used.
                                        <image> can be a partial image hash or
                                        an Ubuntu release version, codename or
                                        alias.
                                        <url> is a custom image URL that is in
                                        http://, https://, or file:// format.
The only, optional, positional argument is the image to launch an instance from. See the multipass find documentation for information on what images are available. It’s also possible to provide a full URL to the image (use file:// for an image available on the host running multipassd).
```
