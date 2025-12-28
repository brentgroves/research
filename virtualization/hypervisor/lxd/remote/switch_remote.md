# switch remotes

```bash
lxc remote list
## Select a default remote

The LXD command-line client is pre-configured with the local remote, which is the local LXD daemon.

To select a different remote as the default remote, enter the following command:

lxc remote switch <remote_name>
To see which server is configured as the default remote, enter the following command:

```bash
lxc remote get-default
local
lxc remote switch <remote_name>
lxc remote switch micro11
lxc remote get-default   
micro11


```
