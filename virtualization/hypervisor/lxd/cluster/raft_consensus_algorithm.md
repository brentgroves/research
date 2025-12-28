# **[Raft consensus algorithm](https://raft.github.io/)

What is Raft?
Raft is a consensus algorithm that is designed to be easy to understand. It's equivalent to Paxos in fault-tolerance and performance. The difference is that it's decomposed into relatively independent subproblems, and it cleanly addresses all major pieces needed for practical systems. We hope Raft will make consensus available to a wider audience, and that this wider audience will be able to develop a variety of higher quality consensus-based systems than are available today.

## Hold on—what is consensus?

Consensus is a fundamental problem in fault-tolerant distributed systems. Consensus involves multiple servers agreeing on values. Once they reach a decision on a value, that decision is final. Typical consensus algorithms make progress when any majority of their servers is available; for example, a cluster of 5 servers can continue to operate even if 2 servers fail. If more servers fail, they stop making progress (but will never return an incorrect result).

Consensus typically arises in the context of replicated state machines, a general approach to building fault-tolerant systems. Each server has a state machine and a log. The state machine is the component that we want to make fault-tolerant, such as a hash table. It will appear to clients that they are interacting with a single, reliable state machine, even if a minority of the servers in the cluster fail. Each state machine takes as input commands from its log. In our hash table example, the log would include commands like set x to 3. A consensus algorithm is used to agree on the commands in the servers' logs. The consensus algorithm must ensure that if any state machine applies set x to 3 as the nth command, no other state machine will ever apply a different nth command. As a result, each state machine processes the same series of commands and thus produces the same series of results and arrives at the same series of states.

## Raft Visualization

Here's a Raft cluster running in your browser. You can interact with it to see Raft in action. Five servers are shown on the left, and their logs are shown on the right. We hope to create a screencast soon to explain what's going on. This visualization (RaftScope) is still pretty rough around the edges; pull requests would be very welcome.

The **[Secret Lives of Data](http://thesecretlivesofdata.com/raft/)** is a different visualization of Raft. It's more guided and less interactive, so it may be a gentler starting point.

Publications
This is "the Raft paper", which describes Raft in detail: In Search of an Understandable Consensus Algorithm (Extended Version) by Diego Ongaro and John Ousterhout. A slightly shorter version of this paper received a Best Paper Award at the 2014 USENIX Annual Technical Conference.

Diego Ongaro's Ph.D. dissertation expands on the content of the paper in much more detail, and it includes a simpler cluster membership change algorithm. The dissertation also includes a formal specification of Raft written in TLA+; a slightly updated version of that specification is here.

More Raft-related papers:

Doug Woos, James R. Wilcox, Steve Anton, Zachary Tatlock, Michael D. Ernst, and Thomas Anderson.
Planning for Change in a Formal Verification of the Raft Consensus Protocol.
Certified Programs and Proofs (CPP), January 2016.

James R. Wilcox, Doug Woos, Pavel Panchekha, Zachary Tatlock, Xi Wang, Michael D. Ernst, and Thomas Anderson.
Verdi: A Framework for Implementing and Verifying Distributed Systems.
Programming Language Design and Implementation (PLDI), June 2015.

Hugues Evrard and Frédéric Lang.
Automatic Distributed Code Generation from Formal Models of Asynchronous Concurrent Processes.
Parallel, Distributed, and Network-Based Processing (PDP), March 2015.

Heidi Howard, Malte Schwarzkopf, Anil Madhavapeddy, and Jon Crowcroft.
Raft Refloated: Do We Have Consensus?.
SIGOPS Operating Systems Review, January 2015.

Heidi Howard.
ARC: Analysis of Raft Consensus.
University of Cambridge, Computer Laboratory, UCAM-CL-TR-857, July 2014.
