# **[](https://discuss.linuxcontainers.org/t/introducing-microcloud/15871/60?page=4)**

Not sure why im having so much trouble but i’ve purged and rebooted and still i cant get my cluster to work.

```bash
root@debian-dell:~# microcloud init
Please choose the address MicroCloud will be listening on [default=10.30.2.2]:
Scanning for eligible servers...
Press enter to end scanning for servers
 Found "debian-dell2" at "10.30.2.3"
 Found "debian-nuc" at "10.30.2.4"

Ending scan
Initializing a new cluster
 Local MicroCloud is ready
 Local MicroCeph is ready
 Local LXD is ready
Awaiting cluster formation...
```

 just gets stuck here and then timesout…

2023-02-17T10:15:56-08:00 microcloud.daemon[2956]: time="2023-02-17T10:15:56-08:00" level=warning msg="microcluster database is uninitialized"
2023-02-17T10:16:15-08:00 microcloud.daemon[2956]: time="2023-02-17T10:16:15-08:00" level=error msg="Failed to parse join token" error="Failed to parse token map: invalid character 'i' looking for beginning of value" name=debian-dell2
<< This is from another node on my network (same subnet)

Timed out waiting for a response from all cluster members
Cluster initialization is complete
Would you like to add additional local disks to MicroCeph? (yes/no) [default=yes]: Select from the available unpartitioned disks:
Space to select; Enter to confirm; Esc to exit; Type to filter results.
Up/Down to move; Right to select all; Left to select none.
       +-------------+----------------+-----------+------+----------------------------------------+
       |  LOCATION   |     MODEL      | CAPACITY  | TYPE |                  PATH                  |
       +-------------+----------------+-----------+------+----------------------------------------+
> [ ]  | debian-dell | EDGE SE847 SSD | 465.76GiB | sata | /dev/disk/by-id/wwn-0x588891410006496d |
  [ ]  | debian-dell | EDGE SE847 SSD | 465.76GiB | sata | /dev/disk/by-id/wwn-0x5888914100071325 |
       +-------------+----------------+-----------+------+----------------------------------------+

Error: Failed to confirm disk selection: Failed to confirm selection: interrupt
<< and this is from where i run microcloud init… its almost as if it cant reach out to the other nodes.?

UPDATE:
for some reason after on debian it is necessary to do a snap restart microcloud before init … if you keep seeing an error in snap log microcloud from parsing tokens then just keep doing snap restart microcloud until the only debug error is that database has not been initialized… it works after …

```bash
lsb_release -r
sudo tail -f /var/log/syslog
sudo snap services
Service                          Startup   Current   Notes
lxd.activate                     enabled   inactive  -
lxd.daemon                       enabled   active    socket-activated
lxd.user-daemon                  enabled   inactive  socket-activated
microceph.daemon                 enabled   active    -
microceph.mds                    enabled   active    -
microceph.mgr                    enabled   active    -
microceph.mon                    enabled   active    -
microceph.osd                    enabled   active    -
microceph.rbd-mirror             disabled  inactive  -
microceph.rgw                    disabled  inactive  -
microcloud.daemon                enabled   active    -
microovn.chassis                 enabled   active    -
microovn.daemon                  enabled   active    -
microovn.ovn-northd              enabled   active    -
microovn.ovn-ovsdb-server-nb     enabled   active    -
microovn.ovn-ovsdb-server-sb     enabled   active    -
microovn.refresh-expiring-certs  enabled   inactive  timer-activated
microovn.switch                  enabled   active    -
```

Summary of issues and solutions:

If while executing “microclound init” it failed with Timed out waiting for a response from all cluster members and one or more of the nodes failed to handle and/or parse the join token (see the errors I got in the previous comment), cancel the current execution, wipe out all snaps on all nodes, and run again, eventually it will succeed.
To wipe out, I executed what nkrapf suggested:
snap stop microcloud microceph lxd && snap disable microcloud && snap disable microceph && snap disable lxd && snap remove --purge microcloud && snap remove --purge microceph && snap remove --purge lxd

If you are using qemu-kvm VMs, and the additional disks attached to the VMs has a disk bus of virtio, then during adding the disks to ceph, there will be an issue that the path to the disks will be unknown or there is some issue there, so there is no path to the disks appearing
/dev/disk/by-id/
to overcome this issue, wipe out all snaps on all nodes as mentioned in point 1, re-add the disks to the VMs but choose SCSI as the bus type and run microclound again, eventually it should succeed.

If you are experiencing timeouts waiting for the cluster to form, the key is to go to each node in the cluster and keep issuing “snap restart microcloud” until you no longer see the error in the logs about parsing tokens. Once all the nodes no longer present that error, initiate the “microcloud init”.

Hmm, no, that’s an odd one.
I’d suggest looking at snap services and systemctl --failed on that initial system.

The error suggests that the microcloud daemon isn’t running.

`sudo journalctl -u snap.microcloud.daemon -n 300`

```bash
sudo journalctl -u snap.microcloud.daemon -n 300
Jul 07 21:22:34 micro13 systemd[1]: Started snap.microcloud.daemon.service - Service for snap application microcloud.daemon.
Jul 07 21:22:35 micro13 microcloud.daemon[15196]: time="2025-07-07T21:22:35Z" level=warning msg="microcluster database is uninitialized"
```

```bash
sudo snap logs microcloud
2025-07-07T21:22:34Z systemd[1]: Started snap.microcloud.daemon.service - Service for snap application microcloud.daemon.
2025-07-07T21:22:35Z microcloud.daemon[15196]: time="2025-07-07T21:22:35Z" level=warning msg="microcluster database is uninitialized"
```

<https://www.youtube.com/watch?v=iWZYUU8lX5A>

Maybe @mionaalex can update on progress, but the plan was to allow for MicroCloud to create Kubernetes clusters by spawning LXD VMs and then having those run microk8s.

So in the initial MicroCloud there was no relation with microk8s, but as that evolved, Kubernetes was meant to be added and that would be done by deploying microk8s inside of VMs.
