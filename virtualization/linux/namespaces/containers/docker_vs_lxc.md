# **[LXC vs docker](https://www.docker.com/blog/lxc-vs-docker/#:~:text=Docker%20is%20designed%20for%20developers,the%20operating%20system%20and%20hardware.)**

**[Research List](../../../../../research_list.md)**\
**[Detailed Status](../../../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../../../a_status/current_tasks.md)**\
**[Main](../../../../../../README.md)**

## AI Overview

LXC (Linux Containers) and Docker, while both container technologies, differ significantly in their approach: LXC focuses on system containers, offering a lightweight alternative to VMs, while Docker is designed for application containers, emphasizing portability and ease of deployment.

| Feature        | LXC                                                       | Docker                                                 |
|----------------|-----------------------------------------------------------|--------------------------------------------------------|
| Focus          | System Containers                                         | Application Containers                                 |
| OS Environment | Full OS environment                                       | Single application environment                         |
| Isolation      | Shares host kernel, but has own process and network space | Uses namespaces and cgroups for isolation              |
| Management     | More manual configuration                                 | Easier to manage and deploy                            |
| Use Cases      | Traditional applications, servers, services               | Microservices, web applications, portable applications |

## LXC (Linux Containers)

### Focus

System containers, offering a lightweight alternative to virtual machines.

### Functionality

LXC containers can be treated as a full OS, allowing installation of applications and services, and can run multiple applications and services.

### Isolation

LXC containers share the host system's kernel, but each container has its own process and network space, providing a level of isolation.

### Use Cases

Ideal for running traditional applications, servers, or services that require a full OS environment.

### Management

LXC containers require more manual configuration and management compared to Docker.

## Docker

### Focus:
Application containers, designed for building, shipping, and running applications in a portable and consistent environment.

### Functionality

Docker containers are designed to run a single application or service, and are not intended to be a full OS environment.

### Isolation

Docker containers use Linux namespaces and cgroups to isolate containers, providing a level of isolation between containers and the host system.

### Use Cases

Ideal for microservices, web applications, and other applications that benefit from portability and ease of deployment.

### Management

Docker containers are easier to manage and deploy than LXC containers, due to the use of Docker images and the Docker ecosystem.
