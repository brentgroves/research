LXD Arch Linux images typically do not have a default password and do not include default user accounts you can log into directly, but you can create a user and password using lxc exec NAME -- passwd <username> after launching the container. For a pre-built image from the LXD image server that has user accounts, you can try the user arch and password arch, but this is for specific images, not all LXD Arch images.
Steps to Set a Password in an Arch Linux LXD Container
Launch the container:
Use the command lxc launch images:archlinux NAME to start a new Arch Linux container, replacing NAME with your desired name.
Execute the command to set a password:
Once the container is running, you can set a password for an existing user (like root or a user you create) with the command: lxc exec NAME -- passwd root or lxc exec NAME -- passwd arch.
You'll be prompted to enter and confirm the new password.

lxc exec archlinux -- passwd archlinux
