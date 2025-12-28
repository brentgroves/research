# **[Restricted unprivileged user namespaces are coming to Ubuntu 23.10](https://ubuntu.com/blog/ubuntu-23-10-restricted-unprivileged-user-namespaces)**

Ubuntu Desktop firmly places security at the forefront, and adheres to the principles of security by default. This approach caters to both everyday users and organisations with specific compliance requirements. As such, Ubuntu ensures that its recommended security configurations are equally robust, easy to understand and readily accessible as part of the default user experience.

Striking such a delicate balance between security and usability is what has guided our design for restricted unprivileged user namespaces, which is a new security feature that is coming to Ubuntu 23.10. On release day, the feature will be opt-in and you will be able to turn it on using the command line. As we collect more feedback from our users, we will then turn it on by default, on 23.10, using the SRU process.

In this blog post, we will provide an overview of what unprivileged user namespaces are, discuss Ubuntu’s approach to mitigating their security risks, and explain how to start using this feature today and provide us with your feedback.

What are the security risks of unprivileged user namespaces?

Unprivileged user namespaces are a feature of the kernel that can be used to replace many of the uses of setuid and setguid programs (short for set user identity and set group identity), and allow for applications to create more secure sandboxes. However, they expose kernel interfaces that are normally restricted to processes with privileged capabilities (root) to use by unprivileged users.

Exposing more kernel interfaces than necessary to a process introduces additional security risks, and unfortunately unprivileged user namespaces are now broadly used as a step in several privilege escalation exploit chains. In fact, even if unprivileged user namespaces are bug free, as long as any privileged kernel interface or combination of interfaces has a bug, an unprivileged user can try to exploit that bug. In a report from Google, 44% of the exploits they saw required unprivileged user namespaces as part of their exploit chain.

## How can we mitigate this risk?

Several distro kernels carry a patch that allows for a sysctl to disable unprivileged user namespaces as a mitigation. Unfortunately the sysctl is all or nothing. While disabling unprivileged user namespaces might stop an exploit, it can also break applications that use them. Generally an exploit targets a specific application, and as long as unprivileged user namespaces can be disabled for those applications there is no need to disable them for the entire system

## Ubuntu’s approach

Therefore, for Ubuntu, we are introducing **[restricted unprivileged user namespaces](https://discourse.ubuntu.com/t/spec-unprivileged-user-namespace-restrictions-via-apparmor-in-ubuntu-23-10/37626?_gl=1*stjtj7*_gcl_au*MTcwMzEzOTMxMC4xNzUzMTIxNDg4)**, where AppArmor can be used to selectively allow and disallow unprivileged user namespaces. An AppArmor policy is used to selectively control access to unprivileged user namespaces on a per applications basis.

As such, unprivileged processes will only be able to create user namespaces if they are confined and have the “userns,” rule in their AppArmor profile (or if they have CAP_SYS_ADMIN). Since it is not feasible to create a complete AppArmor profile for most affected applications, we introduced a new default_allow profile mode. While this effectively allows the application to remain unconfined, it also adds a new “userns,” rule to allow it to use unprivileged user namespaces. An example of such a profile can be seen below (this would be provided by the AppArmor profile file /etc/apparmor.d/opt.google.chrome.chrome in this case):

```ini
abi <abi/4.0>,

include <tunables/global>

/opt/google/chrome/chrome flags=(default_allow) {
  userns,

  # Site-specific additions and overrides. See local/README for details.
  include if exists <local/opt.google.chrome.chrome>
}

```

## What have we done so far?

This change impacts some programs like Firefox, Chrome, and many more. We have surveyed the Ubuntu archives and listed the applications which we believe will be impacted. For those, we are writing AppArmor profiles which allow them to continue using unprivileged user namespaces.

Furthermore, we also plan to add the profiles in the apparmor binary package, as compared to say apparmor-profiles or within the debs for these affected applications themselves.  For Chrome, for instance, this will cover the /opt/google/chrome/chrome binary. So assuming all the various chrome debs install to this same path then they should be covered as well.

This will give us more control over them and hopefully allows us to also cover the case where a user installs from some other source – if they are using AppArmor then they will automatically have a profile for the affected application.

What is missing and where can you help?
The mitigation above described (supplying profiles in the AppArmor package) is not (and may never be) complete, and applications that use unprivileged user namespaces may be denied from using them if:

No AppArmor profile exists for them (ie: packages not in the Ubuntu archives or for which a profile has not been provided); and/or
They get installed at a different path
The best way forward is for the vendors/developers themselves to provide an AppArmor profile that they ship with their software for each Ubuntu release.

This feature will be first available as an opt-in in Ubuntu 23.10 We invite everybody to experiment with it, and to report a bug if they know or suspect an application is breaking because of this change. As we collect more feedback from you throughout the first couple of weeks of the 23.10 lifetime, we will build more AppArmor profiles for more apps, and then turn this feature on by default on 23.10,  through the SRU process (Stable Release Updates).

In order to turn this feature on, use the following command:

sudo sysctl -w kernel.apparmor_restrict_unprivileged_unconfined=1
sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=1

And if you want to disable it, run the following two commands:

```bash
# get
sysctl kernel.apparmor_restrict_unprivileged_unconfined
kernel.apparmor_restrict_unprivileged_unconfined = 0
sysctl kernel.apparmor_restrict_unprivileged_userns
kernel.apparmor_restrict_unprivileged_userns = 1

# set
sudo sysctl -w kernel.apparmor_restrict_unprivileged_unconfined=0
sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0
```

We also note that no prior Ubuntu release will be impacted by this change, even when using the 6.5 kernel as a Hardware Enablement Kernel with older LTS releases, since the feature is not enabled in the kernel directly but within the apparmor package specific to the  Ubuntu 23.10 release.
