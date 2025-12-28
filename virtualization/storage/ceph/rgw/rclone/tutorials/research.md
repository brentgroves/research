# **[Rclone](https://research-it.wharton.upenn.edu/tools/rclone/)**

rclone is a command line program to copy files and directories to and from a large number of cloud storage solutions, including Box & Dropbox, S3, OneDrive, Google Drive, and many others. It is a straightforward and solid, yet powerful tool for use in our clustered environment, providing copy up and down service to and from our your favorite storage solution.

rclone is installed across Wharton’s HPC systems, and can be run from any compute node.

## Configuration

Before you begin copying files, you will need to configure rclone. It’s easy! The only tricky bit is you will need to do this config step on our graphical HPC3-Desktop system, so that when rclone wants to open a web browser, there is one for it to use. So, the step-by-step:

1. browse to and log on to the HPC3 Desktop system. For further details on our FastX service, see our Access page
2. once you have a new desktop running in your browser or FastX client, open a command line terminal by right-clicking the desktop and choosing ‘Open in Terminal’, or clicking the Terminal icon in the top menu bar
3. start the rclone configuration process by typing: 'rclone config'

```bash
$ rclone config
2018/05/15 14:48:06 NOTICE: Config file "/home/wcit/hughmac/.config/rclone/rclone.conf" not found - using defaults
No remotes found - make a new one
n) New remote
s) Set configuration password
q) Quit config
n/s/q> n
name> Box
Type of storage to configure.
Choose a number from below, or type in your own value
 1 / Alias for a existing remote
   \ "alias"
 2 / Amazon Drive
   \ "amazon cloud drive"
 3 / Amazon S3 Compliant Storage Providers (AWS, Ceph, Dreamhost, IBM COS, Minio)
   \ "s3"
 4 / Backblaze B2
   \ "b2"
 5 / Box
   \ "box"
 6 / Cache a remote
   \ "cache"
 7 / Dropbox
   \ "dropbox"
...
Storage> box
Box App Client Id - leave blank normally.
client_id>
Box App Client Secret - leave blank normally.
client_secret>
Remote config
Use auto config?
 * Say Y if not sure
 * Say N if you are working on a remote or headless machine
y) Yes
n) No
y/n> y
```

If your browser doesn't open automatically go to the following link: <http://127.0.0.1:53682/auth>
Log in and authorize rclone for access
Waiting for code...

A browser will open up, and connect to Box (or Dropbox, if you chose 7 instead of 5). Authenticate, and then you can ‘Authorize’ rclone to access your Box / Dropbox files.

That’s it for setup!

## Reauthorization

Here’s a short (2:25) video to walk you through the reauthorization process:

## Syncing Files

While I say ‘syncing’ and ‘sync’, please use the ‘copy’ command for best results!! The best documentation on usage is rclone’s own **[documentation](https://rclone.org/docs/)**. The above video demos a few commands, as well.

I recommend that you have a single folder within your Box / Dropbox dedicated to your HPCC research files. For example, I have an HPCC folder in my Box account. On the HPCC, I want to locate it at ~/Box/HPCC, so I copy it down from Box:

```bash
$ rclone copy Box:HPCC ~/Box/HPCC -u -v
2018/05/15 15:05:46 INFO : Local file system at /home/wcit/hughmac/Box/HPCC: Modify window is 1s
2018/05/15 15:05:46 INFO : Local file system at /home/wcit/hughmac/Box/HPCC: Waiting for checks to finish
2018/05/15 15:05:46 INFO : Local file system at /home/wcit/hughmac/Box/HPCC: Waiting for transfers to finish
2018/05/15 15:05:47 INFO : README.md: Copied (new)
2018/05/15 15:05:47 INFO : Waiting for deletions to finish
2018/05/15 15:05:47 INFO :
Transferred: 80 Bytes (37 Bytes/s)
Errors: 0
Checks: 0
Transferred: 1
Elapsed time: 2.1s
$ find ~/Box
/home/wcit/hughmac/Box
/home/wcit/hughmac/Box/HPCC
/home/wcit/hughmac/Box/HPCC/README.md
```

I have created command line ‘aliases’ to assist with this process. In my ~/.bashrc file, I put:

```bash
alias boxdn='rclone copy Box:HPCC ~/Box/HPCC -u -v'
alias boxup='rclone copy ~/Box/HPCC Box:HPCC -u -v'
shopt -s expand_aliases   # <- this is so that your aliases are expanded in job scripts
```

I logged out and back in, and now to copy my ~/Box/HPCC directory up to the HPCC directory in my Box cloud account, I just type 'boxup', and 'boxdn' to copy in the other direction. And when I run a job script, I can just add 'boxup' on the line after I’ve done the work and written the output, and Rclone will copy my files to my Box account!

For example:

```bash
# !/bin/bash
# $ -N myjob
# $ -j y
```

python output_data_to_Box_HPCC_dir.py
boxup

TIP: if you’re running in interactive mode, most software products have a way to run a system or OS command. Take Stata for example, which uses ‘shell’ or ‘!’, like so:

```bash
. ! rclone copy ~/Box/HPCC Box:HPCC -u -v
2018/05/15 15:25:31 INFO  : box root 'HPCC': Modify window is 1s
2018/05/15 15:25:31 INFO  : box root 'HPCC': Waiting for checks to finish
2018/05/15 15:25:31 INFO  : box root 'HPCC': Waiting for transfers to finish
2018/05/15 15:25:31 INFO  : Waiting for deletions to finish
2018/05/15 15:25:31 INFO  :
Transferred:      0 Bytes (0 Bytes/s)
Errors:                 0
Checks:                 1
Transferred:            0
Elapsed time:        1.2s

# use some data in Stata

. sysuse auto.dta
(1978 Automobile Data)

# save the data to Box directory

. save ~/Box/HPCC/auto.dta
file ~/Box/HPCC/auto.dta saved

# copy the directory back up to Box

. ! rclone copy ~/Box/HPCC Box:HPCC -u
```

Unfortunately, aliases aren’t ‘active’ in Stata ‘shell’, I don’t know why (let me know if you do!). You could write a DO files, like:

program boxdn
    ! rclone copy Box:HPCC ~/Box/HPCC -u -v
    end
program boxup
    ! rclone copy ~/Box/HPCC Box:HPCC -u -v
    end
Stash it somewhere (like '~/ado/rclone.do'), and call it from Stata like:

. run ~/ado/rclone.do
. boxup
2018/05/15 15:39:30 INFO : box root 'HPCC': Modify window is 1s
2018/05/15 15:39:31 INFO : box root 'HPCC': Waiting for checks to finish
2018/05/15 15:39:31 INFO : box root 'HPCC': Waiting for transfers to finish
2018/05/15 15:39:31 INFO : Waiting for deletions to finish
2018/05/15 15:39:31 INFO : Transferred: 0 Bytes (0 Bytes/s) Errors: 0 Checks: 1 Transferred: 0 Elapsed time: 1.1s
For more advanced use, I recommend looking through the vendor’s documentation.
