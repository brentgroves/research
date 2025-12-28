s3fs mybucket /home/brent/s3-bucket -o umask=000 -o allow_other -o sigv2 -o use_path_request_style -o passwd_file=/home/brent/.passwd-s3fs -o url=<http://microcloud> -d
s3fs mybucket /home/brent/s3-bucket -o umask=000 -o allow_other -o sigv2 -o use_path_request_style -o passwd_file=/home/brent/.passwd-s3fs -o url=<http://microcloud> -d
umount /home/brent/s3-bucket

umount /home/brent/s3-bucket

rclone mount mybucket:mybucket S: --links --vfs-cache-mode full

rclone mount remote:path/to/files /path/to/local/mount
