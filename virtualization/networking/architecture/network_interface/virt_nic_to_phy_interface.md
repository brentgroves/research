# **[Virtual Networking](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/virtualization_deployment_and_administration_guide/sect-virtual_networking-directly_attaching_to_physical_interface)**

17.12. Attaching a Virtual NIC Directly to a Physical Interface
As an alternative to the default NAT connection, you can use the macvtap driver to attach the guest's NIC directly to a specified physical interface of the host machine. This is not to be confused with device assignment (also known as passthrough). Macvtap connection has the following modes, each with different benefits and usecases:
