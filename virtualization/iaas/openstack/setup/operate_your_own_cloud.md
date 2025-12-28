# **[OpenStack Tutorial – Operate Your Own Private Cloud (Full Course)](https://www.freecodecamp.org/news/openstack-tutorial-operate-your-own-private-cloud/)**

**[Back to Research List](../../../../../research_list.md)**\
**[Back to Current Tasks](../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../README.md)**

OpenStack is an open source software that provides cloud infrastructure for virtual machines, bare metal, and containers.

In this article, you will learn how to use OpenStack to operate your own private cloud.

By the end of the tutorial, you will have a core understanding of what OpenStack is and you will know the basics of setting up and administering OpenStack using the OpenMetal platform. You will also understand some commonly used OpenStack services.

In addition to creating this article version of the tutorial, I also created a video version. You can watch the video on the freeCodeCamp.org YouTube channel.

To follow along with this tutorial, it can be helpful to have a basic understanding of the Linux command line, networking, and virtualization. But none of it is required.

Thanks to OpenMetal for sponsoring this tutorial.

## What is OpenStack?

OpenStack is an open source cloud computing platform that is used by organizations to manage and control large scale deployments of virtual machines, such as in a cloud computing or virtual private server environment. OpenStack is a popular choice for organizations because it is scalable, reliable, and provides a high degree of control over the underlying infrastructure.

Besides being used to manage deployments of virtual machines, OpenStack can also be used to manage storage and networking resources in a cloud environment.

In some ways OpenStack can be compared to AWS but here are some key differences between the two:

- OpenStack is an open source platform, while AWS is a proprietary platform.
- OpenStack offers more flexibility and customization options than AWS.
- OpenStack typically requires more technical expertise to set up and manage than AWS since you basically have to set up everything yourself.

Let's go into more details about what OpenStack offers.

Beyond standard infrastructure-as-a-service functionality, additional components provide orchestration, fault & service management, and other services to ensure high availability of user applications.

