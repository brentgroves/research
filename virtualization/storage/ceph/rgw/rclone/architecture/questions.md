# **[](https://forum.rclone.org/t/rclone-architecture-question/34169/3)**

What is the problem you are having with rclone?
This is a general architecture question. When using rclone copy between two cloud providers AWS S3 and Azure ADLS, does the data being moved ever hit the local disk of the machine where rclone runs or is it all in memory? What are the steps that rclone takes for a single object? Also in terms of scaling, is it only vertical or can you run rclone in a distributed fashion across multiple instances?

hello and welcome to the forum, all in memory. rclone compares the source object to the dest object. by default, if the source modtime is newer or the size has changed, then rclone copies the source object to the dest. in your case, both providers support MD5 hash, using--checksum rclone can…

1) When using rclone copy between two cloud providers AWS S3 and Azure ADLS, does the data being moved ever hit the local disk of the machine where rclone runs or is it all in memory?

all in memory.

2) What are the steps that rclone takes for a single object?

rclone compares the source object to the dest object.
by default, if the source modtime is newer or the size has changed,
then rclone copies the source object to the dest.

in your case, both providers support MD5 hash, using--checksum
rclone can use that to compare source to dest.

3) you run rclone in a distributed fashion across multiple instances?

yes, can run as many instances as you want.
by default, rclone has a config file.
tho it is possible not to use a config file and create the remote on the fly.

4) Does that mean you can configure Rclone to use multiple instances when copying a single container? In other words, I want to increase parallelism by scaling horizontally when copying data from the same container. So state somehow needs to be kept to know which instance is working on which part of the container content. Can you link me to docs on how to set up something like that?

run a single instance of rclone and feed it multiple jobs/commands.
<https://rclone.org/commands/rclone_rcd/>
