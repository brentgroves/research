# **[VirtualBox](https://www.virtualbox.org/wiki/Linux_Downloads)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Tasks](../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../README.md)**

## references

- **[How to Install VirtualBox 7.1 on Ubuntu 24.04 LTS](https://linuxiac.com/how-to-install-virtualbox-on-ubuntu-24-04-lts/)**

## **[VirtualBox](https://www.virtualbox.org/wiki/Linux_Downloads)**

Note: The package architecture has to match the Linux kernel architecture, that is, if you are running a 64-bit kernel, install the appropriate AMD64 package (it does not matter if you have an Intel or an AMD CPU). Mixed installations (e.g. Debian/Lenny ships an AMD64 kernel with 32-bit packages) are not supported. To install VirtualBox anyway you need to setup a 64-bit chroot environment.

A chroot environment, or chroot jail, is a Linux command that creates a restricted, isolated environment within the existing file system. It essentially changes the apparent root directory for a process and its children, limiting their access to files and directories within the chroot directory. This isolation can be used for various purposes, including sandboxing, testing software, and recovering a system. 

## **[How to Install VirtualBox 7.1 on Ubuntu 24.04 LTS](https://linuxiac.com/how-to-install-virtualbox-on-ubuntu-24-04-lts/)**

A Linux sandbox is a virtualized or isolated environment within a Linux system where you can run programs or code with limited access to system resources, effectively creating a safe space for experimentation or testing. This isolation helps prevent potentially harmful software from affecting the main operating system or network. 


Follow our step-by-step guide to easily install VirtualBox on Ubuntu 24.04 LTS (Noble Numbat) and start virtualizing your systems today!

This guide is tailored specifically for Ubuntu 24.04 LTS (Noble Numbat) users, the latest long-term support release from one of the most popular Linux distributions. Following our simple step-by-step instructions, you can install VirtualBox seamlessly on your Ubuntu system in no time.

VirtualBox is a powerful yet free virtualization software quite popular among home users. It offers a versatile platform for running multiple operating systems simultaneously on a single machine.

It is available for installation in the Ubuntu 24.04 repositories, but the version is often not current. Because of this, this guide will walk you through the steps to install it directly from the official VirtualBox repository.

This ensures you always have the latest version, and the best part is that updates will be included with your regular Ubuntu system updates. So let’s get started.

## Step 1: Import VirtualBox’s Repo GPG Key
First, we’ll import the GPG key from the VirtualBox repository to ensure the authenticity of the software we install from it.

```bash
wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg
```

## Step 2: Add VirtualBox Repository

Next, we’ll add the official VirtualBox repository to our Ubuntu 22.04 system. If a new version is released, the update package will be made available with the rest of your system’s regular updates.

```bash
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] http://download.virtualbox.org/virtualbox/debian $(. /etc/os-release && echo "$VERSION_CODENAME") contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
```

## Step 3: Run System Update

Before we proceed with VirtualBox installation on our Ubuntu 24.04 system, we should refresh the list of available packages. Run the below command to update the APT repositories index.

`sudo apt update`

![i](https://cdn.shortpixel.ai/spai/q_lossy+ret_img+to_auto/linuxiac.com/wp-content/uploads/2024/05/vbox-ubuntu2404-03-1024x371.jpg)

As you can see, our new VirtualBox repository is now available and ready to be used.

## Step 4: Install VirtualBox 7.1 on Ubuntu 24.04 LTS

We’re all set to install VirtualBox on our Ubuntu 24.04 system. Run the following commands:

`sudo apt install virtualbox-7.1`

Wait for the installation to complete. Congratulations, we are done! But hold on before you run it—we have a few small but important things to take care of first.

## Step 5: Install VirtualBox Extension Pack

This is an optional step, but I strongly encourage it because it will make working with VirtualBox on your Ubuntu system easier and more convenient. VirtualBox Extension Pack unlocks many great features, such as:

- USB 2 and USB 3 support
- VirtualBox Remote Desktop Protocol (VRDP)
- Host webcam passthrough
- Disk image encryption with AES algorithm
- Intel PXE boot ROM
- Support for NVMe SSDs

Let’s highlight one peculiarity here. The Extension Pack’s version is strongly recommended to match the VirtualBox’s installed version. To verify the exact one of the just-installed VirtualBox, you can use a built-in vboxmanage command:

```bash
vboxmanage -v | cut -dr -f1
7.1.8
```

As you can see, the installed version of VirtualBox is “7.1.0.” Therefore, you must then download the Extension Pack with the same version. So, use the below wget command to download the appropriate Extension Pack for VirtualBox.

However, if your installation is different, replace both places containing “7.1.0” in the command below with the appropriate version. You can also visit the downloads page and look at the available versions.

```bash
cd ~/Downloads
wget https://download.virtualbox.org/virtualbox/7.1.8/Oracle_VirtualBox_Extension_Pack-7.1.8.vbox-extpack
```

Next, to install the VirtualBox Extension pack, run the vboxmanage command as follows:

```bash
sudo vboxmanage extpack install Oracle_VirtualBox_Extension_Pack-7.1.8.vbox-extpack
...
0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
Successfully installed "Oracle VirtualBox Extension Pack".
```

You will be prompted to agree to Oracle’s license terms and conditions. To confirm, type “y” and press “Enter.”

Additionally, you can verify installed VirtualBox’s extension pack version by running the following:

```bash
vboxmanage list extpacks

Extension Packs: 1
Pack no. 0:   Oracle VirtualBox Extension Pack
Version:        7.1.8
Revision:       168469
Edition:        
Description:    Oracle Cloud Infrastructure integration, Host Webcam, VirtualBox RDP, PXE ROM, Disk Encryption, NVMe, full VM encryption.
VRDE Module:    VBoxVRDP
Crypto Module:  VBoxPuelCrypto
Usable:         true
Why unusable:   
```

## Step 6: Add User to vboxusers Group

Before using VirtualBox, add your user account to the “vboxusers” group. This is quick and simple to accomplish by running:

`sudo usermod -aG vboxusers $USER`

Now, perform a reboot. After login, check that you are in the “vboxusers” group with this command:

`groups $USER`


## Step 7: Running VirtualBox on Ubuntu 24.04

You can start using VirtualBox by launching it from the Ubuntu Dash. Search for “virtualbox” and launch it when its icon appears.

Hit the “New” button and start virtualizing your ideas!

Conclusion
Now, with VirtualBox installed on your Ubuntu 24.04 system, you are well equipped with the power to run multiple operating systems and test applications in safe, isolated environments.

However, VirtualBox isn’t the only player in the virtualization game—VMware Workstation is another excellent and reliable option. If you’re thinking about giving it a try, we’ve got you covered with a step-by-step guide on setting it up in Ubuntu 24.04LTS.

Finally, I recommend checking the official documentation for individuals who want to learn more about VirtualBox’s features and how to use them effectively.

I hope this guide has been informative and helpful in getting you started with VirtualBox on Ubuntu. Thanks for your time! Your feedback and comments are most welcome. Happy virtualizing!