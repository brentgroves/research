# **[Changing Timezone via CLI (command line interface)](https://linuxconfig.org/ubuntu-24-04-change-timezone)**


**[Back to Research List](../../research_list.md)**\
**[Back to Current Status](../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../README.md)**

Open your terminal to begin the CLI process.: Enter the following command:

```bash
$ timedatectl
```
Check your current timezone with the timedatectl command.

Find your Timezone: Use timedatectl to list timezones or grep to filter for your city.

```bash
$ timedatectl list-timezones | grep Indianapolis
America/Indiana/Indianapolis
America/Indianapolis
```

This command helps you find the exact timezone you wish to set.

Set New Timezone: Apply the change by setting your system to the new timezone.

```bash
$ sudo timedatectl set-timezone "America/Indiana/Indianapolis"
```

This command updates your system’s timezone.

Confirm Timezone Settings: Verify the change by checking your system’s timezone again.

```bash
$ timedatectl
```

This will display your system’s current timezone settings, confirming the update.