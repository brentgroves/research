# **[](https://canonical-lxd-imagebuilder.readthedocs-hosted.com/en/latest/tutorials/use/?_gl=1*1u260or*_ga*MTY2Njg1MzMxNS4xNzQ3NTE3NDk3*_ga_892F83CXG5*czE3NTcwMTI2NTIkbzM1JGcxJHQxNzU3MDEyODkxJGo1OSRsMCRoMA..#repack-windows-iso)**

## Repack Windows ISO

▶
Watch on YouTube
With LXD it’s possible to run Windows VMs. All you need is a Windows ISO and a bunch of drivers. To make the installation a bit easier, lxd-imagebuilder added the repack-windows command. It takes a Windows ISO, and repacks it together with the necessary drivers.

The lxd-imagebuilder will automatically detect the Windows version, however, it is possible to set the version manually using --windows-version flag, which allows the following values:

| Flag value | Version                |
|------------|------------------------|
| w11        | Windows 11             |
| w10        | Windows 10             |
| w8         | Windows 8              |
| w8.1       | Windows 8.1            |
| w7         | Windows 7              |
| xp         | Windows XP             |
| 2k22       | Windows Server 2022    |
| 2k19       | Windows Server 2019    |
| 2k16       | Windows Server 2016    |
| 2k12       | Windows Server 2012    |
| 2k12r2     | Windows Server 2012 R2 |
| 2k8        | Windows Server 2008    |
| 2k8r2      | Windows Server 2008 R2 |
| 2k3        | Windows Server 2003    |

When repacking a Windows ISO, lxd-imagebuilder uses external tools that may need to be installed. On a Ubuntu/Debian system, those can be installed with:

```bash
sudo apt-get install -y --no-install-recommends genisoimage libwin-hivex-perl rsync wimtools
```

Here’s how to repack a Windows ISO:

```bash
sudo lxd-imagebuilder repack-windows path/to/Windows.iso path/to/Windows-repacked.iso
```

## More information on repack-windows can be found by running

`lxd-imagebuilder repack-windows -h`

Install Windows
Run the following commands to initialize the VM, add a TPM device, increase the allocated disk space, CPU, memory and finally attach the full path of your prepared ISO file.

```bash
lxc init win11 --empty --vm
lxc config device add win11 vtpm tpm path=/dev/tpm0
lxc config device override win11 root size=50GiB
lxc config set win11 limits.cpu=4 limits.memory=8GiB
lxc config device add win11 iso disk source=/path/to/Windows-repacked.iso boot.priority=10
```

Now, the VM win11 has been configured and it is ready to be started. The following command starts the virtual machine and opens up a VGA console so that we go through the graphical installation of Windows.

```bash
lxc start win11 --console=vga
```

Once done with the manual installation process, the ISO can be removed to speed up next boots by avoiding the prompt to boot from it.

`lxc config device remove win11 iso`
