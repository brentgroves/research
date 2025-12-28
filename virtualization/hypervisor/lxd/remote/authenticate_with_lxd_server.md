# **[](https://documentation.ubuntu.com/lxd/latest/howto/server_expose/#authenticate-with-the-lxd-server)**

Authenticate with the LXD server
To be able to access the remote API, clients must authenticate with the LXD server. There are several authentication methods; see **[Remote API authentication](https://documentation.ubuntu.com/lxd/latest/authentication/#authentication)** for detailed information.

The recommended method is to add the client’s TLS certificate to the server’s trust store through a trust token. There are two ways to create a token. Create a pending fine-grained TLS identity if you would like to manage client permissions via Fine-grained authorization. Create a certificate add token if you would like to grant the client full access to LXD, or manage their permissions via Restricted TLS certificates.

See How to access the LXD web UI for instructions on how to authenticate with the LXD server using the UI. To authenticate a CLI or API client using a trust token, complete the following steps:

## 1. On the server, generate a trust token

There are currently two ways to retrieve a trust token in LXD.

Create a certificate add token

To generate a trust token, enter the following command on the server:

```bash
lxc config trust add
Client research11 certificate add token:
eyJjbGllbnRfbmFtZSI6InJlc2VhcmNoMTEiLCJmaW5nZXJwcmludCI6IjE1MGExMzBiNzM1YmQ4NDVjMWRlMjM1YTBkYWExMTcwMTA0OGYxZmI3ODE4NGRiMzRiNGFlN2MzZjFmNTJkNzgiLCJhZGRyZXNzZXMiOlsiMTAuMTg4LjUwLjIwMTo4NDQzIl0sInNlY3JldCI6ImZkZWI3MDE5ZjFhNDI5YWZjNjkwZTBmZGJhYmM1OGZjYjMyMzg5Y2UyNjUzZjcxNzU5YTk1NTcwNTBlNTAxM2YiLCJleHBpcmVzX2F0IjoiMDAwMS0wMS0wMVQwMDowMDowMFoiLCJ0eXBlIjoiIn0=

```

Enter the name of the client that you want to add. The command generates and prints a token that can be used to add the client certificate.

```bash
lxc config trust add
Please provide client name: isdev
Client isdev certificate add token:
token...
```

The recipient of this token will have full access to LXD. To restrict the access of the client, you must use the --restricted flag. See Confine users to specific projects on the HTTPS API for more details.

## Authenticate the client

On the client, add the server with the following command:

```bash
sudo snap install lxd --channel=5.21/stable --cohort="+"
# sudo snap install microceph --channel=squid/stable --cohort="+"
# sudo snap install microovn --channel=24.03/stable --cohort="+"
# sudo snap install microcloud --channel=2/stable --cohort="+"

If this is your first time running LXD on this machine, you should also run: lxd init
To start your first container, try: lxc launch ubuntu:24.04
Or for a virtual machine: lxc launch ubuntu:24.04 --vm

Generating a client certificate. This may take a minute...

# To indefinitely hold all updates to the snaps needed for MicroCloud, run:

sudo snap refresh --hold lxd

lxc remote add <remote_name> <token>
lxc remote add micro11 token
```

Note

If your LXD server is behind NAT, you must specify its external public address when adding it as a remote for a client:

`lxc remote add <name> <IP_address>`

When you are prompted for the token, specify the generated token from the previous step. Alternatively, use the --token flag:

`lxc remote add <name> <IP_address> --token <token>`

When generating the token on the server, LXD includes a list of IP addresses that the client can use to access the server. However, if the server is behind NAT, these addresses might be local addresses that the client cannot connect to. In this case, you must specify the external address manually.

## List configured remotes

To see all configured remote servers, enter the following command:

```bash
lxc remote list
+----------------------+---------------------------------------------------+---------------+-------------+--------+--------+--------+
|         NAME         |                        URL                        |   PROTOCOL    |  AUTH TYPE  | PUBLIC | STATIC | GLOBAL |
+----------------------+---------------------------------------------------+---------------+-------------+--------+--------+--------+
| images               | https://images.lxd.canonical.com                  | simplestreams | none        | YES    | NO     | NO     |
+----------------------+---------------------------------------------------+---------------+-------------+--------+--------+--------+
| local (current)      | unix://                                           | lxd           | file access | NO     | YES    | NO     |
+----------------------+---------------------------------------------------+---------------+-------------+--------+--------+--------+
| micro11              | https://10.188.50.201:8443                        | lxd           | tls         | NO     | NO     | NO     |
+----------------------+---------------------------------------------------+---------------+-------------+--------+--------+--------+
| ubuntu               | https://cloud-images.ubuntu.com/releases/         | simplestreams | none        | YES    | YES    | NO     |
+----------------------+---------------------------------------------------+---------------+-------------+--------+--------+--------+
| ubuntu-daily         | https://cloud-images.ubuntu.com/daily/            | simplestreams | none        | YES    | YES    | NO     |
+----------------------+---------------------------------------------------+---------------+-------------+--------+--------+--------+
| ubuntu-minimal       | https://cloud-images.ubuntu.com/minimal/releases/ | simplestreams | none        | YES    | YES    | NO     |
+----------------------+---------------------------------------------------+---------------+-------------+--------+--------+--------+
| ubuntu-minimal-daily | https://cloud-images.ubuntu.com/minimal/daily/    | simplestreams | none        | YES    | YES    | NO     |
+----------------------+---------------------------------------------------+---------------+-------------+--------+--------+--------+
```

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
