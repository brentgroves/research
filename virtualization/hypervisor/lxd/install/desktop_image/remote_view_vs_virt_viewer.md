# **[](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/virtualization_deployment_and_administration_guide/sect-graphic_user_interface_tools_for_guest_virtual_machine_management-remote_viewer)**

remote-viewer
The remote-viewer is a simple remote desktop display client that supports SPICE and VNC. It shares most of the features and limitations with virt-viewer.
However, unlike virt-viewer, remote-viewer does not require libvirt to connect to the remote guest display. As such, remote-viewer can be used for example to connect to a virtual machine on a remote host that does not provide permissions to interact with libvirt or to use SSH connections.
To install the remote-viewer utility, run:

# yum install virt-viewer

Syntax
The basic remote-viewer command-line syntax is as follows:

# remote-viewer [OPTIONS] {guest-name|id|uuid}

To see the full list of options available for use with remote-viewer, see the remote-viewer man page.

## Connecting to a guest virtual machine

If used without any options, remote-viewer lists guests that it can connect to on the default URI of the local system.
To connect to a specific guest using remote-viewer, use the VNC/SPICE URI. For information about obtaining the URI, see Section 20.14, **[“Displaying a URI for Connection to a Graphical Display”](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/virtualization_deployment_and_administration_guide/sect-Domain_Commands-Displaying_a_URI_for_connection_to_a_graphical_display)**.

Displaying a URI for Connection to a Graphical Display
Running the virsh domdisplay command will output a URI that can then be used to connect to the graphical display of the guest virtual machine via VNC, SPICE, or RDP. The optional --type can be used to specify the graphical display type. If the argument --include-password is used, the SPICE channel password will be included in the URI.
Example 20.36. How to display the URI for SPICE

The following example displays the URI for SPICE, which is the graphical display that the virtual machine guest1 is using:

# virsh domdisplay --type spice guest1

spice://192.0.2.1:5900
