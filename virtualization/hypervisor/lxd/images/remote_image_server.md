# **[](https://documentation.ubuntu.com/lxd/stable-5.21/reference/remote_image_servers/#remote-image-servers)**

Remote image servers
The lxc CLI command comes pre-configured with the following default remote image servers:

images:
This server provides unofficial images for a variety of Linux distributions. The images are built to be compact and minimal, and therefore the default image variants do not include cloud-init. Where possible, /cloud variants that include cloud-init are provided. See cloud-init support in images.

This server does not provide official Ubuntu images (for those, use the ubuntu: server). It does, however, provide desktop variants of current Ubuntu releases.

See **[images.lxd.canonical.com](https://images.lxd.canonical.com/?_gl=1*jqaavl*_ga*MzM1MDA1MDIwLjE3NDQ3NDc3NTQ.*_ga_5LTL1CNEJM*czE3NTI3NzgzMzQkbzM1JGcxJHQxNzUyNzgwMjcyJGo2MCRsMCRoMA..)** for an overview of available images.

ubuntu:
This server provides official stable Ubuntu images. All images are cloud images, which means that they include both cloud-init and the lxd-agent.

See **[cloud-images.ubuntu.com/releases](https://cloud-images.ubuntu.com/releases/)** for an overview of available images.

ubuntu-daily:
This server provides official daily Ubuntu images. All images are cloud images, which means that they include both cloud-init and the lxd-agent.

See cloud-images.ubuntu.com/daily for an overview of available images.

ubuntu-minimal:
This server provides official Ubuntu Minimal images. All images are cloud images, which means that they include both cloud-init and the lxd-agent.

See cloud-images.ubuntu.com/minimal/releases for an overview of available images.

ubuntu-minimal-daily:
This server provides official daily Ubuntu Minimal images. All images are cloud images, which means that they include both cloud-init and the lxd-agent.

See cloud-images.ubuntu.com/minimal/daily for an overview of available images.
