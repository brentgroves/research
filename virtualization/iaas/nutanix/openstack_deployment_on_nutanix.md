# **[OpenStack Deployment on Nutanix](https://technosfr.weebly.com/openstack-deployment-on-nutanix.html)

## OpenStack deployment on Nutanix

​
OpenStack deployment is by far one of the easiest OpenStack deployments that you will ever do. It takes less than 15 minutes to have the OpenStack setup up and running.
Pre Requisites
Nutanix Cluster running Acropolis Hypervisor
Nutanix OVM image for OpenStack downloaded from Nutanix Support Portal which is available in the below location.
Downloads-> Tools & Firmware ->

![Picture](https://technosfr.weebly.com/uploads/7/9/0/3/79032276/5570366_orig.jpg)**

​You add Nutanix clusters to the datacenter by adding the OpenStack controller and the Nutanix clusters
to the Nutanix OVM. The Nutanix OVM can run either on a Nutanix cluster or elsewhere in the datacenter.
Nutanix OVM can be run in “All in one mode” or “Driver only mode”

## All-In-One Mode

You use the OpenStack controller that is included in the Nutanix OVM to manage the Nutanix
clusters. The Nutanix OVM runs all the OpenStack services and the Acropolis OpenStack drivers.

## Driver-Only Mode

You use a remote OpenStack controller to manage the Nutanix clusters, and the Nutanix OVM
includes only the Acropolis OpenStack drivers.

![pic2](https://technosfr.weebly.com/uploads/7/9/0/3/79032276/5522273_orig.jpg)

## ​The Architecture of the Nutanix Integration with Open Stack

![pic3](https://technosfr.weebly.com/uploads/7/9/0/3/79032276/3730734_orig.jpg)

## Installation and Configuration

Uploading the Nutanix OVM Image to a Container on a Nutanix Cluster
If you want to create the Nutanix OVM on a Nutanix cluster, you can use Image Service to upload the Nutanix OVM image to a container on the cluster.
To upload the Nutanix OVM to a container on the Nutanix cluster, do the following:

1. Log on to the web console with the Nutanix credentials.
2. Click the gear icon at the top-right corner, and then click Image Configuration.
3. Click Upload Image.
4. In the Create Image dialog box, do the following:
           a. Click the Upload a file option, and then click Choose File.
           b. Browse to the Nutanix OVM image and click Open.
5. Click Save.

## Creating a Nutanix OVM

Create a VM on the Acropolis Cluster using Prism with the following settings.

- 4 vCPU, 2 Cores each
- 16GB RAM
- SCSI Disk with the Nutanix OVM image mounted using “Clone from Image Service”
- NIC attached to any VLAN

... Next steps
