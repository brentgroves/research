# **[SSH to Multipass VM](https://dev.to/arc42/enable-ssh-access-to-multipass-vms-36p7)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

## references

## Enable ssh access to multipass vms

**The problem**\

- You are using multipass to create lightweight virtual (Ubuntu) machines.
- You want to ssh into those machines, because you cannot or don't want to use the standard shell command multipass shell <name-of-vm>.
- The naive approach fails with permission denied:

Permission denied, although there is a route to this virtual machine available...

```bash
ssh brent@k8sgw
[brent@repsys11 ~]# ip ro
default via 10.188.50.254 dev br0 proto static 
10.130.245.0/24 dev mpqemubr0 proto kernel scope link src 10.130.245.1 
10.188.50.0/24 dev br0 proto kernel scope link src 10.188.50.203 
10.188.73.0/24 via 10.188.220.254 dev vlan220 proto static 
10.188.220.0/24 dev vlan220 proto kernel scope link src 10.188.220.203 
```

## **[multipass ubuntu password set](https://askubuntu.com/questions/1230753/login-and-password-for-multipass-instance)**

In multipass instance, set a password to ubuntu user. Needed to ftp from dev system. Multipass has transfer command but only works from the host.

```bash
sudo passwd ubuntu

ubuntu@k8sn1:~$ cat ~/.ssh/authorized_keys 
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsHv7cX9SFsKIuskZyVxOIkQnSifoaHc6Vhw1cC64wPUw+nJuKncrGWhND3672KH3OrJyLapcNJa/T03MUNrdMY9uIkjuLKcCuvYyulxlSbR5digPN60pxF/XD1cnmNXEc1qbfSDxtveedy6fNNyLjvD82m37hH8mU08ld1JZ4kz8bsQdskwtIG8RLrcb5rLFdRIHliixh+7k2P2pt5irjQPZAQPNdJrC3nMrGmXxCdIt6eXSTfdsc1pj9Z9f/ydVlno2Z/oNEeX4cKW7L/To2VCiRL/Q1O8HcAPDBfycF2O+6Lcr/UyFs5iuvHK0XTjsgjkec9l0yTBDV7pxNB/tn ubuntu@localhost
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGEboFZQ4rNwjTLk9XLreFQ65LHTaXayXIKR7Yg1pd42 brent.groves@gmail.com

brent@k8sgw1:~$ cat ~/.ssh/id_ed25519.pub
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGEboFZQ4rNwjTLk9XLreFQ65LHTaXayXIKR7Yg1pd42 brent.groves@gmail.com
exit

brent@isdev  ~/src/repsys   main ±  cat ~/.ssh/id_ed25519.pub
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBYqUcC6UGn+MQnPZ7fMVYq0b3HhsQFYor6zx6W4ro9o brent.groves@gmail.com

ssh brent@10.188.50.203
multipass shell k8sn1
cat ~/.ssh/authorized_keys 
...
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGEboFZQ4rNwjTLk9XLreFQ65LHTaXayXIKR7Yg1pd42 brent.groves@gmail.com

vi ~/.ssh/


```

## 1. Create ssh-key

On your host machine (the one with multipass installed), change to the directory from where you will be launching multipass vms. It can be your home directory, but any other will do.

$ ssh-keygen -C vmuser -f multipass-ssh-key
vmuser can be any (dummy) username, it will later be used to log into the VM.
The parameter to -f is the filename for the generated key. You can choose a name of your liking, but there must not be an existing key with the same name in the same directory.
You will be asked to enter a passphrase, leave that empty! I know, it's not as secure as it should be, but multipass VMs are used for development and test only...

Empty passphrases are NOT suited for production environments.

## Different approaches

Two approaches have been documented elsewhere:

- Add an ssh-key to an existing virtual machine (explained by **[Josue Bustos here](https://dev.to/josuebustos/vs-code-remote-ssh-multipass-dn8)**). Downside of this approach: You have to repeat it (more or less manually) for all new VMs you create with multipass launch. Therefore, let's look at a solution that will also work for new VMs...
- Pass an ssh-key while creating a multipass VM (explained in detail by Ivan Krizsan here). In short: You generate a new ssh-key, and pass the public key into every new VM. I summarize the required steps below.

## Add SSH Host

Before we can SSH into our Multipass VM instance, you need to add a new Host in the user's SSH config file. You can directly access the file by locating the directory it's in.

```bash
vi ~/.ssh/config
# Edit the file by adding or appending these three lines:
Host k8sn1
  HostName 10.188.50.205
  User ubuntu
```

## get key from Host to connect from

```bash
ssh brent@isdev
cat ~/.ssh/id_ed25519.pub
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBYqUcC6UGn+MQnPZ7fMVYq0b3HhsQFYor6zx6W4ro9o brent.groves@gmail.com
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBYqUcC6UGn+MQnPZ7fMVYq0b3HhsQFYor6zx6W4ro9o brent.groves@gmail.com
# copy key
```

## add key to host to connect to

```bash
ssh brent@k8sgw3
multipass shell repsys11-c2-n1
vi ~/.ssh/authorized_keys
# paste key
```

## connect

```bash
ssh brent@reports-alb
ssh ubuntu@repsys11-c2-n2
```
