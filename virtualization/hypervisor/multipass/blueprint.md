# **[Multipass Blueprint](https://multipass.run/docs/blueprint)**

**[Back to Research List](../../research_list.md)**\
**[Back to Multipass Menu](./multipass_menu.md)**\
**[Back to Current Status](../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../README.md)**

In Multipass, a blueprint is a recipe to create a customised Multipass instance.

Blueprints consist of a base image, cloud-init initialisation, and a set of parameters describing the instance itself, e.g. minimum memory, CPUs or disk.

## references

- <https://github.com/canonical/multipass-blueprints/blob/main/README.md>
- <https://cloud-images.ubuntu.com/>

## Blueprints

Blueprints are defined from a YAML file with the following schema:

## v1/<name>.yaml

```yaml
description: <string>      # *a short description of the blueprint ("tagline")
version: <string>          #* a version string

runs-on:                   # a list of architectures this blueprint can run on

- arm64                    #   see <https://doc.qt.io/qt-5/qsysinfo.html#currentCpuArchitecture>
- x86_64                   #   for a list of valid values

instances:
  <name>:                  # * equal to the blueprint name
    image: <base image>    # a valid image alias, see `multipass find` for available values
    limits:
      min-cpu: <int>       # the minimum number of CPUs this blueprint can work with
      min-mem: <string>    # the minimum amount of memory (can use G/K/M/B suffixes)
      min-disk: <string>   # and the minimum disk size (as above)
    timeout: <int>         # maximum time for the instance to launch, and separately for cloud-init to complete
    cloud-init:
      vendor-data: |       # cloud-init vendor data
        <string>

health-check: |            # a health-check shell script ran by integration tests
  <string>
```

Blueprints currently integrated into Multipass can be found with the **[multipass find](https://multipass.run/docs/find-command)** command.

```bash
multipass find            
Image                       Aliases           Version          Description
core                        core16            20200818         Ubuntu Core 16
core18                                        20211124         Ubuntu Core 18
core20                                        20230119         Ubuntu Core 20
core22                                        20230717         Ubuntu Core 22
20.04                       focal             20240430         Ubuntu 20.04 LTS
22.04                       jammy             20240426         Ubuntu 22.04 LTS
23.10                       mantic            20240410         Ubuntu 23.10
24.04                       noble,lts         20240423         Ubuntu 24.04 LTS
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

For more information on creating a blueprint for inclusion into Multipass, please refer to the **[github project](https://github.com/canonical/multipass-blueprints)**.

## Github readme

Multipass Blueprints
This repository contains Multipass Blueprint definitions. They augment the offerings already available from the Ubuntu Cloud Images. You can list the available images with multipass find and run them with multipass launch:

```bash
$ multipass find
Image                       Aliases           Version          Description
# ...
minikube                                      latest           minikube is local Kubernetes

$ multipass launch minikube
Launched: minikube

$ multipass exec minikube -- minikube status
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured
```

## Testing

On Linux, the multipass find command looks for blueprints in a URL provided by an environment variable, MULTIPASS_BLUEPRINTS_URL. To locally test your blueprints you would need to override the systemd service with the following setting:

[Service]

```bash
Environment="MULTIPASS_BLUEPRINTS_URL=https://github.com/USERNAME/multipass-blueprints/archive/refs/heads/BRANCH_NAME.zip"
This can be done by using the systemctl edit utility:

sudo systemctl edit snap.multipass.multipassd.service
followed by service restart:

sudo snap restart multipass
```
