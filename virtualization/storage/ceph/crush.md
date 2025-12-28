# **[crush](https://ceph.io/assets/pdfs/weil-crush-sc06.pdf)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../a_status/detailed_status.md)**\
**[Back to Main](../../../../../README.md)**

CRUSH: Controlled, Scalable, Decentralized Placement of Replicated Data
Sage A. Weil Scott A. Brandt Ethan L. Miller Carlos Maltzahn
Storage Systems Research Center
University of California, Santa Cruz
{sage, scott, elm, carlosm}@cs.ucsc.ed

## Abstract

Emerging large-scale distributed storage systems are faced
with the task of distributing petabytes of data among tens
or hundreds of thousands of storage devices. Such systems
must evenly distribute data and workload to efficiently utilize available resources and maximize system performance,
while facilitating system growth and managing hardware
failures. We have developed CRUSH, a scalable pseudorandom data distribution function designed for distributed
object-based storage systems that efficiently maps data objects to storage devices without relying on a central directory. Because large systems are inherently dynamic, CRUSH
is designed to facilitate the addition and removal of storage
while minimizing unnecessary data movement. The algorithm accommodates a wide variety of data replication and
reliability mechanisms and distributes data in terms of userdefined policies that enforce separation of replicas across
failure domains.

## 1 Introduction

Object-based storage is an emerging architecture that
promises improved manageability, scalability, and performance [Azagury et al. 2003]. Unlike conventional blockbased hard drives, object-based storage devices (OSDs) manage disk block allocation internally, exposing an interface
that allows others to read and write to variably-sized, named
objects. In such a system, each file’s data is typically
striped across a relatively small number of named objects
distributed throughout the storage cluster. Objects are replicated across multiple devices (or employ some other data
redundancy scheme) in order to protect against data loss in
the presence of failures. Object-based storage systems simplify data layout by replacing large block lists with small
object lists and distributing the low-level block allocation
problem. Although this vastly improves scalability by reducing file allocation metadata and complexity, mental task of distributing data among thousands of storage devices—typically with varying capacities and performance characteristics—remains.

Most systems simply write new data to underutilized devices. The fundamental problem with this approach is that
data is rarely, if ever, moved once it is written. Even a perfect distribution will become imbalanced when the storage
system is expanded, because new disks either sit empty or
contain only new data. Either old or new disks may be busy,
depending on the system workload, but only the rarest of
conditions will utilize both equally to take full advantage of
available resources.

A robust solution is to distribute all data in a system randomly among available storage devices. This leads to a probabilistically balanced distribution and uniformly mixes old
and new data together. When new storage is added, a random
sample of existing data is migrated onto new storage devices
to restore balance. This approach has the critical advantage
that, on average, all devices will be similarly loaded, allowing the system to perform well under any potential workload [Santos et al. 2000]. Furthermore, in a large storage
system, a single large file will be randomly distributed across
a large set of available devices, providing a high level of parallelism and aggregate bandwidth. However, simple hashbased distribution fails to cope with changes in the number of
devices, incurring a massive reshuffling of data. Further, existing randomized distribution schemes that decluster replication by spreading each disk’s replicas across many other
devices suffer from a high probability of data loss from coincident device failures.

We have developed CRUSH (Controlled Replication Under Scalable Hashing), a pseudo-random data distribution
algorithm that efficiently and robustly distributes object
replicas across a heterogeneous, structured storage cluster.
CRUSH is implemented as a pseudo-random, deterministic
function that maps an input value, typically an object or object group identifier, to a list of devices on which to store
object replicas. This differs from conventional approaches
in that data placement does not rely on any sort of per-file
or per-object directory—CRUSH needs only a compact, hierarchical description of the devices comprising the storage
cluster and knowledge of the replica placement policy. This
approach has two key advantages: first, it is completely distributed such that any party in a large system can independently calculate the location of any object; and second, what little metadata is required is mostly static, changing only
when devices are added or removed.

