# **[About MAAS](https://maas.io/docs/about-maas)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

## What is MAAS?

MAAS, or “Metal As A Service,” morphs your bare-metal servers into an agile cloud-like environment. Forget fussing over individual hardware; treat them as fluid resources similar to instances in AWS, GCE, or Azure. MAAS is adept as a standalone PXE/preseed service, but it truly shines when paired with Juju, streamlining both machine and service management. Network booting via PXE? Even virtual machines can join the MAAS ecosystem.

![m](https://discourse-maas-io-uploads.s3.us-east-1.amazonaws.com/original/1X/d19eff9ef45c554d085ee1d657e4ddd810eac6df.jpeg)

## PXE booting

PXE, or “Preboot Execution Environment” (often called “pixie”), empowers machines to load OS images via network interfaces. This requires a PXE-compatible NIC, configurable through software switches.

## Why choose MAAS?

MAAS transforms a vast collection of physical servers into flexible resource pools. It seamlessly provisions, re-purposes, and deallocates resources, letting you focus on the bigger picture. Want to delve into hardware details before deployment? MAAS scrutinises attached USB and PCI devices, allowing optional exclusion.

## System management

MAAS wraps 13 critical features into one cohesive interface:

- Responsive web UI
- Broad OS support: Ubuntu, CentOS, Windows, RHEL
- IP address management (IPAM)
- API/CLI access
- Optional high availability
- IPv6 readiness
- Hardware inventory
- DHCP and DNS for network devices
- DHCP relay
- VLAN and fabric support
- Network time protocol (NTP)
- In-depth hardware testing
- Composable hardware

Easily scale and manage your data centre with these integrated tools.

![sm](https://discourse-maas-io-uploads.s3.us-east-1.amazonaws.com/original/1X/00968a71b82ce01c45ae3b345ed6b1270d0927bf.jpeg)

## Scriptable CLI

If CLI is your preference, here are 11 features you shouldn’t overlook:

- Broad OS support: Ubuntu, CentOS, Windows, RHEL
- IPAM
- Optional high availability
- IPv6 readiness
- Hardware inventory
- DHCP and DNS for network devices
- DHCP relay
- VLAN and fabric support
- NTP
- Hardware testing
- Composable hardware

![cli](https://discourse-maas-io-uploads.s3.us-east-1.amazonaws.com/optimized/1X/40fdae53957095e5a830458dc5c7a62ea5d78c10_2_690x438.jpeg)

MAAS plays well with configuration management tools, receiving endorsements from both **[Chef](https://www.chef.io/chef)** and **[Juju](https://jaas.ai/)** teams.

Note: Windows and RHEL compatibility may require Ubuntu Pro for seamless integration.

## Resource efficiency

MAAS architecture comprises two linchpins: the region controller and the rack controller. The former orchestrates data centre-wide operations while the latter focuses on individual racks. For a streamlined setup, co-locating these controllers is advisable, and it’s the default in MAAS installations. This config also brings DHCP into the mix.

![ri](https://discourse-maas-io-uploads.s3.us-east-1.amazonaws.com/original/1X/3ad2b128fbc034e9f575f21c0415a6e6c55baea3.jpeg)

For a deep dive into these components, refer to **[Concepts and terms](https://maas.io/docs/reference-maas-glossary)** may warrant additional controllers.