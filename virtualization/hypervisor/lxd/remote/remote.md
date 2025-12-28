# **[How to add remote servers](https://documentation.ubuntu.com/lxd/latest/remotes/)**

**[ref](https://www.youtube.com/watch?v=amslKipAjxo)**

Remote servers are a concept in the LXD CLI.

If you are using the UI or the API, you can interact with different remotes by using their exposed UI or API addresses instead.

By default, the command-line client interacts with the local LXD daemon, but you can add other servers or clusters to interact with.

One use case for remote servers is to distribute images that can be used to create instances on local servers. See **[Remote image servers](https://documentation.ubuntu.com/lxd/latest/reference/remote_image_servers/#remote-image-servers)** for more information.

You can also add a full LXD server as a remote server to your client. In this case, you can interact with the remote server in the same way as with your local daemon. For example, you can manage instances or update the server configuration on the remote server.

## Authentication

To be able to add a LXD server as a remote server, the server’s API must be exposed, which means that its **[core.https_address](https://documentation.ubuntu.com/lxd/latest/server/#server-core:core.https_address)** server configuration option must be set.

When adding the server, you must then authenticate with it using the chosen method for **[Remote API authentication](https://documentation.ubuntu.com/lxd/latest/authentication/#authentication)**.

See How to expose LXD to the network for more information.

## ai

To configure a remote LXD server, use the lxc remote add command, followed by a unique name for the remote and the server's address. You'll likely be prompted for a trust password or token to authenticate. Once added, you can manage the remote server using the LXD client.

Here's a more detailed explanation:
Add the remote: Use the lxc remote add <remote_name> <remote_address> command, replacing <remote_name> with a chosen name for the remote and <remote_address> with the server's address (e.g., an IP address or hostname).
Authentication: LXD will attempt to authenticate you using TLS certificates. If a trust password is set, you'll be prompted for it. If not, the connection might be rejected.
Token-based authentication: LXD also supports token-based authentication. You can generate a token on the server using lxc config trust add and use it with the lxc remote add command on the client.
Switching remotes: To switch the default remote, use lxc remote switch <remote_name>.
Listing remotes: Use lxc remote list to see all configured remotes.
Global configuration: You can configure remotes on a system-wide basis by editing the global configuration file (e.g., /etc/lxd/config.yml or /var/snap/lxd/common/global-conf/config.yml for the snap version).
Certificate storage: Certificates for remotes should be stored in the servercerts directory within the configuration directory (e.g., /etc/lxd/servercerts/ or /var/snap/lxd/common/global-conf/servercerts/).

spice+unix:///home/brent/snap/lxd/common/config/sockets/3205655147.spice

```bash
cat ~/snap/lxd/common/config/config.yml
default-remote: micro11
remotes:
  local:
    addr: unix://
    public: false
  micro11:
    addr: <https://10.188.50.201:8443>
    auth_type: tls
    project: default
    protocol: lxd
    public: false
```
