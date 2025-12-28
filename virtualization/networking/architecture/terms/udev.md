# **[udev](https://opensource.com/article/18/11/udev)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Networking Menu](../networking_menu.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

## references

- **[udev](https://linux.die.net/man/8/udev)**

## An introduction to Udev: The Linux subsystem for managing device events

Create a script that triggers your computer to do a specific action when a specific device is plugged in.

Udev is the Linux subsystem that supplies your computer with device events. In plain English, that means it's the code that detects when you have things plugged into your computer, like a network card, external hard drives (including USB thumb drives), mouses, keyboards, joysticks and gamepads, DVD-ROM drives, and so on. That makes it a potentially useful utility, and it's well-enough exposed that a standard user can manually script it to do things like performing certain tasks when a certain hard drive is plugged in.

This article teaches you how to create a **[udev](https://linux.die.net/man/8/udev)** script triggered by some udev event, such as plugging in a specific thumb drive. Once you understand the process for working with udev, you can use it to do all manner of things, like loading a specific driver when a gamepad is attached, or performing an automatic backup when you attach your backup drive.
