# **[How to Test Network Speed in Linux via CLI](https://phoenixnap.com/kb/ss-command)**

**[Back to Research List](../../../../../research_list.md)**\
**[Back to Current Tasks](../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../README.md)**

![f](https://media.beehiiv.com/cdn-cgi/image/fit=scale-down,format=auto,onerror=redirect,quality=80/uploads/asset/file/9ba5ca1d-95a9-487c-833c-c91fb8cdfc49/ip-header-2021-1024x505.png)

With the increase in people staying at home and spending more time on the Internet, ISPs have seen traffic loads higher than ever. If you noticed your network speed was slower at times, this global overload is the reason.

There are many online tools to test internet speed. However, Linux users can do this from the command prompt window. Some of the utilities for testing both local and internet speed we will cover are:

- Speedtest
- Fast
- Color Bandwidth Meter (CBM)
- iPerf
- nload
- Tcptrack
- Iftop
- Wget
- youtube-dl
Follow the instructions in this article to learn how to test network connection speed on Linux using the terminal. The steps work in both normal and headless mode.

## Prerequisites

- A machine running Linux
- sudo / root permissions
- Access to a terminal / command-prompt window

## Test Network Speed on Linux Via Command Line

The tools in this guide help you check the Internet and LAN speed on a Linux machine. The article uses Ubuntu 20.04 for instructions, but the utilities work for any Linux distribution.

## Using speedtest-cli to Test Internet Speed

One of the most famous online internet connection test apps is speedtest.net. To install Speedtest on Linux via the terminal, use a package manager for your distro.

On Ubuntu, enter:

`sudo apt install speedtest-cli`

![i1](https://phoenixnap.com/kb/wp-content/uploads/2021/04/install-speedtest.png)

Optionally, use pip to install speedtest-cli in Python:

 `sudo pip install speedtest-cli`

To run the test, type:

`speedtest`

![i2](https://phoenixnap.com/kb/wp-content/uploads/2021/04/speedtest-cli.png)

The standard speedtest-cli output shows all steps, including selecting a server. To display a shorter output, enter:

```bash
speedtest --simple
Cannot retrieve speedtest configuration
ERROR: HTTP Error 403: Forbidden
```

The test is simple to use and provides multiple options. To view all of them, pass the -h flag to display the speedtest-cli help file.

## Using fast-cli to Test Internet Speed

Fast is a lightweight CLI utility based on the web speed test fast.com. The test uses Netflix servers to provide results.

```bash
npx fast-cli
Need to install the following packages:
fast-cli@4.0.0
Ok to proceed? (y)
```

To test the download speed, enter:

```bash
npx fast-cli fast
910 Mbps ↓
```

To show both the download and upload speed, add the -u option:

```bash
npx fast-cli fast -u
⠹ 880 Mbps ↓ / 570 Mbps ↑
```

## Using CMB to Show Network Speed

The Color Bandwidth Meter (CMB) is a Linux tool that displays activity on all network interfaces. After the installation, run the tool to see network speeds in color-coded columns.

To install CBM, run this command:

`sudo apt install cbm`

When the process finishes, run the tool:

```bash
cbm
```

![i3](https://phoenixnap.com/kb/wp-content/uploads/2021/04/cbm-test-linux.png)

## there are several more
