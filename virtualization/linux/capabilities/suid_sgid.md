# **[Demystifying SUID and SGID bits](https://tbhaxor.com/demystifying-suid-and-sgid-bits)

## references

**[Exploiting SUID Binaries to Get Root User Shell](https://tbhaxor.com/exploiting-suid-binaries-to-get-root-user-shell)**

## Demystifying SUID and SGID bits

Learn about SUID, SGID and Sticky bits in detail practically with programs and how to drop privileges gracefully

## SUID – SGID – Sticky Bits

Till now you have seen 3 sets of permissions 777 numbers while performing chmod. There is an additional byte in starting which is optional and by default, it is 0. When you do 777 it also means 0777

Here are the logs from strace

```bash
strace -e newfstatat chmod 777 file 
newfstatat(3, "", {st_mode=S_IFREG|0644, st_size=174016, ...}, AT_EMPTY_PATH) = 0
newfstatat(3, "", {st_mode=S_IFREG|0755, st_size=2150424, ...}, AT_EMPTY_PATH) = 0
newfstatat(3, "", {st_mode=S_IFREG|0644, st_size=3046144, ...}, AT_EMPTY_PATH) = 0
+++ exited with 0 +++
```

strace is a diagnostic, debugging, and instructional userspace utility for Linux used to monitor and interact with the interactions between processes and the Linux kernel. It primarily focuses on system calls, signal deliveries, and changes in process state.

Even though I have used 777, the utility translated it to 0777

The very first permission set is known as special permissions. Like RWX, there are three other bits

- SUID – Set User ID
- SGID – Set Group ID
- Sticky Bit

Since there is no other space available in the permissions set for these 3 bits, it takes the place of x permission in all three groups

The translation would look like

rwsrw-r-x – SUID bit set and the binary is executable
rwSrw-r-x – SUID bit set and the binary is not executable
rwxrwsr-x – SGID bit set and the binary is executable
rwxrwSr-x – SGID bit set and the binary is not executable

Let's forget about the sticky bit for now. I will be discussing it under the "Sticky Bit vs Immutable File" heading

When you run a SUID bit enabled file, it is being executed with the user-id current user but with an effective id of the owner of that file.

SUID / SGID on File vs Directory
You have seen how effective a SUID and SGID is on file. However, we will explore it further in this post. But before that, let me explain its effect when set on the directory.

The SUID bit is ignored in most of the Unix/Linux so it will not affect the files you create in the directory. But when you set the SGID bit on the directory and then create a file inside it, the group of the new files will be the same as the group of directories.

For example,

```bash
$ mkdir mydir
# The command `chmod g+s` in Linux sets the Set Group ID (SetGID) bit for a file or directory.
# The command chmod o-r in Linux is used to remove read permissions for "others" on a specified file or directory.

$ chmod g+s,o+rwx mydir
$ stat -c "%A %n" mydir
drwxr-srwx mydir
$ ls -la mydir/
total 0
drwxr-srwx 2 terabyte terabyte  40 Aug  8 00:06 .
drwxr-xr-x 3 terabyte terabyte 100 Aug  8 00:06 ..
$ su amit -c "touch mydir/file"
Password: 
$ ls -l mydir/
total 0
-rw-r--r-- 1 amit terabyte 0 Aug  8 00:07 file
```

The command `chmod g+s` in Linux sets the Set Group ID (SetGID) bit for a file or directory.
Effect on Directories:
When the SetGID bit is set on a directory, any new files or subdirectories created within that directory will inherit the group ownership of the parent directory, rather than the primary group of the user who created them. This is particularly useful in collaborative environments where multiple users need to work on files within a shared directory and maintain consistent group ownership.

Read more about it on Wikipedia – <https://en.wikipedia.org/wiki/Setuid#When_set_on_a_directory>

## User IDs in a Running Process

Basically, for every process, there are two IDs each for group and user

- Effective ID (EUID) – The user/group who is the owner of the file (only in case of SUID/SGID)
- Real ID (RUID) – The user/group who is initially owner of the process

Normally process will have the same EUID as RUID. But in the case of SUID/SGID bit enabled programs, the EUID is changed to file owner/group and RUID remains the same as of the user/group creating process. To make the process "actually" perform actions with the elevated privileges, you still need to use setuid syscall

Here is a secure way to temporary elevate the privileges and then drop them after use

```c
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>

int main(void) {
    // store the uids
    uid_t ruid = getuid();
    uid_t euid = geteuid();
    // store the gids
    gid_t rgid = getgid();
    gid_t egid = getegid();

    printf("Before execution UID: %d and EUID: %d\n", ruid, euid);
    printf("Before execution GID: %d and EGID: %d\n", rgid, egid);

    // elevate the privileges
    setuid(euid);
    setgid(egid);

    // perform action
    system("id > /tmp/output");

    // drop privileges
    if (setuid(ruid)) {
        fprintf(stderr, "Drop user privileges setuid(%d) failed!\n", ruid);
    }
    if (setgid(rgid)) {
        fprintf(stderr, "Drop group privileges setgid(%d) failed!\n", rgid);
    }

    printf("After execution UID: %d and EUID: %d\n", getuid(), geteuid());
    printf("After execution GID: %d and EGID: %d\n", getgid(), getegid());
    printf("Completed! Check output in /tmp/output\n");
    return 0;
}
```

Compile the code and assign proper privileges

```bash
gcc -Wall -o program program.c
sudo chown root:root program
sudo chmod +sx program
```

The transition of users and groups ids would look like following

![i2](https://tbhaxor.com/content/images/2021/08/image-52.png)

Dropping the group privileges after setuid(1000) will fail and it makes sense because users with ID 1000 doesn't have privileges to call setgid() syscall.

## Sticky Bit vs Immutable File

Ever thought of situations where you want to have a directory world-writable by only allow the owner of the file to delete or rename it? Well, that what the sticky bit does. It is specifically for the directory to perform a delete/rename operation.

It takes place of executable permission in the others permission set

rwxrwxrwt – Sticky bit is set and directory has executable permission
rwxrwxrwT – Sticky bit is set and the directory doesn't have executable permission

One of the use cases of this feature is /tmp directory

```bash
$ ls -l / | grep tmp
drwxrwxrwt  19 root root        720 Aug  8 20:55 tmp
```

While learning these concepts, I got confused with the immutable files. When you set the immutable flag on the file, being an owner of the file you can't modify or delete the file.

```bash
$ lsattr program.c 
--------------e------- program.c
$ sudo chattr +i program.c 
$ lsattr program.c 
----i---------e------- program.c
$ ls -l program.c 
-rw-r--r-- 1 terabyte terabyte 975 Aug  8 20:11 program.c
$ rm -rf program.c 
rm: cannot remove 'program.c': Operation not permitted
$ sudo chattr -i program.c 
$ lsattr program.c 
--------------e------- program.c
$ ls -l program.c 
-rw-r--r-- 1 terabyte terabyte 975 Aug  8 20:11 program.c
$ rm -rf program.c 
$ ls -l program.c
ls: cannot access 'program.c': No such file or directory
```

The lsattr command in Linux is used to display the file attributes on file systems that support extended attributes, such as ext2, ext3, ext4, and XFS. These attributes are special flags that control how the file system treats files and directories, going beyond the standard permissions, ownership, and timestamps.
