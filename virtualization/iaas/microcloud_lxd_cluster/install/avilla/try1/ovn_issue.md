# **[](https://discuss.linuxcontainers.org/t/ovn-cluster-ovn-nbctl-6641-database-connection-failed-connection-refused/22058)**

```bash
ovn-nbctl show
2025-07-11T20:20:37Z|00001|stream_ssl|ERR|SSL_use_certificate_file: error:8000000D:system library::Permission denied
2025-07-11T20:20:37Z|00002|stream_ssl|ERR|SSL_use_PrivateKey_file: error:10080002:BIO routines::system lib
2025-07-11T20:20:37Z|00003|stream_ssl|ERR|failed to load client certificates from /var/snap/microovn/common/data/pki/cacert.pem: error:0A080002:SSL routines::system lib
ovn-nbctl: : database connection failed (Address family not supported by protocol)

ovn-nbctl show
2025-07-11T20:25:04Z|00001|stream_ssl|ERR|SSL_use_certificate_file: error:8000000D:system library::Permission denied
2025-07-11T20:25:04Z|00002|stream_ssl|ERR|SSL_use_PrivateKey_file: error:10080002:BIO routines::system lib
2025-07-11T20:25:04Z|00003|stream_ssl|ERR|failed to load client certificates from /var/snap/microovn/common/data/pki/cacert.pem: error:0A080002:SSL routines::system lib
ovn-nbctl: : database connection failed (Address family not supported by protocol)

ovs-appctl -t /run/ovn/ovnnb_db.ctl cluster/status OVN_Northbound
