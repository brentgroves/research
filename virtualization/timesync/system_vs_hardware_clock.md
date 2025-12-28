# **[System Clock vs Hardware Clock on Linux](https://linuxconfig.org/system-clock-vs-hardware-clock-on-linux)**

12 October 2022 by Korbin Brown
The system clock and the hardware clock are used for different purposes on a Linux system. The system clock is maintained by the operating system, and the hardware clock is maintained in BIOS. The hardware clock will continue to keep time when the computer is powered off, thanks to the CMOS battery on the motherboard. The system clock maintains time by querying online time servers whenever the computer is powered on.

The hardware clock will set the time for the system clock upon installation if there is no internet connection. Apart from this scenario, there is little use for the hardware clock in Linux. Instead, Linux uses systemd to synchronize the system time with online servers or an NTPD server.

Linux programs and services will rely on the system clock, not the hardware clock. Usually, the hardware clock will get synchronized to the system time whenever the computer is powered off. This way, the hardware time can remain accurate and will not drift off more than a few milliseconds while the computer is off, usually. In this tutorial, you will learn the difference between system clock and hardware clock, and about commands that can be used to view or set the hardware clock and system clock in Linux.

In this tutorial you will learn:

What is the difference between hardware clock and system clock
How to view and set the hardware clock
How to view and set the system time and time zone

## System Clock vs Hardware Clock on Linux

Now that you know the difference between the system clock and hardware clock, you can try out some of the commands below to view the times and change them as needed.
You can view the time of the hardware clock with the following command. This time can also be seen in the BIOS or UEFI screen.

```bash
$ sudo hwclock
2022-10-08 15:00:00.885214-0400
Command 'hwclock' not found, but can be installed with:
apt install util-linux-extra
```

The date command is usually the most common way to query the system time in Linux.

```bash
$ date
Sat Oct  8 15:00:09 EDT 2022
```

Use the timedatectl command to see all relevant information about your system clock.

```bash
$ timedatectl
                      Local time: Sat 2022-10-08 15:01:58 EDT
                  Universal time: Sat 2022-10-08 19:01:58 UTC
                        RTC time: Sat 2022-10-08 19:01:59
                       Time zone: America/New_York (EDT, -0400)
       System clock synchronized: yes
systemd-timesyncd.service active: yes
                 RTC in local TZ: no
```

If your system time is different than your hardware clock time, you can use the --systohc option to change the hardware clock to the current system clock time.
`$ sudo hwclock --systohc`

It also works the other way around. To set the system clock time from the hardware clock use the --hctosys option.
`$ sudo hwclock --hctosys`

If you’d like to set the system clock to some arbitrary date and time, ensure that time synchronization is off and use the following date command. This command will set the date and time to 10 January 2021, 12:00 PM, but substitute any values you want.

```bash
sudo timedatectl set-ntp off
sudo date -s "10 JAN 2021 12:00:00"
```

To set the system time to be synchronized to a particular time zone:
$ sudo timedatectl set-timezone Australia/Sydney
And view the list of available time zomes:

```bash
$ timedatectl list-timezones
Australia/Adelaide
Australia/Brisbane
Australia/Broken_Hill
Australia/Currie
Australia/Darwin
Australia/Eucla
Australia/Hobart
Australia/Lindeman
Australia/Lord_Howe
Australia/Melbourne
Australia/Perth
Australia/Sydney
....
```
