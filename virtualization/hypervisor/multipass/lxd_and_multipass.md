# **[Workstation VMs with LXD & Multipass](https://jnsgr.uk/2024/06/desktop-vms-lxd-multipass/)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Multipass Menu](./multipass_menu.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

## references

- **[instance](https://multipass.run/docs/instance)**
- See also **[how to manage instances](https://multipass.run/docs/how-to-guides#heading--manage-instances)**

Over the years, I’ve used countless tools for creating virtual machines - often just for short periods of time when testing new software, trying out a new desktop environment, or creating a more isolated development environment. I’ve gone from just using the venerable qemu at the command line, to full-blown desktop applications like Virtualbox, to using **[virt-manager](https://virt-manager.org/)** with **[libvirt](https://libvirt.org/)**.

When I joined Canonical back in March 2021, I’d hardly used LXD, and I hadn’t ever used **[Multipass](https://multipass.run/)**. Since then, they’ve both become indispensable parts of my workflow, so I thought I’d share why I like them, and how I use each of them in my day to day work.

I work for Canonical, and am therefore invested in the success of their products, but at the time of writing I’m not responsible for either LXD or Multipass, and this post represents my honest opinions as a user of the products, and nothing more.

![lxd](https://jnsgr.uk/2024/06/desktop-vms-lxd-multipass/01.png)

## Installation / Distribution#

Both LXD and Multipass are available as snap packages, and that’s the most supported and recommended route for installation. LXD is available in the repos of a few other Linux distributions (including NixOS, Arch Linux), but the snap package also works great on Arch, Fedora, etc. I personally ran Multipass and LXD as snaps on Arch Linux for a couple of years without issue.

If you’d like to follow along with the commands in this post, you can get setup like so:

```bash
sudo snap install lxd
sudo lxd init --minimal

# If you'd like to use LXD/LXC commands without sudo
# run the following command and logout/login:
#
# sudo usermod -aG lxd $USER

sudo snap install multipass
```

Early on in my journey with NixOS, I **[packaged](https://github.com/NixOS/nixpkgs/pull/214193)** Multipass for Nix. I still maintain (and use!) the NixOS module. This was my first ever contribution to NixOS – a fairly colourful review process to say the least…

The result is that you can use something like the following in your configuration, and have multipass be available to you after a nixos-rebuild switch:

```bash
{

  virtualisation.multipass.enable = true;

}
```

LXD has been maintained in NixOS for many years now - and around this time last year I added support for the LXD UI. The screenshots you see throughout this post are all from LXD UI running on a NixOS machine using the following configuration:

LXD-UI is a browser frontend for LXD. It enables easy and accessible container and virtual machine management. Targets small and large scale private clouds.

```bash
{
  virtualisation.lxd = {
    enable = true;
    zfsSupport = true;
    ui.enable = true;
  };

  networking = {
    firewall = {
      trustedInterfaces = [ "lxdbr0" ];
    };
  };
}
```

## Ubuntu on-demand with Multipass#
Multipass is designed to provide simple on-demand access to Ubuntu VMs from any workstation - whether that workstation is running Linux, macOS or Windows. It is designed to replicate, in a lightweight way, the experience of provisioning a simple Ubuntu VM on a cloud.

Multipass makes use of whichever the most appropriate hypervisor is on a given platform. On Linux, it can use QEMU, LXD or libvirt as backends, on Windows it can use Hyper-V or Virtualbox, and on macOS it can use QEMU or Virtualbox. Multipass refers to these backends as drivers.

Multipass’ scope is relatively limited, but in my opinion that’s what makes it so delightful to use. Once installed, the basic operation of Multipass couldn’t be simpler:

```bash
❯ multipass shell
Launched: primary
Mounted '/home/jon' into 'primary:Home'
Welcome to Ubuntu 24.04 LTS (GNU/Linux 6.8.0-35-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Tue Jun 25 11:17:55 BST 2024

  System load:  0.4               Processes:             132
  Usage of /:   38.9% of 3.80GB   Users logged in:       0
  Memory usage: 31%               IPv4 address for ens3: 10.93.253.20
  Swap usage:   0%

Expanded Security Maintenance for Applications is not enabled.

3 updates can be applied immediately.
1 of these updates is a standard security update.
To see these additional updates run: apt list --upgradable
Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status

ubuntu@primary:~$
```

This one command will take care of creating the primary instance if it doesn’t already exist, start the instance and drop you into a bash shell - normally in under a minute.

Multipass has a neat trick: it bundles a reverse **[SSHFS](https://github.com/libfuse/sshfs)** server that enables easy mounting of the host’s home directory into the VM. This happens by default for the primary instance. As a result the instance I created above has my home directory mounted at /home/ubuntu/Home - making it trivial to jump between editing code/files on my host and in the VM. I find this really useful - I can edit files on my workstation in my own editor, using my Yubikey to sign and push commits without having to worry about complicated provisioning or passthrough to the VM, and any files resulting from a build process on my workstation are instantly available in the VM for testing.

Multipass instances can be customised a little. You won’t find complicated features like PCI-passthrough, but basic parameters can be tweaked. The commands I usually run for setting up a development machine when I’m working on Juju/Charms are:

```bash
# Create a machine named 'dev' with 16 cores, 40GiB RAM and 100GiB disk
multipass launch noble -n dev -c 16 -m 40G -d 100G
# Mount my home directory into the VM
multipass mount /home/jon dev:/home/ubuntu/Home
# Get a shell in the VM
multipass shell dev
```

Once you’re done with an instance, you can remove it like so:

```bash
multipass delete dev
multipass purge
```

Multipass does have some more interesting features, though most of my usage is represented above. One feature that might be of more interest for MacOS or Windows users is aliases. This feature enables you to alias local commands to their counterparts in a Multipass VM, meaning for example that every time you run docker on your Mac, the command is actually executed inside the Multipass VM:

```bash
# Example of mapping the local `mdocker` command -> `docker` in
# the multipass VM
multipass alias dev:docker mdocker
```

Multipass will launch the latest Ubuntu LTS by default, but there are a number of other images available - including some “appliance” images for applications like Nextcloud, Mosquitto, etc.

There is also the concept of Blueprints which are essentially recipes for virtual machines with a given purpose. These are curated partly by the Multipass team, and partly by the community. A blueprint enables the author to specify cores, memory, disk, cloud-init data, aliases, health checks and more. The recipes themselves are maintained on Github, and you can see the list of available images/blueprints using multipass find:

The team also recently introduced the ability to **[snapshot](https://multipass.run/docs/snapshot)** virtual machines, though I must confess I’ve not tried it out in anger yet.

## LXD… for VMs?#

For many people, LXD is a container manager - and indeed for many years it could “only” manage containers. LXD was built for running “system containers”, as opposed to “application containers” like Docker/Podman (or Kubernetes). Running a container with LXD is more similar to to running a container with systemd-nspawn, but with the added bonus that it can cluster across machines, authenticate against different identity backends, and manage more sophisticated storage.

Because LXD manages system containers, each container gets its own systemd, and behaves more like a ’lightweight VM’ sharing the host’s kernel. This turns out to be a very interesting property for people who want to get some of the benefits of containerisation (i.e. higher workload density, easier snapshotting, migration, etc.) with more legacy applications that might struggle to run effectively in application containers.

But this post is about virtual machines. Since the 4.0 LTS release, LXD has also supported running VMs with qemu. The API for launching a container is identical to launching a virtual machine. Better still, Canonical provides images for lots of different Linux distributions, and even desktop variants of some images - meaning you can quickly get up and running with a wide range of distributions, for example:

```bash
# Launch a Ubuntu 24.04 LTS VM
lxc launch ubuntu:noble ubuntu --vm

# Get a shell inside the VM
lxc exec ubuntu bash

# Launch a Fedora 40 VM
lxc launch images:fedora/40 fedora --vm

# Get a shell inside the VM
lxc exec fedora bash

# Launch an Arch Linux VM (doesn't support secure boot yet)
lxc launch images:archlinux arch --vm -c security.secureboot=false

# Get a shell inside the VM
lxc exec arch bash
```

You can get a full list of virtual machine images like so:

```bash
lxc image ls images: --format=compact | grep VIRTUAL-MACHINE
```

## LXD Desktop VMs#

Another neat trick for LXD is desktop virtual machines. These are launched with curated images that drop you into a minimal desktop environment that’s configured to automatically login. This has to be one of my favourite features of LXD!

```bash
# Launch a Ubuntu 24.04 LTS desktop VM and get a console
lxc launch images:ubuntu/24.04/desktop ubuntu --vm --console=vga
```

![l](https://jnsgr.uk/2024/06/desktop-vms-lxd-multipass/02_hu5ce32e3b7e2151bd0ab5608e95da3546_380211_1320x0_resize_q75_h2_box_3.webp)

The guest is pre-configured to work correctly with SPICE, so that means clipboard integration, automatic resizing with the viewer window, USB redirection, etc. The same also works for other distros, as before:

```bash
# Launch an Arch desktop VM
lxc launch images:archlinux/desktop-gnome arch --vm \
  -c limits.cpu=8 \
  -c limits.memory=16GiB \
  -c security.secureboot=false

# Get a console using a separate command (if preferred!)
lxc console --type=vga arch
```

## LXD UI 😍#

Back in June 2023, Canonical announced early access to the LXD graphical user interface on their blog. The LXD UI is now generally available and enabled by default from LXD 5.21 onwards - though you can find instructions for enabling it on earlier versions in the docs. The summary is:

```bash
lxc config set core.https_address :8443
sudo snap set lxd ui.enable=true
sudo systemctl reload snap.lxd.daemon
```

In my opinion, the LXD UI is one of the best, if not the best way to interact with a hypervisor yet. Being a full-stack web application, it gains independence from different GUI toolkits on Linux and, provided the cluster is remote, can be accessed the same way from Windows, Mac and Linux.

I’ve used other hypervisors with web UIs, particularly Proxmox, and I’ve found the experience with LXD UI to be very smooth, even from the early days. The UI can walk you through the creation and management of VMs, containers, storage and networking. The UI can also give you a nice concise summary of each instance (below is the summary of the VM created using the command in the last section):


![lui](https://jnsgr.uk/2024/06/desktop-vms-lxd-multipass/03_hud89646cb61fcd541e6c912c4dc020b2a_135810_1320x0_resize_q75_h2_box_3.webp)

One of my favourite features is the web-based SPICE console for desktop VMs, which combined with the management features makes it trivial to stand up a desktop VM and start testing:


![t](https://jnsgr.uk/2024/06/desktop-vms-lxd-multipass/04.png)

## Why both?#
By now you’ve probably realised that LXD can do everything Multipass can do, and give much more flexibility - and that’s true. LXD is a full-featured hypervisor which supports much more sophisticated networking, PCI-passthrough, clustering, integration with enterprise identity providers, observability through Prometheus metrics and Loki log-forwarding, etc.

Multipass is small, lean and very easy to configure. If I just want a quick command-line only Ubuntu VM to play with, I still find multipass shell to be most convenient - especially with the automatic home directory mounting.

When I want to work with desktop VMs, interact with non-Ubuntu distributions, or work more closely with hardware, then I use LXD. I was already a bit of a closet LXD fan, having previously described it as a bit of a “secret weapon” for Canonical, but since the introduction of the LXD UI, I’m a fully paid up member of the LXD fan club 😉

## Summary#

As I mentioned in the opening paragraphs - both LXD and Multipass have become central to a lot of my technical workflows. The reason I packaged Multipass for NixOS, was that I wanted to dive into daily-driving NixOS, but not without Multipass! In my opinion, the LXD UI is one of the most polished experiences for managing containers and VMs on Linux, and I’m really excited for what that team cooks up next.