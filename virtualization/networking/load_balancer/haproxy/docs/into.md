# **[](https://docs.haproxy.org/3.2/intro.html)**

## Introduction to HAProxy

HAProxy is written as "HAProxy" to designate the product, and as "haproxy" to
designate the executable program, software package or a process. However, both
are commonly used for both purposes, and are pronounced H-A-Proxy. Very early,
"haproxy" used to stand for "high availability proxy" and the name was written
in two separate words, though by now it means nothing else than "HAProxy".

## What HAProxy is and isn't

HAProxy is :

- a TCP proxy : it can accept a TCP connection from a listening socket,
    connect to a server and attach these sockets together allowing traffic to
    flow in both directions; IPv4, IPv6 and even UNIX sockets are supported on
    either side, so this can provide an easy way to translate addresses between
    different families.
- an HTTP reverse-proxy (called a "gateway" in HTTP terminology) : it presents
    itself as a server, receives HTTP requests over connections accepted on a
    listening TCP socket, and passes the requests from these connections to
    servers using different connections. It may use any combination of HTTP/1.x
    or HTTP/2 on any side and will even automatically detect the protocol
    spoken on each side when ALPN is used over TLS.

## What is ALPN? #

ALPN, or Application-Layer Protocol Negotiation, is a TLS extension that includes the protocol negotiation within the exchange of hello messages. ALPN is able to negotiate which protocol should be handled over a secure connection in a way that is more efficient and avoids additional round trips. In simpler terms, it's a way for a client and a server to agree on a protocol that they both support, and then use that protocol to communicate. The HTTP/2 protocol, makes use of ALPN to further decrease website load times and encrypt connections faster.

- an SSL terminator / initiator / offloader : SSL/TLS may be used on the
    connection coming from the client, on the connection going to the server,
    or even on both connections. A lot of settings can be applied per name
    (SNI), and may be updated at runtime without restarting. Such setups are
    extremely scalable and deployments involving tens to hundreds of thousands
    of certificates were reported.

  - a TCP normalizer : since connections are locally terminated by the operating
    system, there is no relation between both sides, so abnormal traffic such as
    invalid packets, flag combinations, window advertisements, sequence numbers,
    incomplete connections (SYN floods), or so will not be passed to the other
    side. This protects fragile TCP stacks from protocol attacks, and also
    allows to optimize the connection parameters with the client without having
    to modify the servers' TCP stack settings.
- an HTTP normalizer : when configured to process HTTP traffic, only valid
    complete requests are passed. This protects against a lot of protocol-based
    attacks. Additionally, protocol deviations for which there is a tolerance
    in the specification are fixed so that they don't cause problem on the
    servers (e.g. multiple-line headers).
  - an HTTP fixing tool : it can modify / fix / add / remove / rewrite the URL
    or any request or response header. This helps fixing interoperability issues
    in complex environments.
- a content-based switch : it can consider any element from the request to
    decide what server to pass the request or connection to. Thus it is possible
    to handle multiple protocols over a same port (e.g. HTTP, HTTPS, SSH).
  - a server load balancer : it can load balance TCP connections and HTTP
    requests. In TCP mode, load balancing decisions are taken for the whole
    connection. In HTTP mode, decisions are taken per request.
- a traffic regulator : it can apply some rate limiting at various points,
    protect the servers against overloading, adjust traffic priorities based on
    the contents, and even pass such information to lower layers and outer
    network components by marking packets.
- a protection against DDoS and service abuse : it can maintain a wide number
    of statistics per IP address, URL, cookie, etc and detect when an abuse is
    happening, then take action (slow down the offenders, block them, send them
    to outdated contents, etc).

- an observation point for network troubleshooting : due to the precision of
    the information reported in logs, it is often used to narrow down some
    network-related issues.
- an HTTP compression offloader : it can compress responses which were not
    compressed by the server, thus reducing the page load time for clients with
    poor connectivity or using high-latency, mobile networks.

