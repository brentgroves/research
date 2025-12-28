# **[Configuring Networks](https://documentation.ubuntu.com/server/explanation/networking/configuring-networks/)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

Network configuration on Ubuntu is handled through Netplan, which provides a high-level, distribution-agnostic way to define how the network on your system should be set up via a YAML configuration file.

While Netplan is a configuration abstraction renderer that covers all aspects of network configuration, here we will outline the underlying system elements like IP addresses, ethernet devices, name resolution and so on. We will refer to the related Netplan settings where appropriate, but we do recommend studying the **[Netplan documentation](https://netplan.readthedocs.io/en/stable/)** in general.
