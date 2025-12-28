# **[Network debugging](https://canonical-openstack.readthedocs-hosted.com/en/latest/reference/network-debugging/)**

**[Back to Research List](../../../../../research_list.md)**\
**[Back to Current Tasks](../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../README.md)**

This page presents a collection of techniques for interrogating your cloud’s virtual networking system (OVN). Whether prompted by sheer interest or by necessity (an issue has arisen), this page will assist you in looking into the internals of your cloud’s networking layer.

This page was inspired by **[upstream OVN documentation](https://docs.ovn.org/en/latest/tutorials/ovn-openstack.html)**. Many OVN troubleshooting techniques can be applied equally to a Sunbeam environment.

Contents:

- **[Accessing OVN databases](https://canonical-openstack.readthedocs-hosted.com/en/latest/reference/network-debugging/#heading--accessing-ovn-databases)**

- **[Querying OVN databases](https://canonical-openstack.readthedocs-hosted.com/en/latest/reference/network-debugging/#heading--accessing-ovn-databases)**

- **[Capturing and tracing an ingress packet](https://canonical-openstack.readthedocs-hosted.com/en/latest/reference/network-debugging/#heading--capturing-and-tracing-an-ingress-packet)**
- **[Resolving OpenFlow port numbers](https://canonical-openstack.readthedocs-hosted.com/en/latest/reference/network-debugging/#heading--resolving-openflow-port-numbers)**

Accessing OVN databases

There are four containers in each ovn-chassis pod:

- Northd
- Northbound database
- Southbound database
- the charm itself

These containers can each be accessed with Juju over SSH. Once connected, start a Bash shell and create aliases for accessing the OVN tooling:

For the Northbound DB container:

```bash
juju ssh -m openstack --container ovn-nb-db-server ovn-central/0
```

Set up aliases:

```bash
alias ovn-nbctl='ovn-nbctl --db=ssl:127.0.0.1:6641 -c /etc/ovn/cert_host -p /etc/ovn/key_host -C /etc/ovn/ovn-central.crt'
```

For the Southbound DB container:

```bash
juju ssh -m openstack --container ovn-sb-db-server ovn-central/0
```

Set up aliases:

```bash
alias ovn-sbctl='ovn-sbctl --db=ssl:127.0.0.1:6642 -c /etc/ovn/cert_host -p /etc/ovn/key_host -C /etc/ovn/ovn-central.crt'
```

## Querying OVN databases

Assuming that all the defaults for a single-node install were used and sunbeam launch was used to create a guest, then there will be a demo-network, external-network, demo-router, and a guest.

These are some of the entities that are present from an OpenStack perspective:

```bash
openstack server list --all-projects
+--------------------------------------+-----------+--------+-------------------------------------------+--------+---------+
| ID                                   | Name      | Status | Networks                                  | Image  | Flavor  |
+--------------------------------------+-----------+--------+-------------------------------------------+--------+---------+
| 6c446cb5-4934-401a-917d-e3bc215c0b64 | rapid-owl | ACTIVE | demo-network=10.20.20.138, 192.168.122.83 | ubuntu | m1.tiny |
+--------------------------------------+-----------+--------+-------------------------------------------+--------+---------+

openstack network list
+--------------------------------------+------------------+--------------------------------------+
| ID                                   | Name             | Subnets                              |
+--------------------------------------+------------------+--------------------------------------+
| 3f9bc3b1-2520-4658-85f0-545a69e8b06a | demo-network     | 17e394f9-e12c-4f31-a269-62ddf3308fc8 |
| 856fe9e3-60bf-4177-bb8b-831f68bb55c0 | external-network | 14c63eaf-eeb7-476d-a99d-0a05f6a674f8 |
+--------------------------------------+------------------+--------------------------------------+

openstack subnet list
+--------------------------------------+-----------------+--------------------------------------+------------------+
| ID                                   | Name            | Network                              | Subnet           |
+--------------------------------------+-----------------+--------------------------------------+------------------+
| 14c63eaf-eeb7-476d-a99d-0a05f6a674f8 | external-subnet | 856fe9e3-60bf-4177-bb8b-831f68bb55c0 | 10.20.20.0/24    |
| 17e394f9-e12c-4f31-a269-62ddf3308fc8 | demo-subnet     | 3f9bc3b1-2520-4658-85f0-545a69e8b06a | 192.168.122.0/24 |
+--------------------------------------+-----------------+--------------------------------------+------------------+

openstack router list
+--------------------------------------+-------------+--------+-------+----------------------------------+
| ID                                   | Name        | Status | State | Project                          |
+--------------------------------------+-------------+--------+-------+----------------------------------+
| 5c300bae-bf1f-4773-ac98-1d71c23e1bc7 | demo-router | ACTIVE | UP    | b8c896d15bb247448edd2d97f7d99f1f |
+--------------------------------------+-------------+--------+-------+----------------------------------+

openstack port list
+--------------------------------------+------+-------------------+-------------------------------------------------------------------------------+--------+
| ID                                   | Name | MAC Address       | Fixed IP Addresses                                                            | Status |
+--------------------------------------+------+-------------------+-------------------------------------------------------------------------------+--------+
| 418c3e5d-87fa-467c-b1c1-b9832fa1e752 |      | fa:16:3e:09:d4:a6 | ip_address='192.168.122.2', subnet_id='17e394f9-e12c-4f31-a269-62ddf3308fc8'  | DOWN   |
| 56a18b9e-07d4-4249-b28b-b6446961a587 |      | fa:16:3e:23:60:97 | ip_address='10.20.20.239', subnet_id='14c63eaf-eeb7-476d-a99d-0a05f6a674f8'   | ACTIVE |
| 98835e99-8ab5-4cd3-8b17-207e15538c03 |      | fa:16:3e:2d:6e:82 |                                                                               | DOWN   |
| ae7b9a8e-48e8-4c3a-9ef0-710ccba00776 |      | fa:16:3e:70:93:8c | ip_address='192.168.122.1', subnet_id='17e394f9-e12c-4f31-a269-62ddf3308fc8'  | ACTIVE |
| cd9f7cce-77cb-4fae-ae1c-94964248d8d5 |      | fa:16:3e:00:53:35 | ip_address='10.20.20.138', subnet_id='14c63eaf-eeb7-476d-a99d-0a05f6a674f8'   | N/A    |
| d8174cec-c5ae-4bd0-abb4-9420c3b87e76 |      | fa:16:3e:dd:8f:4d | ip_address='192.168.122.83', subnet_id='17e394f9-e12c-4f31-a269-62ddf3308fc8' | ACTIVE |
+--------------------------------------+------+-------------------+-------------------------------------------------------------------------------+--------+
```

Note

The two metadata ports are marked as down and each of the guests floating IP ports is in a N/A state. In both cases, this is normal and not an indication of any kind of problem.

These entities are reflected in the configuration of the Northbound DB.

```bash
ovn-nbctl show
switch 7fd2fe36-74b6-41a4-9005-d521d2a9a0fd (neutron-3f9bc3b1-2520-4658-85f0-545a69e8b06a) (aka demo-network)
    port d8174cec-c5ae-4bd0-abb4-9420c3b87e76 (aka rapid-owl-internal)
        addresses: ["fa:16:3e:dd:8f:4d 192.168.122.83"]
    port 418c3e5d-87fa-467c-b1c1-b9832fa1e752
        type: localport
        addresses: ["fa:16:3e:09:d4:a6 192.168.122.2"]
    port ae7b9a8e-48e8-4c3a-9ef0-710ccba00776 (aka demo-router-internal)
        type: router
        router-port: lrp-ae7b9a8e-48e8-4c3a-9ef0-710ccba00776
switch 31f5c4f7-725b-4313-86a5-2b5c47d4f03a (neutron-856fe9e3-60bf-4177-bb8b-831f68bb55c0) (aka external-network)
    port 98835e99-8ab5-4cd3-8b17-207e15538c03
        type: localport
        addresses: ["fa:16:3e:2d:6e:82"]
    port 56a18b9e-07d4-4249-b28b-b6446961a587 (aka demo-router-floating)
        type: router
        router-port: lrp-56a18b9e-07d4-4249-b28b-b6446961a587
    port provnet-f5363a0a-8963-4271-a844-e545ba5f931b
        type: localnet
        addresses: ["unknown"]
router 1a6ddfff-8a1e-45a6-bdf8-6f13e7c5d8f9 (neutron-5c300bae-bf1f-4773-ac98-1d71c23e1bc7) (aka demo-router)
    port lrp-ae7b9a8e-48e8-4c3a-9ef0-710ccba00776
        mac: "fa:16:3e:70:93:8c"
        networks: ["192.168.122.1/24"]
    port lrp-56a18b9e-07d4-4249-b28b-b6446961a587
        mac: "fa:16:3e:23:60:97"
        networks: ["10.20.20.239/24"]
        gateway chassis: [microk8s06.maas]
    nat aba8126c-612d-4de5-9445-6aacb813714a
        external ip: "10.20.20.138"
        logical ip: "192.168.122.83"
        type: "dnat_and_snat"
    nat cf7cfd04-ebfa-4407-b14e-1d43f999e233
        external ip: "10.20.20.239"
        logical ip: "192.168.122.0/24"
        type: "snat"
```

Over in the Southbound DB, the chassis for this deployment can be examined:

```bash
ovn-sbctl show
Chassis microk8s06.maas
    hostname: microk8s06.maas
    Encap geneve
        ip: "10.177.200.18"
        options: {csum="true"}
    Port_Binding "d8174cec-c5ae-4bd0-abb4-9420c3b87e76"
    Port_Binding cr-lrp-56a18b9e-07d4-4249-b28b-b6446961a587
```

The flows can also be listed:

```bash
ovn-sbctl lflow-list
...
```

## Capturing and tracing an ingress packet

The example below captures and then traces an ICMP echo request packet destined for a guest. The first step is to capture an echo request packet. The code:tcpdump command can be used for this. In this example, there is a single-node install with access to the guests available from the installation node. The guests floating IP address is 10.20.20.138. The routes on the box show that traffic for this subnet will be routed to br-ex.

```bash
ip route | grep '10.20.20.0/24'
10.20.20.0/24 dev br-ex proto kernel scope link src 10.20.20.1
```

Listen on the br-ex interface, filter for echo request packets (an ICMP code of 8), and store the captured packets in a file for later usage:

Window 1:

```bash
sudo tcpdump -i br-ex "icmp[0] == 8" -w ping.pcap
```

Window 2:

```bash
ping -c3 10.20.20.138
```

The ping.pcap file should now contain the echo requests generated by the ping command. To use these with the OVS trace utility the packet capture file needs to be converted. The utility for doing this is called code:ovs-pcap. At the time of writing, this command is included in the openstack-hypervisor snap but is not exposed. However it can still be used:

/snap/openstack-hypervisor/current/usr/bin/ovs-pcap ping.pcap > ping.hex
The ping.hex file will contain three entries corresponding to each of the echo requests. For this example only the first is needed.

```bash
IN_PORT="br-ex"
BRIDGE="br-ex"
PACKET=$(head -1 ping.hex)
sudo openstack-hypervisor.ovs-appctl ofproto/trace $BRIDGE in_port="$IN_PORT" $PACKET
```

If all is well the last rule in the output should end with:

...
65. reg15=0x3,metadata=0x2, priority 100, cookie 0x3d326af3
    output:2
This shows that the packet was sent out of OpenFlow port number 2. This corresponds to the intended guest (See “Resolving OpenFlow port numbers” below).
