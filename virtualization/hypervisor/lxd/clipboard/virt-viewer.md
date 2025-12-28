<https://unix.stackexchange.com/questions/109117/virt-manager-copy-paste-functionality-to-the-vm>

With a Linux (Debian 11/bullseye) host and a Windows 10 guest, I did the following to enable copy-and-paste between the guest and the host:

Install spice-guest-tools on Windows guest; the binaries can be downloaded from <https://www.spice-space.org/download.html>.
Install spice-vdagent on Linux host.
Using virt-manager (on host) change the Windows VM configuration:
Set the 'Display' to 'Spice'.
Add a 'spicevmc' Channel (via 'Add Hardware'); The XML data will be:
channel type="spicevmc"
target type="virtio"
name="com.redhat.spice.0"
alias name="channel0"
address type="virtio-serial" controller="0" bus="0" port="2"

In Linux host, enable spice-vdagentd.service; eg.

# systemctl enable spice-vdagentd.service`

Restart Linux.
The copy-and-paste functionality is ready to use.
