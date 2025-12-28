# **[Ceph/Rados AWS S3 API Bucket Policy via CURL](https://stackoverflow.com/questions/70891761/ceph-rados-aws-s3-api-bucket-policy-via-curl)**

<https://medium.com/@hojat_gazestani/basic-ceph-rgw-setup-and-s3-access-with-aws-cli-and-python-boto3-c3db142d3b55>
I am currently struggling with a problem I am having with rest calls to an AWS s3 API hosted by a rados/ceph gateway.

For reasons I wont go into, I can't use an SDK that is provided to talk to it, which would solve all of my woes - I'm recreating some of the more simple jobs I need via CURL - which in the most part work, I can make buckets, delete them, add objects, create roles but my newest problem is bucket policies, both GET for them and PUT. I receive a 403 every time and I cannot figure out why.

What I have attempted to do is use another box with an SDK that talks to the API (boto3) and the AWS s3API calls to do the same thing and they work perfectly fine with the users Access and Secret key, so I do not think its an account thing.

Using the logs from the SDK jobs, I have attempted to recreate everything that is being sent, headers, payload etc...

Now I can only think that as a 403 maybe its the Auth4 strategy but .... this strategy works for every other job I need to do.

```bash
#!/bin/bash
set -x
ACCESS_KEY="foo"
SECRET_KEY="bar"
# ACCESS_KEY="accesskey"
# SECRET_KEY="secret"

SERVICE="s3"
REGION="default"
ENDPOINT="micro11"
BUCKET="mybucket"
# ENDPOINT="s3-test.example.com"
# BUCKET="bucketname"

MYPATH="?policy"
TIMEDATE="$(date -u '+%Y%m%d')"
TIMEDATEISO="${TIMEDATE}T$(date -u '+%H%M%S')Z"

# Create sha256 hash in hex
function hash_sha256 {
  printf "${1}" | openssl dgst -sha256 |  sed "s/^.* //"
}

# Create sha256 hmac in hex
function hmac_sha256 {
  printf "{2}" | openssl dgst -sha256 -mac HMAC -macopt "${1}" | sed "s/^.* //"
}

PAYLOAD="$(printf "" | openssl dgst -sha256 |  sed 's/^.* //')"
CANONICAL_URI="/${BUCKET}${PATH}"
# CANONICAL_HEADERS="host:${ENDPOINT} x-amz-content-sha256:${PAYLOAD} x-amz-date:${TIMEDATEISO}"
CANONICAL_HEADERS="host:${ENDPOINT}
x-amz-content-sha256:${PAYLOAD}
x-amz-date:${TIMEDATEISO}"

SIGNED_HEADERS="host;x-amz-content-sha256;x-amz-date"
CANONICAL_REQUEST="GET
${CANONICAL_URI}
${CANONICAL_HEADERS}
${SIGNED_HEADERS}
${PAYLOAD}"
# CANONICAL_REQUEST="GET
# ${CANONICAL_URI}\n
# ${CANONICAL_HEADERS}\n
# ${SIGNED_HEADERS}\n
# ${PAYLOAD}"

# Create signature
function create_signature {
  stringToSign="AWS4-HMAC-SHA256\n${TIMEDATEISO}\n${TIMEDATE}/${REGION}/${SERVICE}/aws_request\n$(hash_sha256 "${CANONICAL_REQUEST}")"
  dateKey=$(hmac_sha256 key:"AWS4${SECRET_KEY}" "${TIMEDATE}")
  regionKey=$(hmac_sha256 hexkey:"${dateKey}" "${REGION}")
  serviceKey=$(hmac_sha256 hexkey:"${regionKey}" "${SERVICE}")
  signingKey=$(hmac_sha256 hexkey:"${serviceKey}" "aws4_request")

  printf "${stringToSign}" | openssl dgst -sha256 -mac HMAC -macopt hexkey:"${signingKey}" |  sed 's/(stdin)= //'
}

SIGNATURE="$(create_signature)"

AUTH_HEADER="\
AWS4-HMAC-SHA256 Credential=${ACCESS_KEY}/${TIMEDATE}/${REGION}/${SERVICE}/aws4_request, \
SignedHeaders=${SIGNED_HEADERS}, Signature=${SIGNATURE}"

curl -vvv "http://${ENDPOINT}${CANONICAL_URI}" \
    -H "Accept:" \
    -H "Authorization: ${AUTH_HEADER}" \
    -H "x-amz-content-sha256: ${PAYLOAD}" \
    -H "x-amz-date: ${TIMEDATEISO}" \

# curl -vvv "https://${ENDPOINT}${CANONICAL_URI}" \
#     -H "Accept:" \
#     -H "Authorization: ${AUTH_HEADER}" \
#     -H "x-amz-content-sha256: ${PAYLOAD}" \
#     -H "x-amz-date: ${TIMEDATEISO}" \

```

Managed to solve my own issue. Noticed in the ceph logs (not sure how I missed it first time round) that the signature from my client didnt match how the ceph radosgw was signing the same signature.

Took it back to task on the canonicalRequest and for some reason if i take out all the line breaks (\n), it calculates.... But all of my other jobs like updating roles, adding buckets etc... fail as they need the line breaks. Not sure why, some Ceph weirdry?

I did packet captures and stripped the SSL to see what both requests from a working SDK and my curl were sending and it was identical...

Oh well, working :)
