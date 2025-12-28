# **[Erasure code](<https://docs.ceph.com/en/mimic/rados/operations/erasure-code/>)**

A Ceph pool is associated to a type to sustain the loss of an OSD (i.e. a disk since most of the time there is one OSD per disk). The default choice when **[creating a pool](https://docs.ceph.com/en/mimic/rados/operations/pools)** is replicated, meaning every object is copied on multiple disks. The **[Erasure Code](https://en.wikipedia.org/wiki/Erasure_code)** pool type can be used instead to save space.

## Creating a sample erasure coded pool

The simplest erasure coded pool is equivalent to RAID5 and requires at least three hosts:

```bash
$ ceph osd pool create ecpool 12 12 erasure
pool 'ecpool' created
$ echo ABCDEFGHI | rados --pool ecpool put NYAN -
$ rados --pool ecpool get NYAN -
ABCDEFGHI
```

Note the 12 in pool create stands for **[the number of placement groups](https://docs.ceph.com/en/mimic/rados/operations/pools)**

## Erasure code profiles

The default erasure code profile sustains the loss of a single OSD. It is equivalent to a replicated pool of size two but requires 1.5TB instead of 2TB to store 1TB of data. The default profile can be displayed with:

```bash
ceph osd erasure-code-profile get default
k=2
m=1
plugin=jerasure
crush-failure-domain=host
technique=reed_sol_van
```