CRUSH is designed to optimally distribute data to utilize available resources, efficiently reorganize data when
storage devices are added or removed, and enforce flexible
constraints on object replica placement that maximize data
safety in the presence of coincident or correlated hardware
failures. A wide variety of data safety mechanisms are supported, including n-way replication (mirroring), RAID parity
schemes or other forms of erasure coding, and hybrid approaches (e. g., RAID-10). These features make CRUSH ideally suited for managing object distribution in extremely large (multi-petabyte) storage systems where scalability, performance, and reliability are critically important.

## 2 Related Work

Object-based storage has recently garnered significant interest as a mechanism for improving the scalability of storage systems. A number of research and production file
systems have adopted an object-based approach, including the seminal NASD file system [Gobioff et al. 1997],
the Panasas file system [Nagle et al. 2004], Lustre [Braam
2004], and others [Rodeh and Teperman 2003; Ghemawat
et al. 2003]. Other block-based distributed file systems like
GPFS [Schmuck and Haskin 2002] and Federated Array of
Bricks (FAB) [Saito et al. 2004] face a similar data distribution challenge. In these systems a semi-random or heuristicbased approach is used to allocate new data to storage devices with available capacity, but data is rarely relocated
to maintain a balanced distribution over time. More importantly, all of these systems locate data via some sort of
metadata directory, while CRUSH relies instead on a compact cluster description and deterministic mapping function.
This distinction is most significant when writing data, as systems utilizing CRUSH can calculate any new data’s storage target without consulting a central allocator. The Sorrento [Tang et al. 2004] storage system’s use of consistent
hashing [Karger et al. 1997] most closely resembles CRUSH,
but lacks support for controlled weighting of devices, a wellbalanced distribution of data, and failure domains for improving data safety.

Although the data migration problem has been studied extensively in the context of systems with explicit allocation
maps [Anderson et al. 2001; Anderson et al. 2002], such approaches have heavy metadata requirements that functional
approaches like CRUSH avoid. Choy, et al. [1996] describe
algorithms for distributing data over disks which move an
optimal number of objects as disks are added, but do not
support weighting, replication, or disk removal. Brinkmann,
et al. [2000] use hash functions to distribute data to a heterogeneous but static cluster. SCADDAR [Goel et al. 2002]
addresses the addition and removal of storage, but only supports a constrained subset of replication strategies. None of
these approaches include CRUSH’s flexibility or failure domains for improved reliability.

CRUSH most closely resembles the RUSH [Honicky and
Miller 2004] family of algorithms upon which it is based.
RUSH remains the only existing set of algorithms in the literature that utilizes a mapping function in place of explicit
metadata and supports the efficient addition and removal of
weighted devices. Despite these basic properties, a number
of issues make RUSH an insufficient solution in practice.
CRUSH fully generalizes the useful elements of RUSHP and
RUSHT while resolving previously unaddressed reliability
and replication issues, and offering improved performance
and flexibility.

## 3 The CRUSH algorithm

The CRUSH algorithm distributes data objects among storage devices according to a per-device weight value, approximating a uniform probability distribution. The distribution
is controlled by a hierarchical cluster map representing the
available storage resources and composed of the logical elements from which it is built. For example, one might describe a large installation in terms of rows of server cabinets,
cabinets filled with disk shelves, and shelves filled with storage devices. The data distribution policy is defined in terms
of placement rules that specify how many replica targets are
chosen from the cluster and what restrictions are imposed
on replica placement. For example, one might specify that
three mirrored replicas are to be placed on devices in different physical cabinets so that they do not share the same
electrical circuit.
Given a single integer input value x, CRUSH will output
an ordered list ~R of n distinct storage targets. CRUSH utilizes a strong multi-input integer hash function whose inputs
include x, making the mapping completely deterministic and
independently calculable using only the cluster map, placement rules, and x. The distribution is pseudo-random in that
there is no apparent correlation between the resulting output
from similar inputs or in the items stored on any storage device. We say that CRUSH generates a declustered distribution of replicas in that the set of devices sharing replicas for
one item also appears to be independent of all other items.
