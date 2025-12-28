# AI Overview

The rclone copy command is used to copy files and directories from a source to a destination, skipping files that are already identical on both the source and destination. This command does not delete files from the destination.
Key features and behavior:
Skips identical files: It uses a combination of file size and modification time (or checksum if available) to determine if a file on the destination is identical to the source, and if so, it skips the transfer.
No deletion: Unlike rclone sync, rclone copy will not remove files from the destination that are not present in the source.
Copies contents of directories: When copying a directory, rclone copy transfers the contents of the source directory, not the directory name itself. For example, rclone copy source:path dest:path will copy the files within source:path directly into dest:path, not into a new subdirectory named source:path within dest:path.
Creates destination if needed: If the specified destination path does not exist, rclone copy will create it.
Example usage:
To copy a local folder named my_local_data to a Google Drive remote named gdrive into a folder called backups:
Code

rclone copy /path/to/my_local_data gdrive:backups
Important considerations:
For scenarios where you need the destination to exactly mirror the source (including deleting files from the destination that are not in the source), the rclone sync command is more appropriate.
rclone copy offers various options to control its behavior, such as ignoring existing files (--ignore-existing), preserving metadata (--metadata), or controlling multi-threaded transfers.
