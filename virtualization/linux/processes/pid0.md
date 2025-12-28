# **[](https://thelearningjourneyebooks.com/wp-content/uploads/2024/09/TheLinuxProcessJourney_v9_June2024.pdf)**

Introduction
When starting to learn OS internals I believe that we must understand the default processes
executing (roles, tasks, etc). Because of that I have decided to write a series of short writeups
named "Process ID Card" (aimed at providing the OS vocabulary).
Overall, I wanted to create something that will improve the overall knowledge of Linux in
writeups that can be read in 1-3 mins. I hope you are going to enjoy the ride.
In order to create the list of processes I want to explain, I have installed a clean Ubuntu 22.10
VM (Desktop version) and executed ps (as can be seen in the following image - not all the output
was included ).
Probably the best way to do it is to go over the processes by the order of their PID value.
The first one I want to talk about is the one we can’t see on the list, that is PID 0 (we can see it is
the PPID for PID 1 and PID 2 - on them in the next posts).
Lastly, you can follow me on twitter - @boutnaru (<https://twitter.com/boutnaru>). Also, you can
read my other writeups on medium - <https://medium.com/@boutnaru>. Lastly, You can find my
free eBooks at <https://TheLearningJourneyEbooks.com>.
Lets GO!!!!!!

swapper (PID 0)
Historically, old Unix systems used swapping and not demand paging. So, swapper was
responsible for the “Swap Process” - moving all pages of a specific process from/to
memory/backing store (including related process’ kernel data structures). In the case of Linux
PID 0 was used as the “idle process”, simply does not do anything (like nops). It was there so
Linux will always have something that a CPU can execute (for cases that a CPU can’t be stopped
to save power). By the way, the idle syscall is not supported since kernel 2.3.13 (for more info
check out “man 2 idle”). So what is the current purpose of swapper today? helping with pageout
? cache flushes? idling? buffer zeroning? I promise we will answer it in more detail while going
through the other processes and explaining the relationship between them.
But how can you believe that swapper (PID 0) even exists? if you can’t see it using ps. I am
going to use “bpftrace” for demonstrating that (if you don’t know about bpftrace, I strongly
encourage you to read about it). In the demo I am going to trace the kernel function
“hrtimer_wakeup” which is responsible for waking up a process and move it to the set of
runnable processes. During the trace I am going to print the pid of the calling process (BTW, in
the kernel everything is called a task - more on that in future posts) and the executable name (the
comm field of the task_struct [/include/linux/sched.h]). Here is the command: sudo bpftrace -e
'kfunc:hrtimer_wakeup { printf("%s:%d\n",curtask->comm,curtask->pid); }'.
