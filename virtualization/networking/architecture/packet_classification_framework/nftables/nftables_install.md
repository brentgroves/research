# **[nftables install](https://www.server-world.info/en/note?os=Ubuntu_22.04&p=nftables&f=1)**

## This is the Basic Operation of Nftables

[1] On Ubuntu 22.04, nftables is used as the default UFW backend.

```bash
root@dlp:~# update-alternatives --config iptables
There are 2 choices for the alternative iptables (providing /usr/sbin/iptables).

  Selection    Path                       Priority   Status
------------------------------------------------------------
* 0            /usr/sbin/iptables-nft      20        auto mode
  1            /usr/sbin/iptables-legacy   10        manual mode
  2            /usr/sbin/iptables-nft      20        manual mode

Press <enter> to keep the current choice[*], or type selection number:
```

If you use nftables directly, disable UFW service to avoid that the different firewall services influence each other.
Furthermore, enable nftables.service that restores filtering ruleset when system restarts.

```bash
root@dlp:~# systemctl disable --now ufw
Synchronizing state of ufw.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install disable ufw
Removed /etc/systemd/system/multi-user.target.wants/ufw.service.
```

Backup nftables.conf

```bash
# backup 
cp /etc/nftables.conf ~/backup/
sudo rm /etc/nftables.conf
sudo touch /etc/nftables.conf
sudo chmod 666 /etc/nftables.conf
echo "flush ruleset" > /etc/nftables.conf
sudo nft list ruleset >> /etc/nftables.conf
```

If iptables is enabled then disable it:

```bash
systemctl status iptables
○ iptables.service - netfilter persistent configuration
     Loaded: loaded (/lib/systemd/system/iptables.service; alias)
     Active: inactive (dead)
       Docs: man:netfilter-persistent(8)
```

If nftables is disable then enable it:

```bash
systemctl status nftables            
○ nftables.service - nftables
     Loaded: loaded (/lib/systemd/system/nftables.service; disabled; vendor preset: enabled)
     Active: inactive (dead)
       Docs: man:nft(8)
             http://wiki.nftables.org

systemctl enable --now nftables             

# systemctl config file
cat /lib/systemd/system/nftables.service                
[Unit]
Description=nftables
Documentation=man:nft(8) http://wiki.nftables.org
Wants=network-pre.target
Before=network-pre.target shutdown.target
Conflicts=shutdown.target
DefaultDependencies=no

[Service]
Type=oneshot
RemainAfterExit=yes
StandardInput=null
ProtectSystem=full
ProtectHome=true
ExecStart=/usr/sbin/nft -f /etc/nftables.conf
ExecReload=/usr/sbin/nft -f /etc/nftables.conf
ExecStop=/usr/sbin/nft flush ruleset

[Install]
WantedBy=sysinit.target


# [/etc/nftables.conf] has no filtering setting by default
root@dlp:~# cat /etc/nftables.conf
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
        chain input {
                type filter hook input priority 0;
        }
        chain forward {
                type filter hook forward priority 0;
        }
        chain output {
                type filter hook output priority 0;
        }
}

sudo nft list ruleset

```
