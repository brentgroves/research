# will docker be hurt if if I change iptables FORWARD to ACCEPT

**[Back to Research List](../../../../../research_list.md)**\
**[Back to Current Tasks](../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../README.md)**

## AI Overview

No, setting the iptables FORWARD chain policy to ACCEPT will not "hurt" Docker itself in the sense that it will break its basic functionality. Docker is designed to manage networking and iptables rules internally, and it generally works around existing iptables configurations.
However, setting the FORWARD policy to ACCEPT can have significant security implications and may interfere with Docker's default behavior and your intentions.
Here's why:
Security Risk: The FORWARD chain controls packets that are being routed through your system, such as traffic going to or from your Docker containers. Setting the default policy to ACCEPT means that unless a specific rule explicitly denies traffic, all forwarded packets will be allowed. This can expose your Docker containers or other services running on your host to unauthorized access. Security best practices recommend a default DROP policy for the FORWARD chain, allowing only the necessary traffic.
Docker's Internal iptables Management: Docker itself manages iptables rules to handle networking, port publishing, and filtering for its bridge networks. Docker sets the default policy for the filter table to DROP. It also creates custom chains like DOCKER-USER and DOCKER-FORWARD to process Docker-related traffic.
Potential Conflicts and unexpected behavior: While Docker generally works around existing rules, setting the FORWARD policy to ACCEPT can override or conflict with Docker's intended security measures. This might lead to unexpected behavior or expose ports that you intended to be protected by Docker's configuration.
In summary:
Changing the iptables FORWARD policy to ACCEPT is not recommended for security reasons and could potentially interfere with Docker's network management.
If you need to adjust iptables rules for your Docker containers, it's generally best to:
Work with Docker's built-in mechanisms: Leverage Docker's networking options to configure port forwarding and network isolation.
Use the DOCKER-USER chain: If you need to add custom firewall rules, add them to the DOCKER-USER chain. Rules in this chain are processed before Docker's own rules, allowing you to filter traffic before it reaches your containers.
If you must change the FORWARD policy (e.g., for specific routing needs), ensure you have detailed rules to control traffic flow and prevent unauthorized access to your Docker containers. You can specifically configure Docker to not set the FORWARD chain to DROP by using the ip-forward-no-drop option in the Docker daemon configuration. However, carefully consider the security implications before implementing such a change.
