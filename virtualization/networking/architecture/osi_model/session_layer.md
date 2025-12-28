# # **[Session Layer](https://osi-model.com/session-layer/)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

![osi](https://media.geeksforgeeks.org/wp-content/uploads/20240615010645/OSI-Model.png)

## Build and control sessions

The layer 5 (control of logical connections; also session layer) provides inter-process communication between two systems. Here you can find among others the protocol RPC (Remote Procedure Call). To resolve failures of meeting and similar problems, the session layer services for an organized and synchronized data exchange. To this end, recovery points, so-called fixed points (check points) introduced, where the session can be synchronized after a failure of a transport connection again without the transfer must start from the beginning again.

## OSI Layer 5 - Session Layer

In the seven-layer OSI model of computer networking, the session layer is layer 5.

The session layer provides the mechanism for opening, closing and managing a session between end-user application processes, i.e., a semi-permanent dialogue. Communication sessions consist of requests and responses that occur between applications. Session-layer services are commonly used in application environments that make use of remote procedure calls (RPCs).

An example of a session-layer protocol is the OSI protocol suite session-layer protocol, also known as X.225 or ISO 8327. In case of a connection loss this protocol may try to recover the connection. If a connection is not used for a long period, the session-layer protocol may close it and re-open it. It provides for either full duplex or half-duplex operation and provides synchronization points in the stream of exchanged messages.

Other examples of session layer implementations include Zone Information Protocol (ZIP) – the AppleTalk protocol that coordinates the name binding process, and Session Control Protocol (SCP) – the DECnet Phase IV session-layer protocol.

Within the service layering semantics of the OSI network architecture, the session layer responds to service requests from the presentation layer and issues service requests to the transport layer.