- a caching proxy : it may cache responses in RAM so that subsequent requests
    for the same object avoid the cost of another network transfer from the
    server as long as the object remains present and valid. It will however not
    store objects to any persistent storage. Please note that this caching
    feature is designed to be maintenance free and focuses solely on saving
    haproxy's precious resources and not on save the server's resources. Caches
    designed to optimize servers require much more tuning and flexibility. If
    you instead need such an advanced cache, please use Varnish Cache, which
    integrates perfectly with haproxy, especially when SSL/TLS is needed on any
    side.
- a FastCGI gateway : FastCGI can be seen as a different representation of
    HTTP, and as such, HAProxy can directly load-balance a farm comprising any
    combination of FastCGI application servers without requiring to insert
    another level of gateway between them. This results in resource savings and
    a reduction of maintenance costs.

## HAProxy is not

- an explicit HTTP proxy, i.e. the proxy that browsers use to reach the
    internet. There are excellent open-source software dedicated for this task,
    such as Squid. However HAProxy can be installed in front of such a proxy to
    provide load balancing and high availability.

- a data scrubber : it will not modify the body of requests nor responses.

- a static web server : during startup, it isolates itself inside a chroot
    jail and drops its privileges, so that it will not perform any single file-
    system access once started. As such it cannot be turned into a static web
    server (dynamic servers are supported through FastCGI however). There are
    excellent open-source software for this such as Apache or Nginx, and
    HAProxy can be easily installed in front of them to provide load balancing,
    high availability and acceleration.

- a packet-based load balancer : it will not see IP packets nor UDP datagrams,
    will not perform NAT or even less DSR. These are tasks for lower layers.
    Some kernel-based components such as IPVS (Linux Virtual Server) already do
    this pretty well and complement perfectly with HAProxy.

## How HAProxy works

HAProxy is an event-driven, non-blocking engine combining a very fast I/O layer
with a priority-based, multi-threaded scheduler. As it is designed with a data
forwarding goal in mind, its architecture is optimized to move data as fast as
possible with the least possible operations. It focuses on optimizing the CPU
cache's efficiency by sticking connections to the same CPU as long as possible.
As such it implements a layered model offering bypass mechanisms at each level
ensuring data doesn't reach higher levels unless needed. Most of the processing
is performed in the kernel, and HAProxy does its best to help the kernel do the
work as fast as possible by giving some hints or by avoiding certain operation
when it guesses they could be grouped later. As a result, typical figures show
15% of the processing time spent in HAProxy versus 85% in the kernel in TCP or
HTTP close mode, and about 30% for HAProxy versus 70% for the kernel in HTTP
keep-alive mode.

A single process can run many proxy instances; configurations as large as
300000 distinct proxies in a single process were reported to run fine. A single
core, single CPU setup is far more than enough for more than 99% users, and as
such, users of containers and virtual machines are encouraged to use the
absolute smallest images they can get to save on operational costs and simplify
troubleshooting. However the machine HAProxy runs on must never ever swap, and
its CPU must not be artificially throttled (sub-CPU allocation in hypervisors)
nor be shared with compute-intensive processes which would induce a very high
context-switch latency.

Threading allows to exploit all available processing capacity by using one
thread per CPU core. This is mostly useful for SSL or when data forwarding
rates above 40 Gbps are needed. In such cases it is critically important to
avoid communications between multiple physical CPUs, which can cause strong
bottlenecks in the network stack and in HAProxy itself. While counter-intuitive
to some, the first thing to do when facing some performance issues is often to
reduce the number of CPUs HAProxy runs on.

HAProxy only requires the haproxy executable and a configuration file to run.
For logging it is highly recommended to have a properly configured syslog daemon
and log rotations in place. Logs may also be sent to stdout/stderr, which can be
useful inside containers. The configuration files are parsed before starting,
then HAProxy tries to bind all listening sockets, and refuses to start if
anything fails. Past this point it cannot fail anymore. This means that there
are no runtime failures and that if it accepts to start, it will work until it
is stopped.

Once HAProxy is started, it does exactly 3 things :

- process incoming connections;

- periodically check the servers' status (known as health checks);

- exchange information with other haproxy nodes.

Processing incoming connections is by far the most complex task as it depends
on a lot of configuration possibilities, but it can be summarized as the 9 steps
below :

