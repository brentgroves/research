# **[Remote API authentication](https://documentation.ubuntu.com/lxd/latest/authentication/#authentication)**

Remote API authentication
Remote communications with the LXD daemon happen using JSON over HTTPS. This requires the LXD API to be exposed over the network; see **[How to expose LXD to the network](https://documentation.ubuntu.com/lxd/latest/howto/server_expose/#server-expose)** for instructions.

To be able to access the remote API, clients must authenticate with the LXD server. The following authentication methods are supported:

TLS client certificates

OpenID Connect authentication
