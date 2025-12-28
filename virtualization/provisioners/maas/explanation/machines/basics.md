# **[Machine Basics](https://discourse.maas.io/t/about-machine-basics/7917)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

## Machine basics

Machines are the heart of MAAS. This page offers a detailed explanation of machines and how they interact with MAAS.

## Machine list (UI)

The machine list is a valuable dashboard for many MAAS operations. In the illustration below, you see the machine list for a typical small hospital data centre, including servers ready and allocated for functions like Pharmacy, Orders, Charts, and so on:

![mui](https://discourse-maas-io-uploads.s3.us-east-1.amazonaws.com/original/1X/30df04b0bcec5fcf6538590ed795cb0514a64675.jpeg)

Rolling the cursor over status icons often reveals more details. For example, a failed hardware test script will place a warning icon alongside the hardware type tested by the script. Rolling the cursor over this will reveal which test failed. Likewise, you can find some immediate options by rolling over the column data items in the machines table.

![muir](https://discourse-maas-io-uploads.s3.us-east-1.amazonaws.com/original/1X/8f78a8877a029e7a44bcd4cf3d138499637fe790.jpeg)

The ‘Add hardware’ drop-down menu is used to add either new machines or a new chassis. This menu changes context when one or more machines are selected from the table, using either the individual check-boxes in the first column or the column title checkbox to select all.

![ah](https://discourse-maas-io-uploads.s3.us-east-1.amazonaws.com/original/1X/9a0747649e6aff999d3c04335eb752accedaf3de.jpeg)

With one or more machines selected, the ‘Add hardware’ drop-down menu moves to the left, and is joined by the ‘Take action’ menu. This menu provides access to the various machine actions:

![ta](https://discourse-maas-io-uploads.s3.us-east-1.amazonaws.com/original/1X/e03d5ac8de9ea4f4827ed057bb2dd83e241aac3b.jpeg)

The ‘Filter by’ section limits the machines listed in the table to selected keywords and machine attributes.

## jq dashboard (CLI)

You can also create a non-interactive dashboard using the CLI and jq:

FQDN               POWER  STATUS     OWNER  TAGS     POOL       NOTE     ZONE
----               -----  ------     -----  ----     ----       ----     ----
52-54-00-15-36-f2  off    Ready      -      Orders   Prescrbr   @md-all  Medications
52-54-00-17-64-c8  off    Ready      -      HRMgmt   StaffComp  @tmclck  Payroll
52-54-00-1d-47-95  off    Ready      -      MedSupp  SuppServ   @storag  Inventory
52-54-00-1e-06-41  off    Ready      -      PatPrtl  BusOfc     @bzstns  BizOffice
52-54-00-1e-a5-7e  off    Ready      -      Pharm    Prescrbr   @rxonly  Pharmacy
52-54-00-2e-b7-1e  off    Allocated  admin  NursOrd  NurServ    @nstns   Nursing
52-54-00-2e-c4-40  off    Allocated  admin  MedAdmn  NurServ    @rxonly  Nursing
52-54-00-2e-ee-17  off    Deployed   admin  Charts   ProServ    @md-all  Physician

You can generate this view with the command:

```bash
maas admin machines read | jq -r '(["FQDN","POWER","STATUS",
"OWNER", "TAGS", "POOL", "NOTE", "ZONE"] | (., map(length*"-"))),
(.[] | [.hostname, .power_state, .status_name, .owner // "-", 
.tag_names[0] // "-", .pool.name, .description // "-", .zone.name]) | @tsv' | column -t
```

These example machines would typically be duplicated in several different geographies, with a quick way to switch to a redundant node, should anything go wrong (e.g., high availability). We used the word node there because, In the network language of MAAS, machines are one of several different types of nodes. A node is simply a network-connected object or, more specifically, an object that can independently communicate on a network. MAAS nodes include controllers, network devices, and of course, machines.

Looking back at the example above, you can see that there are several columns in the machine list, depending on your view:

FQDN | MAC: The fully qualified domain name or the MAC address of the machine.
Power: ‘On’, ‘Off’ or ‘Error’ to highlight an error state.
Status: The current status of the machine, such as ‘Ready’, ‘Commissioning’ or ‘Failed testing’.
Owner: The MAAS account responsible for the machine.
Cores: The number of CPU cores detected on the machine.
RAM: The amount of RAM, in GiB, discovered on the machine.
Disks: The number of drives detected on the machine.
Storage: The amount of storage, in GB, identified on the machine.

## Machine summary

Click a machine’s FQDN or MAC address to open a detailed view of a machine’s status and configuration.

![ms](https://discourse-maas-io-uploads.s3.us-east-1.amazonaws.com/original/2X/a/a8ff4caf6362a3d695682499a74d64cb189dfc37.png)

The default view is ‘Machine summary’, presented as a series of cards detailing the CPU, memory, storage and tag characteristics of the machine, as well as an overview of its current status. When relevant, ‘Edit’ links take you directly to the settings pane for the configuration referenced within the card. The machine menu bar within the web UI also includes links to logs, events, and configuration options:

