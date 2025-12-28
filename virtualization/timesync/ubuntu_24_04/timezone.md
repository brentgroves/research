# **[Changing Timezone via CLI (command line interface)](https://linuxconfig.org/ubuntu-24-04-change-timezone)**

Open your terminal to begin the CLI process.: Enter the following command:
`$ timedatectl`

Check your current timezone with the timedatectl command.

Find your Timezone: Use timedatectl to list timezones or grep to filter for your city.

`$ timedatectl list-timezones | grep Kathmandu`

This command helps you find the exact timezone you wish to set.

Set New Timezone: Apply the change by setting your system to the new timezone.
`$ sudo timedatectl set-timezone Asia/Kathmandu`
This command updates your system’s timezone.

Confirm Timezone Settings: Verify the change by checking your system’s timezone again.
`$ timedatectl`

This will display your system’s current timezone settings, confirming the update.

![i1](https://linuxconfig.org/wp-content/uploads/2024/02/02-ubuntu-24-04-change-timezone.webp)

FAQ

1. How can I find out the current time in a specific timezone?
You can use the command timedatectl with the option set-timezone followed by the timezone you’re interested in to see the current time there. Alternatively, numerous online tools and websites provide current times for various timezones.
2. What should I do if my city is not listed in the timezone options?
When a specific city is not listed, you should select the nearest city in your timezone. Timezones cover broader regions, so cities within the same timezone will share the same time.
3. Can daylight saving time affect how I set my timezone in Ubuntu?
Yes, daylight saving time (DST) can affect timezone settings. Ubuntu automatically adjusts for DST if your timezone supports it. Ensure the ‘Network Time’ is enabled for automatic adjustments.
4. How does Ubuntu determine my current timezone automatically?
Ubuntu uses the ‘geoclue’ service to determine your location and set the timezone automatically. This requires an active internet connection and location services to be enabled.
5. Is it possible to have different time settings for different users on the same Ubuntu system?
No, the timezone setting is a system-wide setting that affects all users on the system. Individual users cannot have separate timezone settings.
6. What is the difference between UTC and GMT?
Coordinated Universal Time (UTC) and Greenwich Mean Time (GMT) are often used interchangeably as they share the same current time in practice. However, UTC is a time standard that is not affected by daylight saving time, while GMT is a timezone.
7. How do I revert to the default timezone settings after making a change?
To revert to the default timezone, you need to know what the default was (typically UTC or the timezone set during installation). Use the timedatectl set-timezone command followed by the default timezone, e.g., UTC or your region’s timezone.
