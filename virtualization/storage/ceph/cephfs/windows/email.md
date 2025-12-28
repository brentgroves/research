ceph-dokan.exe -c C:\Users\bgroves\ceph\ceph.conf -l x --client_fs indFs
ceph-dokan.exe -l x --client_fs indFs

[global]
    log to stderr = true
    ; Uncomment the following in order to use the Windows Event Log
    ; log to syslog = true

    run dir = C:/ProgramData/ceph/out
    crash dir = C:/ProgramData/ceph/out

    ; Use the following to change the cephfs client log level
    ; debug client = 2
[client]
    keyring = C:/ProgramData/ceph/keyring
    ; log file = C:/ProgramData/ceph/out/$name.$pid.log
    admin socket = C:/ProgramData/ceph/out/$name.$pid.asok

    ; client_permissions = true
    ; client_mount_uid = 1000
    ; client_mount_gid = 1000
[global]
    mon host = 10.188.50.201,10.188.50.202,10.188.50.203

[client.admin]
        key = AQCe1XZoBMNKKxAA1LaglugE/511b+gg6MWbiQ==
        caps mds = "allow *"
        caps mgr = "allow*"
        caps mon = "allow *"
        caps osd = "allow*"

[global]
    log to stderr = true
    ; Uncomment the following in order to use the Windows Event Log
    ; log to syslog = true

    run dir = C:/Users/bgroves/ceph/out
    crash dir = C:/Users/bgroves/ceph/out

    ; Use the following to change the cephfs client log level
    ; debug client = 2
[client]
    keyring = C:/Users/bgroves/ceph/keyring
    ; log file = C:/Users/bgroves/ceph/out/$name.$pid.log
    admin socket = C:/Users/bgroves/ceph/out/$name.$pid.asok

    ; client_permissions = true
    ; client_mount_uid = 1000
    ; client_mount_gid = 1000
[global]
    mon host = 10.188.50.201,10.188.50.202,10.188.50.203
