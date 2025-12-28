# AI Overview: how to run a script at system startup on ubuntu

**[Back to Research List](../../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../../README.md)**

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
