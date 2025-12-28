# **[chattr and the Meaning of the lsattr Command Output](https://www.baeldung.com/linux/lsattr-chattr-attributes)**

1. Overview
The lsattr command in Linux displays the attributes set on files or directories. Further, attributes are special flags that control how the file system treats the files and directories, i.e., file system objects. For example, attributes can mark files as immutable or append-only.

Because of this, understanding the output of lsattr is important for Linux system administrators. We may need to check or modify file attributes for security, compliance, or other reasons. So, knowing how to interpret lsattr enables us to quickly inspect attributes and determine whether we need to make any changes.

In this tutorial, we’ll discuss the lsattr command and its output. Also, we’ll see how we can modify file attributes using the chattr command.

## 2. lsattr Command

We use the lsattr command to list the attributes of files or directories on Linux file systems that support extended attributes:

- ext2
- ext3
- ext4
- xfs
- btrfs
In general, lsattr has a basic syntax:

`$ lsattr [options] [files]`

In practice, the lsattr command takes the names of files and directories to inspect as arguments. If we specify no file, it checks the attributes of the current working directory.

As a result, the lsattr command displays one character per attribute to indicate whether that attribute is on or off:

```bash
$ lsattr test.txt
----i--------e-- test.txt
```

This output shows we set the immutable and extent format attributes on test.txt.

However, lsattr doesn’t show the names of attributes. Thus, we might have to know the meaning of each letter code to interpret the output.

## 3. lsattr Options

Also, the lsattr command has several options that we can use to modify its behavior and output. For example, we can use the -R option to recursively list the attributes of all files in a directory, or the -a option to list only the files with attributes set.

## 3.1. -R Option

The -R option tells lsattr to recursively list all files and directories. It also lists the contents of subdirectories:

```bash
$ lsattr -R /home/abdulhameed
--------------e------- /home/abdulhameed/export-set_5.sh
--------------e------- /home/abdulhameed/export-set_4.sh
--------------e------- /home/abdulhameed/Music
...
```

As we can see, this is a list of all files and directories in /home/abdulhameed and its subdirectories.

## 3.2. -a Option

By default, lsattr won’t list any hidden files. However, the -a option displays attributes for all files in the specified directory, including hidden files that start with a dot:

```bash
$ lsattr -a /home/abdulhameed
--------------e------- /home/abdulhameed/export-set_5.sh
--------------e------- /home/abdulhameed/export-set_4.sh
--------------e------- /home/abdulhameed/Music
--------------e------- /home/abdulhameed/export-set_2.sh
--------------e------- /home/abdulhameed/.cache
--------------e------- /home/abdulhameed/.themes
...
--------------e------- /home/abdulhameed/.bash_logout
--------------e------- /home/abdulhameed/.config
--------------e------- /home/abdulhameed/.vscode
```

As a result, this command lists all files in /home/abdulhameed, including hidden ones like .cache or .bash_logout.

## 3.3. -d Option

By default, if we provide a directory name as an argument, lsattr lists its content. However, the -d option tells the lsattr command to list only directories and not their contents:

```bash
$ lsattr -d /home/abdulhameed
--------------e------- /home/abdulhameed
```

The output is of the directory object itself and not of any of its content.

## 3.4. -v Option

The -v option prints the file’s version or generation number:

```bash
$ lsattr -v /home/abdulhameed
707470822  --------------e------- /home/abdulhameed/export-set_5.sh
1241820598 --------------e------- /home/abdulhameed/export-set_4.sh
741945726  --------------e------- /home/abdulhameed/Music
264954810  --------------e------- /home/abdulhameed/export-set_2.sh
4092474338 --------------e------- /home/abdulhameed/file.txt
646553919  --------------e------- /home/abdulhameed/test
617306977  -----------I--e------- /home/abdulhameed/Downloads
...
```

Evidently, the number in the first column is the version number. The version number is a 32-bit unsigned integer that’s incremented every time we modify a file. As a result, some file systems use this number to keep track of file changes.

