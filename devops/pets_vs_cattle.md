# **[DevOps Concepts: Pets vs Cattle](https://joachim8675309.medium.com/devops-concepts-pets-vs-cattle-2380b5aab313)**

**[Current Status](../../../development/status/weekly/current_status.md)**\
**[Research List](../../../research/research_list.md)**\
**[Back Main](../../../README.md)**

This is one of the cardinal concepts in DevOps is the notion of pets vs cattle for the service model. This was first introduced by Bill Baker on topic of scaling up vs scaling out presentation that was included slide deck titled Scaling SQL Server 2012. It was later introduced popularized by Gavin McCance in CERN Data Centre Evolution presentation.

## Pets Service Model

In the pets service model, each pet server is given a loving names like zeus, ares, hades, poseidon, and athena. They are “unique, lovingly hand-raised, and cared for, and when they get sick, you nurse them back to health”. You scale these up by making them bigger, and when they are unavailable, everyone notices.

Examples of pet servers include mainframes, solitary servers, load balancers and firewalls, database systems, and so on.

## Cattle Service Model

In the cattle service model, the servers are given identification numbers like web01, web02, web03, web04, and web05, much the same way cattle are given numbers tagged to their ear. Each server is “almost identical to each other” and “when one gets sick, you replace it with another one”. You scale these by creating more of them, and when one is unavailable, no one notices.

Examples of cattle servers include web server arrays, no-sql clusters, queuing cluster, search cluster, caching reverse proxy cluster, multi-master datastores like **[Cassandra](http://cassandra.apache.org/)**, big-data cluster solutions, and so on.

## What's the difference between Cassandra and MongoDB?

Apache Cassandra and MongoDB are two NoSQL databases that store data in a non-tabular format. Cassandra is an early NoSQL database with a hybrid design between a tabular and key-value store. It’s designed to store data for applications that require fast read and write performance. In contrast, MongoDB is a document database built for general-purpose usage. It has a flexible data model that allows you to store unstructured data in an optimized JSON format called Binary JSON, or BSON. The MongoDB database provides full indexing support and replication with rich and intuitive APIs.

## Evolution of Cattle

The cattle service model has evolved from Iron Age (bare metal racked-mounted servers) to the Cloud Age (virtualized servers that are programmable through a web interface). This is a brief overview of the platforms and tools that have evolved in each of these eras.

## The Iron Age

During the The Iron Age of computing, it wasn’t until the introduction of hardware virtualization that gave rise to managing systems of cattle. Robust change configuration tools like Puppet (2005), CFEngine 3 (2008), and Chef (2009) allowed operations to configure fleets of systems using automation.

## The First Cloud Age

In this initial era, virtualization was extended to offer IaaS (Infrastructure as a Service) that virtualized the entire infrastructure (networks, storage, memory, cpu) into programmable resources. Popular platforms offering IaaS are Amazon Web Services (2006), Microsoft Azure (2010), Google Cloud Platform (2011).

Such services gave rise to push-based orchestration tools like **[Salt Stack](https://saltstack.com/)** (2011), **[Ansible](https://www.ansible.com/)** (2012), and **[Terraform](https://www.terraform.io/)** (2014). These tools allowed you to coordinate state between the cloud provider and your application, and essentially allow you to program infrastructure, a pattern called Infrastructure as Code.

## The Second Cloud Age

While automation was built to virtualize aspects of the infrastructure, there were early movements to virtualize or partition aspects of the operating system (processes, network, memory, file system). This allows applications to be segregated into their own isolated environment without the need to virtualize hardware, which in turn duplicates the operating system per application. Some of these technologies include OpenVZ (2005), Linux Containers or LXC (2008), and Docker (2015).

The introduction of containers became explosive with Docker becoming a ubiquitous ecosystem in and of itself. A new set of technologies evolved to allocate resources for containers and schedule these containers across a cluster of servers: Apache Mesos (2009), Kubernetes (2014), Nomad (2015), Swarm (2015).

These tools give rise to what is called Immutable Production (or immutable infrastructure), where disposable containers are configured at deployment.

## The Current Ecosystem

With cloud computing platforms, where you can program the infrastructure (infrastructure as code) and apply immutable production with containers, orchestration tools tend to be more popular. There will still be niche use cases where runtime change configuration is required on both servers managed as cattle or pets. Currently, Ansible, Terraform, and Chef has been the most popular platforms in recent years (personal experience).

For container scheduling solutions, Kubernetes is now the ubiquitous ecosystem with implementations on popular cloud platforms: Google Kubernetes Engine (GKE), Azure Kubernetes Service (AKS), and soon to be released AWS Elastic Kubernetes Service (EKS).

In the big-data or streaming space with distributed platforms — Spark, Kafka, Flink, Storm, Hadoop, Cassandra, Samza, Akka, Finagle, Heron, to name but a few — Apache Mesos ecosystem is popular. Mesosphere and DC/OS are platforms that leverage Mesos to create a complete system for orchestrating these clusters. There’s support to also orchestrate Kubernetes as a cluster on top of DC/OS, giving you access to both platforms. Now you can schedule Kubernetes to schedule applications that use your big data clusters scheduled by DC/OS.