- accept incoming connections from listening sockets that belong to a
    configuration entity known as a "frontend", which references one or multiple
    listening addresses;

- apply the frontend-specific processing rules to these connections that may
    result in blocking them, modifying some headers, or intercepting them to
    execute some internal applets such as the statistics page or the CLI;
- pass these incoming connections to another configuration entity representing
    a server farm known as a "backend", which contains the list of servers and
    the load balancing strategy for this server farm;

- apply the backend-specific processing rules to these connections;

- decide which server to forward the connection to according to the load
    balancing strategy;

- apply the backend-specific processing rules to the response data;

- apply the frontend-specific processing rules to the response data;

- emit a log to report what happened in fine details;

- in HTTP, loop back to the second step to wait for a new request, otherwise
    close the connection.
Frontends and backends are sometimes considered as half-proxies, since they only
look at one side of an end-to-end connection; the frontend only cares about the
clients while the backend only cares about the servers. HAProxy also supports
full proxies which are exactly the union of a frontend and a backend. When HTTP
processing is desired, the configuration will generally be split into frontends
and backends as they open a lot of possibilities since any frontend may pass a
connection to any backend. With TCP-only proxies, using frontends and backends
rarely provides a benefit and the configuration can be more readable with full
proxies.

## Basic features

This section will enumerate a number of features that HAProxy implements, some
of which are generally expected from any modern load balancer, and some of
which are a direct benefit of HAProxy's architecture. More advanced features
will be detailed in the next section.
Basic features : Proxying
Proxying is the action of transferring data between a client and a server over
two independent connections. The following basic features are supported by
HAProxy regarding proxying and connection management :

- Provide the server with a clean connection to protect them against any
    client-side defect or attack;
  - Listen to multiple IP addresses and/or ports, even port ranges;

  - Transparent accept : intercept traffic targeting any arbitrary IP address
    that doesn't even belong to the local system;

  - Server port doesn't need to be related to listening port, and may even be
    translated by a fixed offset (useful with ranges);

  - Transparent connect : spoof the client's (or any) IP address if needed
    when connecting to the server;

  - Provide a reliable return IP address to the servers in multi-site LBs;

  - Offload the server thanks to buffers and possibly short-lived connections
    to reduce their concurrent connection count and their memory footprint;

  - Optimize TCP stacks (e.g. SACK), congestion control, and reduce RTT impacts;

  - Support different protocol families on both sides (e.g. IPv4/IPv6/Unix);

  - Timeout enforcement : HAProxy supports multiple levels of timeouts depending
    on the stage the connection is, so that a dead client or server, or an
    attacker cannot be granted resources for too long;

  - Protocol validation: HTTP, SSL, or payload are inspected and invalid
    protocol elements are rejected, unless instructed to accept them anyway;

  - Policy enforcement : ensure that only what is allowed may be forwarded;

  - Both incoming and outgoing connections may be limited to certain network
    namespaces (Linux only), making it easy to build a cross-container,
    multi-tenant load balancer;

  - PROXY protocol presents the client's IP address to the server even for
    non-HTTP traffic. This is an HAProxy extension that was adopted by a number
    of third-party products by now, at least these ones at the time of writing :
    - client : haproxy, stud, stunnel, exaproxy, ELB, squid
    - server : haproxy, stud, postfix, exim, nginx, squid, node.js, varnish
