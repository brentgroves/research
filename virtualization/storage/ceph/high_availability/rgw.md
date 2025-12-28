# use keepalived for HA for rgw

## cephadm orch

ceph orchestrator has a service that you can deploy
<https://docs.ceph.com/en/reef/cephadm/services/rgw/#high-availability-service-for-rgw>

but microceph does not use ceph orchestrator which is for more complex setups.

## microceph

For Microceph deployments use stand alone KeepAliveD for rgw HA.  RGW is nothing more than http file storage front end so normal keepalived setup will work fine.

## config

Specify all nodes that have an MDS service running in the config.
