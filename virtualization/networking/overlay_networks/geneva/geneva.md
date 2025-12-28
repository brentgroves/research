# **[VXLAN vs Geneve: Understand the difference](https://ipwithease.com/vxlan-vs-geneve-understand-the-difference/#:~:text=Difference%20between%20VxLAN%20and%20GENEVE,-From%20a%20bird's&text=While%20the%20Header%20Length%20of,chaining%20and%20in%2Dband%20telemetry.)**

In this article, we will have discussion regarding tunnelling protocols VXLAN and Geneve and how both are different from each other.

With the introduction of new use cases in IT environments and fast development in technology, customer requirements created market demand to introduce new tunnelling protocols to address the new and old requirements in the same sack.

## What is VxLAN

The full form of the word VxLAN is Virtual Extensible LAN, which was developed by a joint collaboration of market leaders – VMware, Arista Networks and Cisco. Features like vMotion etc. across Data Centers requires a Layer 2 domain across data centers, can be easily achieved with the help of VXLAN overlay. VXLAN is responsible for forming a Layer 2 LAN Segment across the Layer 3 network. By leveraging the VXLAN technology over underlying routed Layer 3 network, spanning tree and trunking of VLANS is mitigated.

VXLAN is officially documented in RFC 7348, hence a standard.  Each VXLAN segment has an identifier called VNI, which is 24-bit and allows to extend the VXLAN values to around 16 Million segments of VXLAN to work on. Below diagram depicts VxLAN Header and its related fields –

![i1](https://ipwithease.com/wp-content/uploads/2022/04/VXLAN-VS-GENEVE-3.jpg.webp)

## What is GENEVE

GENEVE stands for Generic Network Virtualization Encapsulation. It has been designed to understand and accommodate changing capabilities and needs of different vendor devices. It provides a framework for tunnelling rather than being prescriptive about the entire system. Similar to VXLAN, GENEVE also encapsulates packets with a unique header and uses UDP as its mechanism of transport. Geneve supports unicast, multicast, and broadcast.

Geneve defines an encapsulation data format only and does not include information for the control plane. GENEVE is developed to be flexible and extensible in the best possible way. VXLAN holds a 24-bit tunnel identifier field in VXLAN. What makes GENEVE powerful and future proof is the extensibility through a proposed set of TLV options that can be set. GENEVE’s flexible option format in addition to use of IANA to designate Option Classes are key benefits over VXLAN encapsulation methods. Vendors have flexibility to include as many or as few options as they wish without being limited to 24 bits.

![i2](https://ipwithease.com/wp-content/uploads/2022/04/VXLAN-VS-GENEVE-2.jpg.webp)

## Difference between VxLAN and GENEVE

From a bird’s eye view, we will feel that VxLAN and Geneve provide the same functional output, i.e. encapsulation and transport of L2 frames inside an Layer 3 IP packet. In fact, both use UDP protocol for carrying out their function. However, there are some aspects which differentiate both the tunnelling protocols.

While the Header Length of VXLAN frame is 8 Byte, Geneve has double the size of header is 16 bytes. Further, 3 aspects which are not available in VXLAN are Transport security, service chaining and in-band telemetry. Additionally, some key shortcomings with VXLAN which were addressed with Geneve are:

- VXLAN lacks the protocol identifier field, so VXLAN assumes the payload is Ethernet and no other. However, further multiplexing/demultiplexing requires a protocol identifier in payload address, which VXLAN lacks.
- No ability to send out a packet frame which does not belong to the client i.e. the other end can’t distinguish whether it is a client packet or not.
- All fields in VXLAN are fixed and there is no option for interoperability by using extensible fields.

One last distinction between both protocols is that VXLAN calls the Tunnel endpoints as “VTEP” while “TEP” is terminology used in the case of Geneve.

## Comparison Table: VxLAN vs Geneve

The above shared differences have been enlisted in below table –

| PARAMETER                                               | VxLAN                                                        | GENEVE                                                |
|---------------------------------------------------------|--------------------------------------------------------------|-------------------------------------------------------|
| Abbreviation for                                        | VxLAN (Virtual Extensible LAN)                               | GENEVE (Generic Network Virtualization Encapsulation) |
| Developed by                                            | VMware, Arista Networks and Cisco                            | VMware, Microsoft, Red Hat and Intel                  |
| Protocol                                                | UDP                                                          | UDP                                                   |
| Port no                                                 | 4789                                                         | 6081                                                  |
| Header length                                           | 8 byte                                                       | 16 byte                                               |
| Transport security, service chaining, in-band telemetry | Not supported                                                | Supported                                             |
| RFC                                                     | VXLAN is officially documented by the IETF in RFC 7348       | RFC 8926                                              |
| Protocol Identifier                                     | No                                                           | Yes                                                   |
| non-client payload indication                           | No                                                           | Yes                                                   |
| Extensibility.                                          | No. Infact all fields in VXLAN header have predefined values | Yes                                                   |
| Hardware friendly vendor extensibility mechanism        | Limited                                                      | Yes                                                   |
| Term used for Tunnel Endpoints                          | VTEP                                                         | TEP                                                   |

## Closing Thoughts

To summarize, VxLAN will work fine when there is a single vendor environment, however when there are multiple vendors in a customer environment and complex, Geneve is the go-to technology. It’s imperative to highlight that changes with Geneve are only on the Data Plane with no change to the Control plane.
