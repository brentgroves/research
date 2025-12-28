# what is a file overlay

A file overlay is a layer of data or a separate file system that sits on top of an existing one, providing a unified view while allowing changes to be made to the top layer without altering the underlying content. This is achieved by combining a read-only lower layer with a writable upper layer, so modifications are recorded in the upper layer, or in memory, creating a persistent or temporary modification of otherwise immutable data.

## Here's a breakdown of the concept

## Overlay Filesystem (OverlayFS)

- **Core Idea:** This is a common implementation where multiple directories are stacked to appear as a single filesystem.
- **Components:** It uses a read-only "lower" directory, a writable "upper" directory, and a "work" directory for temporary operations.
- **How it Works:** When a file is accessed, the system looks in the upper layer first. If the file exists there, it's used; otherwise, it's pulled from the lower layer.
- **Modifications:** When you modify a file from the lower layer, a copy is made in the upper layer, and the changes are applied to that copy, a process called copy-on-write. Deleting a file creates a marker in the upper layer to hide it.

## Use Cases

- **Linux Containers:** Used to layer changes on top of a base image, making images smaller and enabling multiple containers to share the same base.
- **Live CDs/IoT Devices:** Provides a writable partition on top of a read-only system, allowing temporary modifications or software installations on devices with limited write cycles.

## Executable File Overlay

- **Core Idea:** Data appended to the end of an executable file that is not part of its standard loaded image.
- **How it Works:** The operating system, when loading the executable, doesn't map the overlay into memory. The program must explicitly open the file and find the overlay section to access the data.

## Use Cases

- **Software Distribution:** Appending archive files or certificates to an executable.
- **Malware:** Viruses use this technique to store malicious code, which is loaded into memory after the initial execution of the executable.
