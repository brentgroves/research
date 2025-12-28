# **[can i use lxd and docker on the same machine]()

Yes, it's generally possible and permissible to use both LXD and Docker on the same machine, but there are potential challenges related to networking and resource management that need to be addressed.
Key Considerations:
Network Configuration:
Both LXD and Docker can modify firewall rules, potentially causing conflicts. It's recommended to set up a network bridge to give each container its own IP address and avoid direct interference.
Resource Conflicts:
Ensure sufficient resources (CPU, memory, storage) are available to handle both LXD and Docker workloads. Monitor resource usage to prevent performance issues.
Use Cases:
Docker is often preferred for application-level containerization, while LXD is more versatile, supporting both full-system containers and virtual machines.
Installation:
Docker can be installed within an LXD container, allowing you to leverage LXD's management capabilities for Dockerized applications.
Network Isolation:
If you encounter networking issues, consider using a dedicated bridge interface for each technology or configuring port forwarding.
In essence, while technically feasible, careful planning and configuration are essential when running LXD and Docker together.
This video demonstrates how to install Docker inside an LXD virtual machine using cloud-init:
