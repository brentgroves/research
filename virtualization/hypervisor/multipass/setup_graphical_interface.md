# **[How to set up a graphical interface](https://canonical.com/multipass/docs/set-up-a-graphical-interface)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

You can display the graphical desktop in various ways. In this document, we describe two options: RDP (Remote Display Protocol) and plain X11 forwarding. Other methods include VNC and running a Mir shell through X11 forwarding, as described in **[A simple GUI shell for a Multipass VM](https://discourse.ubuntu.com/t/20439?_gl=1*v27g4m*_gcl_au*MTY2MjY0NTQ5MC4xNzM4ODUxMzU1)**.

Using RDP
The images used by Multipass do not come with a graphical desktop installed. For this reason, you will have to install a desktop environment (here we use ubuntu-desktop but there are as many other options as flavors of Ubuntu exist) along with the RDP server (we will use xrdp but there are also other options such as freerdp).

