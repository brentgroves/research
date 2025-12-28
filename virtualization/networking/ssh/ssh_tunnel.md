# **[ssh tunnel](https://www.ssh.com/academy/ssh/tunneling)**

SSH Tunneling
This page explains SSH tunneling (also called SSH port forwarding), how it can be used to get into an internal corporate network from the Internet, and how to prevent SSH tunnels at a firewall. SSH tunneling is a powerful tool, but it can also be abused. Controlling tunneling is particularly important when moving services to Amazon AWS or other cloud computing services.

## What is an SSH tunnel?

SSH tunneling is a method of transporting arbitrary networking data over an encrypted SSH connection. It can be used to add encryption to legacy applications. It can also be used to implement VPNs (Virtual Private Networks) and access intranet services across firewalls.

SSH is a standard for secure remote logins and file transfers over untrusted networks. It also provides a way to secure the data traffic of any given application using port forwarding, basically tunneling any TCP/IP port over SSH. This means that the application data traffic is directed to flow inside an encrypted SSH connection so that it cannot be eavesdropped or intercepted while it is in transit. SSH tunneling enables adding network security to legacy applications that do not natively support encryption.

![i1](https://www.ssh.com/hubfs/Imported_Blog_Media/Securing_applications_with_ssh_tunneling___port_forwarding-2.png)

The figure presents a simplified overview of SSH tunneling. The secure connection over the untrusted network is established between an SSH client and an SSH server. This SSH connection is encrypted, protects confidentiality and integrity, and authenticates communicating parties.

The SSH connection is used by the application to connect to the application server. With tunneling enabled, the application contacts to a port on the local host that the SSH client listens on. The SSH client then forwards the application over its encrypted tunnel to the server. The server then connects to the actual application server - usually on the same machine or in the same data center as the SSH server. The application communication is thus secured, without having to modify the application or end user workflows.

## Who uses SSH tunneling?

The downside is that any user who is able to log into a server can enable port forwarding. This is widely exploited by internal IT people to log into their home machines or servers in a cloud, forwarding a port from the server back into the enterprise intranet to their work machine or suitable server.

Hackers and malware can similarly use it to leave a backdoor into the internal network. It can also be used for hiding attackers's tracks by bouncing an attack through multiple devices that permit uncontrolled tunneling.

To see how to configure an SSH tunnel, see this example. Tunneling is often used together with SSH keys and public key authentication to fully automate the process.

Benefits of SSH tunneling for enterprises
SSH tunnels are widely used in many corporate environments that employ mainframe systems as their application backends. In those environments the applications themselves may have very limited native support for security. By utilizing tunneling, compliance with SOX, HIPAA, PCI-DSS and other standards can be achieved without having to modify applications.

In many cases these applications and application servers are such that making code changes to them may be impractical or prohibitively expensive. Source code may not be available, the vendor may no longer exist, the product may be out of support, or the development team may no longer exist. Adding a security wrapper, such as SSH tunneling, has provided a cost-effective and practical way to add security for such applications. For example, entire country-wide ATM networks run using tunneling for security.

SSH's Tectia SSH Client/Server is a commercial solution that can provide secure application tunneling along with SFTP and secure remote access for enterprises.
