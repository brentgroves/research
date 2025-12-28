AI Overview
To configure the Keepalived service installed via snap, you need to edit the configuration file, typically located at /var/snap/keepalived/common/keepalived.conf. The specific configuration within this file will depend on your desired setup (e.g., virtual IP addresses, failover parameters, etc.). After modifying the configuration, you'll need to restart the Keepalived snap service to apply the changes.
Here's a breakdown of the process:

1. Locate the Configuration File:
Keepalived configuration files for snap installations are usually found in /var/snap/keepalived/common/keepalived.conf.
2. Edit the Configuration:
Open the configuration file using a text editor (e.g., sudo nano /var/snap/keepalived/common/keepalived.conf).
The configuration file uses a specific syntax to define Keepalived's behavior. You'll likely need to configure VRRP instances, including their states (master/backup), virtual router IDs, priorities, and virtual IP addresses.
Refer to Keepalived's documentation for detailed information on available configuration options and their meanings, according to documentation.
3. Apply Changes and Restart:
Save the modified configuration file.
Restart the Keepalived snap service using: sudo snap restart keepalived.
Example Configuration (Illustrative):
Code

vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 51
    priority 101
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass your_password
    }
    virtual_ipaddress {
        192.168.1.100/24
    }
}
This example configures a VRRP instance named VI_1 on interface eth0, setting it as the master with priority 101. It uses password-based authentication (auth_pass) and assigns the virtual IP address 192.168.1.100. Remember to replace placeholders like your_password with your actual credentials.
This video demonstrates a basic Keepalived configuration with two servers:
