# **[Using the OpenStack CLI](https://canonical.com/microstack/docs/cli)**

Once OpenStack has been deployed you can interact with your cloud via the CLI by using the standard openstack client commands. The CLI client is provided as part of the openstack snap.

The client recognises the environment variables stored in generated credential files (cloud init files). Source an init file before using the client:

source <init-file>

For help with command syntax see the documentation for the **[python-openstackclient](https://docs.openstack.org/python-openstackclient/latest/cli/command-list.html)** package.

## Unprivileged vs admin user credentials

Unprivileged user credentials are generated at cloud-configuration time with the sunbeam configure command.

Admin user credentials are generated with the sunbeam openrc command. Here, the file admin-openrc is chosen as init file:

```bash
pushd .
cd ~/src/repsys/research/m_z/virtualization/iaas/microstack
sunbeam openrc > admin-openrc
source ./admin-openrc
```
