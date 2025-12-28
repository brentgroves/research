<https://docs.ceph.com/en/reef/rados/configuration/common/#example-ceph-conf>

Note that since the Mimic release the Monitors maintain a database of option settings: the central config. Node-local ceph.conf files are still supported, but in most cases need only contain the first three lines shown below. Maintaining full ceph.conf files across cluster nodes can be tedious and prone to omission and error, especially when daemons are containerized. The below file is provided as a reference example. Clusters running recent releases are best managed primary by central config, with a minimal ceph.conf file that defines only how to reach the Monitors and thus rarely requires modification.

[global]
fsid = {cluster-id}
mon_initial_members = {hostname}[, {hostname}]
mon_host = {ip-address}[, {ip-address}]
