# **[EtherType](https://en.wikipedia.org/wiki/EtherType)**

EtherType is a two-octet field in an Ethernet frame. It is used to indicate which protocol is encapsulated in the payload of the frame and is used at the receiving end by the data link layer to determine how the payload is processed. The same field is also used to indicate the size of some Ethernet frames.

EtherType is also used as the basis of 802.1Q VLAN tagging, encapsulating packets from VLANs for transmission multiplexed with other VLAN traffic over an Ethernet trunk.

EtherType was first defined by the Ethernet II framing standard and later adapted for the IEEE 802.3 standard. EtherType values are assigned by the IEEE Registration Authority.

![i1](https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/EthernetFrame.jpg/700px-EthernetFrame.jpg)

In modern implementations of Ethernet, the field within the Ethernet frame used to describe the EtherType can also be used to represent the size of the payload of the Ethernet Frame. Historically, depending on the type of Ethernet framing that was in use on an Ethernet segment, both interpretations were simultaneously valid, leading to potential ambiguity. Ethernet II framing considered these octets to represent EtherType while the original IEEE 802.3 framing considered these octets to represent the size of the payload in bytes.

In order to allow Ethernet II and IEEE 802.3 framing to be used on the same Ethernet segment, a unifying standard, IEEE 802.3x-1997, was introduced that required that EtherType values be greater than or equal to 1536. That value was chosen because the maximum length (MTU) of the data field of an Ethernet 802.3 frame is 1500 bytes and 1536 is represented by the number 600 in the hexadecimal numeral system. Thus, values of 1500 and below for this field indicate that the field is used as the size of the payload of the Ethernet frame while values of 1536 and above indicate that the field is used to represent an EtherType. The interpretation of values 1501–1535, inclusive, is undefined.[1]

The end of a frame is signaled by a valid **[frame check sequence](https://en.wikipedia.org/wiki/Frame_check_sequence)** followed by loss of carrier or by a special symbol or sequence in the line coding scheme for a particular Ethernet physical layer, so the length of the frame does not always need to be encoded as a value in the Ethernet frame. However, as the minimum payload of an Ethernet frame is 46 bytes, a protocol that uses EtherType must include its own length field if that is necessary for the recipient of the frame to determine the length of short packets (if allowed) for that protocol.

## VLAN tagging

![i2](https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Ethernet_802.1Q_Insert.svg/960px-Ethernet_802.1Q_Insert.svg.png)

802.1Q VLAN tagging uses a 0x8100 EtherType value. The payload following includes a 2-byte tag control identifier (TCI) followed by an Ethernet frame beginning with a second (original) EtherType field for consumption by end stations. IEEE 802.1ad extends this tagging with further nested EtherType and TCI pairs.

| EtherType value (hexadecimal) | Protocol                                                                                           |
|-------------------------------|----------------------------------------------------------------------------------------------------|
| 0x0800                        | Internet Protocol version 4 (IPv4)                                                                 |
| 0x0806                        | Address Resolution Protocol (ARP)                                                                  |
| 0x0842                        | Wake-on-LAN[8]                                                                                     |
| 0x22EA                        | Stream Reservation Protocol                                                                        |
| 0x22F0                        | Audio Video Transport Protocol (AVTP)                                                              |
| 0x22F3                        | IETF TRILL Protocol                                                                                |
| 0x6002                        | DEC MOP RC                                                                                         |
| 0x6003                        | DECnet Phase IV, DNA Routing                                                                       |
| 0x6004                        | DEC LAT                                                                                            |
| 0x8035                        | Reverse Address Resolution Protocol (RARP)                                                         |
| 0x809B                        | AppleTalk (EtherTalk)                                                                              |
| 0x80D5                        | LLC PDU (in particular, IBM SNA), preceded by 2 bytes length and 1 byte padding[9]                 |
| 0x80F3                        | AppleTalk Address Resolution Protocol (AARP)                                                       |
| 0x8100                        | VLAN-tagged frame (IEEE 802.1Q) and Shortest Path Bridging IEEE 802.1aq with NNI compatibility[10] |
| 0x8102                        | Simple Loop Prevention Protocol (SLPP)                                                             |
| 0x8103                        | Virtual Link Aggregation Control Protocol (VLACP)                                                  |
| 0x8137                        | IPX                                                                                                |
| 0x8204                        | QNX Qnet                                                                                           |
| 0x86DD                        | Internet Protocol Version 6 (IPv6)                                                                 |
| 0x8808                        | Ethernet flow control                                                                              |
| 0x8809                        | Ethernet Slow Protocols[11] such as the Link Aggregation Control Protocol (LACP)                   |
| 0x8819                        | CobraNet                                                                                           |
| 0x8847                        | MPLS unicast                                                                                       |
| 0x8848                        | MPLS multicast                                                                                     |
| 0x8863                        | PPPoE Discovery Stage                                                                              |
| 0x8864                        | PPPoE Session Stage                                                                                |
| 0x887B                        | HomePlug 1.0 MME                                                                                   |
| 0x888E                        | EAP over LAN (IEEE 802.1X)                                                                         |
| 0x8892                        | PROFINET Protocol                                                                                  |
| 0x889A                        | HyperSCSI (SCSI over Ethernet)                                                                     |
| 0x88A2                        | ATA over Ethernet                                                                                  |
| 0x88A4                        | EtherCAT Protocol                                                                                  |
| 0x88A8                        | Service VLAN tag identifier (S-Tag) on Q-in-Q tunnel                                               |
| 0x88AB                        | Ethernet Powerlink[citation needed]                                                                |
| 0x88B8                        | GOOSE (Generic Object Oriented Substation event)                                                   |
| 0x88B9                        | GSE (Generic Substation Events) Management Services                                                |
| 0x88BA                        | SV (Sampled Value Transmission)                                                                    |
| 0x88BF                        | MikroTik RoMON (unofficial)                                                                        |
| 0x88CC                        | Link Layer Discovery Protocol (LLDP)                                                               |
| 0x88CD                        | SERCOS III                                                                                         |
| 0x88E1                        | HomePlug Green PHY                                                                                 |
| 0x88E3                        | Media Redundancy Protocol (IEC62439-2)                                                             |
| 0x88E5                        | IEEE 802.1AE MAC security (MACsec)                                                                 |
| 0x88E7                        | Provider Backbone Bridges (PBB) (IEEE 802.1ah)                                                     |
| 0x88F7                        | Precision Time Protocol (PTP) over IEEE 802.3 Ethernet                                             |
| 0x88F8                        | NC-SI                                                                                              |
| 0x88FB                        | Parallel Redundancy Protocol (PRP)                                                                 |
| 0x8902                        | IEEE 802.1ag Connectivity Fault Management (CFM) Protocol / ITU-T Recommendation Y.1731 (OAM)      |
| 0x8906                        | Fibre Channel over Ethernet (FCoE)                                                                 |
| 0x8914                        | FCoE Initialization Protocol                                                                       |
| 0x8915                        | RDMA over Converged Ethernet (RoCE)                                                                |
| 0x891D                        | TTEthernet Protocol Control Frame (TTE)                                                            |
| 0x893a                        | 1905.1 IEEE Protocol                                                                               |
| 0x892F                        | High-availability Seamless Redundancy (HSR)                                                        |
| 0x9000                        | Ethernet Configuration Testing Protocol[12]                                                        |
| 0xF1C1                        | Redundancy Tag (IEEE 802.1CB Frame Replication and Elimination for Reliability)                    |
