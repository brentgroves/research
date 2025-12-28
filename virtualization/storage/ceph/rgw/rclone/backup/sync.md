# **[sync](https://rclone.org/commands/rclone_sync/)**

Make source and dest identical, modifying destination only.

Sync the source to the destination, changing the destination only. Doesn't transfer files that are identical on source and destination, testing by size and modification time or MD5SUM. Destination is updated to match source, including deleting files if necessary (except duplicate objects, see below). If you don't want to delete files from destination, use the copy command instead.

Important: Since this can cause data loss, test first with the --dry-run or the --interactive/-i flag.

```bash
rclone sync --interactive SOURCE remote:DESTINATION
```

Note that files in the destination won't be deleted if there were any errors at any point. Duplicate objects (files with the same name, on those providers that support it) are also not yet handled.

It is always the contents of the directory that is synced, not the directory itself. So when source:path is a directory, it's the contents of source:path that are copied, not the directory name and contents. See extended explanation in the copy command if unsure.

If dest:path doesn't exist, it is created and the source:path contents go there.

It is not possible to sync overlapping remotes. However, you may exclude the destination from the sync with a filter rule or by putting an exclude-if-present file inside the destination directory and sync to a destination that is inside the source directory.

Rclone will sync the modification times of files and directories if the backend supports it. If metadata syncing is required then use the --metadata flag.

Note that the modification time and metadata for the root directory will not be synced. See <https://github.com/rclone/rclone/issues/7652> for more info.

Note: Use the -P/--progress flag to view real-time transfer statistics

Note: Use the rclone dedupe command to deal with "Duplicate object/directory found in source/destination - ignoring" errors. See this forum post for more info.

## **[sync to local directory](https://rclone.org/local/)**

To sync a remote location to a local directory using rclone, the rclone sync command is used. This command ensures that the destination directory (in this case, your local directory) mirrors the source (the remote location), by copying new or changed files and deleting files in the destination that no longer exist in the source.
The basic syntax for syncing a remote to a local directory is:

```bash
# rclone sync remote_name:remote_path /path/to/local/directory
rclone sync mybucket:mybucket /home/brent/backups/rclone/mybucket

```

Explanation of the components:
**rclone sync:** This is the command that initiates the synchronization process.
**remote_name:** This refers to the name you assigned to your cloud storage configuration when setting it up with rclone config. For example, if you configured Google Drive as MyGdrive, then MyGdrive would be your remote_name.
**remote_path:** This specifies the specific directory or file within your remote storage that you want to sync. For example, MyGdrive:my_folder would refer to a folder named my_folder within your MyGdrive remote.
**/path/to/local/directory:** This is the absolute or relative path to the local directory on your system where you want the remote content to be synchronized.

Example:
To sync a folder named documents from a Google Drive remote named MyGdrive to a local directory at /home/user/my_backups, the command would be:

`rclone sync MyGdrive:documents /home/user/my_backups`

Important Considerations:

**--dry-run:** Before executing a sync that modifies data, it is highly recommended to use the --dry-run flag. This will show you what rclone would do without actually making any changes, allowing you to verify the operation.

```bash
rclone sync MyGdrive:documents /home/user/my_backups --dry-run
--interactive / -i: This flag prompts for confirmation before deleting or overwriting files, providing an extra layer of safety.
--progress / -P: This flag displays real-time transfer statistics, including progress, speed, and estimated time remaining.
```
