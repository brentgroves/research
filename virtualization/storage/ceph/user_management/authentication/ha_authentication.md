# **[High Availability Authentication](https://docs.ceph.com/en/reef/architecture/#high-availability-authentication)**

The cephx authentication system is used by Ceph to authenticate users and daemons and to protect against man-in-the-middle attacks.

Note

The cephx protocol does not address data encryption in transport (for example, SSL/TLS) or encryption at rest.

cephx uses shared secret keys for authentication. This means that both the client and the monitor cluster keep a copy of the client’s secret key.

The cephx protocol makes it possible for each party to prove to the other that it has a copy of the key without revealing it. This provides mutual authentication and allows the cluster to confirm (1) that the user has the secret key and (2) that the user can be confident that the cluster has a copy of the secret key.

As stated in Scalability and High Availability, Ceph does not have any centralized interface between clients and the Ceph object store. By avoiding such a centralized interface, Ceph avoids the bottlenecks that attend such centralized interfaces. However, this means that clients must interact directly with OSDs. Direct interactions between Ceph clients and OSDs require authenticated connections. The cephx authentication system establishes and sustains these authenticated connections.

The cephx protocol operates in a manner similar to Kerberos.

A user invokes a Ceph client to contact a monitor. Unlike Kerberos, each monitor can authenticate users and distribute keys, which means that there is no single point of failure and no bottleneck when using cephx. The monitor returns an authentication data structure that is similar to a Kerberos ticket. This authentication data structure contains a session key for use in obtaining Ceph services. The session key is itself encrypted with the user’s permanent secret key, which means that only the user can request services from the Ceph Monitors. The client then uses the session key to request services from the monitors, and the monitors provide the client with a ticket that authenticates the client against the OSDs that actually handle data. Ceph Monitors and OSDs share a secret, which means that the clients can use the ticket provided by the monitors to authenticate against any OSD or metadata server in the cluster.

Like Kerberos tickets, cephx tickets expire. An attacker cannot use an expired ticket or session key that has been obtained surreptitiously. This form of authentication prevents attackers who have access to the communications medium from creating bogus messages under another user’s identity and prevents attackers from altering another user’s legitimate messages, as long as the user’s secret key is not divulged before it expires.

An administrator must set up users before using cephx. In the following diagram, the client.admin user invokes ceph auth get-or-create-key from the command line to generate a username and secret key. Ceph’s auth subsystem generates the username and key, stores a copy on the monitor(s), and transmits the user’s secret back to the client.admin user. This means that the client and the monitor share a secret key.

Note

The client.admin user must provide the user ID and secret key to the user in a secure manner.

![i1](https://docs.ceph.com/en/reef/_images/ditaa-98e822f6a4f486de7dc55635f9fb80d356ad931f.png)

Here is how a client authenticates with a monitor. The client passes the user name to the monitor. The monitor generates a session key that is encrypted with the secret key associated with the username. The monitor transmits the encrypted ticket to the client. The client uses the shared secret key to decrypt the payload. The session key identifies the user, and this act of identification will last for the duration of the session. The client requests a ticket for the user, and the ticket is signed with the session key. The monitor generates a ticket and uses the user’s secret key to encrypt it. The encrypted ticket is transmitted to the client. The client decrypts the ticket and uses it to sign requests to OSDs and to metadata servers in the cluster.

![i2](https://docs.ceph.com/en/reef/_images/ditaa-22b3096a0b880cfcdc7995b8d870653c71bd5244.png)

The cephx protocol authenticates ongoing communications between the clients and Ceph daemons. After initial authentication, each message sent between a client and a daemon is signed using a ticket that can be verified by monitors, OSDs, and metadata daemons. This ticket is verified by using the secret shared between the client and the daemon.

![i3](https://docs.ceph.com/en/reef/_images/ditaa-3a51d20eaaf90e1071e7dc84ea1fd784896d4b99.png)

This authentication protects only the connections between Ceph clients and Ceph daemons. The authentication is not extended beyond the Ceph client. If a user accesses the Ceph client from a remote host, cephx authentication will not be applied to the connection between the user’s host and the client host.

See Cephx Config Guide for more on configuration details.

See User Management for more on user management.

See A Detailed Description of the Cephx Authentication Protocol for more on the distinction between authorization and authentication and for a step-by-step explanation of the setup of cephx tickets and session keys.
