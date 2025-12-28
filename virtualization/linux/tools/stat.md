The stat command in Linux is a utility used to display detailed information about files or file systems. It provides a comprehensive set of metadata, including:
File Name: The name of the file or directory.
Size: The size of the file in bytes.
Blocks: The number of disk blocks allocated to the file.
IO Block: The optimal I/O block size for the file.
File Type: Whether it's a regular file, directory, symbolic link, etc.
Device: The device ID where the file resides.
Inode: The inode number, which is a unique identifier for the file within the filesystem.
Links: The number of hard links pointing to the file.
Access Rights: File permissions in both octal and symbolic (rwx) format.
Ownership: User ID (UID) and Group ID (GID) of the file owner, along with their respective names.
Timestamps:
Access Time (Atime): Last time the file was accessed (read).
Modify Time (Mtime): Last time the file's content was modified.
Change Time (Ctime): Last time the file's metadata (permissions, ownership, etc.) was changed.
Birth Time (Btime): Creation time of the file (may not be supported on all file systems).
Basic Usage:
To display information about a specific file, use the command:
Code

stat filename
Options:
-L, --dereference: Follows symbolic links to display information about the target file.
-f, --file-system: Displays information about the file system instead of the file.
-c, --format=FORMAT: Uses a specified format string to customize the output.
--printf=FORMAT: Similar to --format, but interprets backslash escapes and does not add a trailing newline by default.
-t, --terse: Prints information in a more concise, terse format.
Example:
To get detailed information about a file named document.txt:
