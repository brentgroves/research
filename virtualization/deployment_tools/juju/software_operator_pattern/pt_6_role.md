# **[Understanding roles in software operators](https://juju.is/blog/the-software-operator-design-pattern-part-6)**

**[Back to Research List](../../../../../research_list.md)**\
**[Back to Current Tasks](../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../README.md)**

The software operator design pattern – part 6: Roles
As we’ve seen throughout this series, a design pattern is a general solution that has been proven to solve a repeatedly occurring problem when designing software. In my previous blog posts, we examined the basics of the software operator design pattern, the forces impacting it, and the advantages and disadvantages of using it. But how does the software operator pattern actually work?

In today’s blog we take a closer look at roles – the key elements that make up the design pattern – and how they work together to simplify maintaining application infrastructure. And putting this knowledge into practice, we explore how roles relate to Kubernetes, Juju and charms.

## What are the roles in the operator pattern?

In the pattern community, acting software elements are described as roles. The term “role” is preferred because other terms can imply a particular implementation approach, resulting in an unnecessary limitation. Moreover, an element or component of a software system can cover multiple roles at the same time. As illustrated in Figure 1, the primary roles in the operator pattern are:

- The resource being managed.
- A controller watching the state of the resource and acting accordingly.
- The operator pattern describes the role of an “Operational Knowledge Code” element which implements the application-specific operational tasks.

![i1](https://res.cloudinary.com/canonical/image/fetch/f_auto,q_auto,fl_sanitize,c_fill,w_624,h_351/https://lh7-us.googleusercontent.com/n8ZjrVBWyW5iQWwAFOPrLrl8fzW_uOXxPrCql-_68EAAwkEPa_c-fd821vfLHWbiM_ljuJK72jwTwZvjgz0L8MWBPLd-oqV0Uj19RoNHo1udTE1Me0742jfNjn2-b4RGT4gpmDwUpq2WwepXr2ZybnI)

Figure 1: A simplified view of the roles in the operator design pattern.

Many operational tasks in distributed systems have a long runtime with some degree of uncertainty. A proven approach for this situation is to avoid synchronous interaction. Instead, a controller maintains a desired state and continuously checks if the watched state matches. Being state-oriented represents a more robust approach that copes better with failures and outages. Figure 2 shows an extended setup of the roles in the pattern, including:

- A managed environment that hosts the managed resource
- The controller maintaining a desired state
- External events that can also impact the controller

![i2](https://res.cloudinary.com/canonical/image/fetch/f_auto,q_auto,fl_sanitize,c_fill,w_624,h_351/https://lh7-us.googleusercontent.com/MXntxtItDDDWrIytpYnwYb2535UATeIZXlORKPj2yBROgm1_mtDR0Yl1Mu_xuFXbz_DWY__yfBYqI_mXAQ_hfugiC42g0PIpJynsnXaM2v6VrajmcoOQGC5o75UbM9mjigkBNIhzI1GqGmQq68tsyBU)

Figure 2: An extended view of the roles in the operator design pattern.

The controller captures the states from both the managed resource and the managed environment. External events are additional input for the controller. At the same time, the controller maintains a desired state against which the current state is reconciled. The controller executes tasks on the managed environment, or triggers the Operational Knowledge Code to carry out application-specific tasks accordingly.

These are the primary roles of the design pattern. This design can be applied to a variety of platforms and technologies. An operator can cover almost any application controlled by a central orchestrator, running on all environments, including bare metal servers, public or private clouds, and Kubernetes.

It is important to note that while Kubernetes manages containerised applications, using Kubernetes does not make operators obsolete. The operator pattern can also be applied in this managed environment to provide application-specific operations code.

## What does the software operator pattern look like on Kubernetes?

Canonical provides Juju, an open source orchestration engine for software operators that enables the deployment, integration and lifecycle management of applications and software infrastructure. Operators written for Juju are named charms.

For Kubernetes, Juju and charms implement the roles of the pattern in a straightforward way:

![i3](https://res.cloudinary.com/canonical/image/fetch/f_auto,q_auto,fl_sanitize,c_fill,w_624,h_351/https://lh7-us.googleusercontent.com/WshEEELVgdVlZ2SCUs4l7JNM2Bv-n3ZeDBd_pxqTGjICwWcznGfGQGAaMZ1BRYWFUq4BdpL2Plif8i01KZ-6dtyGK03ELhizrDmzYGAdoxHFcrvTFzM_uNc6vcdZ6AnQAumj79g-q0NTFnHTbDAvtzw)

Figure 3: Juju and Charm implementing the operator pattern on Kubernetes

| Role                       | Implementation | Description                                                                                                                                                |
|----------------------------|----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Controller                 | Juju           | Juju watches the environment and reconciles the current state with the desired state.                                                                      |
| External Events            | Juju CLI / API | External events reach the controller via the APIs or the user interface (the Juju CLI or the Juju dashboard).                                              |
| Operational Knowledge Code | Charm          | A charm represents the Operational Knowledge Code. The charm runs in a container in the same pod as the workload. There is one charm per managed resource. |
| Managed Resources          | Application    | The managed resource is an application which runs in another container.                                                                                    |

The Operational Knowledge Code is application-specific. Each charm covers only one application to ensure the reuse of applications and operators in different use cases. Juju manages and collects the current state and external events to reconcile them with the desired state, stored in a database. The Juju controller interacts with Kubernetes (the managed environment) to control computing, networking, and storage resources for deployed applications as required. In the same way, the charm interacts with the workload to execute operational code accordingly.

This article provided a short introduction to Juju in the context of the CNCF operator pattern. The pattern implemented by Canonical meets all deployment scenarios at scale with a fully open-source-based platform: Juju and the Charm SDK for developing operators. Juju can be applied across Kubernetes clusters, containers, virtual machines, and bare metal machines, on public or private clouds.

There is more to discover about Juju, charms and the operator framework, so watch out for more parts of this series. In the meantime, a great starting point is Juju’s documentation. You can also check out the presentations from our recent Operator Day events to learn how to build operators and see examples of operators for popular open-source applications.

## Learn more

- **[Learn more about Juju and charms](https://juju.is/)**
- **[Recorded presentations of Operator Day on YouTube](https://juju.is/operator-day)**
- **[The software operator design pattern: disadvantages – part 5](https://ubuntu.com/blog/the-software-operator-design-pattern-part-5)**
- **[The software operator design pattern: advantages – part 4](https://ubuntu.com/blog/software-operator-design-pattern-part-4)**
- **[The software operator design pattern: May the force be with you – Part 3](https://ubuntu.com/blog/software-operator-design-pattern-part-3)**
- **[The software operator design pattern – part 2](https://ubuntu.com/blog/software-operator-design-pattern-part-2)**
- **[Design patterns and the software operator – part 1](https://ubuntu.com/blog/software-operator-design-pattern-part-1)**
