# **[What is the difference between a process, a container, and a VM?](https://jessicagreben.medium.com/what-is-the-difference-between-a-process-a-container-and-a-vm-f36ba0f8a8f7)**

**[Research List](../../../../../research_list.md)**\
**[Detailed Status](../../../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../../../a_status/current_tasks.md)**\

**[Main](../../../../../../README.md)**

![p](https://miro.medium.com/v2/resize:fit:640/format:webp/1*VCq52pM6LEMzvO5jE-Di9w.png)

## What is a process?

A process represents a running program; it is an instance of an executing program. A process consists of memory and a set of data structures. The kernel uses these data structures to store important information about the state of the program.

## What problem is a process solving? Why do we need them?

The CPU can only execute one program at a time, therefore it must share the CPU with many programs and task switch between them. The CPU needs to remember where it left off in the execution of the program (among other things). **The process is the abstraction that stores that state of the running program.**

## Isolation for a process

By default a process has pretty minimal isolation from the operating system resources. For example, you can easily get an error if you try to run multiple services on the same port. There are two main things that are isolated by default for processes:

1. A process gets its own memory space.
2. A process has restricted privileges. A process gets the same privileges as the user that created the process.

## What is a container?

There are a bunch of definitions of what a container is.

**[Nigel Poulton’s](https://twitter.com/nigelpoulton)** definition is an “Isolated area of an OS with resource limits usage applied.”

The **[Wikipedia’s definition](https://en.wikipedia.org/wiki/Linux_containers)** says “containers is a generic term for an operating system level virtualization. … There are a number of such implementations including Docker, lxc, and rkt.”
