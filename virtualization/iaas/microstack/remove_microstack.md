# **[Try microstack](https://canonical.com/microstack?_gl=1*vzb68q*_gcl_au*MTczMDcyNjk4MC4xNzQ0NzQ3NzU2*_ga*MzM1MDA1MDIwLjE3NDQ3NDc3NTQ.*_ga_5LTL1CNEJM*czE3NDc0MTUzNzkkbzMkZzEkdDE3NDc0MTUzNzkkajYwJGwwJGgw#get-started)**

## uninstall

Uninstall Sunbeam
Duration: 5:00

In case you no longer need it, you can completely uninstall Sunbeam.

To uninstall Sunbeam, execute the following commands:

```bash

https://discourse.ubuntu.com/t/tear-down-your-openstack-lab-environment/25078
sudo snap remove --purge microk8s 
sudo snap remove --purge juju 
sudo snap remove --purge openstack
sudo snap remove --purge openstack-hypervisor
sudo /usr/sbin/remove-juju-services
removing juju service: /etc/systemd/system/jujud-machine-0-exec-start.sh
Failed to stop jujud-machine-0-exec-start.sh.service: Unit jujud-machine-0-exec-start.sh.service not loaded.
Failed to disable unit: Unit file jujud-machine-0-exec-start.sh.service does not exist.
removing juju service: /etc/systemd/system/jujud-machine-0.service
Removed "/etc/systemd/system/multi-user.target.wants/jujud-machine-0.service".
removing /var/lib/juju/tools/*
removing /var/lib/juju/db/*
removing /var/lib/juju/dqlite/*
removing /var/lib/juju/raft/*
removing /var/run/juju/*
sudo rm -rf /var/lib/juju
rm -rf ~/.local/share/juju
rm -rf ~/.local/share/openstack
rm -rf ~/snap/openstack
rm -rf ~/snap/openstack-hypervisor
rm -rf ~/snap/microstack/
rm -rf ~/snap/juju/
rm -rf ~/snap/microk8s/
sudo init 6
```

## Project and community

MicroStack is an Open Source project that welcomes usage discussion, project feedback, and especially contributions!

Join the user forum or the chat group on **[Matrix](https://matrix.to/#/#openstack-sunbeam:ubuntu.com)** use google account
We abide by the Ubuntu Code of Conduct
Get involved in improving the software or the documentation
Don’t hesitate to reach out if you have questions about integrating MicroStack into your own cloud project.

## Try MicroStack

Refer to MicroStack **[documentation](https://canonical.com/microstack/docs)** for exact requirements regarding hardware and operating system.

## 1. Install the snap

```bash
sudo snap install openstack --channel 2024.1/beta
```

## 2. Prepare a machine

```bash
sunbeam prepare-node-script | bash -x && newgrp snap_daemon
```

## 3. Bootstrap OpenStack

```bash
sunbeam cluster bootstrap --accept-defaults
Error: 'brent' not part of lxd groupInsufficient permissions to run sunbeam commands
Add the user 'brent' to the 'lxd' group:

    sudo usermod -a -G lxd brent

After this, reload the user groups either via a reboot or by running 'newgrp lxd'.

# try again
sunbeam cluster bootstrap --accept-defaults

Error: Missing Juju controller on LXD
Bootstrap Juju controller on LXD:
    juju bootstrap localhost

# run this command
juju bootstrap localhost
update.go:85: cannot change mount namespace according to change mount (/run/user/1000/doc/by-app/snap.juju /run/user/1000/doc none bind,rw,x-snapd.ignore-missing 0 0): cannot inspect "/run/user/1000/doc": lstat /run/user/1000/doc: permission denied
ERROR LXD socket not found; is LXD installed & running?

Please install LXD by running:
        $ sudo snap install lxd
and then configure it with:
        $ newgrp lxd
        $ lxd init
```

## try again

Installed lxd and ran juju again

```bash
# after installing lxd

juju bootstrap localhost

# add a config request
Located Juju agent version 3.6.5-ubuntu-amd64 at https://streams.canonical.com/juju/tools/agent/3.6.5/juju-3.6.5-linux-amd64.tgz   

...
update.go:85: cannot change mount namespace according to change mount (/run/user/1000/doc/by-app/snap.juju /run/user/1000/doc none bind,rw,x-snapd.ignore-missing 0 0): cannot inspect "/run/user/1000/doc": lstat /run/user/1000/doc: permission denied
Creating Juju controller "localhost-localhost" on localhost/localhost
Looking for packaged Juju agent version 3.6.5 for amd64
Located Juju agent version 3.6.5-ubuntu-amd64 at https://streams.canonical.com/juju/tools/agent/3.6.5/juju-3.6.5-linux-amd64.tgz
To configure your system to better support LXD containers, please see: https://documentation.ubuntu.com/lxd/en/latest/explanation/performance_tuning/
Launching controller instance(s) on localhost/localhost...
 - juju-d6ac62-0 (arch=amd64)                   
Installing Juju agent on bootstrap instance
Waiting for address
Attempting to connect to 10.92.6.233:22
Attempting to connect to [fd42:e17d:9078:6858:216:3eff:fea2:2e3b]:22
Connected to fd42:e17d:9078:6858:216:3eff:fea2:2e3b
Running machine configuration script...
Bootstrap agent now started
Contacting Juju controller at 10.92.6.233 to verify accessibility...

Bootstrap complete, controller "localhost-localhost" is now available
Controller machines are in the "controller" model

Now you can run
        juju add-model <model-name>
to create a new model to deploy workloads.
```

## try bootstrap again

```bash
sunbeam cluster bootstrap --accept-defaults

⠼ Adding machine to Juju model ...

Error: No subnets available in any space
```

## Configure OpenStack

```bash
sunbeam configure --accept-defaults --openrc demo-openrc
```
