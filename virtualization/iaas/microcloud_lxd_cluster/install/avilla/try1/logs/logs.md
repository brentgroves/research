# **[](https://canonical-microovn.readthedocs-hosted.com/en/latest/how-to/logs/)**

Accessing logs
The MicroOVN services provide logs as part of their normal operation.

By default they are provided through the systemd journal, and can be accessed through the use of the journalctl or snap logs commands.

This is how you can access the logs of the microovn.chassis service using the snap logs command:

```bash
sudo snap logs microovn.chassis
2025-07-10T22:20:19Z ovn-controller[26912]: ovs|00102|rconn|INFO|unix:/var/snap/microovn/common/run/switch//br-int.mgmt: connected
2025-07-10T22:20:19Z ovn-controller[26912]: ovs|00103|main|INFO|OVS OpenFlow connection reconnected,force recompute.
2025-07-10T22:20:19Z ovn-controller[26912]: ovs|00104|rconn|INFO|unix:/var/snap/microovn/common/run/switch//br-int.mgmt: connected
2025-07-10T22:20:19Z ovn-controller[26912]: ovs|00105|main|INFO|OVS feature set changed, force recompute.
2025-07-10T22:20:19Z ovn-controller[26912]: ovs|00001|pinctrl(ovn_pinctrl0)|INFO|unix:/var/snap/microovn/common/run/switch//br-int.mgmt: connecting to switch
2025-07-10T22:20:19Z ovn-controller[26912]: ovs|00002|rconn(ovn_pinctrl0)|INFO|unix:/var/snap/microovn/common/run/switch//br-int.mgmt: connecting...
2025-07-10T22:20:19Z ovn-controller[26912]: ovs|00001|statctrl(ovn_statctrl2)|INFO|unix:/var/snap/microovn/common/run/switch//br-int.mgmt: connecting to switch
2025-07-10T22:20:19Z ovn-controller[26912]: ovs|00002|rconn(ovn_statctrl2)|INFO|unix:/var/snap/microovn/common/run/switch//br-int.mgmt: connecting...
2025-07-10T22:20:19Z ovn-controller[26912]: ovs|00003|rconn(ovn_pinctrl0)|INFO|unix:/var/snap/microovn/common/run/switch//br-int.mgmt: connected
2025-07-10T22:20:19Z ovn-controller[26912]: ovs|00003|rconn(ovn_statctrl2)|INFO|unix:/var/snap/microovn/common/run/switch//br-int.mgmt: connected
```

and using the journalctl command:

```bash
journalctl -u snap.microovn.chassis
Jul 10 22:15:25 micro13 systemd[1]: Started snap.microovn.chassis.service - Service for snap application microovn.chassis.
Jul 10 22:15:25 micro13 microovn.chassis[26682]: + . /snap/microovn/667/ovn.env
Jul 10 22:15:25 micro13 microovn.chassis[26682]: + runtime_env=/var/snap/microovn/common/data/env/ovn.env
Jul 10 22:15:25 micro13 microovn.chassis[26682]: + [ -r /var/snap/microovn/common/data/env/ovn.env ]
Jul 10 22:15:25 micro13 microovn.chassis[26682]: + . /var/snap/microovn/common/data/env/ovn.env
Jul 10 22:15:25 micro13 microovn.chassis[26682]: + OVN_INITIAL_NB=10.188.50.201
Jul 10 22:15:25 micro13 microovn.chassis[26682]: + OVN_INITIAL_SB=10.188.50.201
Jul 10 22:15:25 micro13 microovn.chassis[26682]: + OVN_NB_CONNECT=ssl:10.188.50.201:6641,ssl:10.188.50.203:6641
Jul 10 22:15:25 micro13 microovn.chassis[26682]: + OVN_SB_CONNECT=ssl:10.188.50.201:6642,ssl:10.188.50.203:6642
Jul 10 22:15:25 micro13 microovn.chassis[26682]: + OVN_LOCAL_IP=10.188.50.203
Jul 10 22:15:25 micro13 microovn.chassis[26682]: + export OVN_PKI_DIR=/var/snap/microovn/common/data/pki
Jul 10 22:15:25 micro13 microovn.chassis[26682]: + export CA_CERT=/var/snap/microovn/common/data/pki/cacert.pem
Jul 10 22:15:25 micro13 microovn.chassis[26682]: + export OVN_RUNDIR=/var/snap/microovn/common/run/ovn/
Jul 10 22:15:25 micro13 microovn.chassis[26682]: + export OVN_NB_DB=ssl:10.188.50.201:6641,ssl:10.188.50.203:6641
Jul 10 22:15:25 micro13 microovn.chassis[26682]: + export OVN_SB_DB=ssl:10.188.50.201:6642,ssl:10.188.50.203:6642
Jul 10 22:15:25 micro13 microovn.chassis[26682]: + export OVS_RUNDIR=/var/snap/microovn/common/run/switch/
Jul 10 22:15:25 micro13 microovn.chassis[26682]: + export OVN_DBDIR=/var/snap/microovn/common/data/central/db
```

