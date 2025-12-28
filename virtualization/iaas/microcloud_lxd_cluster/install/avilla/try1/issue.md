
Oh wait there's a big problem, you're using latest/stable of microcloud, thats not been updated for months and is known broken currently (this is pre-release software as 1.0 isnt out yet).

Can you try with latest/edge of microcloud please.

`Yep, that worked. Thank you so much!`

So I redid the whole process: remove old LXD snap, install LXD, restart LXD, run sudo microcloud init. As far as I can tell from the LXD snap logs, all the LXD members had a => Detected MicroOVN log line, therefore this should mean all of them do detect microOVN. Problem still persists, I get the same error.

Initializing new services
 Local MicroCloud is ready
 Local MicroOVN is ready
 Local MicroCeph is ready
 Local LXD is ready
Awaiting cluster formation ...
 Peer "micro13" has joined the cluster
 Peer "micro12" has joined the cluster

 Error: Failed to notify peer micro13 at 10.188.50.203:8443: Failed getting port group UUID for network "default" setup: Failed to run: ovn-nbctl --timeout=10 --db ssl:10.188.50.201:6641,ssl:10.188.50.203:6641,ssl:10.188.50.202:6641 -c /proc/self/fd/3 -p /proc/self/fd/4 -C /proc/self/fd/5 --wait=sb --format=csv --no-headings --data=bare --colum=_uuid,name,acl find port_group name=lxd_net2: exit status 1 (2025-07-10T22:16:17Z|00001|stream_ssl|WARN|SSL_read: error:0A000412:SSL routines::sslv3 alert bad certificate
2025-07-10T22:16:17Z|00002|jsonrpc|WARN|ssl:10.188.50.201:6641: receive error: Input/output error
2025-07-10T22:16:17Z|00003|reconnect|WARN|ssl:10.188.50.201:6641: connection dropped (Input/output error)
ovn-nbctl: ssl:10.188.50.201:6641,ssl:10.188.50.203:6641,ssl:10.188.50.202:6641: database connection failed (Connection refused))

Failed to run: ovn-nbctl sslv3 alert bad certificate

