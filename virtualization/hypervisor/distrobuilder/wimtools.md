# wimtools

wimtools is a collection of open-source, cross-platform tools for creating, modifying, and extracting Windows Imaging (WIM) archives. It is the command-line frontend to the wimlib C library.
The WIM format was developed by Microsoft for deploying Windows Vista and later versions of the Windows operating system. It differs from traditional disk-imaging formats like ISOs because it is file-based rather than sector-based.

## Key features

- **Alternative to Microsoft tools:** wimtools and wimlib-imagex provide a free and cross-platform alternative to Microsoft's WIMGAPI, ImageX, and DISM for handling WIM and ESD files.
- **Cross-platform support:** wimtools can be used on various operating systems, including Windows, macOS, and Linux, and provides specific support for archiving files on Windows-style filesystems like NTFS.
- **Mounting WIMs:** On UNIX-like systems, wimtools can mount WIM images using FUSE (Filesystem in UserSpacE), allowing for both read-only and read-write access.
- **Deployment:** The tools enable the deployment of Windows operating systems from non-Windows platforms, such as Linux.
- **Archive manipulation:** With wimtools, you can perform various actions on WIM files, including:
- Displaying information about a WIM.
- Applying (extracting) or capturing (creating) a WIM image.
- Modifying an image by adding, deleting, or renaming files.
- Optimizing and rebuilding WIM files.
- Splitting and joining multi-part WIM files.
- Verifying the integrity of a WIM file.
