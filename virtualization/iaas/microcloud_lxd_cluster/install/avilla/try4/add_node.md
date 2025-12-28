# **[add node](https://www.youtube.com/watch?v=M0y0hQ16YuE&t=359s)**

time: 13:25

## **[add machine](https://documentation.ubuntu.com/microcloud/stable/microcloud/how-to/add_machine/)**

```bash
# micro11
microcloud add
Waiting for services to start ...
Use the following command on systems that you want to join the cluster:

 microcloud join

When requested enter the passphrase:

 
marbles coverless attic bonnet
Verify the fingerprint "c2e0d413926f" is displayed on joining systems.
Waiting to detect systems ...
Error: System "micro12" failed to join the cluster: Failed to update cluster status of services: Failed to join "LXD" cluster: Failed to configure cluster: Failed to setup cluster trust: Failed to add server cert to cluster: The provided certificate isn't valid yet
micro11 date
Mon Jul 14 11:30:28 PM UTC 2025
micro12
Mon Jul 14 11:35:14 PM UTC 2025
micro13
Mon Jul 14 11:35:14 PM UTC 2025
# password
```

```bash
# micro12
# multicast allowed
microcloud join
# unicast only
microcloud join --initiator-address 10.188.50.201

root@micro12:~# microcloud join
Waiting for services to start ...
Select an address for MicroCloud's internal traffic:
Space to select; enter to confirm; type to filter results.
Up/down to move; right to select all; left to select none.
       +----------------+----------+
       |    ADDRESS     |  IFACE   |
       +----------------+----------+
> [x]  | 10.188.50.202  | eno150   |
  [ ]  | 10.188.220.202 | eno1220  |
  [ ]  | 10.187.220.202 | eno11220 |
       +----------------+----------+
 Using address "10.188.50.202" for MicroCloud

Verify the fingerprint "8a12b663e4db" is displayed on the other system.
Specify the passphrase for joining the system: 

# micro13
microcloud join
Using address "10.188.50.203" for MicroCloud

Verify the fingerprint "389e4add5cc6" is displayed on the other system.
Specify the passphrase for joining the system: 

```

communication secured with password. secured channel then used to pass a join tokens.

