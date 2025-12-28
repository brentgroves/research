# **[Administrative Distance (AD) and Autonomous System (AS)](https://www.geeksforgeeks.org/administrative-distance-ad-and-autonomous-system-as/)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

Administrative Distance (AD) is used to rate the trustworthiness of routing information received from the neighbor router. The route with the least AD will be selected as the best route to reach the destination remote network and that route will be placed in the routing table. It defines how reliable a routing protocol is. It is an integer value ranging from 0 to 255 where 0 shows that the route is most trusted and 255 means that no traffic will be passed through that route or that route is never installed in the routing table.

| Route sources       | Default AD                   |
|---------------------|------------------------------|
| Connected interface | 0                            |
| Static route        | 1                            |
| External BGP        | 20                           |
| EIGRP               | 90                           |
| OSPF                | 110                          |
| RIP                 | 120                          |
| External EIGRP      | 170                          |
| Internal BGP        | 200                          |
| Unknown             | 255 (This route is not used) |

## Example –

The smaller the value of AD, the more reliable the routing protocol is. For example, if a router receives an advertised route to a remote destination network from OSPF and EIGRP, then the advertised route of EIGRP will be considered as the best route and will be placed in the routing table as EIGRP has lower AD.

## The best path selection process by dynamic protocol –

If a router receives the same advertised routes from more than one source for a remote network, then the first AD value is checked. The advertised route having the least AD value will get preference. If the AD value of the advertised routes is the same, then the metrics of advertised routes are checked. The advertised route with the least metric will be placed in the routing table. If both AD and metric are the same then load balancing is done i.e the traffic will traverse through different routes. The load balancing can be equal or unequal. In equal load balancing, the same amount of traffic will traverse through both routes one at a time while the different amounts of traffic will traverse in unequal load balancing.

Autonomous System (AS) is a group of routers and networks working under a single administrative domain. It is a 16-bit value that defines the routing domain of the routers. These numbers range from 1 to 65535.

- Public Autonomous System Number –

These are 16-bit values that range from 1 to 64511. The service provider will provide a public AS if the customer is connected to more than one ISPs such as multihoming. A global autonomous number, which will be unique, is provided when the customer wants to propagate its BGP routes through 2 ISPs.

- Private Autonomous system Number –

Private Autonomous System Number are 16-bit values that range from 64512 to 65535. The service provider will provide a private autonomous system number to the customer when the customer wants multi-connection to a single ISP (single home or dual home network) but not to more than one ISPs. These are provided in order to conserve the autonomous system numbers.

- Assigning of AS numbers –
The Autonomous numbers are first assigned by IANA (Internet Assign Number Authority) to the respective regional registries. Further, the regional registry distributes these autonomous numbers (from the block of autonomous numbers provided by IANA) to entities within their designated area.
