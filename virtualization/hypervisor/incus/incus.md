# **[]()**

Incus is the community-driven continuation of the LXD project, designed to offer a modern, open-source system container and VM management platform, while LXC (Linux Containers) is the underlying foundational library and tooling that provides the core Linux kernel features for containerization. Therefore, Incus manages containers built on the LXC technology, similar to how LXD did, but Incus is not a direct competitor to LXC, but rather a higher-level management tool built on top of it.
LXC: The Foundation
What it is:
A collection of tools and a C library (liblxc) that leverage the Linux kernel's cgroups and namespaces to create and manage system containers.
How it works:
It's a lower-level, more direct interface to the kernel features for isolation, allowing users to create and run isolated Linux environments.
Role:
It provides the basic technology and command-line tools for managing individual containers.
Incus: The Management Layer
What it is:
A high-level management tool for containers and virtual machines, forked from the LXD project by the Linux Containers community.
How it works:
It utilizes LXC to manage system containers and QEMU for virtual machines, providing a more unified experience.
Role:
It acts as a powerful system container manager with features like a REST API, cluster management, support for OCI/Docker images, and compatibility with technologies like ZFS.
Key Differences & Relationship
Hierarchy:
Incus sits above LXC; it uses LXC's technology to provide an advanced management system.
Project Focus:
Incus is community-backed, open-source, and aims to be a successor to the LXD project. LXC is the foundational project for containerization technologies under the Linux Containers umbrella.
Management Features:
While LXC provides the core containerization, Incus adds features like a dashboard, backup management, and a user-friendly interface, making it easier to manage infrastructure like a private cloud.
Origin:
Incus is a direct successor and fork of Canonical's LXD, created when Canonical took full control of the LXD project.
Packaging:
Incus is designed for community distribution (e.g., via repositories), contrasting with the LXD project which is distributed as a proprietary Snap package from Canonical.
