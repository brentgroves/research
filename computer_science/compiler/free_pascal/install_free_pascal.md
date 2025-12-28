https://www.freepascal.org/docs-html/3.0.2/user/usersu5.html

The linux distribution of Free Pascal comes in three forms:

a tar.gz version, also available as separate files.
a .rpm (Red Hat Package Manager) version, and
a .deb (Debian) version.
If you use the .rpm format, installation is limited to

rpm -i fpc-X.Y.Z-N.ARCH.rpm
Where X.Y.Z is the version number of the .rpm file, and ARCH is one of the supported architectures (i386, x86_64 etc.).
If you use Debian, installation is limited to

dpkg -i fpc-XXX.deb
Here again, XXX is the version number of the .deb file.
You need root access to install these packages. The .tar file allows you to do an installation below your home directory if you don’t have root permissions.
When downloading the .tar file, or the separate files, installation is more interactive.
In case you downloaded the .tar file, you should first untar the file, in some directory where you have write permission, using the following command:

tar -xvf fpc.tar
We supposed here that you downloaded the file fpc.tar somewhere from the Internet. (The real filename will have some version number in it, which we omit here for clarity.)
When the file is untarred, you will be left with more archive files, and an install program: an installation shell script.
If you downloaded the files as separate files, you should at least download the install.sh script, and the libraries (in libs.tar.gz).
To install Free Pascal, all that you need to do now is give the following command:

```bash
# Don't use did not work
sudo apt install fp-compiler-3.2.2
```

```bash
cd ~/Downloads
tar -xvf fpc-3.2.0-x86_64-linux.tar 
cd fpc-3.2.0-x86_64-linux
./install.sh
File /home/brent/.fpc.cfg contains string "3.2.0", trying to subtitute with "$fpcversion"
File /home/brent/fpc-3.2.0/lib/fpc/3.2.0/ide/text/fp.cfg contains string "3.2.0", trying to subtitute with "$fpcversion"
File /home/brent/.config/fppkg.cfg contains string "3.2.0", trying to subtitute with "{CompilerVersion}"
# Added export PATH="/home/brent/fpc-3.2.0/bin:$PATH" to exports.sh
```

And then you must answer some questions. They’re very simple, they’re mainly concerned with 2 things :

Places where you can install different things.
Deciding if you want to install certain components (such as sources and demo programs).
The script will automatically detect which components are present and can be installed. It will only offer to install what has been found. Because of this feature, you must keep the original names when downloading, since the script expects this.
If you run the installation script as the root user, you can just accept all installation defaults. If you don’t run as root, you must take care to supply the installation program with directory names where you have write permission, as it will attempt to create the directories you specify. In principle, you can install it wherever you want, though.
At the end of installation, the installation program will generate a configuration file (fpc.cfg) for the Free Pascal compiler which reflects the settings that you chose. It will install this file in the /etc directory or in your home directory (with name .fpc.cfg) if you do not have write permission in the /etc directory. It will make a copy in the directory where you installed the libraries.
The compiler will first look for a file .fpc.cfg in your home directory before looking in the /etc directory.

/home/brent/fpc-3.2.0



