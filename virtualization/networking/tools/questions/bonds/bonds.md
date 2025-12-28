# **[How to configure interface bonding](https://netplan.readthedocs.io/en/stable/examples/#how-to-configure-interface-bonding)**

## AI - What is interface bonding in Linux?

In Linux, "interface bonding" refers to the process of combining multiple physical network interfaces into a single logical interface, essentially creating a virtual network interface with increased bandwidth and redundancy by allowing traffic to flow across all connected interfaces simultaneously, providing failover capability if one interface fails; this is achieved through a kernel module called "bonding" which manages the aggregation of these interfaces.

## Key points about interface bonding

Purpose:
To improve network performance and reliability by utilizing multiple network cards to distribute traffic across them, effectively increasing throughput and providing redundancy in case of a single connection failure.

Terminology:

- Slave interfaces: Individual physical network interfaces that are combined to create the bonded interface.
- Master interface: The single logical interface created by bonding the slave interfaces, often referred to as "bond0".

## Modes of operation

Different bonding modes can be configured depending on the desired behavior, including load balancing (distributing traffic across all interfaces) and active-backup (only using one interface as primary, switching to another only if the primary fails).

## AI - extreme switch bonding modes

On an Extreme switch, "bonding modes" primarily refer to the configuration of Link Aggregation Groups (LAGs), which allows you to combine multiple physical ports into a single logical port to increase bandwidth and provide redundancy, essentially "bonding" them together; the primary method for configuring this is through the "sharing" command, with options to set the load-balancing algorithm and whether to use LACP (Link Aggregation Control Protocol) for dynamic link aggregation.

## Key points about Extreme switch bonding modes

Terminology:

In Extreme Networks documentation, "bonding" is often referred to as "link aggregation" or "load sharing".

Creating a LAG:
To create a LAG, use the "enable sharing" command, specifying the master port and the group of ports to be included.

LACP support:

You can configure LACP (Link Aggregation Control Protocol) to automatically negotiate the LAG with connected devices.
Load balancing algorithms:
When configuring a LAG, you can choose a load-balancing algorithm to determine how traffic is distributed across the member ports, such as "address-based L2" (based on MAC addresses) or "address-based L3" (based on IP addresses).

## **[How To Configure a Sharing Group (LAG) with LACP](https://extreme-networks.my.site.com/ExtrArticleDetail?an=000082730)**

## Objective

How to configure sharing groups (LAGs) with LACP in EXOS.

### Environment

- ExtremeSwitching
- EXOS
- Sharing Group / Link Aggregation Group (LAG) / LACP / Ether-Channel / Port-Channel / Multi Link Trunk (MLT)

### Procedure

To create an LACP enabled sharing group, create a normal sharing group and use the 'LACP' keyword at the end of the command:

```bash
enable sharing <MasterPort> grouping <PortList> { algorithm [ address-based { L2 | L3 | L3_L4 | custom } | port-based }]} lacp
```

- MasterPort - The port by which you want to reference the sharing group. Further VLAN configuration is directed at the MasterPort
- PortList - All of the ports you want in the LAG
- Algorithm (Default L2) - Determines which port in the LAG transmits a given frame based on frame info (see below)
- LACP - Enables LACP active mode on the LAG, often called an 'LACP LAG' in contrast to a 'Static LAG' that does not use LACP operation.

To change LACP parameters:

```bash
configure sharing <MasterPort> lacp activity-mode [ active | passive ]
configure sharing <MasterPort> lacp timeout [ long | short ]
configure sharing <MasterPort> lacp system-priority <System_Priority>
configure lacp member-port <Port> priority <Port_Priority>
```

- Activity-Mode (Default Active) - Choose between active (periodically send LACP PDUs) or passive (only respond to LACP PDUs) operation
- Timeout (Default Long) - Choose between a 3s or 90s LACP timeout. This setting must match on both ends of the LAG.
- System_Priority (Default 0) - Set the LACP system priority (0 to 65535)
- Port_Priority (Default 0) - Set an individual port priority (0 to 65535)

To view/verify the LAG is configured:

```bash
show sharing

# Example

Load Sharing Monitor
Config    Current Agg     Min     Ld Share    Ld Share  Agg   Link   Link Up
Master    Master  Control Active  Algorithm   Group     Mbr   State  Transitions
================================================================================
    21     21     LACP       1     port        21         Y      A        1
                                   port        22         Y      A        2
================================================================================
Link State: A-Active, D-Disabled, R-Ready, NP-Port not present, L-Loopback

```

