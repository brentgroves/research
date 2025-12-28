# **[How to use LXD virtual machines](https://maas.io/docs/how-to-use-lxd-vms)**

This guide provides step-by-step instructions for setting up, managing, and overseeing LXD VM hosts and virtual machines in MAAS.

Setting up LXD for VM hosts
Remove older LXD versions

```bash
sudo apt-get purge -y *lxd* *lxc*
sudo apt-get autoremove -y
```

## Install LXD

```bash
sudo snap install lxd
sudo snap refresh
```

## Initialize LXD

```bash
sudo lxd init
```

Follow prompts:

Use clustering: no
Storage back-end: dir
Connect to MAAS: no
Use existing bridge: yes
Bridge name: br0
Trust password: provide password

## Disable DHCP for LXD’s bridge

```bash
lxc network set lxdbr0 dns.mode=none
lxc network set lxdbr0 ipv4.dhcp=false
lxc network set lxdbr0 ipv6.dhcp=false
```

## Adding a VM host

1. Add VM host via UI
2. Navigate to KVM > Add KVM.
3. Enter required details like Name, LXD address, and select Generate new certificate.
4. Run the command to add trust to LXD.
5. Choose Check authentication.
6. Finalize by selecting Add new project or Select existing project.

## Add VM host via CLI

```bash
maas $PROFILE vm-host create type=lxd power_address=$LXD_ADDRESS project=$PROJECT_NAME
```

## Managing LXD projects

### Create a new LXD project via CLI
1. Generate API key:

  ```bash
  sudo maas apikey --generate --username admin
  ```

2. Log in:

  ```bash
  maas login admin http://$MAAS_URL/MAAS/api/2.0 $API_KEY
  ```