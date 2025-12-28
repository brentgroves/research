# **[The socat Command in Linux](https://www.baeldung.com/linux/socat-command)**

**[Back to Research List](../../research_list.md)**\
**[Back to Current Tasks](../../../a_status/current_tasks.md)**\
**[Back to Main](../../../README.md)**

The **[socat](https://linux.die.net/man/1/socat)** utility is a relay for bidirectional data transfers between two independent data channels.

## 1. Overview

In this tutorial, we’ll take a look at the socat command in Linux. Socat is a flexible, multi-purpose relay tool. Its purpose is to establish a relationship between two data sources, where each data source can be a file, a Unix socket, UDP, TCP, or standard input.

## 2. Use Case of socat

Socat is useful for connecting applications inside separate boxes. Imagine we have Box A and Box B, and inside Box A, there’s a database server application running. Furthermore, Box A is closed to the public, but Box B is open. Our network will allow a connection from Box B to Box A.

Now, let’s say a user wants to read the database log. We don’t want the user to enter Box A, but we’re fine if the user wants to get inside Box B.

Socat can connect the database log in Box A with a text reader in Box B. That way, the user can read the log in Box B. We don’t have to compromise the security of Box A in order for the user to do the job.

Socat can work in both directions. The user in Box B might want to send some database queries to the database server application in Box A. Then, the database server application could send the result back to the user in Box B. Socat supports two-way communication as well.

Let’s start with an introduction to the socat command. Then, we’ll continue with a series of examples.