## To check LACP counters and configuration

```bash
show lacp counters

#Example
LACP PDUs dropped on non-LACP ports : 0
LACP Bulk checkpointed msgs sent    : 0
LACP Bulk checkpointed msgs recv    : 0
LACP PDUs checkpointed sent         : 0
LACP PDUs checkpointed recv         : 0
Lag        Member     Rx       Rx Drop  Rx Drop  Rx Drop  Tx       Tx
Group      Port       Ok       PDU Err  Not Up   Same MAC Sent Ok  Xmit Err
--------------------------------------------------------------------------------
21         21         2        0        0        0        2        0
           22         2        0        0        0        2        0

================================================================================
```

```bash
show lacp lag <master-port>

#Example
Lag   Actor    Actor  Partner           Partner  Partner Agg   Actor
      Sys-Pri  Key    MAC               Sys-Pri  Key     Count MAC
--------------------------------------------------------------------------------
21          0  0x03fd 00:04:96:99:90:0a       0  0x03fd      2 00:04:96:98:88:1b
Port list:
Member     Port      Rx           Sel          Mux            Actor     Partner
Port       Priority  State        Logic        State          Flags     Port
--------------------------------------------------------------------------------
21         0         Current      Selected     Collect-Dist   A-GSCD--  1021
22         0         Current      Selected     Collect-Dist   A-GSCD--  1022
================================================================================
Actor Flags: A-Activity, T-Timeout, G-Aggregation, S-Synchronization
             C-Collecting, D-Distributing, F-Defaulted, E-Expired
```

## Additional notes

**[How to Create and Delete an EXOS Sharing Group (LAG / Port-Channel)](https://extreme-networks.my.site.com/ExtrArticleDetail?an=000074233)**

The following sharing algorithm data sources are available, the default being address-based L2. The sharing algorithm is used when a frame has to be transmitted on a LAG. It determines which port of the LAG should transmit that frame. The algorithm data source determines what information about a frame is used in that determination. The sharing algorithm hashes the relevant data in the frame down to a port index that determines the egress port. Therefore, if all traffic has the same data, it will all be hashed the same, and will all leave the same port. Therefore, consider which algorithm data source is likely to give you the most balanced (random) hashing/load balancing.
If the default algorithm does not provide a sufficiently balanced transmit load across all ports of the LAG, try using a different algorithm. (show port utilization). These switches are not load balancers with a round-robin type of forwarding, but use any of the below mentioned algorithms, so a fully even balancing is unlikely in majority of the networks.
If connecting two EXOS switches, the algorithm does not need to match on both sides of the link for it to operate, however, it is best practice for them to match.

1) Address-Based L2: Layer 2 source and destination MAC addresses
    - Available on BlackDiamond 8800 series, SummitStack, and all Summit family switches
2) Address-Based L3: Layer 3 source and destination IP addresses
    - Available on BlackDiamond 8800 series, SummitStack, and Summit family switches excluding the X150 and X350
3) Address-Based L3_L4: Layer 3 and Layer 4, combined source and destination IP addresses AND source and destination TCP/UDP port numbers
    - Available on BlackDiamond 8000 a-, c-, and e-series and all Summit family switches
4) Address-Based Custom: Configure a custom algorithm to use CRC16, CRC32 or XOR computation, and to use the Source and Destination IP with L4 port number, only the source and destination IP, only the source IP, OR only the destination IP in the hashing calculation. A custom hash-seed can also be set.
    - Available on Summit family switches excluding the X435, X440-G2, and X620
    - Change the custom algorithm with the command 'configure sharing address-based custom [tab]...'
5) Port-Based: Interface Keys
    - Available on Summit X670-G2, X460-G2, X450-G2, X465, X590, X870, X690, X695, and 5520 switches
    - When used, each port on the switch is assigned a numerical key value (show sharing port-based keys).
    - When determining which port in the sharing group to transmit a given frame, the switch will conduct a modulus operation on the key of the source port of the traffic with the sum of the number of ports in the LAG.
    - For example, if a frame comes in on port 1 whose key is 10 and must egress a LAG made up of ports 20-24 (Index values of 0,1,2,3 respectively) the port to forward the traffic is = [source-port-key] % [number-of-ports-in-lag] = 10 % 2 = 0 -> Traffic is forwarded over the first port in the LAG, port 20.

Related Hub Thread: <https://community.extremenetworks.com/extreme/topics/how-i-configure-lacp-between-extreme-and-cisco>