This is how you can view a live log display for the same service using the snap logs command:

snap logs -f microovn.chassis
and using the journalctl command:

```bash
journalctl -f -u snap.microovn.chassis
Jul 10 22:20:19 micro13 ovn-controller[26912]: ovs|00102|rconn|INFO|unix:/var/snap/microovn/common/run/switch//br-int.mgmt: connected
Jul 10 22:20:19 micro13 ovn-controller[26912]: ovs|00103|main|INFO|OVS OpenFlow connection reconnected,force recompute.
Jul 10 22:20:19 micro13 ovn-controller[26912]: ovs|00104|rconn|INFO|unix:/var/snap/microovn/common/run/switch//br-int.mgmt: connected
Jul 10 22:20:19 micro13 ovn-controller[26912]: ovs|00105|main|INFO|OVS feature set changed, force recompute.
Jul 10 22:20:19 micro13 ovn-controller[26912]: ovs|00001|pinctrl(ovn_pinctrl0)|INFO|unix:/var/snap/microovn/common/run/switch//br-int.mgmt: connecting to switch
Jul 10 22:20:19 micro13 ovn-controller[26912]: ovs|00002|rconn(ovn_pinctrl0)|INFO|unix:/var/snap/microovn/common/run/switch//br-int.mgmt: connecting...
Jul 10 22:20:19 micro13 ovn-controller[26912]: ovs|00001|statctrl(ovn_statctrl2)|INFO|unix:/var/snap/microovn/common/run/switch//br-int.mgmt: connecting to switch
Jul 10 22:20:19 micro13 ovn-controller[26912]: ovs|00002|rconn(ovn_statctrl2)|INFO|unix:/var/snap/microovn/common/run/switch//br-int.mgmt: connecting...
Jul 10 22:20:19 micro13 ovn-controller[26912]: ovs|00003|rconn(ovn_pinctrl0)|INFO|unix:/var/snap/microovn/common/run/switch//br-int.mgmt: connected
Jul 10 22:20:19 micro13 ovn-controller[26912]: ovs|00003|rconn(ovn_statctrl2)|INFO|unix:/var/snap/microovn/common/run/switch//br-int.mgmt: connected
```

