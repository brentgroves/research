# **[](https://docs.ceph.com/en/reef/cephadm/services/rgw/#high-availability-service-for-rgw)**

## High availability service for RGW

The ingress service allows you to create a high availability endpoint for RGW with a minimum set of configuration options. The orchestrator will deploy and manage a combination of haproxy and keepalived to provide load balancing on a floating virtual IP.

If the RGW service is configured with SSL enabled, then the ingress service will use the ssl and verify none options in the backend configuration. Trust verification is disabled because the backends are accessed by IP address instead of FQDN.

![i1](https://docs.ceph.com/en/reef/_images/HAProxy_for_RGW.svg)

There are N hosts where the ingress service is deployed. Each host has a haproxy daemon and a keepalived daemon. A virtual IP is automatically configured on only one of these hosts at a time.

Each keepalived daemon checks every few seconds whether the haproxy daemon on the same host is responding. Keepalived will also check that the master keepalived daemon is running without problems. If the “master” keepalived daemon or the active haproxy is not responding, one of the remaining keepalived daemons running in backup mode will be elected as master, and the virtual IP will be moved to that node.

The active haproxy acts like a load balancer, distributing all RGW requests between all the RGW daemons available.

## Prerequisites

An existing RGW service.

```bash
sudo microceph enable rgw --target micro13
brent@micro11:~$ sudo microceph status
MicroCeph deployment summary:
- micro11 (10.188.50.201)
  Services: mds, mgr, mon, rgw, osd
  Disks: 1
- micro12 (10.188.50.202)
  Services: mds, mgr, mon, rgw, osd
  Disks: 1
- micro13 (10.188.50.203)
  Services: mds, mgr, mon, rgw, osd
  Disks: 1
```

## Deploying

Use the command:

`ceph orch apply -i <ingress_spec_file>`

## Service specification

Service specs are YAML blocks with the following properties:

```yaml
service_type: ingress
service_id: rgw.something    # adjust to match your existing RGW service
placement:
  hosts:
    - host1
    - host2
    - host3
spec:
  backend_service: rgw.something            # adjust to match your existing RGW service
  virtual_ip: <string>/<string>             # ex: 192.168.20.1/24
  frontend_port: <integer>                  # ex: 8080
  monitor_port: <integer>                   # ex: 1967, used by haproxy for load balancer status
  virtual_interface_networks: [ ... ]       # optional: list of CIDR networks
  use_keepalived_multicast: <bool>          # optional: Default is False.
  vrrp_interface_network: <string>/<string> # optional: ex: 192.168.20.0/24
  health_check_interval: <string>           # optional: Default is 2s.
  ssl_cert: |                               # optional: SSL certificate and key
    -----BEGIN CERTIFICATE-----
    ...
    -----END CERTIFICATE-----
    -----BEGIN PRIVATE KEY-----
    ...
    -----END PRIVATE KEY-----
```
