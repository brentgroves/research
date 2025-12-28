# MAAS vs Microstack

**[Back to Research List](../../research_list.md)**\
**[Back to Current Status](../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../README.md)**

## Is MAAS the same as MicroStack

No, while closely related, Ubuntu MAAS (Metal as a Service) is not the same as MicroStack; MAAS is a tool for managing physical server infrastructure, while MicroStack is a system for deploying a fully functional OpenStack cloud environment, often utilizing MAAS as a way to provision the underlying hardware for the cloud nodes. 

## MAAS and Microstack used together

When used together, Ubuntu MAAS (Metal as a Service) acts as the bare-metal provisioning engine, automatically discovering and configuring physical servers, while MicroStack, a lightweight OpenStack distribution, leverages MAAS to deploy cloud instances on those provisioned machines, essentially creating a fully automated cloud infrastructure on your physical hardware; allowing you to easily provision and manage cloud environments using your existing physical servers. 