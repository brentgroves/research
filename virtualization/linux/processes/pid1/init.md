# pid 1

In Linux and other Unix-like operating systems, PID 1, also known as init, is the first process started by the kernel during system boot. It's the root of the process tree and the parent of all other processes. PID 1 is special because it handles crucial system tasks like bringing up user space, managing services, and handling orphaned processes.

init as the first process:
When a Linux system starts, the kernel loads and executes the init process, which is assigned PID 1.

Parent of all processes:
All other processes on the system are either direct or indirect children of init. If a process terminates before its children, those children are "adopted" by init.

Essential system tasks:
Init is responsible for:
Bringing up and maintaining the user space environment after the kernel has finished booting.
Starting and managing background services (daemons).
Reaping orphaned processes (processes whose parents have terminated).
Handling system shutdown and reboot.