```bash
Select exactly one disk from each cluster member:
Space to select; enter to confirm; type to filter results.
Up/down to move; right to select all; left to select none.
       +----------+------------------------+-----------+-------+------------------------------------------------------------+
       | LOCATION |         MODEL          | CAPACITY  | TYPE  |                            PATH                            |
       +----------+------------------------+-----------+-------+------------------------------------------------------------+
  [ ]  | micro12  | HL-DT-ST DVD-ROM DU70N | 0B        | cdrom | /dev/disk/by-id/wwn-0x5001480000000000                     |
  [x]  | micro12  | PERC H710              | 1.82TiB   | scsi  | /dev/disk/by-id/wwn-0x6c81f660dba9cc002fedeb29d615b9b9     |
  [ ]  | micro12  | PERC H710              | 1.82TiB   | scsi  | /dev/disk/by-id/wwn-0x6c81f660dba9cc002fedeb53d8986a2b     |
  [ ]  | micro12  | PERC H710              | 465.25GiB | scsi  | /dev/disk/by-id/wwn-0x6c81f660dba9cc002ffb0029198533d2     |
  [ ]  | micro13  | HL-DT-ST DVD-ROM DU70N | 0B        | cdrom | /dev/disk/by-id/wwn-0x5001480000000000                     |
  [ ]  | micro13  | Internal Dual SD       | 1.90GiB   | usb   | /dev/disk/by-id/usb-Dell_Internal_Dual_SD_0123456789AB-0:0 |
> [x]  | micro13  | PERC H710              | 1.82TiB   | scsi  | /dev/disk/by-id/wwn-0x6c81f660dbaa01002fef0cd525840392     |
  [ ]  | micro13  | PERC H710              | 1.82TiB   | scsi  | /dev/disk/by-id/wwn-0x6c81f660dbaa01002fef0cf4275f32f1     |
  [ ]  | micro13  | PERC H710              | 465.25GiB | scsi  | /dev/disk/by-id/wwn-0x6c81f660dbaa01002ffaf94736017676     |
       +----------+------------------------+-----------+-------+------------------------------------------------------------+

       Select which disks to wipe:
Space to select; enter to confirm; type to filter results.
Up/down to move; right to select all; left to select none.
       +----------+------------------------+-----------+-------+------------------------------------------------------------+
       | LOCATION |         MODEL          | CAPACITY  | TYPE  |                            PATH                            |
       +----------+------------------------+-----------+-------+------------------------------------------------------------+
  [x]  | micro12  | PERC H710              | 1.82TiB   | scsi  | /dev/disk/by-id/wwn-0x6c81f660dba9cc002fedeb29d615b9b9     |
> [x]  | micro13  | PERC H710              | 1.82TiB   | scsi  | /dev/disk/by-id/wwn-0x6c81f660dbaa01002fef0cd525840392     |
       +----------+------------------------+-----------+-------+------------------------------------------------------------+

Do you want to encrypt the selected disks? (yes/no) [default=no]: yes
Interface "eno150" ("10.188.50.203/24") detected on cluster member "micro13"
Interface "eno150" ("10.188.50.201/24") detected on cluster member "micro11"
Interface "eno150" ("10.188.50.202/24") detected on cluster member "micro12"
Configure distributed networking? (yes/no) [default=yes]: 

Initializing new services
Awaiting cluster formation ...
Error: System "micro12" failed to join the cluster: Failed to update cluster status of services: Failed to join "MicroCeph" cluster: failed to request disk addition Post "http://control.socket/1.0/services/microceph/1.0/disks": context deadline exceeded

root@micro11:~# microcloud cluster list
+---------+--------------------+-------+------------------------------------------------------------------+--------+
|  NAME   |      ADDRESS       | ROLE  |                           FINGERPRINT                            | STATUS |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
| micro11 | 10.188.50.201:9443 | voter | ab52ab70fe321d44f5d52ef6a0b04fc6abb62421d2da8b989e89103ffbaf5293 | ONLINE |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
| micro12 | 10.188.50.202:9443 | voter | 8a12b663e4db75b59e1907d639e2d2b0cd03ecd5fb6d06519ff172daedeccc00 | ONLINE |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
| micro13 | 10.188.50.203:9443 | voter | 389e4add5cc658ae8c0430d88fb91296e29e628af84dea557947621184c28efc | ONLINE |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
root@micro11:~# microceph cluster list
+---------+--------------------+-------+------------------------------------------------------------------+--------+
|  NAME   |      ADDRESS       | ROLE  |                           FINGERPRINT                            | STATUS |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
| micro11 | 10.188.50.201:7443 | voter | 5808ceb7f4a6495842e1631b6044869b8264b944d773c49f755b43e27c7c5a15 | ONLINE |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
| micro12 | 10.188.50.202:7443 | spare | b2611566a85e90e7ced3cca45a786ca1fb268cd1dcd289e80db8d02293926877 | ONLINE |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
root@micro11:~# microovn cluster list
+---------+--------------------+-------+------------------------------------------------------------------+--------+
|  NAME   |      ADDRESS       | ROLE  |                           FINGERPRINT                            | STATUS |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
| micro11 | 10.188.50.201:6443 | voter | 96f4464e62c8244d37e77517d3faf43d63e73d33194931eaed215308cd410d9d | ONLINE |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
| micro12 | 10.188.50.202:6443 | spare | a9e489f46625745fc13f1d852402786752170a5a927b9d584b613c76cbf01b9d | ONLINE |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
```

## failed adding micro13 to **[microceph cluster](https://canonical-microceph.readthedocs-hosted.com/latest/how-to/multi-node/#prepare-the-cluster)**

