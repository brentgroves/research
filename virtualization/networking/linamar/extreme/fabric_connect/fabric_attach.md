# **[Fabric Attach](https://extr-p-001.sitecorecontenthub.cloud/api/public/content/acf6e2bce58145a8a27297fa312b1e39?v=6f32aef2&download=true#:~:text=The%20FA%20Server%20is%20responsible%20for%20processing,to%20bind%20VLANs%20to%20Fabric%20Connect%20I%2DSIDs.)**

**[Back to Research List](../../../../`research_list.md)**\
**[Back to Current Status](../../../../../a_status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

## referenences

**[](https://extr-p-001.sitecorecontenthub.cloud/api/public/content/acf6e2bce58145a8a27297fa312b1e39?v=6f32aef2&download=true#:~:text=The%20FA%20Server%20is%20responsible%20for%20processing,to%20bind%20VLANs%20to%20Fabric%20Connect%20I%2DSIDs.)**
- **[Extreme Fabric Attach: Zero-Touch User and Device Attachment to Extreme’s Fabric Connect Services](https://www.extremenetworks.com/resources/at-a-glance/extreme-fabric-attach-zero-touch-user-and-device-attachment-to-extremes-fabric-connect-services#:~:text=Enter%20Fabric%20Attach,appropriate%20virtualized%20Fabric%20Connect%20service.)**

- **[Fabric Attach Network Automation](https://www.extremenetworks.com/resources/white-paper/fabric-attach-network-automation#:~:text=Extreme%20Fabric%20Attach%20(FA)%20extends,%2C%20IP%20Camera%2C%20etc.)**

**Fabric attach** is a networking technology that extends Fabric Connect functionality to network elements or hosts that aren't Fabric Connect-capable. It automates the connection of devices to a Fabric Connect environment, simplifying the process of provisioning and mapping devices to virtualized services. Essentially, it bridges the gap between Fabric Connect and non-Fabric Connect devices, making it easier to integrate them into a network fabric. 
Here's a more detailed breakdown:

## Purpose:

Fabric Attach allows you to extend the benefits of Fabric Connect, such as automation and service provisioning, to devices that don't natively support it. 

## Benefits:

- Automation: It automates the process of connecting non-Fabric devices to the fabric, reducing manual configuration efforts. 
- Reduced time-to-service: It speeds up the process of adding new services or modifying existing ones. 
- Simplified management: It simplifies the management of a diverse network environment by allowing non-Fabric devices to participate in the fabric's capabilities. 

## Example:

Imagine a network with a mixture of Fabric Connect-capable switches and non-Fabric Connect wireless access points. Fabric Attach can be used to automatically connect the access points to the appropriate Fabric Connect service, enabling them to participate in features like virtualized VLANs and policy enforcement. 

Extreme Fabric Attach:
Extreme Networks uses "Extreme Fabric Attach" as its term for a similar technology, which also automates the connection of non-Fabric devices to Fabric Connect services. 

## Key components involved in Fabric Attach:
- FA Server: The central authority that manages Fabric Attach mappings and service provisioning. 
- FA Clients: Devices that request Fabric Attach assignments from the FA Server. 
- FA Proxies: Devices that forward Fabric Attach requests on behalf of other devices. 