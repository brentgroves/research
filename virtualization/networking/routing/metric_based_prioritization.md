# netplan can i have same default route on multiple interfaces

## AI

While Netplan allows you to define default routes on multiple interfaces, having multiple default routes with the same metric is generally not recommended as it creates ambiguity for the system in determining which route to use for outbound traffic.
Understanding the implications:
Ambiguity in Routing:
.
When multiple default routes exist with identical metrics, the system's behavior regarding which route is chosen for outbound traffic can become unpredictable. This can lead to inconsistent network performance or unexpected routing decisions.

## Metric-based Prioritization

.
**Routes with lower metric values are preferred by the routing table**. If you define multiple default routes, you can assign different metric values to them to establish a preferred path and a fallback path. For instance, a lower metric on one interface makes it the primary default route, while a higher metric on another interface designates it as a secondary or backup route.

## How to configure multiple default routes with different priorities

You can achieve this by explicitly defining routes with varying metric values within your Netplan configuration:
Code

```bash
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      addresses:
        - 192.168.1.10/24
      routes:
        - to: default
          via: 192.168.1.1
          metric: 100 # Primary default route
    eth1:
      addresses:
        - 192.168.2.10/24
      routes:
        - to: default
          via: 192.168.2.1
          metric: 200 # Secondary/fallback default route
```

In this example, eth0 is configured as the primary default route due to its lower metric (100), while eth1 serves as a fallback with a higher metric (200). This setup ensures that eth0 is used for general outbound traffic, and eth1 is only utilized if eth0 becomes unavailable or for specific routing policies.