![i1](https://www.freecodecamp.org/news/content/images/2022/04/openstack.svg)
OpenStack diagram.

OpenStack is broken up into services to allow you to plug and play components depending on your needs. The OpenStack map below shows common services and how they fit together.

![i2](https://www.freecodecamp.org/news/content/images/2022/04/openstack-map.svg)

OpenStack map.

I won't cover every service but here is what some of the more common OpenStack services do.

Object Storage: OpenStack Object Storage (Swift) is a highly scalable, distributed object storage system.

Compute: OpenStack Compute (Nova) is a cloud computing fabric controller, which manages the allocation of compute resources.

Networking: OpenStack Networking (Neutron) is a system for managing networks and IP addresses.

Dashboard: The OpenStack Dashboard (Horizon) is a web-based interface for managing OpenStack resources.

Identity: OpenStack Identity (Keystone) is a system for managing user accounts and access control.

Image: OpenStack Image (Glance) is a service for storing and retrieving virtual machine images.

Block Storage: OpenStack Block Storage (Cinder) is a service for managing block storage devices.

Telemetry: OpenStack Telemetry (Ceilometer) is a service for collecting and storing metering data.

Orchestration: OpenStack Orchestration (Heat) is a service for orchestration and cloud formation.

Bare Metal: OpenStack Bare Metal (Ironic) is a service for provisioning and managing bare metal servers.

Data Processing: OpenStack Data Processing (Sahara) is a service for provisioning and managing Hadoop and Spark clusters.

We will be demonstrating a few of the more common OpenStack services later int his course.

There are a bunch of different ways to deploy and configure OpenStack based on the needs of your application or organization.

In this course, we will learn how to get started with OpenStack and use many of the most common features.

One of the easiest ways to get started with OpenStack is by using the OpenMetal on-demand private cloud. This allows us to quickly deploy OpenStack to the cloud and simplifies the setup process. OpenMetal provided a grant that made this tutorial possible.

While we will be using OpenMetal to learn about OpenStack, the material covered in this tutorial applies to any OpenStack deployment, not just ones that use OpenMetal. So no matter how you want to use OpenStack, this tutorial is for you.

## Setting Up OpenStack on OpenMetal

To get OpenStack setup, you need to provision and set up your cloud on OpenMetal. Just follow the prompts on this **[OpenMetal Central page](https://central.openmetal.io/)** to get everything setup.

When setting up, you will have to

OpenMetal Private Clouds are deployed with OpenStack to three bare metal servers. These three servers comprise the Private Cloud Core. To OpenStack, these three servers are considered the control plane. Private Clouds are deployed with Ceph, providing your cloud with shared storage. Ceph is an open source software-defined storage solution.

Let's view the hardware assets that were created on OpenMetal. If you just created a cloud, you may already be on on the cloud management page. If not, click "manage". Now click "Assets" on the left side menu.

This page contains a list of assets included with your Private Cloud Deployment. These include your Hardware Control Plane Nodes and IP blocks for Inventory and Provider IP addresses.

![i1](https://www.freecodecamp.org/news/content/images/2022/04/image-51.png)

## Assets Page of Cloud Management Dashboard for OpenMetal

The screenshot above is a list of assets in a Demo Private Cloud. Your Private Cloud can have different hardware based on the options you have selected in your deployment:

In this example, you will notice three main sections:

- 3 Cloud Core mb_small_v1 Control Plane Nodes
- Inventory IP Address Blocks
- Provider IP Address Blocks

With these Private Clouds, OpenStack is deployed with three hyper-converged control plane nodes.

You can access these Control Plane Nodes directly through SSH as the root user. This access is done through the SSH keys you provided during your Private Cloud Deployment. Use this command to connect (you will have to change the key name and IP to match your information):

```bash
ssh -i ~/.ssh/your_key_name root@173.231.217.21
```

## Getting Started with OpenStack Horizon

Horizon is the name of the default OpenStack dashboard, which provides a web based user interface to OpenStack services. It allows a user to manage the cloud.

To access your new cloud's OpenStack dashboard (called Horizon) you will need to obtain Horizon's administrator password. The username is "admin".

To begin, SSH into one of the cloud's servers (you can use any IP address from the "Assets" page). For example:

`ssh -i ~/.ssh/your_key_name root@173.231.217.21`

Once you are logged in to the server, run this command:

grep keystone_admin_password /etc/kolla/passwords.yml

The password will be shown in the output as in this example:

keystone_admin_password: aB0cD1eF2gH3iJ4kL5mN6oP7qR8sT9uV

Next, launch Horizon. On OpenMetal, you can click the "Horizon" tab on the left menu.

![i2](https://www.freecodecamp.org/news/content/images/2022/04/image-52.png)

Login using "admin" and the password you just accessed.

![i3](https://www.freecodecamp.org/news/content/images/2022/04/image-53.png)

## Horizon dashboard

### Create a Project in OpenStack Horizon

In OpenStack, the cloud is divided through the use of projects. Projects have associated with them users, who have differing levels of access, defined by roles. An administrator defines resource limits per project by modifying quotas.

Now we'll learn how to create a project and associate a user with it. And we will learn how project quotas can be adjusted. The Horizon interface will be similar no matter where you deploy OpenStack. This is not specific to OpenMetal.

There are three root-level tabs on the left menu in Horizon: Project, Admin, and Identity. Only users with administrative privileges can see the admin tab.

To create your first project, navigate to Identity -> Projects.

![i3](https://www.freecodecamp.org/news/content/images/2022/04/image-56.png)

Projects.

Several projects already exist, including the admin project. These projects are deployed by default and generally should not be modified.

Click the Create Project button near the top right to create a new project.

![i4](https://www.freecodecamp.org/news/content/images/2022/04/image-57.png)

Under the Name field, specify a name for the project. This example project is called Development. You can also add Project Members and Project Groups but we are not going to cover those yet. Click Create Project to finish creating the first project.

Once created, the project appears in the Project Listing page.

While in the project listing page, you can view and adjust quotas for this project as the admin user. Quotas are limits on resources, like the number of instances.

To view the quotas for this project while in Identity -> Projects tab, find the drop down to the right with the first option being Manage Members. From this menu, click Modify Quotas to view the default quota values.

![i5](https://www.freecodecamp.org/news/content/images/2022/04/image-58.png)

You will see a form with several tabs and you are presented with the quotas for the Compute service. Quotas exist for the Volume and Network services as well.

You may want to adjust the parameters in this form depending on your workload. Setting a value to -1 means that quota is unlimited.

## How to Create a User and Associate with Project

Now that you have a project, you can associate a user with it. There is already the default admin user but now let's see how to create a new user and login with the new user.

First navigate as admin to Identity -> Users. By default, there are several users already listed, and this is expected. These are created during cloud deployment and should generally not be modified.

Click the Create User button.
