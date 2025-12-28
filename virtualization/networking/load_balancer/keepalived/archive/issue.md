sudo systemctl start keepalived.service
Job for keepalived.service failed because the service did not take the steps required by its unit configuration.
See "systemctl status keepalived.service" and "journalctl -xeu keepalived.service" for details.

AI Overview
The "Failed with result 'protocol'" message in Keepalived's systemd status or logs typically indicates an issue related to the Virtual Router Redundancy Protocol (VRRP) communication or its configuration. This error can be a catch-all for various underlying problems preventing Keepalived from properly establishing or maintaining its VRRP state.
Common causes and troubleshooting steps include:
VRRP Configuration Errors:
Incorrect virtual_router_id: Ensure the virtual_router_id is unique within the same subnet for each VRRP instance and consistent across the master and backup nodes for the same instance.
Mismatched state and priority: Verify that only one node is configured with state MASTER and a higher priority for a given VRRP instance, while others are state BACKUP with lower priorities.
Authentication issues: If using VRRP authentication, confirm that the authentication type and password are correctly configured and match on all nodes in the VRRP instance.
Network Connectivity Problems:
Firewall rules: Check if firewall rules (e.g., iptables, firewalld) are blocking VRRP multicast traffic (destination address 224.0.0.18).
Network interface issues: Ensure the network interface specified in the Keepalived configuration is up and correctly configured.
SELinux: If SELinux is enabled, it might be preventing Keepalived from binding to the VRRP protocol or virtual IPs. Temporarily disabling SELinux or configuring appropriate SELinux policies can help diagnose this.
Systemd or Keepalived Version Incompatibilities:
Older versions of systemd (e.g., systemd v239) have been known to cause issues with Keepalived, leading to "Failed with result 'protocol'" messages. Upgrading systemd or Keepalived to a more recent, compatible version can resolve this.
Configuration File Syntax Errors:
While less common for this specific error, minor syntax errors, hidden characters (e.g., from copy-pasting from a Windows editor), or incorrect indentation in the keepalived.conf file can lead to parsing errors that manifest as protocol-related failures.
Troubleshooting Steps:
Inspect Keepalived Logs:
.
Use journalctl -u keepalived to view detailed logs and identify more specific error messages preceding the "Failed with result 'protocol'".
Verify Configuration:
.
Double-check the keepalived.conf file for any misconfigurations or typos, especially in the vrrp_instance blocks.
Check Network Connectivity:
.
Use tcpdump -vvv -n -i <interface> host 224.0.0.18 to observe VRRP advertisements and verify network communication between nodes.
Review Systemd Version:
.
If on an older Linux distribution, consider if a systemd or Keepalived version incompatibility might be at play.

<https://github.com/acassen/keepalived/issues/1845>
