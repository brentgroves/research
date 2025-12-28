# **[SSH Tunneling Explained](https://goteleport.com/blog/ssh-tunneling-explained/)**

## **[ssh cookbook](https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Proxies_and_Jump_Hosts#SOCKS_Proxy)**

## **[protocols](https://protocol.podigee.io/episodes)**

![i1](https://goteleport.com/blog/_next/image/?url=%2Fblog%2F_next%2Fstatic%2Fmedia%2Fssh-tunnel-min.591932d5.png&w=1920&q=75)

Although the typical use case of SSH is to access a remote server securely, you can also transfer files, forward local and remote ports, mount remote directories, redirect GUI, or even proxy arbitrary traffic (need I say SSH is awesome?). And this is just a small set of what's possible with SSH.

In this post, I'll cover different tunneling features as supported by OpenSSH, which helps achieve security use cases such as remote web service access without exposing ports on the internet, accessing servers behind NAT, exposing local ports to the internet. OpenSSH is the most widely used open-source SSH server. It comes pre-installed by default with the vast majority of Linux distributions.

If you are looking for a modern open-source alternative to OpenSSH that is optimized for elastic multi-cloud environments and supports other access protocols in addition to SSH, make sure to check out Teleport.

Now let's begin!

## What is SSH tunneling?

SSH tunneling is a method to transport additional data streams within an existing SSH session. SSH tunneling helps achieve security use cases such as remote web service access without exposing port on the internet, accessing server behind NAT, exposing local port to the internet.

## How does the SSH tunnel work?

When you connect to a server using SSH, you get a server's shell. This is the default behavior of an SSH connection. Under the hood, your SSH client creates an encrypted session between your SSH client and the SSH server. But the data transported within the SSH session can be of any type. For example, during shell access, the data transmitted are binary streams detailing dimensions of pseudo-terminal and ASCII characters to run commands on the remote shell. However, during SSH port forwarding, the data transmitted can be a binary stream of protocol tunneled over SSH (e.g. SQL over SSH).

![i2](https://goteleport.com/blog/_next/image/?url=%2Fblog%2F_next%2Fstatic%2Fmedia%2Fssh-tunnel.323a9894.png&w=750&q=75)

Fig: An SSH session.
So SSH tunneling is just a way to transport arbitrary data with a dedicated data stream (tunnel) inside an existing SSH session. This can be achieved with either local port forwarding, remote port forwarding, dynamic port forwarding, or by creating a TUN/TAP tunnel. Let's take a look at how port forwarding works and their use cases below.

## Local port forwarding

When local port forwarding is used, OpenSSH creates a separate tunnel inside the SSH connection that forwards network traffic from the local port to the remote server's port. In OpenSSH, this tunneling feature can be used by supplying -L flag. Internally, SSH allocates a socket listener on the client on the given port. When a connection is made to this port, the connection is forwarded over the existing SSH channel over to the remote server's port.

Local port forwarding is one of the ways of securing an insecure protocol or making a remote service appear local.

## Accessing insecure protocol

If a service running at a remote server does not natively support an encrypted transport mechanism, in that case, local port forwarding can be used to connect to that service by tunneling inside an encrypted SSH session.

## Secure access to remote service

For security reasons, it is good to bind services only to the local interface (as opposed to listening on a public interface). The flip side to this is how users would access the service from an external network. You can use local port forwarding to access the service that is listening on the remote localhost. In this way, connections on the local machine made to the forwarded port will, in effect, be connecting to the remote machine.

Consider an example below where PostgreSQL database on remote server listens on remote localhost (127.0.0.1:5432). There is no way the client can connect directly to this database but can access the server via SSH. So with SSH local port forwarding, the client connects to the remote server (with valid SSH credential) and commands SSH to forward the client's local port 5432 to the server's local port 5432. Thus, when a program (pgAdmin in this case) connects to the port 5432 of the client, SSH forwards the connection to the local port 5432 of the remote server (running PostgreSQL).

![i1](https://goteleport.com/blog/_next/image/?url=%2Fblog%2F_next%2Fstatic%2Fmedia%2Flocal-port-forwarding.3a4fb7b6.png&w=750&q=75)

Fig: SSH local port forwarding.
SSH local port forwarding command for above scenario:

`ssh -L 5432:127.0.0.1:5432 user@<remote_db_server>`

Further, there are no restrictions on the number of port forwarding you want to enable. For example, below SSH forwards two local ports, 3338 and 3339, to remote ports 3338 and 3339.

`ssh -L 3338:localhost:3338 -L 3339:localhost:3339 user@<remote_server>`

By default, an interactive session is created for you when you command local port forwarding. To prevent interactive sessions, you can use the -N flag that tells SSH to not to execute remote commands:

`ssh -N -L 3339:localhost:3339 user@<remote_server>`

## Remote port forwarding (reverse tunneling)

Also often called SSH reverse tunneling, remote port forwarding redirects the remote server's port to the localhost's port. When remote port forwarding is used, at first, the client connects to the server with SSH. Then, SSH creates a separate tunnel inside the existing SSH session that redirects incoming traffic in the remote port to localhost (where SSH connection was created).

Remote port forwarding can be achieved in OpenSSH by using -R flag. Internally, SSH allocates a socket listener on the remote server on the given port. When a connection is made to this port, the connection is forwarded over the existing SSH channel over to the local client's port.

## When to use remote port forwarding?

Exposing service running in localhost of a server behind NAT to the internet
Consider the scenario below. The client runs a web server on port 3000 but cannot expose this web server to the public internet as the client machine is behind NAT. The remote server, on the other hand, can be reachable via the internet. The client can SSH into this remote server. In this situation, how can the client expose the webserver on port 3000 to the internet? Via reverse SSH tunnel!

![i2](https://goteleport.com/blog/_next/image/?url=%2Fblog%2F_next%2Fstatic%2Fmedia%2Fremote-port-forwarding.eb42e3f9.png&w=828&q=75)

Fig: SSH remote port forwarding
Steps:
Run a web server on client localhost port 3000. 2. Configure reverse tunnel with command.

`ssh -R 80:127.0.0.1:3000 user@<remote_server_ip>`

Now, when users from distant internet visit port 80 of the remote server as http://<remote_server_ip>, the request is redirected back to the client's local server (port 3000) via SSH tunnel where the local server handles the request and response.

By default, the remote port forwarding tunnel will bind to the localhost of the remote server. To enable it to listen on the public interface (for a scenario like above), set the SSH configuration GatewayPorts yes in sshd_config.

## Alternative to local port forwarding

Local port forwarding does not work if incoming SSH requests in the remote server are disabled. For security reasons, administrators might entirely block inbound SSH requests but allow outbound SSH requests. In such situations, you can use remote port forwarding to create an outbound SSH connection and let the clients connect to the local port even if inbound connections are blocked.

## Dynamic port forwarding

Both local and remote port forwarding require defining a local and remote port. What if the ports are unknown beforehand or if you want to relay traffic to an arbitrary destination? Also known as dynamic tunneling, or SSH SOCKS5 proxy, dynamic port forwarding allows you to specify a connect port that will forward every incoming traffic to the remote server dynamically.

Dynamic port forwarding turns your SSH client into a SOCKS5 proxy server. SOCKS is an old but widely used protocol for programs to request outbound connections through a proxy server.

## When to use dynamic port forwarding?

Bypassing content filters
By tunneling network traffic inside SSH, it is possible to access services such as HTTP web pages that may be blocked by your ISP or organization. SOCKS5 proxy can proxy any type of traffic and any type of protocol. This means you can tunnel HTTP inside SSH using SOCKS5.

![i3](https://goteleport.com/blog/_next/image/?url=%2Fblog%2F_next%2Fstatic%2Fmedia%2Fdynamic-port-forwarding.5756ef35.png&w=828&q=75)

Fig: SSH dynamic port forwarding
Consider the case above. The client cannot access certain web pages due to content filtering implemented in front by the firewall. But the client can connect to the remote server (via SSH), which has unrestricted access to the internet. In this case, the client can initiate ssh connection by enabling dynamic port forwarding, thus creating a SOCKS5 proxy; the client can point web browser to proxy listening on local port 6000 and access restricted web content.

Command used for dynamic SSH tunneling scenario above:

`ssh -D 127.0.0.1:6000 user@<remote_server>`

## SSH TUN/TAP tunneling

SSH supports tunnel device forwarding (also known as TUN/TAP). TUN/TAP are virtual network interfaces that can be used to create a tunnel between two servers. This setup is a poor man's VPN. For a fully working SSH-forwarded TUN/TAP tunnel, you will first need to add a tun device and configure routing between two servers. The format for using SSH TUN is -w local_tun[:remote_tun]. Refer to this **[guide](https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Proxies_and_Jump_Hosts#Passing_Through_a_Gateway_with_an_Ad_Hoc_VPN)** for a complete setup. There's also a script available in this **[blog post](https://www.marcfargas.com/2008/07/ip-tunnel-over-ssh-with-tun/)** if you want to try tunneling in your server.

## Bonus - SSH tunnel over TOR

So far, we've discussed how SSH supports tunneling inside existing SSH sessions. But SSH itself can be tunneled over other protocols such as SOCKS. TOR is a popular anonymity software that supports tunneling any protocol over its SOCKS5 proxy.

SSH already provides a secure way of communicating via encrypted channels. If you want additional anonymity (conceal origin of SSH session), you can use TOR to relay SSH connection. This can be done by using torsocks as:

bash $ torsocks ssh user@<remote_server>

Or using **[netcat](https://en.wikipedia.org/wiki/Netcat)** as:

`ssh -o ProxyCommand="nc -X 5 -x localhost:9050 %h %p" user@<remote_server>`

## Security concerns of SSH tunneling

So far, we have covered the advantages of SSH tunneling and how it makes it easy to connect to remote services, which otherwise would not be possible due to network configurations and restrictions. But this power of SSH tunneling is also often misused by malicious users. Hiding malicious traffic within an SSH tunnel is a common classic way to go undetected inside a network. For example, read this post where android malware used SSH tunnel to access corporate network, this report which states Fox Kitten campaign using SSH tunnel, or this article describing misuse of SSH tunnels to send spam.

Detecting such activities is tough since SSH communications are encrypted, and you would not know what kind of data is transported underneath. If you are a network or security administrator, a continuous full traffic analysis within your network is a must which might give you clues such as types of SSH access performed, e.g., SSH file transfer, SSH shell access, or SSH tunnel. If the patterns do not match the work stuff that SSH requires to be used within your network, it might be a good lead to start an investigation.
