# **[How to add network interfaces](https://discourse.ubuntu.com/t/how-to-add-network-interfaces/19544)**

Multipass can **[launch](https://discourse.ubuntu.com/t/multipass-launch-command/10846)** instances with additional network interfaces, via the --network option. That is complemented by the networks command, to find available host networks to bridge with.

Description
The name of the interface to connect the instance to when the shortcut launch --bridged is issued. See How to add network interfaces for details.

Allowed values
Any name from multipass networks. Note validation is deferred to multipass launch.

Examples
multipass set local.bridged-network=en0
