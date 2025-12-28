# **[polkit — Authorization Manager](https://www.freedesktop.org/software/polkit/docs/latest/polkit.8.html)**

**[Back to Research List](../../research_list.md)**\
**[Back to Networking Menu](./networking_menu.md)**\
**[Back to Current Status](../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../README.md)**

## OVERVIEW

polkit provides an authorization API intended to be used by privileged programs (“MECHANISMS”) offering service to unprivileged programs (“SUBJECTS”) often through some form of inter-process communication mechanism. In this scenario, the mechanism typically treats the subject as untrusted. For every request from a subject, the mechanism needs to determine if the request is authorized or if it should refuse to service the subject. Using the polkit APIs, a mechanism can offload this decision to a trusted party: The polkit authority.

The polkit authority is implemented as an system daemon, polkitd(8), which itself has little privilege as it is running as the polkitd system user. Mechanisms, subjects and authentication agents communicate with the authority using the system message bus.

In addition to acting as an authority, polkit allows users to obtain temporary authorization through authenticating either an administrative user or the owner of the session the client belongs to. This is useful for scenarios where a mechanism needs to verify that the operator of the system really is the user or really is an administrative user.

## SYSTEM ARCHITECTURE

The system architecture of polkit is comprised of the Authority (implemented as a service on the system message bus) and an Authentication Agent per user session (provided and started by the user's graphical environment). Actions are defined by applications. Vendors, sites and system administrators can control authorization policy through Authorization Rules.

![](https://www.freedesktop.org/software/polkit/docs/latest/polkit-architecture.png)

## AUTHENTICATION AGENTS

An authentication agent is used to make the user of a session prove that the user of the session really is the user (by authenticating as the user) or an administrative user (by authenticating as a administrator). In order to integrate well with the rest of the user session (e.g. match the look and feel), authentication agents are meant to be provided by the user session that the user uses. For example, an authentication agent may look like this:

![](https://www.freedesktop.org/software/polkit/docs/latest/polkit-authentication-agent-example.png)
