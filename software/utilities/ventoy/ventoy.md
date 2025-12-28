# **[ventoy](https://itsfoss.com/use-ventoy/)**

Install and Use Ventoy on Linux [Step-by-Step Guide]
Tired of flashing USB drives for every ISO? Get started with Ventoy and get the ability to easily boot from ISOs.

Being a distro hopper, I can relate to the pain of having one ISO image on a flash drive. But not anymore!

If you constantly distro hop, or you just want to carry multiple ISO files in a single pen drive, there is a solution - Ventoy.

## Install Ventoy on Linux

Ventoy is not available in the default repositories or 3rd party repos on Ubuntu. But, it is available on AUR for Arch users. This simply means you cannot use apt to install the package.

So in this case, we have to install Ventoy from source. Fret not, you just need to follow along the steps below, it is easy.

📋
You can use this method for any Linux distribution.

1. Visit the **[official download page](https://www.ventoy.net/en/download.html)** of Ventoy and choose the file ending with linux.tar.gz:
![i](https://itsfoss.com/content/images/2023/07/download-the-latest-version-of-Ventoy-in-Ubuntu.png)

2. Now, open your terminal and use the cd command to navigate to where the Ventoy file was downloaded. For most users, it will be the Downloads directory:

    `cd Downloads`

    The Ventoy binaries are shipped in the form of the tarball and to untar (or extract) the package, you can use the **[tar command](https://learnubuntu.com/untar-files/)** as shown:

    `tar -xzvf ventoy-*.tar.gz`

3. Once extracted, you will find a directory of Ventoy. Use the cd command to get into that directory.

    In my case, it was ventoy-1.0.93, so I will be using the following:

    `cd ventoy-1.0.93`

    If you list the directory contents, you will find that there are multiple scripts:

    `ls`

    ![i](https://itsfoss.com/content/images/2023/07/use-ls-command-to-list-the-directory-contents.png)

    But what you need is VentoyWeb.sh which allows you to flash your drive using your browser without any commands.

4. To execute the script, use the following command:

`sudo ./VentoyWeb.sh`

![i](https://itsfoss.com/content/images/2023/07/start-the-ventoy-web-script-in-terminal.png)

As you can see, it started the Ventoy server and to access it, copy the given URL and paste it to the address bar of your browser.

Once you do that, it will look like this:

![i1](https://itsfoss.com/content/images/size/w1000/2023/07/start-ventoy-web-in-browser-to-install-Ventoy-in-Ubuntu.png)

By default, it will be enabled to work with the secure boot option and this is the reason it shows the 🔒 (lock) symbol with the version name.

I do not recommend you change this setting, but if you would like to, you can disable this option from the Option→Secure boot Support:

![i1](https://itsfoss.com/content/images/size/w1000/2023/07/enable-or-disable-secure-boot-option-in-Ventoy.png)

Once done, select the storage path on which you want to install Ventoy and hit the Install button.

Before installing, it will ask you to check the drive two times as it will format the drive, so make sure to take a backup of critical data (if there's any):

![i](https://itsfoss.com/content/images/2023/07/Ventory-warning-before-installing-in-Ubuntu.png)

Once done, you will see a message—"Ventoy has been successfully installed to the device":

![i](https://itsfoss.com/content/images/size/w1000/2023/07/Ventoy-has-been-successfully-installed-to-the-device-in-Ubuntu.png)

And the installation is done.

## Create a Live USB with Ventoy

To create a Live USB with Ventoy, first, you need to download an ISO image of your preferred operating system.

While Ventoy should support almost everything, I would still recommend checking the compatibility from their official page.

To make the USB bootable with Ventoy, all you have to do is paste the ISO file to the Ventoy drive. Yes, it is as simple as that! 🤯

![i](https://itsfoss.com/content/images/2023/07/make-bootable-USB-using-ventoy-1.gif)

📋
If you want to check the hash of the ISO file for file integrity, you can find the steps mentioned below.

## Using GtkHash to check the hash (optional)

While Ventoy does can check the hash, it can only be used when you boot with Ventoy and most users won't have another system to compare the hash.

So it is a good idea to check the hash sum on a working system.

To check the hash, I would recommend using GtkHash which is a simple GUI tool that lets you check the hash for the files.

It is available as a Flatpak so if you haven't enabled flatpak, then, you can refer to our detailed guide on **[using Flatpak on Linux](https://itsfoss.com/flatpak-guide/)**. Your software center may include support for it, so you might want to check that too.

Once setup, you can use the following command to install it on your system:

`flatpak install flathub org.gtkhash.gtkhash`

After installation, start GtkHash from your system menu and follow two simple steps to check the hash value:

First, select the ISO file:

![i1](https://itsfoss.com/content/images/2023/07/Select-an-ISO-file-to-check-hash.png)

And paste the hash from the website you got the ISO file in the Check field, then press the Hash button:

![i1](https://itsfoss.com/content/images/size/w1000/2023/07/check-hash-for-ISO-file-to-create-bootable-drive-in-ventoy.png)