Fails to finish setting up OVN network (ovn-nbctl: database ...

GitHub
<https://github.com> › canonical › microcloud › issues

<https://github.com/canonical/microcloud/issues/175>

From cursory view:

Error: Failed to run: ovn-nbctl --timeout=10 --db tcp:10.8.16.251:6641,tcp:10.8.16.224:6641,tcp:10.8.16.223:6641 --wait=sb ha-chassis-group-add lxd-net2: exit status 1 (ovn-nbctl: tcp:10.8.16.251:6641,tcp:10.8.16.224:6641,tcp:10.8.16.223:6641: database connection failed (End of file))

## answer 1

That message indicates to me that LXD thinks it should use OVN from the system and not from the MicroOVN snap. MicroOVN uses TLS by default and provides ssl:x.x.x.x:nnnn values in the connection string provided in its environment file.

Does it help to install/restart LXD as the last snap to ensure it detects the presence of MicroOVN?

## answer 2

Interestingly I'm getting this behaviour inconsistently without changing anything on LXD when launching instances.

Nevermind, the issue I was seeing is something else. I too would advise trying to install the LXD snap last, or ensuring that you restart the snap before calling microcloud init.

## response 1

Thanks for your responses! I'm pretty sure I installed LXD last (had to reinstall it to get the latest version), and even issued a restart before microcloud init. Will retry the process and get back with results.

## answer 4

Yes this sounds like at least one of the LXD members has not detected MicroOVN is installed and is still trying to use the host OVN.

We are planning to add a snap content interface to MicroOVN that will allow LXD to be notified when its installed and will reconfigure itself. We had an earlier attempt of this here canonical/microovn#76 but @masnax is planning to open a new PR since we've gained experience on how to do this with the MicroCeph snap (which had the same issue with LXD).

<https://discuss.linuxcontainers.org/t/ovn-cluster-ovn-nbctl-6641-database-connection-failed-connection-refused/22058>

<https://mail.openvswitch.org/pipermail/ovs-discuss/2021-November/051606.html>

openssl version
OpenSSL 3.0.13 30 Jan 2024 (Library: OpenSSL 3.0.13 30 Jan 2024)

```bash
2023-10-05T12:52:27Z systemd[1]: Starting Service for snap application lxd.activate...
2023-10-05T12:52:28Z lxd.activate[2683]: => Starting LXD activation
2023-10-05T12:52:28Z lxd.activate[2683]: ==> Creating missing snap configuration
2023-10-05T12:52:28Z lxd.activate[2683]: ==> Loading snap configuration
2023-10-05T12:52:28Z lxd.activate[2683]: ==> Checking for socket activation support
2023-10-05T12:52:28Z lxd.activate[2683]: ==> Setting LXD socket ownership
2023-10-05T12:52:28Z lxd.activate[2683]: ==> Setting LXD user socket ownership
2023-10-05T12:52:28Z lxd.activate[2683]: ==> LXD never started on this system, no need to start it now
2023-10-05T12:52:28Z systemd[1]: snap.lxd.activate.service: Deactivated successfully.
2023-10-05T12:52:28Z systemd[1]: Finished Service for snap application lxd.activate.
2023-10-05T12:52:58Z systemd[1]: Starting Service for snap application lxd.activate...
2023-10-05T12:52:58Z lxd.activate[3219]: => Starting LXD activation
2023-10-05T12:52:58Z lxd.activate[3219]: ==> Loading snap configuration
2023-10-05T12:52:58Z lxd.activate[3219]: ==> Checking for socket activation support
2023-10-05T12:52:58Z lxd.activate[3219]: ==> Setting LXD socket ownership
2023-10-05T12:52:58Z lxd.activate[3219]: ==> Setting LXD user socket ownership
2023-10-05T12:52:58Z lxd.activate[3219]: ==> LXD never started on this system, no need to start it now
2023-10-05T12:52:58Z systemd[1]: snap.lxd.activate.service: Deactivated successfully.
2023-10-05T12:52:58Z systemd[1]: Finished Service for snap application lxd.activate.
2023-10-05T12:52:58Z systemd[1]: Started Service for snap application lxd.daemon.
2023-10-05T12:52:58Z systemd[1]: Started Service for snap application lxd.user-daemon.
2023-10-05T12:52:59Z lxd.daemon[3285]: => Preparing the system (25846)
2023-10-05T12:52:59Z lxd.daemon[3285]: ==> Loading snap configuration
2023-10-05T12:52:59Z lxd.daemon[3285]: ==> Creating /var/snap/lxd/common/lxd/logs
2023-10-05T12:52:59Z lxd.daemon[3285]: ==> Creating /var/snap/lxd/common/global-conf
2023-10-05T12:52:59Z lxd.daemon[3285]: ==> Setting up mntns symlink (mnt:[4026532480])
2023-10-05T12:52:59Z lxd.daemon[3285]: ==> Setting up mount propagation on /var/snap/lxd/common/lxd/storage-pools
2023-10-05T12:52:59Z lxd.daemon[3285]: ==> Setting up mount propagation on /var/snap/lxd/common/lxd/devices
2023-10-05T12:52:59Z lxd.daemon[3285]: ==> Setting up persistent shmounts path
2023-10-05T12:52:59Z lxd.daemon[3285]: ====> Making LXD shmounts use the persistent path
2023-10-05T12:52:59Z lxd.daemon[3285]: ====> Making LXCFS use the persistent path
2023-10-05T12:52:59Z lxd.daemon[3285]: ==> Setting up kmod wrapper
2023-10-05T12:52:59Z lxd.daemon[3285]: ==> Preparing /boot
2023-10-05T12:52:59Z lxd.daemon[3285]: ==> Preparing a clean copy of /run
2023-10-05T12:52:59Z lxd.daemon[3285]: ==> Preparing /run/bin
2023-10-05T12:52:59Z lxd.daemon[3285]: ==> Preparing a clean copy of /etc
2023-10-05T12:53:00Z lxd.daemon[3285]: ==> Preparing a clean copy of /usr/share/misc
2023-10-05T12:53:00Z lxd.daemon[3285]: ==> Setting up ceph configuration
2023-10-05T12:53:00Z lxd.daemon[3285]: ==> Setting up LVM configuration
2023-10-05T12:53:00Z lxd.daemon[3285]: ==> Setting up OVN configuration
2023-10-05T12:53:00Z lxd.daemon[3285]: => Detected MicroOVN
2023-10-05T12:53:00Z lxd.daemon[3285]: ==> Rotating logs
2023-10-05T12:53:00Z lxd.daemon[3285]: ==> Setting up ZFS (2.1)
2023-10-05T12:53:00Z lxd.daemon[3285]: ==> Escaping the systemd cgroups
2023-10-05T12:53:00Z lxd.daemon[3285]: ====> Detected cgroup V2
2023-10-05T12:53:00Z lxd.daemon[3285]: ==> Escaping the systemd process resource limits
2023-10-05T12:53:00Z lxd.daemon[3285]: ==> Exposing LXD documentation
2023-10-05T12:53:00Z lxd.daemon[3285]: ==> Disabling shiftfs on this kernel (auto)
2023-10-05T12:53:00Z lxd.daemon[3285]: => Starting LXCFS
2023-10-05T12:53:00Z lxd.daemon[3493]: Running constructor lxcfs_init to reload liblxcfs
2023-10-05T12:53:00Z lxd.daemon[3493]: mount namespace: 5
2023-10-05T12:53:00Z lxd.daemon[3493]: hierarchies:
2023-10-05T12:53:00Z lxd.daemon[3493]:   0: fd:   6: cpuset,cpu,io,memory,hugetlb,pids,rdma,misc
2023-10-05T12:53:00Z lxd.daemon[3493]: Kernel supports pidfds
2023-10-05T12:53:00Z lxd.daemon[3493]: Kernel does not support swap accounting
2023-10-05T12:53:00Z lxd.daemon[3493]: api_extensions:
2023-10-05T12:53:00Z lxd.daemon[3493]: - cgroups
2023-10-05T12:53:00Z lxd.daemon[3493]: - sys_cpu_online
2023-10-05T12:53:00Z lxd.daemon[3493]: - proc_cpuinfo
2023-10-05T12:53:00Z lxd.daemon[3493]: - proc_diskstats
2023-10-05T12:53:00Z lxd.daemon[3493]: - proc_loadavg
2023-10-05T12:53:00Z lxd.daemon[3493]: - proc_meminfo
2023-10-05T12:53:00Z lxd.daemon[3493]: - proc_stat
2023-10-05T12:53:00Z lxd.daemon[3493]: - proc_swaps
2023-10-05T12:53:00Z lxd.daemon[3493]: - proc_uptime
2023-10-05T12:53:00Z lxd.daemon[3493]: - proc_slabinfo
2023-10-05T12:53:00Z lxd.daemon[3493]: - shared_pidns
2023-10-05T12:53:00Z lxd.daemon[3493]: - cpuview_daemon
2023-10-05T12:53:00Z lxd.daemon[3493]: - loadavg_daemon
2023-10-05T12:53:00Z lxd.daemon[3493]: - pidfds
2023-10-05T12:53:01Z lxd.daemon[3285]: => Starting LXD
2023-10-05T12:53:04Z lxd.daemon[3505]: time="2023-10-05T12:53:04Z" level=warning msg=" - Couldn't find the CGroup network priority controller, network priority will be ignored"
2023-10-05T12:53:07Z lxd.user-daemon[3295]: time="2023-10-05T12:53:07Z" level=info msg="Performing initial LXD configuration"
2023-10-05T12:53:08Z lxd.daemon[3285]: => First LXD execution on this system
2023-10-05T12:53:08Z lxd.daemon[3285]: => LXD is ready
2023-10-05T12:53:11Z lxd.user-daemon[3295]: time="2023-10-05T12:53:11Z" level=info msg="Starting up the server"
2023-10-05T12:53:46Z systemd[1]: snap.lxd.user-daemon.service: Deactivated successfully.
```
