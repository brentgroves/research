# unit

In Juju, a unit is a deployed charm.

An application’s units occupy machines.

Simple applications may be deployed with a single application unit, but it is possible for an individual application to have multiple units running on different machines. For example, one may deploy a single MongoDB application, and specify that it should run three units (with one machine per unit) so that the replica set is resilient to failures.

A unit is always named on the pattern <application>/<unit ID>, where <application> is the name of the application and the <unit ID> is its ID number or, for the leader unit, the keyword leader. For example, mysql/0 or mysql/leader. Note: the number designation is a static reference to a unique entity whereas the leader designation is a dynamic reference to whichever unit happens to be elected by Juju to be the leader .
