# **[nssm](https://nssm.cc/)

nssm is a service helper which doesn't suck. srvany and other service helper programs suck because they don't handle failure of the application running as a service. If you use such a program you may see a service listed as started when in fact the application has died. nssm monitors the running service and will restart it if it dies. With nssm you know that if a service says it's running, it really is. Alternatively, if your application is well-behaved you can configure nssm to absolve all responsibility for restarting it and let Windows take care of recovery actions.

nssm logs its progress to the system Event Log so you can get some idea of why an application isn't behaving as it should.

nssm also features a graphical service installation and removal facility. Prior to version 2.19 it did suck. Now it's quite a bit better.

<https://nssm.cc/commands>

## install

add c:\bin to path
copy nssm.exe to c:\bin

<!-- run as admin -->
```bash
nssm install rclone_start.cmd

nssm install dokan_start.cmd
```
