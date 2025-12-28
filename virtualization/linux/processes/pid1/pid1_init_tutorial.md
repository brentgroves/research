# **[](https://medium.com/@boutnaru/the-linux-process-journey-pid-1-init-60765a069f17)**

After explaining about PID 0, now we are going to talk about PID 1. Mostly known as “init”. init is the first Linux user-mode process created, which runs until the system shuts down. init manages the services (called demons under Linux, more on them in a future post). Also, if we check the process tree of a Linux machine we will find that the root of the tree is init.

`pstree`

There are multiple implementations for init, each of them provide different advantages among them are: SysVinit, launched, systemd, runit, upstart, busybox-init and OpenRC (those are examples only and not a full list). Thus, based on the implementation specific configuration files are read (such as /etc/inittab — SysVinit), different command/tools to manage demons (such as service — SysVinit and systemctl — systemd), and different scripts/profiles might be executed during the boot process (runlevels of SysVinit vs targets in systemd).

The creation of init is done by the kernel function “rest_init” (<https://elixir.bootlin.com/linux/latest/source/init/main.c#L680—> shows the source code). In the code we can see the call to “user_mode_thread” which spawns init, later in the function there is a call to “kernel_thread” which creates PID 2 (but that is for our next post ;-).

Now we will go over a couple of fun facts about init. First, in case a parent process exits before all of its children process, init adopts those child processes. Second, only the signals which have been explicitly installed with a handler can be sent to init. Thus, sending “kill -9 1” won’t do anything in most distributions (try it and see nothing happens). Remember that different init implementations handle signals in different ways.

Because they are multiple init implementations (as we stated before) we can determine the one installed in the following manner. We can perform “ls -l /sbin/init”. If it is not a symlink it is probably SysVinit, else if it points to “/lib/systemd/systmed” than systemd is in use (and of course they are other symlinks to the other implementation — you can read about it in the documentation of each init implementation).

As you can see in the attached screenshot Ubuntu 22.04 uses systemd:

Zoom image will be displayed

reading the link “/sbin/init” to check which init implementation is in use. In this case it is systemd
See you in my next writeup ;-) You can follow me on twitter — @boutnaru (<https://twitter.com/boutnaru>). Also, you can read my other writeups on medium — <https://medium.com/@boutnaru>. You can find my free eBooks at <https://TheLearningJourneyEbooks.com>.