Basic features : SSL
HAProxy's SSL stack is recognized as one of the most featureful according to
Google's engineers (<http://istlsfastyet.com/>). The most commonly used features
making it quite complete are :

  - SNI-based multi-hosting with no limit on sites count and focus on
    performance. At least one deployment is known for running 50000 domains
    with their respective certificates;

  - support for wildcard certificates reduces the need for many certificates ;

  - certificate-based client authentication with configurable policies on
    failure to present a valid certificate. This allows to present a different
    server farm to regenerate the client certificate for example;

  - authentication of the backend server ensures the backend server is the real
    one and not a man in the middle;

  - authentication with the backend server lets the backend server know it's
    really the expected haproxy node that is connecting to it;

  - TLS NPN and ALPN extensions make it possible to reliably offload SPDY/HTTP2
    connections and pass them in clear text to backend servers;

  - OCSP stapling further reduces first page load time by delivering inline an
    OCSP response when the client requests a Certificate Status Request;

  - Dynamic record sizing provides both high performance and low latency, and
    significantly reduces page load time by letting the browser start to fetch
    new objects while packets are still in flight;

  - permanent access to all relevant SSL/TLS layer information for logging,
    access control, reporting etc. These elements can be embedded into HTTP
    header or even as a PROXY protocol extension so that the offloaded server
    gets all the information it would have had if it performed the SSL
    termination itself.

  - Detect, log and block certain known attacks even on vulnerable SSL libs,
    such as the Heartbleed attack affecting certain versions of OpenSSL.

  - support for stateless session resumption (RFC 5077 TLS Ticket extension).
    TLS tickets can be updated from CLI which provides them means to implement
    Perfect Forward Secrecy by frequently rotating the tickets.
Basic features : Monitoring
HAProxy focuses a lot on availability. As such it cares about servers state,
and about reporting its own state to other network components :

  - Servers' state is continuously monitored using per-server parameters. This
    ensures the path to the server is operational for regular traffic;

  - Health checks support two hysteresis for up and down transitions in order
    to protect against state flapping;

  - Checks can be sent to a different address/port/protocol : this makes it
    easy to check a single service that is considered representative of multiple
    ones, for example the HTTPS port for an HTTP+HTTPS server.

  - Servers can track other servers and go down simultaneously : this ensures
    that servers hosting multiple services can fail atomically and that no one
    will be sent to a partially failed server;

  - Agents may be deployed on the server to monitor load and health : a server
    may be interested in reporting its load, operational status, administrative
    status independently from what health checks can see. By running a simple
    agent on the server, it's possible to consider the server's view of its own
    health in addition to the health checks validating the whole path;

  - Various check methods are available : TCP connect, HTTP request, SMTP hello,
    SSL hello, LDAP, SQL, Redis, send/expect scripts, all with/without SSL;

  - State change is notified in the logs and stats page with the failure reason
    (e.g. the HTTP response received at the moment the failure was detected). An
    e-mail can also be sent to a configurable address upon such a change ;

  - Server state is also reported on the stats interface and can be used to take
    routing decisions so that traffic may be sent to different farms depending
    on their sizes and/or health (e.g. loss of an inter-DC link);

  - HAProxy can use health check requests to pass information to the servers,
    such as their names, weight, the number of other servers in the farm etc.
    so that servers can adjust their response and decisions based on this
    knowledge (e.g. postpone backups to keep more CPU available);

  - Servers can use health checks to report more detailed state than just on/off
    (e.g. I would like to stop, please stop sending new visitors);

  - HAProxy itself can report its state to external components such as routers
    or other load balancers, allowing to build very complete multi-path and
    multi-layer infrastructures.

## Basic features : High availability

Just like any serious load balancer, HAProxy cares a lot about availability to
ensure the best global service continuity :

- Only valid servers are used ; the other ones are automatically evicted from
    load balancing farms ; under certain conditions it is still possible to
    force to use them though;
- Support for a graceful shutdown so that it is possible to take servers out
    of a farm without affecting any connection;

- Backup servers are automatically used when active servers are down and
    replace them so that sessions are not lost when possible. This also allows
    to build multiple paths to reach the same server (e.g. multiple interfaces);

- Ability to return a global failed status for a farm when too many servers
    are down. This, combined with the monitoring capabilities makes it possible
    for an upstream component to choose a different LB node for a given service;

- Stateless design makes it easy to build clusters : by design, HAProxy does
    its best to ensure the highest service continuity without having to store
    information that could be lost in the event of a failure. This ensures that
    a takeover is the most seamless possible;

- Integrates well with standard VRRP daemon keepalived : HAProxy easily tells
    keepalived about its state and copes very well with floating virtual IP
    addresses. Note: only use IP redundancy protocols (VRRP/CARP) over cluster-
    based solutions (Heartbeat, ...) as they're the ones offering the fastest,
    most seamless, and most reliable switchover.
