# **[Microcloud? Yes, the micro and the cloud...](https://www.linkedin.com/pulse/microcloud-yes-micro-cloud-anders-carlius-f2xmf/)**

Canonical, the company behind Ubuntu, has long been a significant player in the Linux market. As Ubuntu approaches its 20th anniversary, this milestone is not just a celebration of longevity but also a testament to the impact Ubuntu has had in demystifying Linux for millions worldwide.

This year, Canonical marks this momentous occasion with introducing Microcloud, its latest innovation tailored for small-to-medium scale, on-premises high-availability clusters. Microcloud is poised to be a game-changer in the world of Linux clustering, offering an intriguing blend of simplicity and sophistication.

## Overview of Microcloud

At its core, Microcloud is designed to simplify the complexity traditionally associated with setting up and managing Linux clusters. It’s a solution aimed at organizations that require reliable, high-availability cluster infrastructure but without the operational overhead typically involved. Microcloud is especially suited for small and medium businesses, educational institutions, and research organizations that seek to harness the power of clustering technology without the need for extensive IT resources.

For instance, a small business with limited IT staff can leverage Microcloud to enhance its server infrastructure. By deploying Microcloud, such a business could ensure the continuous availability of critical applications, with the added benefits of scalability and redundancy minus the complexity of traditional clustering solutions.

## Key Features and Technologies

Microcloud brings together several cutting-edge technologies to offer a robust clustering solution. At its heart lies the LXD containervisor, a powerful tool for managing system containers that provide a lightweight, efficient alternative to traditional virtual machines. Alongside LXD, Microcloud integrates Ceph for distributed storage, offering scalable and resilient storage solutions and OpenZFS for reliable local storage with advanced features like snapshots and replication.

One of the key components is the OVN (Open Virtual Network), which is instrumental in virtualizing the cluster interconnect, thus ensuring seamless communication between cluster nodes. This amalgamation of technologies facilitates the creation of a high-availability cluster that is not just resilient but also adaptive to varying workload demands.

## The Launch Event and Demonstrations

The unveiling of Microcloud was not without its share of drama and excitement. At the launch event, Canonical presented a series of live demonstrations, showcasing the capabilities of Microcloud in real-time. The highlight was certainly the set-up of an on-stage cluster using three ODROID machines, chosen for their dual Ethernet connections and robust processing capabilities.

However, the event took an unexpected turn when the first demonstration, which involved bringing up a new cluster, encountered repeated failures. This hiccup, caused by a typo in a script, led to the demo running significantly over its planned duration. Despite the initial setback, the team at Canonical quickly identified and resolved the issue, demonstrating their technical acumen and commitment to transparency. While the malfunction momentarily disrupted the sequence of demonstrations and perhaps impacted audience perception, the rapid resolution also highlighted the resilience and adaptability of Microcloud.

## Microcloud vs. Kubernetes

Microcloud's debut inevitably draws comparisons with Kubernetes, the current de facto standard for container orchestration in large-scale systems. However, Canonical's Microcloud charts a different course. Unlike Kubernetes, which primarily focuses on orchestrating microservices across a distributed system of containers, Microcloud centers around LXD clusters and system containers. These system containers are capable of running complete Linux distributions, offering a more holistic and integrated approach compared to the more segmented nature of Kubernetes' container orchestration.

A case study illustrating this difference can be seen in an organization's transition from a Kubernetes-based system to Microcloud. The organization, previously managing a complex web of microservices under Kubernetes, found a more streamlined and cohesive environment in Microcloud. This shift not only simplified their infrastructure management but also provided enhanced performance due to the more integrated nature of system containers.

## User-Friendly Approach and Market Impact

Canonical’s launch of Microcloud underscores its longstanding strategy of prioritizing simplicity and cost-effectiveness, making advanced technology accessible to a wider range of users. This approach has been a cornerstone of Canonical's market strategy, helping to establish Ubuntu as a preferred choice for both new and experienced Linux users.

Microcloud seamlessly aligns with this strategy. Simplifying the complexities of cluster management and offering it as a cost-effective solution, opens up new possibilities for organizations that previously might have found such technology out of reach. An illustrative example of this impact is seen in a startup that chose Microcloud for its server infrastructure. The startup, with limited financial resources and technical expertise, was able to deploy a reliable and scalable cluster, something that was previously beyond its reach both technically and financially. This choice not only facilitated the startup’s growth but also demonstrated Microcloud’s potential to democratize advanced clustering technology.

My Conclusion?

Microcloud stands as a testament to the potential of open-source innovation to transform technology landscapes as many other open source projects have done over the yeras. Simplifying the complex world of on-premises Linux clustering opens up new avenues for businesses and developers who may have previously been sidelined by resource and expertise constraints. This tool is not just a technological advancement; it's a democratizing force in the industry.

Canonical’s unwavering commitment to user-friendly and cost-effective solutions is evident in Microcloud. Their understanding reflects that the future of technology lies not only in its sophistication but also in its accessibility. Microcloud could very well be a catalyst in shaping the future of Linux clustering, making high-availability systems a realistic option for a much broader range of users. In doing so, it holds the promise of fueling innovation and growth for businesses and developers alike, continuing Canonical's legacy of transforming and democratizing technology.
