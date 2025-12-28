# **[](https://tbhaxor.com/exploiting-linux-capabilities-part-1/)**

## issues

```bash
lxc console v1 --type vga
unshare: write failed /proc/self/uid_map: Operation not permitted
# <https://tbhaxor.com/exploiting-linux-capabilities-part-1/>
```

As I have discussed capabilities in my **[previous post](https://tbhaxor.com/understanding-linux-capabilities)**, there are 40 capabilities, but from an infosec point of view, I will discuss around 20 of them. Fitting writeup for all of them in one post in nearly one post is nearly impossible. I will discuss 4 labs in each post

In this post, I will discuss 2 capabilities related to setuid and setgid. If you want a refresher on them, I have written two posts – **[Demystifying SUID and SGID bits](https://tbhaxor.com/demystifying-suid-and-sgid-bits) and **[Exploiting SUID Binaries to Get Root User Shell](https://tbhaxor.com/exploiting-suid-binaries-to-get-root-user-shell)**

Following are the name and links of the labs I will be discussing today

- The Basics: CAP_SETUID
- The Basics: CAP_SETUID II
- The Basics: CAP_SETGID
- The Basics: CAP_SETGID II

So let's start off with the first lab

LAB: The Basics: CAP_SETUID
To get the files with at least one capability, you can use getcap recursive search using getcap -r <directory> 2> /dev/null. Redirecting stderr to /dev/null is quite convenient as if the file doesn't have any capability or reading capability is not allowed, it will throw the error

As I have discussed capabilities in my previous post, there are 40 capabilities, but from an infosec point of view, I will discuss around 20 of them. Fitting writeup for all of them in one post in nearly one post is nearly impossible. I will discuss 4 labs in each post

In this post, I will discuss 2 capabilities related to setuid and setgid. If you want a refresher on them, I have written two posts – Demystifying SUID and SGID bits and Exploiting SUID Binaries to Get Root User Shell

Following are the name and links of the labs I will be discussing today

The Basics: CAP_SETUID
The Basics: CAP_SETUID II
The Basics: CAP_SETGID
The Basics: CAP_SETGID II
So let's start off with the first lab

LAB: The Basics: CAP_SETUID
To get the files with at least one capability, you can use getcap recursive search using getcap -r <directory> 2> /dev/null. Redirecting stderr to /dev/null is quite convenient as if the file doesn't have any capability or reading capability is not allowed, it will throw the error

Getting capability recursively in the root directory
Since python interpreter has cap_setuid allowed in the effective set, this means any it can arbitrarily set the user id, even though the user-id is set to 0, you can't set the group id because the process is not running with EUID = 0 and cap_setgid is not allowed. So kernel will drop the action and you will get an "Operation not permitted" error

From the **[capabilities man page](https://man7.org/linux/man-pages/man7/capabilities.7.html)**

Since python interpreter has cap_setuid allowed in the effective set, this means any it can arbitrarily set the user id, even though the user-id is set to 0, you can't set the group id because the process is not running with EUID = 0 and cap_setgid is not allowed. So kernel will drop the action and you will get an "Operation not permitted" error

You can now import the os module and call the setuid function, which will internally call setuid syscall and elevate you to root user with group id same as of current user (i.e student)

![i1](https://tbhaxor.com/content/images/2021/08/image-256.png)**

You can find the reference of same on hacktricks gitbook – <https://book.hacktricks.xyz/linux-unix/privilege-escalation/linux-capabilities#cap_setuid>

LAB: The Basics: CAP_SETUID II
While finding the capabilities recursively in the root directory, I found that again python2 interpreter has cap_setuid set

![i2](https://tbhaxor.com/content/images/2021/08/image-252.png)

```bash
getcap -r /
/snap/core24/1006/usr/bin/ping cap_net_raw=ep
/snap/core24/1055/usr/bin/ping cap_net_raw=ep
/snap/core22/2045/usr/bin/ping cap_net_raw=ep
/snap/core22/2010/usr/bin/ping cap_net_raw=ep
/snap/snapd/24792/usr/lib/snapd/snap-confine cap_chown,cap_dac_override,cap_dac_read_search,cap_fowner,cap_sys_chroot,cap_sys_ptrace,cap_sys_admin=p
/usr/lib/x86_64-linux-gnu/gstreamer1.0/gstreamer-1.0/gst-ptp-helper cap_net_bind_service,cap_net_admin,cap_sys_nice=ep
/usr/bin/ping cap_net_raw=ep
/usr/bin/mtr-packet cap_net_raw=ep
```

If you look closely, this time it is in the permitted set. So if you try setting UID to 0, where it will fail will be the "Operation not permitted" error. This actually makes sense as the kernel will look for the capabilities in the effective set rather than the permitted set.

However, you can fix this by importing prctl and then transitioning the capability from permitted to effective set. Once this is executed successfully, call os.setuid(0) and this time it will be executed successfully

![i3](https://tbhaxor.com/content/images/2021/08/image-254.png)

In case the capabilities are in the permitted set and prctl is not installed, you can import the ctypes module, load libc and call the prtcl function from that

```bash
 readelf -s /usr/lib/libc.so.6  | grep prctl
   883: 00000000000fedd0   136 FUNC    WEAK   DEFAULT   16 prctl@@GLIBC_2.2.5
  2126: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS prctl.c
  3738: 00000000000fedd0   136 FUNC    LOCAL  DEFAULT   16 __GI___prctl
  3871: 00000000000ff100    37 FUNC    LOCAL  DEFAULT   16 __GI_arch_prctl
  4467: 00000000000ff100    37 FUNC    LOCAL  DEFAULT   16 __GI___arch_prctl
  4586: 00000000000fedd0   136 FUNC    LOCAL  DEFAULT   16 __prctl
  7594: 00000000000fedd0   136 FUNC    WEAK   DEFAULT   16 prctl
  8096: 00000000000ff100    37 FUNC    WEAK   DEFAULT   16 arch_prctl
  8266: 00000000000ff100    37 FUNC    GLOBAL DEFAULT   16 __arch_prctl
```

readelf is a command-line utility used on Unix-like systems, including Linux, to display detailed information about object files in the Executable and Linkable Format (ELF). ELF is the standard binary format for executables, shared libraries, and object files on these systems.

LAB: The Basics: CAP_SETGID
On getting capabilities recursively in the root directory, I found that this time python interpreter has cap_setgid capability set to both effective and permitted set.

![i4](https://tbhaxor.com/content/images/2021/08/image-248.png)

When a program has cap_setgid capability set in the effective set, you can arbitrarily change the group id when the program is executed. This will not allow you to change the user id.

![i5](https://tbhaxor.com/content/images/2021/08/image-334.png)

From the **[capabilities man page](https://man7.org/linux/man-pages/man7/capabilities.7.html)**

You can not directly spawn the privileged shell, but perform group-specific action on the files having the same group id as of your current running process, after you call os.setgid() function. This will call setgid() syscall under the hood

![i6](https://tbhaxor.com/content/images/2021/08/image-249.png)

List the DAC permissions of /etc/shadow and /etc/passwd files
In the description, it is written that the flag is the hash of the root user. Since there is no write permission to the group in these files, getting a privileged shell is not possible but you can read the content of the shadow file. Since the setgid function require a group id, you can find this information in the /etc/group file

![i7](https://tbhaxor.com/content/images/2021/08/image-250.png)

Now I have everything to proceed with, it's time to change the group id to 42 and read the first line from the /etc/shadow file.

When you open the file in python using the open built-in function, it will give you an iterator, to read the first line simply type execute the next(file) function by passing variable to filehandle

![i8](https://tbhaxor.com/content/images/2021/08/image-251.png)

So in this case, the hash will start from Yg .... 1. Remember,
1
1 is the hash type and
f
l
a
g
flag is the salt, not hash value

For more reference, you can refer to the hacktricks gitbook – <https://book.hacktricks.xyz/linux-unix/privilege-escalation/linux-capabilities#cap_setgid>

## LAB: The Basics: CAP_SETGID II

On checking capabilities recursively in the root directory, I found that again the python interpreter was allowed to change the group id.

The flag this time is in the home directory of the root user (i.e /root) but I can't perform any action in the /root directory either ways

![i9](https://tbhaxor.com/content/images/2021/08/image-257.png)

I found that the current system is running the docker service as the docker socket exists in the /var/run directory and docker CLI is also installed. This means if anyhow I can get run docker container, I can then take over the system

![i10](https://tbhaxor.com/content/images/size/w1000/2021/08/image-260.png)

I found the docker group can perform read and write actions on the docker socket thus sending commands to the docker service. This isn't a misconfiguration but you can see how running an unintentional application and having another binary to change gid can be a vulnerable vector

![i11](https://tbhaxor.com/content/images/2021/08/image-261.png)

Let's test all these by listing docker images. If there is no image, it would be then again impossible to escalate to the root user.

Use the /etc/group file to find the group id of docker and spawn a shell from python by setting gid same as of docker.

![i12](https://tbhaxor.com/content/images/2021/08/image-262.png)

The id command in Linux is used to display the user and group identity information for a specified user, or for the current user if no user is provided. This information includes the User ID (UID), Group ID (GID), and all supplementary groups to which the user belongs.

Since the docker has an ubuntu image, it is pretty obvious that it will provide a shell to execute commands. Use docker to mount the root in /host directory of the container and spawn a shell. Later you can use chroot utility to get into the root file system of host and perform actions via root user

![i13](https://tbhaxor.com/content/images/size/w1000/2021/08/image-263.png)

The chroot command in Linux and other Unix-like operating systems is used to change the root directory for the current running process and its child processes. This creates an isolated environment, often referred to as a "chroot jail" or "jailed directory."
