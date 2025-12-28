# use wimtools to add drivers to WIM files

## from Linux

To add drivers to a WIM file using wimtools, you must first mount the WIM image, add the drivers to the mounted directory, and then unmount and commit the changes. The driver files must be in the .inf format.
This process is most commonly performed on a Linux-based system using the wimlib-utils package, which is part of the wimtools suite. The following steps use the wimlib-imagex command, which is the primary tool for manipulating WIM files in this suite.

## Step 1: Install wimtools

First, ensure you have wimtools installed. On a Debian/Ubuntu system, you can install it from the default repositories:

```bash
sudo apt update
sudo apt install wimtools
```

## Step 2: Mount the WIM image

You will need to mount the WIM file's image to a temporary directory.
Create a temporary mount directory.

```bash
mkdir /mnt/wim
```

Mount the WIM image. You must specify the image index you want to modify. You can use wiminfo to find the correct index.

```bash
wimlib-imagex mountrw /path/to/install.wim 1 /mnt/wim
```

- /path/to/install.wim: The full path to your WIM file.
- 1: The index number of the image to mount. Use wiminfo on your WIM file to list all available images.
- /mnt/wim: The mount directory you created.

## Step 3: Add the drivers

Next, copy the drivers into the mounted WIM directory. The drivers must be in a folder containing the .inf file and any accompanying files (.sys, .cat, etc.). You can also copy a folder containing multiple driver packages.

1. Copy driver packages into the mounted image.

```bash
cp -r /path/to/drivers /mnt/wim/
```

- /path/to/drivers: The directory containing your driver package(s).

2. Use wimapply with the driver path. While copying is the standard approach for adding files, some advanced use cases might involve more complex commands. However, the direct copy method is the most straightforward for injecting drivers.

## Step 4: Add the drivers via DISM (alternative)

If the WIM image was used with Windows, you might have success using the DISM (Deployment Image Servicing and Management) equivalent commands available within some Linux environments or by using the Windows ADK in a Windows environment. However, the most reliable method is to use a tool that directly supports the WIM format, such as wimlib-imagex, and add the drivers to the directory structure.

## Step 5: Unmount and commit changes

After adding the drivers, unmount the WIM image and commit your changes.

```bash
wimlib-imagex unmount --commit /mnt/wim
```

--commit: This option saves the changes you made to the WIM file. If you want to discard the changes, use --abort instead.

## Step 6: Verify the changes (optional)

To confirm that the drivers were added successfully, you can run a wiminfo command on the updated WIM file to check for driver information. You can also re-mount the image and manually check for the driver files in the directory structure.

## from Windows OS

To add drivers to a WIM file, you use the Deployment Image Servicing and Management (DISM) tool to mount the image, add the drivers using the /Add-Driver command, and then unmount the image with the /Commit option to save your changes. You need the driver's .inf file, or a folder containing multiple .inf files, and you must run the command prompt as an administrator.
Here are the steps to add drivers to a WIM file:

1. Prepare your environment
Install the Windows Assessment and Deployment Kit (ADK): This includes DISM.

- Create a folder structure: Create a folder for your WIM file, a folder for your drivers (e.g., C:\Drivers), and an empty folder to mount the image (e.g., C:\Mount).
- Unpack driver files: Extract the contents of any vendor-supplied driver archives (like .exe or .zip files) into your C:\Drivers folder so you have the necessary .inf, .cat, and .sys files.

## 2. Mount the WIM file

Open an elevated Command Prompt: Launch Command Prompt as an administrator.

- Mount the WIM image: Use the DISM /Mount-Image command, specifying the path to your .wim file, the image index if there are multiple images within the file, and the mount directory.

Example: DISM /Mount-Image /WimFile:C:\Path\to\your\install.wim /Index:1 /MountDir:C:\Mount

## 3. Add the drivers

Use the /Add-Driver command: Run the DISM /Image: command to add your drivers.

- To add a single driver: DISM /Image:C:\Mount /Add-Driver /Driver:C:\Drivers\YourDriver.inf
- To add all drivers from a folder: DISM /Image:C:\Mount /Add-Driver /Driver:C:\Drivers /Recurse

## 4. Unmount the image

- Commit the changes: Use the DISM /Unmount-Image command with the /Commit option to save your modifications to the WIM file.

Example: DISM /Unmount-Image /MountDir:C:\Mount /Commit

You have now successfully added the drivers to your offline Windows image.
