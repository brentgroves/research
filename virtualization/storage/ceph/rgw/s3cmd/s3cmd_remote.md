# microceph s3cmd remote

To configure s3cmd for use with a remote MicroCeph cluster, the primary step involves creating or modifying the ~/.s3cfg configuration file. This file specifies the necessary details for s3cmd to connect and authenticate with the MicroCeph object storage.

## Configuration Steps

An INI-style configuration file named .s3cfg needs to be created in the user's home directory. This file contains a [default] section with key-value pairs for configuration.

```ini
    [default]
    access_key = your_access_key
    secret_key = your_secret_key
    host_base = microceph_cluster_ip_or_hostname
    host_bucket = microceph_cluster_ip_or_hostname/%(bucket)
    check_ssl_certificate = False  ; Set to True if using HTTPS with a valid certificate
    check_ssl_hostname = False     ; Set to True if using HTTPS with a valid certificate
    use_https = False              ; Set to True to use HTTPS
```

**access_key and secret_key:** These are the credentials for accessing the MicroCeph object storage.
**host_base:** This specifies the IP address or hostname of the MicroCeph cluster.
**host_bucket:**This defines the template for accessing buckets on the MicroCeph cluster, typically including the host_base and a placeholder for the bucket name.
**check_ssl_certificate,check_ssl_hostname, and use_https:** These options control SSL/TLS behavior. Adjust them based on whether the MicroCeph cluster is configured for HTTPS and if a valid SSL certificate is in use.

Create/Edit ~/.s3cfg.

```ini
[default]
access_key = foo
secret_key = bar
host_base = micro11
host_bucket = micro11/%(bucket)
check_ssl_certificate = False
check_ssl_hostname = False
use_https = False
```
