# **[PCI Pass-through](https://pve.proxmox.com/wiki/PCI_Passthrough)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Networking Menu](../networking_menu.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

PCI passthrough allows you to use a physical PCI device (graphics card, network card) inside a VM (KVM virtualization only).

If you "PCI passthrough" a device, the device is not available to the host anymore. Note that VMs with passed-through devices cannot be migrated.

Requirements
This is a list of basic requirements adapted from the Arch wiki

CPU requirements
Your CPU has to support hardware virtualization and IOMMU. Most new CPUs support this.
AMD: CPUs from the Bulldozer generation and newer, CPUs from the K10 generation need a 890FX or 990FX motherboard.
Intel: list of VT-d capable Intel CPUs
Motherboard requirements
Your motherboard needs to support IOMMU. Lists can be found on the Xen wiki and Wikipedia. Note that, as of writing, both these lists are incomplete and very out-of-date and most newer motherboards support IOMMU.
GPU requirements
The ROM of your GPU does not necessarily need to support UEFI, however, most modern GPUs do. If you GPU ROM supports UEFI, it is recommended to use OVMF (UEFI) instead of SeaBIOS. For a list of GPU ROMs, see Techpowerup's collection of GPU ROMs

Verifying IOMMU parameters
Verify IOMMU is enabled
Reboot, then run:

```bash
ssh brent@reports-alb
dmesg | grep -e DMAR -e IOMMU
[   21.815933] AMD-Vi: AMD IOMMUv2 functionality not available on this system - This is not a bug.

ssh brent@repsys11

sudo dmesg | grep -e DMAR -e IOMMU
# There should be a line that looks like "DMAR: IOMMU enabled". If there is no output, something is wrong.
[sudo] password for brent: 
[    0.015380] ACPI: DMAR 0x00000000BD3346F4 000130 (v01 DELL   PE_SC3   00000001 DELL 00000001)
[    0.015443] ACPI: Reserving DMAR table memory at [mem 0xbd3346f4-0xbd334823]
[    0.785796] DMAR: Host address width 46
[    0.785798] DMAR: DRHD base: 0x000000d4800000 flags: 0x0
[    0.785806] DMAR: dmar0: reg_base_addr d4800000 ver 1:0 cap d2078c106f0462 ecap f020fe
[    0.785809] DMAR: DRHD base: 0x000000df900000 flags: 0x1
[    0.785824] DMAR: dmar1: reg_base_addr df900000 ver 1:0 cap d2078c106f0462 ecap f020fe
[    0.785827] DMAR: RMRR base: 0x000000bf458000 end: 0x000000bf46ffff
[    0.785829] DMAR: RMRR base: 0x000000bf450000 end: 0x000000bf450fff
[    0.785831] DMAR: RMRR base: 0x000000bf452000 end: 0x000000bf452fff
[    0.785832] DMAR: ATSR flags: 0x0
[    0.785836] DMAR-IR: IOAPIC id 2 under DRHD base  0xd4800000 IOMMU 0
[    0.785838] DMAR-IR: IOAPIC id 0 under DRHD base  0xdf900000 IOMMU 1
[    0.785840] DMAR-IR: IOAPIC id 1 under DRHD base  0xdf900000 IOMMU 1
[    0.785842] DMAR-IR: HPET id 0 under DRHD base 0xdf900000
[    0.785844] DMAR-IR: x2apic is disabled because BIOS sets x2apic opt out bit.
[    0.785845] DMAR-IR: Use 'intremap=no_x2apic_optout' to override the BIOS setting.
[    0.786517] DMAR-IR: Enabled IRQ remapping in xapic mode


```

There should be a line that looks like "DMAR: IOMMU enabled". If there is no output, something is wrong.
