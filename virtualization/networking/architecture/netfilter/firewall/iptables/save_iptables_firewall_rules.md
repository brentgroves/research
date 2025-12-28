# **[How to save iptables firewall rules permanently on Linux](https://www.cyberciti.biz/faq/how-to-save-iptables-firewall-rules-permanently-on-linux/)**

**[Back to Research List](../../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../../README.md)**

## reference

- **[libvirt and network filtering with nat - iptables overrides](https://serverfault.com/questions/565871/libvirt-and-network-filtering-with-nat-iptables-overrides#:~:text=I%20feel%20your%20pain.,your%20hook%20set%20those%20up.)**

## **[Libvirt hooks](https://stackoverflow.com/questions/58766690/injecting-iptables-rule-after-libvirt-network-is-created-with-terraform-0-11)

Libvirt has a concept of "hooks" which are admin defined scripts to be run at certain key points in libvirt:

<https://libvirt.org/hooks.html>

There's an illustration of using hooks for port forwarding here:

<https://wiki.libvirt.org/page/Networking#Forwarding_Incoming_Connections>

## AI Overview: how to run a script at system startup on ubuntu

To run a script at system startup in Ubuntu, you can use the @reboot cron task, add a systemd service, or utilize the rc.local file.
Here's a breakdown of each method:

1. Using Cron with @reboot:
Edit the cron table: Open the cron table for the current user using crontab -e.
Add a line: Add a line like @reboot /path/to/your/script.sh to the cron table.
Save and exit: Save the changes and exit the editor.
Example: @reboot /home/user/my_startup_script.sh.
2. Using Systemd Service:
Create a service file: Create a file named my_service.service in /etc/systemd/system/ (e.g., /etc/systemd/system/my_service.service).
Add the following content:
Code

    [Unit]
    Description=My Startup Script
    After=network.target

    [Service]
    ExecStart=/path/to/your/script.sh
    User=your_user
Replace /path/to/your/script.sh with the actual path to your script and your_user with your username.
Enable the service: Run sudo systemctl enable my_service.service.
Start the service: Run sudo systemctl start my_service.service.
3. Using rc.local (Less Recommended):
Edit the file: Open /etc/rc.local with root privileges (e.g., sudo nano /etc/rc.local).
Add the command: Add the command to execute your script at the end of the file (e.g., /path/to/your/script.sh).
Make the script executable: Ensure the script has execute permissions (e.g., sudo chmod +x /path/to/your/script.sh).
Add an exit statement: Add exit 0 at the end of the file.
Important Notes:
Permissions: Ensure your script has the necessary permissions to run.
Paths: Use absolute paths to your script.
Dependencies: Consider any dependencies your script might have and ensure they are available at startup.
Testing: Test your startup script by rebooting your system.

## If libvirt is not controlling the firewall

am using Debian / Ubuntu Linux server. How do I save iptables rules permanently on Linux using the CLI added using the iptables command? How can I store iptables IPv4 and IPv6 rules permanently on the Debian Linux cloud server?

Linux system administrator and developers use iptables and ip6tables commands to set up, maintain, and inspect the firewall tables of IPv4 and IPv6 packet filter rules in the Linux kernel. Any modification made using these commands is lost when you reboot the Linux server. Hence, we need to store those rules across reboot permanently. This page examples how to save iptables firewall rules permanently either on Ubuntu or Debian Linux server.

## Saving iptables firewall rules permanently on Linux

You need to use the following commands to save iptables firewall rules forever:

1. iptables-save command or ip6tables-save command – Save or dump the contents of IPv4 or IPv6 Table in easily parseable format either to screen or to a specified file.

2. iptables-restore command or ip6tables-restore command – Restore IPv4 or IPv6 firewall rules and tables from a given file under Linux.

## Step 1 – Open the terminal

Open the terminal application and then type the following commands. For remote server login using the ssh command:

```bash
ssh vivek@server1.cyberciti.biz
ssh ec2-user@ec2-host-or-ip
```

You must type the following command as root user either using the sudo command or su command.

## Step 2 – Save IPv4 and IPv6 Linux firewall rules

Debian and Ubuntu Linux user type:

```bash
sudo sh -c '/sbin/iptables-save > /etc/iptables/rules.v4'
## IPv6 ##
sudo sh -c '/sbin/ip6tables-save > /etc/iptables/rules.v6'
```

## Step 3 – Restore IPv4 and IPv6 Linux filewall rules

We just reverse above commands as follows per operating system:

```bash
## Debian or Ubuntu ##
sudo sh -c '/sbin/iptables-restore < /etc/iptables/rules.v4'
sudo sh -c '/sbin/ip6tables-restore < /etc/iptables/rules.v6'
## CentOS/RHEL ##
sudo sh -c '/sbin/iptables-restore < /etc/sysconfig/iptables'
sudo sh -c '/sbin/ip6tables-restore < /etc/sysconfig/ip6tables'
```