```bash
ovn-nbctl pg-list
ovn-nbctl pg-list
2025-07-11T21:07:38Z|00001|stream_ssl|ERR|SSL_use_certificate_file: error:8000000D:system library::Permission denied
2025-07-11T21:07:38Z|00002|stream_ssl|ERR|SSL_use_PrivateKey_file: error:10080002:BIO routines::system lib
2025-07-11T21:07:38Z|00003|stream_ssl|ERR|failed to load client certificates from /var/snap/microovn/common/data/pki/cacert.pem: error:0A080002:SSL routines::system lib
ovn-nbctl: unknown command 'pg-list'; use --help for help

sudo lxc cluster list

sudo lxd cluster list-database
+--------------------+
|      ADDRESS       |
+--------------------+
| 10.188.50.201:8443 |
+--------------------+
| 10.188.50.203:8443 |
+--------------------+
| 10.188.50.202:8443 |
+--------------------+

Make sure that the LXD daemon is not running on the machine. For example, if you’re using the snap:

sudo snap stop lxd

sudo snap logs lxd
2025-07-10T21:51:28Z lxd.daemon[25051]: => First LXD execution on this system
2025-07-10T21:51:28Z lxd.daemon[25051]: => LXD is ready
2025-07-10T22:15:32Z lxd.daemon[25295]: time="2025-07-10T22:15:32Z" level=warning msg="Dqlite last entry" index=0 term=0
2025-07-10T22:15:32Z lxd.daemon[25295]: time="2025-07-10T22:15:32Z" level=warning msg="Dqlite: attempt 1: server 10.188.50.203:8443: no known leader"
2025-07-10T22:15:32Z lxd.daemon[25295]: time="2025-07-10T22:15:32Z" level=warning msg="Dqlite: attempt 1: server 10.188.50.203:8443: no known leader"
2025-07-10T22:15:32Z lxd.daemon[25295]: time="2025-07-10T22:15:32Z" level=error msg="No active cluster event listener clients" local="10.188.50.203:8443"
2025-07-10T22:15:32Z lxd.daemon[25295]: time="2025-07-10T22:15:32Z" level=error msg="No active cluster event listener clients" local="10.188.50.203:8443"
2025-07-10T22:15:39Z lxd.daemon[25295]: time="2025-07-10T22:15:39Z" level=warning msg="Time skew detected between leader and local" leaderTime="2025-07-10 22:10:49.835282013 +0000 UTC" localTime="2025-07-10 22:15:39.666499196 +0000 UTC"
2025-07-10T22:15:53Z lxd.daemon[25295]: time="2025-07-10T22:15:53Z" level=warning msg="Time skew resolved"
2025-07-10T22:16:02Z lxd.daemon[25295]: time="2025-07-10T22:16:02Z" level=warning msg="Time skew detected between leader and local" leaderTime="2025-07-10 22:11:12.907921356 +0000 UTC" localTime="2025-07-10 22:16:02.738594281 +0000 UTC"

sudo snap logs lxd
[sudo] password for brent: 
Sorry, try again.
[sudo] password for brent: 
2025-07-10T21:43:00Z lxd.daemon[25741]: - loadavg_daemon
2025-07-10T21:43:00Z lxd.daemon[25741]: - pidfds
2025-07-10T21:43:01Z lxd.daemon[25485]: => Starting LXD
2025-07-10T21:43:03Z lxd.daemon[25752]: time="2025-07-10T21:43:03Z" level=warning msg=" - Couldn't find the CGroup network priority controller, per-instance network priority will be ignored. Please use per-device limits.priority instead"
2025-07-10T21:43:10Z lxd.daemon[25485]: => First LXD execution on this system
2025-07-10T21:43:10Z lxd.daemon[25485]: => LXD is ready
2025-07-10T22:10:27Z lxd.daemon[25752]: time="2025-07-10T22:10:27Z" level=error msg="Failed to get leader cluster member address" err="Failed to get the address of the cluster leader: Server is not clustered"
2025-07-10T22:10:27Z lxd.daemon[25752]: time="2025-07-10T22:10:27Z" level=error msg="Failed to get leader cluster member address" err="Failed to get the address of the cluster leader: Server is not clustered"
2025-07-10T22:10:27Z lxd.daemon[25752]: time="2025-07-10T22:10:27Z" level=warning msg="Dqlite last entry" index=0 term=0
2025-07-10T22:10:42Z lxd.daemon[25752]: time="2025-07-10T22:10:42Z" level=warning msg="Time skew detected between leader and local" leaderTime="2025-07-10 22:15:32.780058528 +0000 UTC" localTime="2025-07-10 22:10:42.978249842 +0000 UTC"
```
