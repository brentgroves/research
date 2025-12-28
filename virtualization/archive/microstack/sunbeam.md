# Sunbeam

**[Back to Research List](../../research_list.md)**\
**[Back to Current Status](../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../README.md)**

June 13, Vancouver, OpenInfra Summit – Canonical today announced the extension of its commercial OpenStack offering to small-scale cloud environments with a new project Sunbeam. The project is 100% open source and is available free-of-charge. Early adopters can also opt-in for comprehensive security coverage and full commercial support under the Ubuntu Pro + Support subscriptions once they complete the deployment themselves. This enables organisations to modernise their small-scale, legacy IT estates and easily transition from proprietary solutions to OpenStack, without an expensive professional services engagement.

“Historically, commercial OpenStack deployments always used to come through paid consulting engagements and no vendor was an exception here”, said Tytus Kurek, Product Manager at Canonical. “In line with our mission to amplify open source, we are committed to delivering a production-grade platform to the community that everyone could just deploy themselves. Sunbeam emerged to remove numerous barriers around the initial adoption of OpenStack and is just the first step towards an autonomous private cloud.”

## references

<https://canonical.com/blog/canonical-extends-commercial-openstack-offering-to-small-scale-cloud-environments-with-project-sunbeam>

<https://governance.openstack.org/tc/reference/projects/sunbeam.html>

<https://opendev.org/openstack/sunbeam-charms>

## The most straightforward OpenStack ever

Sunbeam comes with a lucid interface and very simple installation instructions, making it super straightforward for everyone – even those with no previous OpenStack experience. This enables newcomers without in-depth technical knowledge to break the ice with OpenStack immediately. Ambitious engineers can fire the bootstrap procedure and get a fully-functional cloud in minutes. Finally, its lightweight architecture makes Sunbeam usable on machines with limited hardware resources, including workstations and VMs, effectively eliminating the need for dedicated hardware for testing purposes.

## K8s-native architecture

What makes Sunbeam unique is its K8s-native architecture. By running its services inside of containers, OpenStack gets fully decoupled from the underlying operating system, making historically challenging operations, such as upgrades, much easier. But Sunbeam is much more than just another OpenStack on Kubernetes. By using native Kubernetes principles, such as StatefulSets and operators, OpenStack can finally be modelled, deployed and managed as any other cloud-native application. This helps organisations to standardise on a single substrate across the entire spectrum of infrastructure and applications, while benefiting from a fresh, modern operational experience for OpenStack.

“More than 70% of OpenStack users also deploy Kubernetes, but Kubernetes is also increasingly used to manage OpenStack deployments themselves”, said Thierry Carrez, general manager of the Open Infrastructure Foundation. “With more than 40m compute cores of OpenStack now in production worldwide, the introduction of Sunbeam opens an exciting new way of deploying and operating OpenStack, from small labs to global scale deployments. We’re excited about the accessibility Canonical has brought to both OpenStack and Kubernetes through Sunbeam, and we’re eager to show it off to the community at the OpenInfra Summit this week in Vancouver.”

Sunbeam ships with the latest OpenStack version – 2023.1 (Antelope). Early adopters will be able to upgrade directly to the 2024.1 version next year through the Skip Level Upgrade Release Process (SLURP) mechanism. As of now Sunbeam includes core OpenStack services only, but it’s expected to evolve quickly to ensure full feature parity with OpenStack Charms soon. OpenStack Charms are at the heart of Canonical’s reference architecture for OpenStack implementation. They are software components that package typical OpenStack operational tasks, including upgrades, backups, scale-out and more.
