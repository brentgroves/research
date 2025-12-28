# **[](https://rclone.org/commands/rclone_rcd/)**

rclone rcd
Run rclone listening to remote control commands only.

Synopsis
This runs rclone so that it only listens to remote control commands.

This is useful if you are controlling rclone via the rc API.

If you pass in a path to a directory, rclone will serve that directory for GET requests on the URL passed in. It will also open the URL in the browser when rclone is run.

See the rc documentation for more info on the rc flags.

## Server options

Use --rc-addr to specify which IP address and port the server should listen on, eg --rc-addr 1.2.3.4:8000 or --rc-addr :8080 to listen to all IPs. By default it only listens on localhost. You can use port :0 to let the OS choose an available port.

If you set --rc-addr to listen on a public or LAN accessible IP address then using Authentication is advised - see the next section for info.

You can use a unix socket by setting the url to unix:///path/to/socket or just by using an absolute path name.

--rc-addr may be repeated to listen on multiple IPs/ports/sockets. Socket activation, described further below, can also be used to accomplish the same.

--rc-server-read-timeout and --rc-server-write-timeout can be used to control the timeouts on the server. Note that this is the total time for a transfer.

--rc-max-header-bytes controls the maximum number of bytes the server will accept in the HTTP header.

--rc-baseurl controls the URL prefix that rclone serves from. By default rclone will serve from the root. If you used --rc-baseurl "/rclone" then rclone would serve from a URL starting with "/rclone/". This is useful if you wish to proxy rclone serve. Rclone automatically inserts leading and trailing "/" on --rc-baseurl, so --rc-baseurl "rclone", --rc-baseurl "/rclone" and --rc-baseurl "/rclone/" are all treated identically.

## TLS (SSL)

By default this will serve over http. If you want you can serve over https. You will need to supply the --rc-cert and --rc-key flags. If you wish to do client side certificate validation then you will need to supply --rc-client-ca also.

--rc-cert must be set to the path of a file containing either a PEM encoded certificate, or a concatenation of that with the CA certificate. --rc-key must be set to the path of a file with the PEM encoded private key. If setting --rc-client-ca, it should be set to the path of a file with PEM encoded client certificate authority certificates.

--rc-min-tls-version is minimum TLS version that is acceptable. Valid values are "tls1.0", "tls1.1", "tls1.2" and "tls1.3" (default "tls1.0").