## 4. lsattr Output

In general, the output of the lsattr command consists of two columns:

attributes
file or directory name
Furthermore, the attributes column shows a series of letters that represent different flags that are set or unset for each file or directory. Consequently, we can classify these attributes into several categories based on their functions.

## 4.1. Deletion and Modification

These categories of attributes control how the files and directories can be deleted, modified, or renamed:

## Letter Attribute Description

- a append-only The file can only be opened in append mode for writing.
- i immutable The file can’t be modified, deleted, or renamed.
- s secure deletion The kernel securely erases the file when we delete it by overwriting its data blocks with zero.
- u undeletable The file can’t be deleted even by the superuser.

Therefore, these attributes can protect important files and directories from accidental or malicious changes

## 4.2. Performance and Storage

Attributes under this category affect how the files and directories are stored, cached, and accessed on disk:

| Letter | Attribute                    | Description                                                                                 |
|--------|------------------------------|---------------------------------------------------------------------------------------------|
| A      | no atime update              | The file’s access time isn’t updated when it’s read                                         |
| c      | compressed                   | The file is automatically compressed by the kernel when it’s written to disk.               |
| D      | synchronous directory update | Any write operations on the directory are synchronized to disk immediately.                 |
| e      | extent format                | The file uses a contiguous range of blocks for mapping storage blocks                       |
| S      | synchronous update           | Any write operations on the file are synchronized to disk immediately.                      |
| t      | no tail-merging              | The file won’t have a partial block fragment at the end of the file merged with other files |

In essence, we can use these attributes to optimize the performance and storage of files

## 4.3. Backup and Recovery

These attributes determine how the files and directories are handled by the backup and recovery program:

| Letter | Attribute        | Description                                                                                            |
|--------|------------------|--------------------------------------------------------------------------------------------------------|
| d      | no dump          | The file isn’t a candidate for backup by dump program                                                  |
| j      | data journalling | Any write operations on the file are first written to an external journal before being written to disk |

## 4.4. Directory Structure

These attributes apply only to directories and affect how they store their entries and subdirectories:

| Letter | Attribute                  | Description                                                                      |
|--------|----------------------------|----------------------------------------------------------------------------------|
| I      | indexed directory          | The directory stores its entries in a hashed tree structure for faster lookup.   |
| T      | top of directory hierarchy | The directory is the top of a directory hierarchy for the Orlov block allocator. |

Further, the Orlov block allocator is a method to allocate disk blocks for directories. It tries to group related subdirectories together in the same block group. As a result, this can improve performance

## 5. chattr Command

Moreover, we can use the chattr command to change the attributes of files and directories of Linux file systems that support extended attributes:

`$ chattr [options] [attributes] [files]`

From the above, options are flags that modify the behavior of the command, attributes are letters that indicate which attributes to set or clear, and files are the names of files to change.

We can prefix the attributes with one of several symbols:

+: add an attribute
–: remove an attribute
=: set an attribute (and clear all others)
Let’s look at an example of adding an attribute to a file:

`$ chattr +i /home/abdulhameed/file.txt`

This command adds the immutable attribute to file.txt.

Also, we can remove an attribute from a file:

`$ chattr -a /home/abdulhameed/file.txt`

Now, file.txt doesn’t have the append-only attribute.

Finally, we can set a file to have an attribute and clear the other attributes:

`$ chattr =c /home/abdulhameed/file.txt`

This command sets the compressed attribute for file.txt and clears all other attributes that we’ve set before for the file.

There are some attributes that we can’t modify with chattr:

E: compression error
h: huge file
I: indexed directory
N: inline data
X: compression raw access
Z: compressed dirty file

Yet, lsattr lists these attributes.

Also, some attributes require running the chattr command as the root user:

a: append only
i: immutable
j: data journalling
Let’s set the a attribute on file.txt as a regular user:

`$ chattr +a /home/abdulhameed/file.txt`

chattr: Operation not permitted while setting flags on /home/abdulhameed/file.txt

This causes chattr to return with an error.
