# **[try 1]()**

Keep this try simple.

Networking:
Use only 1 1Gib network interface for everything.

## note

micro12 only has a 67gb drive for the os. on the next try install the os on th3 512gb ssd drives.

```yaml
micro11:
  vlan: eno150
  network: "10.188.50.0/24"
  ip: "10.188.50.201"
  ceph:
    uplink: eno250
  disks:
    os: sda3
    local_storage: sdb
    distributed_storage: sdc

micro12:
  vlan: eno150
  network: "10.188.50.0/24"
  ip: "10.188.50.202"
  ceph:
    uplink: eno250
  disks:
    os: sdc3
    local_storage: sda
    distributed_storage: sdb

micro13:
  vlan: eno150
  network: "10.188.50.0/24"
  ip: "10.188.50.203"
  ceph:
    uplink: eno250
  disks:
    os: sda3
    local_storage: sdb
    distributed_storage: sdc

```

## **[install MicroCloud](install_microcloud.md)**

## **[initialize MicroCloud](./initialize_microcloud.md)**