```bash
microceph cluster add micro13
eyJzZWNyZXQiOiI5OGYzNWI0OTQxOWZhODBhNjQ5MjI5YzY2YzdiZTcwYTg2YjgwNTg5NTE2MDQwZTNkN2Q1OWE1NTY3ZTZjM2Q0IiwiZmluZ2VycHJpbnQiOiI2NmU3ZTdmOWRjZDdmZDExNTMyNTM1ZWM2ZDg3ODYyN2UwNTAzMmM3ZjJhMjBkNmY5YjZiODcyOGIxNjZhYTY5Iiwiam9pbl9hZGRyZXNzZXMiOlsiMTAuMTg4LjUwLjIwMTo3NDQzIiwiMTAuMTg4LjUwLjIwMjo3NDQzIl19

microceph cluster join eyJzZWNyZXQiOiI5OGYzNWI0OTQxOWZhODBhNjQ5MjI5YzY2YzdiZTcwYTg2YjgwNTg5NTE2MDQwZTNkN2Q1OWE1NTY3ZTZjM2Q0IiwiZmluZ2VycHJpbnQiOiI2NmU3ZTdmOWRjZDdmZDExNTMyNTM1ZWM2ZDg3ODYyN2UwNTAzMmM3ZjJhMjBkNmY5YjZiODcyOGIxNjZhYTY5Iiwiam9pbl9hZGRyZXNzZXMiOlsiMTAuMTg4LjUwLjIwMTo3NDQzIiwiMTAuMTg4LjUwLjIwMjo3NDQzIl19

sudo microceph disk add /dev/sdc --wipe
Error: failed to request disk addition Post "http://control.socket/1.0/disks": context deadline exceeded

microovn cluster add micro13

microovn cluster join eyJzZWNyZXQiOiI3OGY5ODkwYzQxNWI3Mjg4NDViZWZlN2RhNTVkZThjY2IxZjY2MWU2OWU4YzhhZmZkNWU1ZTA1YzFhMzNjMTZlIiwiZmluZ2VycHJpbnQiOiIyMDYxMGVhN2U2Mjg4ZjAzMDcwZWY4N2Y1MjE1MWRlOGU5YmZhN2JjM2ViY2FlMDExZWRlMjI3NWU3ZmQ4MzI1Iiwiam9pbl9hZGRyZXNzZXMiOlsiMTAuMTg4LjUwLjIwMjo2NDQzIiwiMTAuMTg4LjUwLjIwMTo2NDQzIl19

microovn cluster list
+---------+---------------------+-------+------------------------------------------------------------------+--------+
|  NAME   |       ADDRESS       | ROLE  |                           FINGERPRINT                            | STATUS |
+---------+---------------------+-------+------------------------------------------------------------------+--------+
| micro11 | 10.188.50.201:6443  | voter | 96f4464e62c8244d37e77517d3faf43d63e73d33194931eaed215308cd410d9d | ONLINE |
+---------+---------------------+-------+------------------------------------------------------------------+--------+
| micro12 | 10.188.50.202:6443  | voter | a9e489f46625745fc13f1d852402786752170a5a927b9d584b613c76cbf01b9d | ONLINE |
+---------+---------------------+-------+------------------------------------------------------------------+--------+
| micro13 | 10.188.220.203:6443 | voter | 286ed411a7d534173191edd0905e1e677e80351b60536fa32d634d7a3ea3d413 | ONLINE |
+---------+---------------------+-------+------------------------------------------------------------------+--------+

microcloud status

 Status: ERROR

 ┃ ⨯ LXD is not found on micro13, micro12

lxc cluster add micro12

lxc cluster join eyJzZXJ2ZXJfbmFtZSI6Im1pY3JvMTIiLCJmaW5nZXJwcmludCI6IjJjOWNjMWY1YWI5ZDllZTZhOWFmNjRjNTg1N2ZjZDY4YzExMzlhYzJhNjQ0MWM2M2Y1OWFmODYzZmE5OGQ2YmQiLCJhZGRyZXNzZXMiOlsiMTAuMTg4LjUwLjIwMTo4NDQzIl0sInNlY3JldCI6IjRlZmVlZjA2YjhlZjk4MmE1NGVlNWQzMWIxZDRkYzUxYmY4YWNlZWJhYjYxNGVjNjEyNWE0MDI3YjEzMmRhZDQiLCJleHBpcmVzX2F0IjoiMjAyNS0wNy0xNVQwMDo0MDoyOS4xNzgxMDE4NjRaIn0=

lxc cluster add micro13
Member micro13 join token:
eyJzZXJ2ZXJfbmFtZSI6Im1pY3JvMTMiLCJmaW5nZXJwcmludCI6IjJjOWNjMWY1YWI5ZDllZTZhOWFmNjRjNTg1N2ZjZDY4YzExMzlhYzJhNjQ0MWM2M2Y1OWFmODYzZmE5OGQ2YmQiLCJhZGRyZXNzZXMiOlsiMTAuMTg4LjUwLjIwMTo4NDQzIiwiMTAuMTg4LjUwLjIwMjo4NDQzIl0sInNlY3JldCI6ImQ5ZmM3ODBhZmFlZDAwNjkzZmVmNDEyOWRjMDBkMjZhYmU3ZjE3ZmQ4ZDJjOWY0Y2E2ZDNkODlmODYxZWIxMDciLCJleHBpcmVzX2F0IjoiMjAyNS0wNy0xNVQwMDo0Mzo0NS44MDQzNzUxNDFaIn0=

Would you like a YAML "lxd init" preseed to be printed? (yes/no) [default=no]: yes
config: {}
networks: []
storage_pools: []
storage_volumes: []
profiles: []
projects: []
cluster:
  server_name: micro13
  enabled: true
  member_config:
  - entity: network
    name: UPLINK
    key: parent
    value: ""
    description: '"parent" property for network "UPLINK"'
  - entity: storage-pool
    name: local
    key: source
    value: ""
    description: '"source" property for storage pool "local"'
  - entity: storage-pool
    name: local
    key: zfs.pool_name
    value: ""
    description: '"zfs.pool_name" property for storage pool "local"'
  - entity: storage-pool
    name: remote
    key: source
    value: ""
    description: '"source" property for storage pool "remote"'
  - entity: storage-pool
    name: remote-fs
    key: source
    value: ""
    description: '"source" property for storage pool "remote-fs"'
  cluster_address: 10.188.50.201:8443
  cluster_certificate: |
    -----BEGIN CERTIFICATE-----
    MIIB5jCCAWygAwIBAgIQUecW9fxb3qLf5UbHUOP5aDAKBggqhkjOPQQDAzAlMQww
    CgYDVQQKEwNMWEQxFTATBgNVBAMMDHJvb3RAbWljcm8xMTAeFw0yNTA3MTIyMDEw
    NDBaFw0zNTA3MTAyMDEwNDBaMCUxDDAKBgNVBAoTA0xYRDEVMBMGA1UEAwwMcm9v
    dEBtaWNybzExMHYwEAYHKoZIzj0CAQYFK4EEACIDYgAEEu+Vh/li8MzXDQlxsWmO
    PBx9p3fyIswp9E5oaaJ03O2svVCdyo1qz4vLigmVMBF7LiXeuw5u9O9bAb26ZTL9
    gNTnrl99sUz2xbGNcFlGiPPNQzdiTCkXQ37T9isvrNPRo2EwXzAOBgNVHQ8BAf8E
    BAMCBaAwEwYDVR0lBAwwCgYIKwYBBQUHAwEwDAYDVR0TAQH/BAIwADAqBgNVHREE
    IzAhggdtaWNybzExhwR/AAABhxAAAAAAAAAAAAAAAAAAAAABMAoGCCqGSM49BAMD
    A2gAMGUCMBAiYz33pYj4cLwtfndOr3FhlU2+gQdLfRfk6KHmWUbLQo/+/R6P6dIj
    3/EKomgCowIxALmnBl5V/DVriBS5dS+8HB41fQc4tKAgEzqjFftBfF6hhVcz2UvQ
    A4dgpk19LdobpQ==
    -----END CERTIFICATE-----
  server_address: 10.188.220.203:8443
  cluster_password: ""
  cluster_token: ""
  cluster_certificate_path: ""

microcloud status

 Status: HEALTHY

┌─────────┬───────────────┬──────┬─────────────────┬────────────────────────┬────────┐
│  Name   │    Address    │ OSDs │ MicroCeph Units │     MicroOVN Units     │ Status │
├─────────┼───────────────┼──────┼─────────────────┼────────────────────────┼────────┤
│ micro11 │ 10.188.50.201 │  1   │   mds,mgr,mon   │ central,chassis,switch │ ONLINE │
│ micro12 │ 10.188.50.202 │  1   │   mds,mgr,mon   │ central,chassis,switch │ ONLINE │
│ micro13 │ 10.188.50.203 │  1   │   mds,mgr,mon   │ central,chassis,switch │ ONLINE │
└─────────┴───────────────┴──────┴─────────────────┴────────────────────────┴────────┘
```

## move

```bash
lxc move v1 --target micro13
ERROR
