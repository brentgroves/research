# **[Install Custom Linux Desktop Distributions Remotely on LXD Servers | DevOps | Virtualization](https://m.youtube.com/watch?v=dfh_9aGQ9rE)**

## start here 17:20

```bash
lxc project list      
+-------------------+--------+----------+-----------------+-----------------+----------+---------------+---------------------+---------+
|       NAME        | IMAGES | PROFILES | STORAGE VOLUMES | STORAGE BUCKETS | NETWORKS | NETWORK ZONES |     DESCRIPTION     | USED BY |
+-------------------+--------+----------+-----------------+-----------------+----------+---------------+---------------------+---------+
| default (current) | YES    | YES      | YES             | YES             | YES      | YES           | Default LXD project | 13      |
+-------------------+--------+----------+-----------------+-----------------+----------+---------------+---------------------+---------+

lxc project show default
name: default
description: Default LXD project
config:
  features.images: "true"
  features.networks: "true"
  features.networks.zones: "true"
  features.profiles: "true"
  features.storage.buckets: "true"
  features.storage.volumes: "true"
used_by:
- /1.0/instances/open-osprey
- /1.0/profiles/default
- /1.0/images/c89a5fe8efa0a12a59ec3234c17c1bb5524688c66f48b0d7fd616b4c126aba8d
- /1.0/storage-pools/remote/volumes/virtual-machine/open-osprey
- /1.0/storage-pools/remote/volumes/image/c89a5fe8efa0a12a59ec3234c17c1bb5524688c66f48b0d7fd616b4c126aba8d
- /1.0/storage-pools/local/volumes/custom/images?target=micro11
- /1.0/storage-pools/local/volumes/custom/backups?target=micro11
- /1.0/storage-pools/local/volumes/custom/images?target=micro12
- /1.0/storage-pools/local/volumes/custom/backups?target=micro12
- /1.0/storage-pools/local/volumes/custom/images?target=micro13
- /1.0/storage-pools/local/volumes/custom/backups?target=micro13
- /1.0/networks/UPLINK
- /1.0/networks/default

```

<https://www.youtube.com/watch?app=desktop&v=dfh_9aGQ9rE>

## install virt-viewer

```bash
sudo apt install virt-viewer

lxc remote list
lxc remote switch micro11
# bring up virt-viewer after starting mystudio
lxc start mystudio -- console=vga
```
