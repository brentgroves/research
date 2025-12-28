# **[ovs-ofctl](<https://manpages.ubuntu.com/manpages/xenial/man8/ovs-ofctl.8.html#:~:text=Each%20flow%20specification%20(e.g.%2C%20each,delete%20is%20strict%20or%20not>.)**

AI Overview
Learn more
To delete OpenFlow flows in Open vSwitch (OVS), use the ovs-ofctl command with the del-flows option. You can specify the bridge, table ID, and optionally, the priority, cookie, or cookie mask to delete flows matching those criteria.
Here's a breakdown of how to delete flows:

1. Basic Flow Deletion:
ovs-ofctl del-flows <bridge_name>: This will delete all flows on the specified bridge.
For example: ovs-ofctl del-flows br-tun will delete all flows on the bridge named br-tun.
2. Deleting by Table ID:
ovs-ofctl del-flows <bridge_name> table=<table_id>: This will delete all flows belonging to a specific table ID.
For example: ovs-ofctl del-flows br0 table=10 will delete flows on bridge br0 that belong to table 10.
3. Deleting by Priority:
ovs-ofctl del-flows <bridge_name> priority=<priority_value>: This will delete flows with the specified priority. Note that OpenFlow doesn't directly support deleting all flows with a specific priority.
You can use the --strict option in conjunction with this. ovs-ofctl --strict del-flows <bridge_name> priority=<priority_value> will delete the flow with the specified priority and an empty match, according to a developer's mailing list post.
4. Deleting by Cookie:
ovs-ofctl del-flows <bridge_name> cookie=<cookie_value> cookie_mask=<cookie_mask>: This will delete flows where the cookie matches the given value with the specified mask.
Example: ovs-ofctl del-flows br0 cookie=2 cookie_mask=0xFFFFFFFFFFFFFFFF will delete flows on bridge br0 with a cookie equal to 2.
5. Deleting by Match (More Complex):
For more specific flow deletion, you can use match criteria (e.g., ip, nw_src, etc.) in conjunction with the del-flows command.
Refer to the ovs-ofctl man page for a complete list of supported match fields.
Important Considerations:
--strict option:
.
The --strict option is useful when you want to delete flows with specific priorities, especially when the match is empty.
ovs-ofctl man page:
.
For a complete list of ovs-ofctl options and syntax, consult the **[ovs-ofctl man page](https://man7.org/linux/man-pages/man8/ovs-ofctl.8.html)**.

This **[video](https://www.youtube.com/watch?v=FyV4MoQ3T0I&t=156)** demonstrates how to delete a flow in OpenFlow using Open vSwitch (OVS):
