# **[SSH to Multipass VM](https://dev.to/arc42/enable-ssh-access-to-multipass-vms-36p7)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

## get an ssh key from the client

```bash
# Check if ssh key already exists
cat ~/.ssh/id_ed25519.pub

# If key does not exist then generate one with the ed25519 algorithm accept defaults with no passcode
ssh-keygen -t ed25519 -C brent.groves@gmail.com 

# copy key into clipboard
cat ~/.ssh/id_ed25519.pub
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGEboFZQ4rNwjTLk9XLreFQ65LHTaXayXIKR7Yg1pd42 brent.groves@gmail.com
```

## Copy key into servers authorized keys file

```bash
# Normally i would use the ssh-copy-id ubuntu@10.188.50.205 command but can't get that to work
ssh brent@10.188.50.203
multipass shell k8sn1
# Paste clients key to end of the authorized key file
vi ~/.ssh/authorized_keys
# verify key was added
cat ~/.ssh/authorized_keys 
...
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGEboFZQ4rNwjTLk9XLreFQ65LHTaXayXIKR7Yg1pd42 brent.groves@gmail.com
```

## connect from client

```bash
ssh ubuntu@10.188.50.205
```
