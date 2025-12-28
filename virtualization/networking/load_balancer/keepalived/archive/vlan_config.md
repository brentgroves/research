# **[ubuntu](https://medium.com/@xmikex83/how-to-setup-an-highly-available-load-balancer-with-keepalived-and-haproxy-on-ubuntu-18-04-8bab7b77f715)**

## **[](https://documentation.extremenetworks.com/efa/efa_2.4.0/admin/GUID-0851F58E-4024-4DA0-BAD1-C73876E707DE.shtml)**

Once the user configures a new VLAN/sub-interface through EFA on both the active and standby nodes, the sub-interfaces are created.

On the active node the IP subnet is applied to the sub-interface.

The keepalived configuration with the new sub-interface IP subnets are updated on both active and standby nodes

Keepalived runs only one instance of VRRP and multiple VIPs can be assigned.

Copy this code
vrrp_instance HA1 {
  virtual_router_id 51
  advert_int 1
  priority 102
  nopreempt
  interface eth0
  unicast_src_ip 10.24.95.134    # IP address of Master Server
  unicast_peer {
    10.24.95.69                # IP address of Slave Server
  }
  virtual_ipaddress {
    10.24.95.116/32 dev eth0
    20.20.20.2/24   dev efa-sub2
    50.50.50.2/24   dev efa-sub1
  }
  track_script {
    chk_default_gw
    chk_mariadb
  }
  notify /apps/bin/keepalivednotify.sh
}
The first VIP is provided in all HA installations and is not managed by MMIP CLIs. In particular, it can't be removed by MMIP. On failover, EFA configures the new active node sub-interfaces with the IP subnets. This is achieved through Keepalived which runs the VRRP protocol

Keepalived runs only one instance of VRRP and multiple VIPs can be assigned.

## configure keepalived for vlan

To configure Keepalived for a VLAN, you'll need to create a VLAN interface on your servers, configure the VLAN interface with an IP address, and then configure Keepalived to use that VLAN interface in its VRRP instance. Keepalived will manage the failover of the virtual IP address (VIP) associated with that VLAN interface.

## Here's a breakdown of the process

1. Create the VLAN and Interface:
Create the VLAN: On your network switch, create the VLAN you intend to use (e.g., VLAN 10).
Configure the VLAN interface: On each server participating in the Keepalived setup, create a VLAN interface associated with the VLAN you created. This typically involves using commands like ip link add link <physical_interface> name <vlan_interface> type vlan id <vlan_id> (e.g., ip link add link eth0 name eth0.10 type vlan id 10).
Assign an IP address: Assign an IP address to the VLAN interface on the active server (the server that will initially own the VIP).

2. Configure Keepalived:
Edit Keepalived configuration file: Open the /etc/keepalived/keepalived.conf file on each server.
Define a VRRP instance:
Create a vrrp_instance block.
Specify the state as MASTER on the primary server and BACKUP on the secondary server.
Set the interface to the VLAN interface you created (e.g., eth0.10).
Set a virtual_router_id (a unique identifier for the VRRP instance).
Set a priority (higher on the master, lower on the backup).
Define the virtual_ipaddress (the VIP).
Configure authentication (e.g., using auth_type PASS and auth_pass).

3. Start Keepalived:
Start the Keepalived service on both servers.
Example Configuration (Simplified):
Primary Server (/etc/keepalived/keepalived.conf):
Code

global_defs {
    # Optional settings like notification scripts
}

vrrp_instance VI_1 {
    state MASTER
    interface eth0.10
    virtual_router_id 51
    priority 101
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 12345
    }
    virtual_ipaddress {
        192.168.10.100/24  # VLAN IP
    }
}
