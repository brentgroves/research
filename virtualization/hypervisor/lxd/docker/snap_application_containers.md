Snaps are application containers that package an application and its dependencies into a single, self-contained unit. This allows snaps to be easily installed and run on various Linux distributions without conflicts, thanks to their inherent isolation and security features.

Key Features of Snaps:
Self-contained:
Snaps bundle all necessary dependencies, ensuring the application runs consistently across different systems.
Isolation:
Snaps run in a container with limited access to the host system, enhancing security and preventing conflicts with other applications.
Automatic Updates:
Snaps are designed for automatic updates, ensuring users always have the latest version of the application.
Security:
Snaps employ confinement mechanisms to restrict access to system resources, minimizing the risk of security breaches.
Cross-platform:
Snaps can run on various Linux distributions, making them a universal packaging format.
Discoverable and Installable:
Snaps are available through the Snap Store, making it easy to find and install applications.

How Snaps Work:

1. Packaging:
Developers create snaps by packaging their application and its dependencies using the Snapcraft tool.
2. Confinement:
The application runs within a confined environment, with limited access to the host system's resources.
3. Interfaces:
Users can grant specific permissions to snaps through interfaces, allowing them to access features like USB devices or cameras.
4. Updates:
The snapd service handles automatic updates for installed snaps, ensuring users have the latest versions.
Examples:
Desktop Applications: Applications like Spotify and Slack can be installed as snaps on desktop systems.
Server Applications: Snaps are also used for server applications like Nextcloud.
IoT Devices: Snaps can be used to deploy applications on IoT devices running Ubuntu Core.
In essence, snaps provide a convenient and secure way to distribute and run applications on various Linux systems by packaging them as isolated, self-contained units.

## Answer

I think this slide from Mark’s presentation on Container Camp 2016 explains a lot in a single image, and makes a lot of sense to me

![i1](https://i.sstatic.net/z7cDA.jpg)

Video link: Why we need a different container purely for apps - Mark Shuttleworth (Canonical) - YouTube

To sum it up in short:

LXC/LXD are “machine containers” with a persistent filesystem that works like a VM
Docker are “process containers” with an overlay filesystem over a static image (with options for persistent storage)
Snaps are “application containers” that directly extends functionality of the underlying host
