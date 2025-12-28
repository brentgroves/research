In Linux, the command df (disk free) is used to check disk space usage, while du (disk usage) is used to check the disk usage of files and directories. For checking disk errors, the fsck command is used, particularly for file system consistency checks.

1. Checking Disk Space:
df command:
The df command provides information about the disk space usage on your system. It displays the total size, used space, available space, and mount points for each filesystem.
df -h:
This option displays the disk space in a human-readable format (e.g., in KB, MB, or GB).
df -a:
This option shows the file system's complete disk usage, even if the Available field is 0.
du command:
The du command is used to estimate file space usage. It can be used to check the disk space used by a particular directory or file.
du -h:
This option displays the disk usage in a human-readable format for directories and subdirectories.
du -s:
This option shows the total disk space used by a particular file or directory.
pydf:
This is a Python-based command that provides a more colorful and readable output compared to df.
ncdu:
This is an interactive disk usage analyzer with an ncurses interface, allowing for easy navigation and inspection of disk usage.
2. Checking Disk Errors:
fsck command: The fsck (file system consistency check) command is used to check the consistency of a file system and repair any inconsistencies it finds.
sudo fsck /dev/sda1: This command checks and repairs the file system on the specified device (e.g., /dev/sda1). Replace /dev/sda1 with the actual device name you want to check.
smartctl command: The smartctl command is used to check the S.M.A.R.T. (Self-Monitoring, Analysis, and Reporting Technology) status of a hard drive, which can help identify potential hardware issues.
sudo smartctl -a /dev/sda: This command displays all S.M.A.R.T. information for the specified device.
sudo smartctl -H /dev/sda: This command checks the overall health status of the specified device.
3. Other Useful Commands:
lsblk: This command lists all block devices (including hard drives, SSDs, and partitions) on the system.
fdisk -l: This command lists disk partitions, providing information about their size and location.
badblocks: This command can be used to check for bad sectors on a disk.
iostat: This command provides statistics on device input/output, which can be helpful for monitoring disk performance.
iotop: This command displays a real-time list of processes and their I/O usage.
hdparm: This command can be used to test disk speed.
