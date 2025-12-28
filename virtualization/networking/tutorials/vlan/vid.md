# **[VID](https://emc.extremenetworks.com/content/oneview/docs/network/devices/docs/l_ov_cf_vlan.html#:~:text=Port%20VLAN%20ID's.-,VLAN%20ID%20(VID),(VIDs)%20and%20VLAN%20names.&text=A%20unique%20number%20between%201,reserved%20for%20the%20Default%20VLAN.)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

## references

- **[extreme swtiches](https://emc.extremenetworks.com/content/oneview/docs/network/devices/docs/l_ov_cf_vlan.html#:~:text=Port%20VLAN%20ID's.-,VLAN%20ID%20(VID),(VIDs)%20and%20VLAN%20names.&text=A%20unique%20number%20between%201,reserved%20for%20the%20Default%20VLAN.)**

802.1Q VLANs are defined by VLAN IDs (VIDs) and VLAN names. A unique number between 1 and 4094 that identifies a particular VLAN. VID 1 is reserved for the Default VLAN. Although VID 1 is reserved as the default vid when linamar configures each switch the delete vid 1 and configure each port with their default which is vid 5. 

## VLAN Identification

VLAN identifiers include VLAN ID's and Port VLAN ID's.

VLAN ID (VID)
802.1Q VLANs are defined by VLAN IDs (VIDs) and VLAN names.

VID
A unique number between 1 and 4094 that identifies a particular VLAN. VID 1 is reserved for the Default VLAN.

VLAN Name
An alphanumeric name associated with a VLAN ID, used to make VLANs easier to identify and remember (up to 64 characters).

PVID (Port VLAN ID)
You can change a port's VLAN membership to reflect the specific needs of your network by assigning new VLAN membership to the port. When you assign VLAN membership to a port, that VLAN's ID (VID) becomes the Port VLAN ID (PVID) for the port and the port is added to the VLAN's Egress List.

PVID
The PVID (Port VLAN ID) represents a port's VLAN assignment. Possible values are 0 through 4094.
 	NOTE:	The PVID value 0 means incoming untagged traffic is not assigned to any VLAN.
Egress List
The Egress List specifies which ports can transmit the frames associated with the VLAN.
 	NOTE:	On the X-Pedition Router, you cannot assign a PVID to a port that has an interface assigned to it.
VLAN Model
In ExtremeCloud IQ Site Engine, you can create VLAN models and enforce them across multiple network devices. A VLAN model consists of at least one VLAN Definition and one VLAN Port Template.

ExtremeCloud IQ Site Engine provides you with one VLAN model (the Primary VLAN Model) which is pre-populated with a Default VLAN (VID 1). You can further define this VLAN model, and/or you can create other VLAN models. (The Default VLAN for a model cannot be deleted.)

Once a VLAN model has been created, you can utilize it in the following ways:

Enforce the properties of a port template on selected devices. You can also make custom edits for selected ports.
Perform a more detailed analysis of the differences between the definitions in the VLAN model and the VLAN settings on selected devices and their ports. Using these views in the Network > Device tab, you can review the differences and make modifications to your VLAN model and/or device or port VLAN configuration as required, including updating any or all of the definitions in the model with the settings on selected devices and their ports, and writing (enforcing) a model's VLAN definitions and/or VLAN port templates to selected devices or ports.

## VLAN Learning

VLAN learning allows the creation of groups of VLANs that will share Filtered Database information (MAC address, port, and VLAN ID) according to 802.1Q Shared Learning Constraints (IEEE Std 802.1Q-1998). This helps to speed MAC to port lookups and reduce flooding, because MAC addresses will be in the same Filtering Database.

