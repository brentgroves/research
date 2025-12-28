# **[](https://unixism.net/loti/what_is_io_uring.html)**

What is io_uring?
io_uring is a new asynchronous I/O API for Linux created by Jens Axboe from Facebook. It aims at providing an API without the limitations of the current select(2), poll(2), epoll(7) or aio(7) family of system calls, which we discussed in the previous section. Given that users of asynchronous programming models choose it in the first place for performance reasons, it makes sense to have an API that has very low performance overheads. We shall see how io_uring achieves this in subsequent sections.
