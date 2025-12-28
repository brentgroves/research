# file test

## write to same file from 2 locations

Files quickly became out of sync between windows and linux mounts.
After a short time I could reopen the file and it would show a consistent value, but there is no indication when both are writing to the same file at the same time.
From ubuntu:

```bash
sudo -i
mount -t ceph :/ /mnt/mycephfs/ -o name=admin,fs=indFs

ll /mnt/mycephfs
total 512
-rw-r--r-- 1 root  root   0 Jul 18 17:13 test2.md
-rw-rw-r-- 1 brent brent 16 Jul 18 17:25 test3.md
-rw-r--r-- 1 root  root   0 Jul 18 17:15 test4.md
-rw-rw-r-- 1 brent brent  0 Jul 18 17:09 test.md

# test4 and test4 are locked
```

From Windows:

```bash
```
