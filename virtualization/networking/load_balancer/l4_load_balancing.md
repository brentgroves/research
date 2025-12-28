# **[Layer 4 Load Balancing Definition](https://www.vmware.com/topics/layer-4-load-balancing)**

A load balancer distributes application traffic or network traffic across multiple servers, acting as a reverse proxy. Load balancers can increase the reliability and capacity—or possible number of concurrent users—of applications. Load balancers perform application-specific tasks and decrease the burden on servers associated with maintaining and managing network and application sessions to improve overall application performance.

There are two broad categories of load balancers: layer 4 and layer 7. These types of load balancers operate and make decisions based on different factors.

Layer 4 load balancing makes its routing decisions based on information defined at Layer 4, the networking transport layer. Layer 4 represents the fourth layer of the Open Systems Interconnection [OSI] Reference Model, which defines seven networking layers total, **[found here](https://docs.oracle.com/cd/E19504-01/802-5886/intro-45828/index.html)**.

Layer 4 is the transport level, which includes the user datagram protocol (UDP) and transmission control protocol (TCP). For internet traffic, a Layer 4 load balancer does not consider packet contents as it makes its load-balancing decisions, and instead distributes client requests across a group of servers based on the destination and source IP addresses and ports the packet header records.

Layer 1: Physical Layer
This layer specifies the physical media connecting hosts and networks, and the procedures used to transfer data between machines using a specified media. This layer is commonly referred to as the hardware layer of the model.

Layer 2: Data-Link Layer
This layer manages the reliable delivery of data across the physical network. For example, it provides the abstraction of a reliable connection over the potentially unreliable physical layer.

Layer 3: Network Layer
This layer is responsible for routing machine-to machine communications. It determines the path a transmission must take, based upon the destination machine's address. This layer must also respond to network congestion problems.

Layer 4: Transport Layer
This layer provides end-to-end sequenced delivery of data. It is the lowest layer that provides applications and higher layers with end-to-end service. This layer hides the topology and characteristics of the underlying network from users. It provides reliable end-to-end data delivery if the service characteristics require it.

Layer 5: Session Layer
This layer manages sessions between cooperating applications.

Layer 6: Presentation Layer
This layer performs the translation between the data representation local to the computer and the processor-independent format that is sent across the network. It can also negotiate the transfer formats in some protocol suites. Typical examples include standard routines that compress text or convert graphic images into bit streams for transmission across a network.

Layer 7: Application Layer
This layer consists of the user-level programs and network services. Some examples are telnet, ftp, and tftp.
