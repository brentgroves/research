# **[Configuring NTP on Ubuntu 24.04](https://linuxconfig.org/configuring-ntp-on-ubuntu-24-04#:~:text=Open%20the%20NTP%20configuration%20file,Verify%20NTP%20Synchronization)**

30 January 2024 by Lubos Rendek
Maintaining accurate system time is crucial for various network operations and synchronization tasks. In Ubuntu 24.04, setting up the Network Time Protocol (NTP) ensures your system clock remains synchronized with internet time servers. This guide provides a detailed walkthrough on configuring NTP on Ubuntu 24.04, ensuring your system’s timekeeping is precise and reliable.

## Installation and Configuration Steps

Follow these steps to install, configure, and verify the NTP service on your Ubuntu 24.04 system.

Install the NTP Service: Start by updating your package lists to ensure you have the latest version of the repositories.
`$ sudo apt update`
Then, install the NTP package using the following command:

`$ sudo apt install ntp`

This command installs the NTP service on your Ubuntu system, making it ready for configuration.

Configure NTP Servers: Configuring your NTP servers is a critical step. Open the NTP configuration file in a text editor of your choice. Here, nano is used for simplicity.

`$ sudo nano /etc/ntp.conf`

In the configuration file, add or modify the server lines to specify your preferred NTP servers. For example:

server 0.ubuntu.pool.ntp.org
server 1.ubuntu.pool.ntp.org
server 2.ubuntu.pool.ntp.org
server 3.ubuntu.pool.ntp.org

```bash
echo server 10.225.50.203 prefer iburst
```

These servers are part of the Ubuntu pool, but you can choose other public NTP servers closer to your geographic location.

This command installs the NTP service on your Ubuntu system, making it ready for configuration.

Configure NTP Servers: Configuring your NTP servers is a critical step. Open the NTP configuration file in a text editor of your choice. Here, nano is used for simplicity.
$ sudo nano /etc/ntp.conf
In the configuration file, add or modify the server lines to specify your preferred NTP servers. For example:

server 0.ubuntu.pool.ntp.org
server 1.ubuntu.pool.ntp.org
server 2.ubuntu.pool.ntp.org
server 3.ubuntu.pool.ntp.org

```bash
server 10.225.50.203 prefer iburst
server 10.224.50.203
```

These servers are part of the Ubuntu pool, but you can choose other public NTP servers closer to your geographic location.

Restart NTP Service: After configuring your servers, restart the NTP service to apply the changes.

`$ sudo systemctl restart ntp`

This command ensures that the NTP service starts using the new configuration.

Check NTP Service Status: To confirm that NTP is functioning correctly, use the systemctl command.
`$ sudo systemctl status ntp`

This output provides the current status of the NTP service, indicating whether it’s active and running.

![i1](https://linuxconfig.org/wp-content/uploads/2024/01/01-configuring-ntp-on-ubuntu-24-04.webp)

Verify NTP Synchronization: Checking synchronization status helps ensure that your system clock is accurate.

`$ ntpq -p`
The output from this command shows the list of NTP servers you’re synchronized with and various related statistics.

![i2](https://linuxconfig.org/wp-content/uploads/2024/01/02-configuring-ntp-on-ubuntu-24-04.webp)

Enable NTP to Run After Restart: To ensure that the NTP service automatically starts upon system reboot, enable it using the systemctl command.
`$ sudo systemctl enable ntp`
This command configures the NTP service to start automatically whenever your system boots up, maintaining consistent time synchronization.

Optional Configuration: For advanced users, additional configuration options are available in the NTP configuration file. You can set various parameters like drift file, access restrictions, and more.
Open the configuration file again:
$ sudo nano /etc/ntp.conf
Here, you can fine-tune your NTP settings. For example, to restrict which hosts can query your NTP server, add lines like:

restrict example-host.com nomodify notrap
These settings are optional but can be useful for managing larger networks or for specific use cases.

Frequently Asked Questions about Configuring NTP on Ubuntu 24.04

1. What is NTP and why is it important?
NTP (Network Time Protocol) is a protocol used to synchronize the clocks of computers to a reference time source. It’s important for ensuring that all devices in a network have the exact same time for logging, security, and coordination of tasks.
2. How do I install NTP on Ubuntu 24.04?
To install NTP, use the command sudo apt install ntp after updating your package lists with sudo apt update.
3. How can I choose the best NTP servers for synchronization?
You should choose NTP servers that are geographically close to your location for better accuracy and reliability. The Ubuntu pool servers (0.ubuntu.pool.ntp.org to 3.ubuntu.pool.ntp.org) are a good starting point.
4. How do I restart the NTP service after configuration?
Use the command sudo systemctl restart ntp to restart the NTP service and apply your configuration changes.
5. How can I verify that my system is synchronized with the NTP servers?
Run ntpq -p to view the list of NTP servers your system is synchronized with and to check the synchronization status.
6. What should I do if NTP synchronization is not working?
First, check the NTP service status with sudo systemctl status ntp. If there are issues, verify your server configurations in the /etc/ntp.conf file, and ensure your network allows NTP traffic.
7. How do I ensure NTP starts automatically after a reboot?
Enable the NTP service to start on boot using sudo systemctl enable ntp.
8. Are there any advanced configurations I can apply to NTP?
Yes, you can set up advanced configurations like drift files, access restrictions, and logging by editing the /etc/ntp.conf file. These settings are optional but can be useful for specific needs or larger networks.
9. Can I use NTP on a server with limited internet access?
Yes, but you’ll need to ensure that NTP traffic (typically on port 123) is allowed through your firewall and that your server can reach the configured NTP servers
