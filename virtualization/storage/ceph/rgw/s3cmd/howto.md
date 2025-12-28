# **[Simple S3cmd How-To](<https://s3tools.org/s3cmd-howto>)**

The following example demonstrates just the the basic features. However there is much more s3cmd can do. The most popular feature is the **[S3 sync command](https://s3tools.org/s3cmd-sync)**. Check out our S3cmd S3 sync how-to for more details.

## Register for Amazon AWS / S3

Go to Amazon S3 homepage, click on the "Sign up for web service" button in the right column and work through the registration. You will have to supply your Credit Card details in order to allow Amazon charge you for S3 usage. At the end you should posses your Access and Secret Keys.

## Run s3cmd --configure

You will be asked for the two keys - copy and paste them from your confirmation email or from your Amazon account page. Be careful when copying them! They are case sensitive and must be entered accurately or you'll keep getting errors about invalid signatures or similar.

You can optionally enter a GPG encryption key that will be used for encrypting your files before sending them to Amazon. Using GPG encryption will protect your data against reading by Amazon staff or anyone who may get access to your them while they're stored at Amazon S3.

Another option to decide about is whether to use HTTPS or HTTP transport for communication with Amazon. HTTPS is an encrypted version of HTTP, protecting your data against eavesdroppers while they're in transit to and from Amazon S3.

Please note: - both the above mentioned forms of encryption are independent on each other and serve a different purpose. While GPG encryption is protects your data against reading while they are stored in Amazon S3, HTTPS protects them only while they're being uploaded to Amazon S3 (or downloaded from). There are pros and cons for each and you are free to select either, or, both or none.

Run s3cmd ls to list all your buckets.

As you have just started using S3 there are no buckets owned by you as of now. So the output will be empty.

Make a bucket with s3cmd mb s3://my-new-bucket-name
As mentioned above bucket names must be unique amongst _all_ users of S3. That means the simple names like "test" or "asdf" are already taken and you must make up something more original. I often prefix my bucket names with my e-mail domain name (logix.cz) leading to a bucket name, for instance, 'logix.cz-test':

```bash
s3cmd -c ~/.s3cfg put ~/Downloads/TrialBalanceLinamar.xlsx s3://mybucket/tb2.xlsx
s3cmd -c ~/.rgwuser.s3cfg ls s3://buckebasic
s3cmd -c ~/.s3cfg ls s3://mybucket

s3cmd put tb.xlsx s3://mybucket/tb2.xlsx

s3cmd mb s3://logix.cz-test
Bucket 'logix.cz-test' created
```

## List your buckets again with s3cmd ls

Now you should see your freshly created bucket

```bash
s3cmd -c ~/.s3cfg ls s3://mybucket/my-folder/ 

s3cmd ls
   2007-01-19 01:41  s3://logix.cz-test

List the contents of the bucket
   ~$ s3cmd ls s3://logix.cz-test
   Bucket 'logix.cz-test':
   ~$
It's empty, indeed.
```

## deleting object

```bash
s3cmd del s3://mybucket/.~lock.TrialBalanceLinamar.xlsx#
```
