# **[](https://www.kernel.org/doc/html/v6.6/userspace-api/netlink/intro.html)**

## Introduction to Netlink

Netlink is often described as an ioctl() replacement. It aims to replace fixed-format C structures as supplied to ioctl() with a format which allows an easy way to add or extended the arguments.

To achieve this Netlink uses a minimal fixed-format metadata header followed by multiple attributes in the TLV (type, length, value) format.

Unfortunately the protocol has evolved over the years, in an organic and undocumented fashion, making it hard to coherently explain. To make the most practical sense this document starts by describing netlink as it is used today and dives into more "historical" uses in later sections.
