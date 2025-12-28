# **[](https://documentation.ubuntu.com/lxd/latest/howto/server_expose/)**

How to expose LXD to the network
By default, LXD can be used only by local users through a Unix socket and is not accessible over the network.

To expose LXD to the network, you must configure it to listen to addresses other than the local Unix socket. To do so, set the core.https_address server configuration option.

For example, allow access to the LXD server on port 8443:

`lxc config set core.https_address :8443`

To allow access through a specific IP address, use ip addr to find an available address and then set it. For example:

```bash
ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp5s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:16:3e:e3:f3:3f brd ff:ff:ff:ff:ff:ff
    inet 10.68.216.12/24 metric 100 brd 10.68.216.255 scope global dynamic enp5s0
       valid_lft 3028sec preferred_lft 3028sec
    inet6 fd42:e819:7a51:5a7b:216:3eff:fee3:f33f/64 scope global mngtmpaddr noprefixroute
       valid_lft forever preferred_lft forever
    inet6 fe80::216:3eff:fee3:f33f/64 scope link
       valid_lft forever preferred_lft forever
3: lxdbr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether 00:16:3e:8d:f3:72 brd ff:ff:ff:ff:ff:ff
    inet 10.64.82.1/24 scope global lxdbr0
       valid_lft forever preferred_lft forever
    inet6 fd42:f4ab:4399:e6eb::1/64 scope global
       valid_lft forever preferred_lft forever
~$lxc config set core.https_address 10.68.216.12
```

All remote clients can then connect to LXD and access any image that is marked for public use.

## Authenticate with the LXD server

To be able to access the remote API, clients must authenticate with the LXD server. There are several authentication methods; see **[Remote API authentication](https://documentation.ubuntu.com/lxd/latest/authentication/#authentication)** for detailed information.

The recommended method is to add the client’s TLS certificate to the server’s trust store through a trust token. There are two ways to create a token. Create a pending fine-grained TLS identity if you would like to manage client permissions via Fine-grained authorization. Create a certificate add token if you would like to grant the client full access to LXD, or manage their permissions via Restricted TLS certificates.

See **[How to access the LXD web UI](https://documentation.ubuntu.com/lxd/latest/howto/access_ui/#access-ui)** for instructions on how to authenticate with the LXD server using the UI. To authenticate a CLI or API client using a trust token, complete the following steps:

On the server, generate a trust token.

There are currently two ways to retrieve a trust token in LXD.

Create a certificate add token

To generate a trust token, enter the following command on the server:

`lxc config trust add`

Enter the name of the client that you want to add. The command generates and prints a token that can be used to add the client certificate.

The recipient of this token will have full access to LXD. To restrict the access of the client, you must use the --restricted flag. See **[Confine users to specific projects on the HTTPS API](https://documentation.ubuntu.com/lxd/latest/howto/projects_confine/#projects-confine-https)** for more details.

## 2. Authenticate the client

On the client, add the server with the following command:

`lxc remote add <remote_name> <token>`

Note

If your LXD server is behind NAT, you must specify its external public address when adding it as a remote for a client:

`lxc remote add <name> <IP_address>`

When you are prompted for the token, specify the generated token from the previous step. Alternatively, use the --token flag:

`lxc remote add <name> <IP_address> --token <token>`

When generating the token on the server, LXD includes a list of IP addresses that the client can use to access the server. However, if the server is behind NAT, these addresses might be local addresses that the client cannot connect to. In this case, you must specify the external address manually.

See **[Remote API authentication](https://documentation.ubuntu.com/lxd/latest/authentication/#authentication)** for detailed information and other authentication methods.
