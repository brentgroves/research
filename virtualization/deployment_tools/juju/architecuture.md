# **[How it works](https://juju.is/why-juju)**

Shift from application management to distributed system management

![i1](https://res.cloudinary.com/canonical/image/fetch/f_auto,q_auto,fl_sanitize,w_600,h_440/https://assets.ubuntu.com/v1/7e656757-Shift%20from%20application%20management.svg)

Applications never run in isolation. Adding a workload to production requires adding essential services like observability, patching, identity, secret management, and many more

But it doesn’t stop there. 1000 days from now this complex system needs to work just as well as it does today. This means that lifecycle events like upgrades, migrations or scaling have to work seamlessly without downtime.

Without a comprehensive understanding of how to deploy, integrate and operate software, there is often too much perceived risk to adopt it in large scale, production settings. This is especially true for open source software, where operational knowledge is concentrated in a small number of hard-to-recruit individuals.

## It’s time to open source the operations code

To unlock the true potential of open source, we must normalise open sourcing not just the application code, but also the operational frameworks required to take the most out of it

That’s where Juju and charms come in.

Charms take all the domain knowledge required to operate software effectively and distil it into clean, maintainable, testable Python code that can be used across clouds.

Juju is the orchestrator that helps to deploy, manage and integrate that software across Kubernetes containers, Linux containers, virtual machines, and bare metal machines, on public or private clouds.

## What are Juju and Charms?

Juju, the orchestrator engine

Juju is an open source orchestration engine for software operators that enables the deployment, integration and lifecycle management of applications at any scale, on any infrastructure.

## Charms, the software operators

A charm is an operator: business logic encapsulated in reusable software packages that automate every aspect of an application’s life.

Charms are developed with the Charm SDK which comprises the:

Ops library: a Python framework for developing and testing charms
Charmcraft: a tool for building, packaging and publishing charms.

![i2](https://res.cloudinary.com/canonical/image/fetch/f_auto,q_auto,fl_sanitize,w_1500,h_556/https://assets.ubuntu.com/v1/b591a4ac-what%20are%20juju%20and%20charms%20(2).svg)

## What makes juju and charms different?

Automate operations across cloud, metal, VMs and Kubernetes

![i3](https://res.cloudinary.com/canonical/image/fetch/f_auto,q_auto,fl_sanitize,w_600,h_307/https://assets.ubuntu.com/v1/e3043619-Automate%20operations%20across%20clouds.png)

Charms allow you to use a single codebase to automate the lifecycle management of your system across Kubernetes containers, Linux containers, virtual machines, and bare metal machines, on public or private clouds.

## Seamless integrations across different clouds

Integrations simplify the process of connecting two applications by automatically applying required networking and configuration changes, even if the workloads are deployed across different clouds (e.g. Openstack and AWS).

![i4](https://res.cloudinary.com/canonical/image/fetch/f_auto,q_auto,fl_sanitize,w_600,h_377/https://assets.ubuntu.com/v1/cec65d63-Seamless%20integrations%20across%20different%20clouds.png)

## Lifecycle management for your system, not individual applications

Because applications integrations are a first class citizen in Juju, the system knows how to optimise the lifecycle management of the entire system, rather than individual applications.

![i5](https://res.cloudinary.com/canonical/image/fetch/f_auto,q_auto,fl_sanitize,w_600,h_400/https://assets.ubuntu.com/v1/c62ace02-Lifecycle%20management.png)

## Juju compared to similar tools

Juju’s focus is on system lifecycle management

Most existing tools are focused on solving the problem of deployment or configuration management, while juju’s focus is on the entire system lifecycle, from application deployment and integration to Day 2 operations like backup, upgrades, migrations, or scaling.

Juju integrates well with Terraform, extending our system lifecycle management framework with infrastructure as code capabilities.

![i6](https://res.cloudinary.com/canonical/image/fetch/f_auto,q_auto,fl_sanitize,w_1500,h_849/https://assets.ubuntu.com/v1/62922bad-How%20juju%20compares.svg)

Read about these next:

- **[Juju architecture](https://juju.is/juju-architecture)**

Juju provides tools to design, deploy and manage large distributed systems across infrastructures at scale with high availability, visibility, access control and cross-cloud functionality.

![i7](https://res.cloudinary.com/canonical/image/fetch/f_auto,q_auto,fl_sanitize,w_1600,h_780/https://assets.ubuntu.com/v1/5d884b21-Juju%20high%20level%20architecture.svg)

- **[Charm architecture](https://juju.is/charms-architecture)**
Charm architecture encapsulates app management, with charms automating lifecycle actions via a controller, responsive to both admin commands and system events.

![i8](https://res.cloudinary.com/canonical/image/fetch/f_auto,q_auto,fl_sanitize,w_1500,h_836/https://assets.ubuntu.com/v1/905f1670-what%20is%20a%20charm.svg)
