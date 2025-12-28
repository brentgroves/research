# **[Deployment Manifest](https://canonical-openstack.readthedocs-hosted.com/en/latest/explanation/deployment-manifest/)**

**[Back to Research List](../../../../../research_list.md)**\
**[Back to Current Tasks](../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../README.md)**

A deployment manifest allows a user to override the default configuration settings for Canonical OpenStack.

Manifests are supported by the following commands:

sunbeam cluster bootstrap

sunbeam cluster refresh

sunbeam configure

sunbeam enable

Note

For a how-to on using manifests see **[Managing deployment manifests](https://canonical-openstack.readthedocs-hosted.com/en/latest/how-to/misc/managing-deployment-manifests/)**.

A manifest file
A manifest is a YAML file that consists of two sections: deployment and software. It has the following structure:

```yaml
deployment:
  <deployment configuration>
software:
  <software configuration>
```

See the **[Manifest file reference](https://canonical-openstack.readthedocs-hosted.com/en/latest/reference/manifest-file-reference/)** page for details on the structure and possible contents of this file.

## Deployment configuration

Any infrastructure related configuration like hardware and networking are specified in this section. If a key’s value is deemed necessary for your deployment and it has not been provided by means of a manifest file, you will be asked to enter it via an interactive prompt.

Here is an example deployment configuration:

```yaml
deployment:

  proxy:
    proxy_required: false

  bootstrap:
    management_cidr: 192.168.123.0/24

  addons:
    metallb: 192.168.123.81-192.168.123.90

  microceph_config:
    sunbeam-1.localdomain:
      osd_devices: /dev/vdc
```

## Software configuration

The software configuration consists of three subsections: juju, charms, and terraform.

Here is an example software configuration:

```yaml
software:

  juju:
    bootstrap_args:
    - --debug
    - --agent-version=3.2.4

  charms:
    glance-k8s:
      channel: 2024.1/candidate
      revision: 66
      config:
        debug: True
        pool-type: replicated

  terraform:
    hypervisor-plan:
      source: /home/ubuntu/deploy-openstack-hypervisor
```

Terraform is a powerful infrastructure-as-code (IaC) tool that allows users to define and manage their infrastructure in a declarative, human-readable format. Key features include Infrastructure as Code, state management, multi-cloud support, modular code, and workflow automation

## juju section

This section allows users to pass bootstrap arguments to Juju.

Option

Description

bootstrap_args

list of arguments that will be passed to the juju bootstrap command

## charms section

This section allows users to set specific versions of charm to be deployed and the charm configurations. This section is a dictionary of charm and its options. The options that can be set for each charm are described below.

| Option   | Description                |
|----------|----------------------------|
| channel  | charm channel to use       |
| revision | charm revision to use      |
| config   | charm configuration to set |

Charm channel/revision and their configuration are set by default and are known to work together. Use all default values in production and introduce a new setting only when necessary. For example, only change the channel/revision to get a possible hot fix or change a configuration setting as per the local environment (e.g. Keystone LDAP URL).

It is recommended to test any customization in a staging environment before applying them in production.

Tip

Available charms and their configuration options are listed on the **[Underlying projects](https://canonical-openstack.readthedocs-hosted.com/en/latest/reference/underlying-projects-and-charms/)** and charms page.

## terraform section

This section allows users to set local Terraform plans. This section is a dictionary of Terraform plans and their options. The options that can be set for each plan are described below.

Option

Description

source

Local path of the Terraform plan

This section is for demonstration and development purposes only.

Caution

There is significant risk of misconfiguration when using a local Terraform plan due to the fact that Sunbeam depends heavily on the plan variables.
