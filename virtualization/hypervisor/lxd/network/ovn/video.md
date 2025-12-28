# **[lxd cluster and ovn](https://www.youtube.com/watch?v=1M__Rm9iZb8)**

**[the docs](https://documentation.ubuntu.com/lxd/latest/howto/network_ovn_setup/)**

  This is very helpful, thank you! Don't forget to have openvswitch installed. Below are the config strings if you want to simply cut and paste them (and replace with your IPs).

  OVN_CTL_OPTS="--db-nb-addr=SERVER1 --db-nb-create-insecure-remote=yes --db-sb-addr=SERVER1 --db-sb-create-insecure-remote=yes --db-nb-cluster-local-addr=LOCAL --db-sb-cluster-local-addr=LOCAL --ovn-northd-nb-db=tcp:SERVER1:6641,tcp:SERVER2:6641,tcp:SERVER3:6641 --ovn-northd-sb-db=tcp:SERVER1:6642,tcp:SERVER2:6642,tcp:SERVER3:6642"
