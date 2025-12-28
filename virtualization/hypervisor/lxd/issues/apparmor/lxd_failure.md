<https://devco.re/blog/2025/06/26/the-journey-of-bypassing-ubuntus-unprivileged-namespace-restriction-en/>
<https://discourse.ubuntu.com/t/understanding-apparmor-user-namespace-restriction/58007>
<https://linuxsecurity.com/news/security-vulnerabilities/ubuntu-vulns-give-unprivileged-users-admin-access>
<https://github.com/canonical/lxd/issues/12510>
Restrict unprivileged unconfined profile changes
By making sure the kernel.apparmor_restrict_unprivileged_unconfined sysctl setting is enabled, a process that is unprivileged and unconfined cannot leverage aa-exec to change to a more favourable profile. This can be achieved with the following:

echo "kernel.apparmor_restrict_unprivileged_unconfined=1" | sudo tee /etc/sysctl.d/10-apparmor-hardening.conf
sudo sysctl --load /etc/sysctl.d/10-apparmor-hardening.conf
Please note that, if installed, LXD will completely disable the user namespace restriction feature when running, effectively making this sysctl irrelevant.

```bash
lxc console v1 --type vga
unshare: write failed /proc/self/uid_map: Operation not permitted
echo "==> Disabling Apparmor unprivileged userns mediation"
echo 0 > /proc/sys/kernel/apparmor_restrict_unprivileged_userns
cat /proc/sys/kernel/apparmor_restrict_unprivileged_userns
cat /proc/sys/kernel/apparmor_restrict_unprivileged_unconfined

echo "==> Disabling Apparmor unprivileged unconfined mediation"
echo 0 > /proc/sys/kernel/apparmor_restrict_unprivileged_unconfined
```
