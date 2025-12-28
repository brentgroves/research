# charm

In Juju, a charm is an operator – software that wraps an application and that contains all of the instructions necessary for deploying, configuring, scaling, integrating, etc., the application on any Juju-supported cloud.

Charms are often published on **[Charmhub](https://charmhub.io/)** .

## Charm taxonomy

By substrate
Kubernetes
A Kubernetes charm is a charm designed to run on a resource from a Kubernetes cloud – i.e., in a container in a pod.

Example Kubernetes charms:

Discourse K8s

Zinc K8s

**[Postgresql K8s](https://charmhub.io/postgresql-k8s)**

## Machine

A machine charm is a charm designed to run on a resource from a machine cloud – i.e., a bare metal machine, a virtual machine, or a system container.

Example machine charms:

**[Ubuntu](https://charmhub.io/ubuntu)**

Vault

Rsyslog

## Infrastructure-agnostic

While charms are still very much either for Kubernetes or machines, some workloadless charms are in fact infrastructure-agnostic and can be deployed on both.

That is because most of the difference between a machine charm and a Kubernetes charm comes from how the charm handles the workload. So, if a charm does not have a workload, and its metadata does not stipulate Kubernetes, and the charm does not do anything that would only make sense on machines / Kubernetes, it can run perfectly fine on both machines and Kubernetes – the details of the deployment will differ (the charm will be deployed on a machine vs. a container in a pod), but the deployment will be successful. Example workloadless charms that are cloud-agnostic: Azure Storage Integrator .

## much more
