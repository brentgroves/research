# AI Overview

Switching users with s3cmd typically involves managing different sets of AWS credentials, as s3cmd operates based on the access_key and secret_key defined in its configuration.
There are two primary methods to achieve this:
Using Multiple Configuration Files (Profiles):
Create separate .s3cfg configuration files, each containing the access_key and secret_key for a different AWS user or account. For example, you might have ~/.s3personal.s3cfg and ~/.s3work.s3cfg.
When executing s3cmd commands, specify the desired configuration file using the -c flag.
Example:

```bash
cat ~/.aws/credentials

[rgwuser-basic]
aws_access_key_id = JOHR9NY712UOTW6DYYMX
aws_secret_access_key = ImHtGdxMDQH7PRAkLvheCsKr4VjQr4HKUfblGBA7
[user]
aws_access_key_id = foo
aws_secret_access_key = bar

cat ~/.s3cfg          
[default]
access_key = foo
secret_key = bar
host_base = 10.188.50.201
host_bucket = 10.188.50.201/%(bucket)
check_ssl_certificate = False
check_ssl_hostname = False
use_https = False

code ~/.s3rgwuser
[default]
access_key = JOHR9NY712UOTW6DYYMX
secret_key = ImHtGdxMDQH7PRAkLvheCsKr4VjQr4HKUfblGBA7
host_base = 10.188.50.201
host_bucket = 10.188.50.201/%(bucket)
check_ssl_certificate = False
check_ssl_hostname = False
use_https = False

s3cmd -c ~/.rgwuser.s3cfg ls
2025-08-05 22:10  s3://buck1
2025-08-05 22:15  s3://buckebasic

s3cmd -c ~/.rgwuser.s3cfg ls s3://buckebasic

2025-08-05 22:25        12813  s3://buckebasic/testfile
s3cmd -c ~/.rgwuser.s3cfg put my-file.txt s3://buckebasic/
```
