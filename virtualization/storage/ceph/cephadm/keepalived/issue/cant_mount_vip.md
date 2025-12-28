can not mount cephfs with a virtual ip

<https://docs.ceph.com/en/octopus/man/8/mount.ceph/>

AI Overview
The failure to mount CephFS with a virtual IP (VIP) is typically due to a networking or cluster configuration issue, not a fundamental incompatibility. CephFS clients can be directed to multiple Ceph monitors (MONs), and a VIP can serve as a single, stable endpoint for this purpose.
Here are the most common reasons why a mount might fail and how to troubleshoot them.
Common causes for mount failures

1. VIP configuration is incorrect
A Ceph client mounting via the kernel driver or FUSE must be able to reach at least one Ceph Monitor. If the VIP is not correctly configured for high availability (HA) and fails over between your monitor nodes, the mount may fail.
Action: Ensure your VIP is correctly configured using a solution like keepalived or pacemaker and that it is active on a healthy monitor node. Test connectivity by pinging the VIP from your client.

2. Firewall is blocking traffic
The client might not be able to connect to the monitors due to firewall rules on the monitor hosts or the client itself.
Action: Verify that the necessary Ceph ports are open. By default, these are 6789 for the v1 protocol and 3300 for the v2 protocol. You can use nmap or telnet from the client to check if the ports are open on the VIP (nmap <VIP> -p 6789,3300).

3. Monitor quorum or health issues
If the Ceph monitors are not in a healthy quorum, the cluster will not function correctly, and new mounts will fail.
Action: Check the cluster health from one of the monitor hosts using ceph status. All monitors should be in quorum. If not, investigate the health of each monitor with systemctl status ceph-mon@<hostname>. Common issues include clock skew or a corrupted monitor store.

4. Invalid mount command or options
Minor errors in the mount command can cause it to fail with unhelpful messages.
Incorrect monitor address: Ensure the VIP is correctly specified. You can also specify multiple monitor IPs separated by commas.
Wrong filesystem name (mds_namespace): If you have multiple filesystems, you must specify the correct one with the -o mds_namespace=<name> option.
Authentication issue: If CephX authentication is enabled (the default), you must specify the correct username and a valid secret, often via a secretfile.
Example correct mount command (assuming cephx):
mount -t ceph <VIP>:/ /mnt/mycephfs -o name=fs_username,secretfile=/etc/ceph/fs_username.secret
Note: The / in VIP:/ specifies the root of the CephFS filesystem.

5. MDS (Metadata Server) service is down
CephFS relies on active MDS daemons to function. If all MDS daemons are down, you will not be able to mount the filesystem.
Action: Check the output of ceph status for the MDS status. You should see at least one MDS service listed as active. If not, check the MDS daemon logs for errors.

6. Networking misconfiguration
Beyond simple firewalls, more complex networking issues can cause problems:
Incorrect public_network setting: The ceph.conf file on your monitor hosts must have public_network set to the correct subnet where your clients reside. If this is misconfigured, monitors may tell clients to connect to an unreachable IP address.
Asymmetric routing: Network routes may be set up in a way that allows traffic from the client to the VIP but not for the Ceph daemons to communicate back to the client.

## General troubleshooting steps

Run a diagnostic mount: Use a diagnostic mount command to enable logging and get more verbose output:
sudo ceph-fuse -d --debug-client=20 --debug-ms=1 -m <VIP>:/ /mnt/mycephfs

Check dmesg output: If you are using the kernel client, the kernel may log errors related to the mount.
dmesg | grep ceph

Use individual monitor IPs: As a test, try mounting using a single, static IP address of one of your monitors. If this succeeds, your problem is specifically with the VIP or HA configuration, not the cluster itself.
Verify client-side configuration: Make sure the client has the necessary ceph.conf and keyring files in /etc/ceph.
