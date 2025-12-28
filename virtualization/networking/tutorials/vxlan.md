# **[vxlan](https://info.support.huawei.com/info-finder/encyclopedia/en/VXLAN.html)**

## What Is VXLAN?

VXLAN, or Virtual Extensible LAN, is a network virtualization technology widely used on large Layer 2 networks. VXLAN establishes a logical tunnel between the source and destination network devices, through which it uses MAC-in-UDP encapsulation for packets. Specifically, it encapsulates original Ethernet frames sent by a VM into UDP packets. It then encapsulates the UDP packets with the IP header and Ethernet header of the physical network as outer headers, enabling these packets to be routed across the network like common IP packets. This frees VMs on the Layer 2 network from the structural limitations of the Layer 2 and Layer 3 networks.

## Why Do We Need VXLAN?

Why do we need VXLAN? Under the trend of server virtualization, dynamic VM migration occurs, which requires IP addresses and MAC addresses to remain unchanged before and after migration. Server virtualization also leads to a sharp increase in the number of tenants, which the network needs to effectively isolate.

## Dynamic VM Migration

Traditional server virtualization works by virtualizing a physical server into multiple logical servers known as VMs. Server virtualization is an effective way of improving server efficiency while reducing energy consumption and operational costs. Such advantages account for its wide use.

Since server virtualization was widely adopted, dynamic VM migration has become increasingly common. To ensure service continuity during the migration of a VM, the VM's IP address and running status (for example, the TCP session status) must remain unchanged. Therefore, VMs can only be dynamically migrated in the same Layer 2 domain.

As shown in the following figure, the traditional three-layer network architecture limits the dynamic VM migration scope. VMs can only migrate within a limited scope, greatly restricting application.

![](https://download.huawei.com/mdl/image/download?uuid=6c2bfcc95aad464eae0f94cfe63be4da)

Traditional three-layer network architecture limiting the dynamic VM migration scope
To enable smooth VM migration over a large scope or even between regions, all involved servers must be deployed in a large Layer 2 domain.

A Layer 2 switch can support Layer 2 communication between servers connected to the switch. When a server is migrated from one port of the Layer 2 switch to another port, the IP address of the server can remain unchanged. This meets the requirements for dynamic VM migration. It is this concept that inspired the design of VXLAN.

VXLAN provides a methodology for creating a virtual tunnel on the IP network to transparently forward user data when communication is required between a source and destination node on the IP network. Any two nodes can communicate through a VXLAN tunnel, regardless of the underlying network structure and other details. For servers, VXLAN virtualizes the entire infrastructure network into a large "Layer 2 virtual switch", with all servers connecting to this switch. Servers do not need to be aware of how data is forwarded within this "large switch".

## What Are the Differences Between VXLAN and VLAN?

VLAN is a traditional network isolation technology. According to standards, a VLAN network supports a maximum of about 4000 VLANs, failing to meet the requirement for tenant isolation on a large Layer 2 network. In addition, each VLAN is a small and fixed Layer 2 domain, and as such is not suitable for large-scale dynamic VM migration.

VXLAN overcomes these shortfalls of VLAN. In terms of scale, VXLAN uses the 24-bit VNI field to identify up to 16M tenants, far higher than that supported by VLAN (about 4000 tenants). And in terms of flexible migration, VXLAN establishes a virtual tunnel between two switches across the underlying IP network and virtualizes the network into a large "Layer 2 switch" (large Layer 2 network) to meet the requirement for large-scale dynamic VM migration.

Although VXLAN is an extension to VLAN, VXLAN is quite different from VLAN in terms of virtual tunnel establishment.

The following describes what the VXLAN packet looks like.

![](https://download.huawei.com/mdl/image/download?uuid=1cd20c35cbbb4f079e7b3540759924a8)
